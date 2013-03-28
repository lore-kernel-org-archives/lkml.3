Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3C1SiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:38:24 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36406 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3C1SiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:38:23 -0400
Message-ID: <51548E1C.4070508@gmail.com>
Date: Thu, 28 Mar 2013 13:38:20 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg> <51545BE4.9050206@gmail.com> <alpine.LFD.2.03.1303281135320.1372@syhkavp.arg>
In-Reply-To: <alpine.LFD.2.03.1303281135320.1372@syhkavp.arg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 10:39 AM, Nicolas Pitre wrote:
> On Thu, 28 Mar 2013, Rob Herring wrote:
> 
>> On 03/28/2013 09:51 AM, Nicolas Pitre wrote:
>>> On Thu, 28 Mar 2013, Stefano Stabellini wrote:
>>>
>>>> - the interface to bring up secondary cpus is different and based on
>>>> PSCI, in fact Xen is going to add a PSCI node to the device tree so that
>>>> Dom0 can use it.
>>>>
>>>> Oh wait, Dom0 is not going to use the PSCI interface even if the node is
>>>> present on device tree because it's going to prefer the platform smp_ops
>>>> instead.
>>>
>>> Waitaminute...  I must have missed this part.
>>>
>>> Who said platform specific methods must be used in preference to PSCI?
>>
>> I did. Specifically, I said the platform should be allowed to provide
>> its own smp_ops. A platform may need to do addtional things on top of
>> PSCI for example.
> 
> Then the platform should have its special hook that would override the 
> default PSCI methods.  But, by *default* the PSCI methods should be used 
> if the related DT information is present.

Agreed. The special hook to override is setting mach desc smp_ops, right?

>>> If DT does provide PSCI description, then PSCI should be used.  Doing 
>>> otherwise is senseless.  If PSCI is not to be used, then it should not 
>>> be present in DT.
>>
>> You can't assume the DT and kernel are in-sync. For example, I've added
>> PSCI in the firmware and DTB (part of the firmware), but the highbank
>> kernel may or may not use it depending if I convert it.
> 
> If the kernel does not understand PSCI bindings in the DT, it naturally 
> won't use PSCI, right?  Conversely, if the firmware and therefore 
> provided DT don't have PSCI, then the PSCI enabled kernel won't use PSCI 
> either. So what is the problem?

I'm distinguishing the kernel in general is enabled for PSCI and a
platform is enabled. The kernel may have PSCI smp_ops and the DTB may
have PSCI data, but that alone should not make a platform use the
default PSCI smp_ops. The platform has to make the decision and it
cannot be just based on the platform's dtb having PSCI data.

I have firmware (dtb is part of the firmware) with PSCI support and
older firmware without. Old/existing kernels are fine on both firmware
versions and don't use PSCI. New kernels with default PSCI ops should
continue to work with both versions. When/If I convert highbank to use
PSCI in the kernel, only then will new kernels require the new firmware
version. Or perhaps I need to support both in the kernel for a while
before ripping out non PSCI code. There is enough lag in distro kernels
that I don't think this is necessary.

Rob

