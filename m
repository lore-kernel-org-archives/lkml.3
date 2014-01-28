Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaA1SAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:00:16 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36501 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaA1SAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:00:14 -0500
Message-ID: <52E7F02A.7010508@linaro.org>
Date: Tue, 28 Jan 2014 18:00:10 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH] arm/xen: Initialize event channels earlier
References: <1390920842-21886-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1401281651400.4373@kaball.uk.xensource.com> <52E7EA78.5020305@linaro.org> <alpine.DEB.2.02.1401281742080.4373@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1401281742080.4373@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 05:46 PM, Stefano Stabellini wrote:
> On Tue, 28 Jan 2014, Julien Grall wrote:
>>>> +static int xen_cpu_notification(struct notifier_block *self,
>>>> +				unsigned long action,
>>>> +				void *hcpu)
>>>> +{
>>>> +	int cpu = (long)hcpu;
>>>> +
>>>> +	switch (action) {
>>>> +	case CPU_UP_PREPARE:
>>>> +		xen_percpu_init(cpu);
>>>> +		break;
>>>> +	case CPU_STARTING:
>>>> +		xen_interrupt_init();
>>>> +		break;
>>>
>>> Is CPU_STARTING guaranteed to be called on the new cpu only?
>>
>> Yes.
>>
>>> If so, why not call both xen_percpu_init and xen_interrupt_init on
>>> CPU_STARTING?
>>
>> Just in case that xen_vcpu is used somewhere else by a cpu notifier
>> callback CPU_STARTING. We don't know which callback is called first.
> 
> Could you please elaborate a bit more on the problem you are trying to
> describe?

We want to make sure that the vcpu is registered correctly. If not, we
can't skip it and avoid xen to have a "dead" VCPU to schedule due to BUG_ON.

I agree that now we have a BUG_ON in the middle of xen_percpu_init, but
it's possible to return an error. In this case Linux will skip this cpu
and continue to boot.

>>> As it stands I think you introduced a subtle change (that might be OK
>>> but I think is unintentional): xen_percpu_init might not be called from
>>> the same cpu as its target anymore.
>>
>> No, xen_percpu_init and xen_interrupt_init are called on the boot cpu at
>> the end of xen_guest_init.
>  
> Is CPU_UP_PREPARE guaranteed to be called on the target cpu? I think
> not, therefore you would be executing xen_percpu_init for cpu1 on cpu0.
>

I don't see any issue to execute xen_percpu_init for cpu1 on cpu0, all
the code is taking directly the vcpu ID to initialize.

-- 
Julien Grall
