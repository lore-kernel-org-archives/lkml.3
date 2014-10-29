Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaJ2J1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:27:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60070 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaJ2J1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:27:47 -0400
Message-ID: <5450B309.4040607@arm.com>
Date: Wed, 29 Oct 2014 09:27:37 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [Patch Part2 v3 01/24] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com>  <1414484803-10311-2-git-send-email-jiang.liu@linux.intel.com> <1414489711.32399.53.camel@mtksdaap41> <alpine.DEB.2.11.1410282010340.5308@nanos> <544FF900.4020601@arm.com> <alpine.DEB.2.11.1410282116220.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410282116220.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 29 Oct 2014 09:27:39.0513 (UTC) FILETIME=[9556BE90:01CFF35A]
X-MC-Unique: 114102909274312701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 20:23, Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Marc Zyngier wrote:
>> On 28/10/14 19:37, Thomas Gleixner wrote:
>>> So while we are at it:
>>>
>>>> +	if (irq_domain_is_hierarchy(domain)) {
>>>> +		if (domain->ops->xlate) {
>>>> +			/*
>>>> +			 * If we've already configured this interrupt,
>>>> +			 * don't do it again, or hell will break loose.
>>>> +			 */
>>>> +			virq = irq_find_mapping(domain, hwirq);
>>>> +			if (virq)
>>>> +				return virq;
>>>
>>> I can understand that it is an issue if the mapping exists already,
>>> but I have to ask WHY is it correct behaviour to call into that code
>>> for an existing mapping.
>>
>> As I have originally looked at this, I'll answer the question:
>>
>> The generic DT code parses the whole tree, and generates platform
>> devices as it goes. As part of the platform device creation, it
>> populates the IRQ resources, which translates into calling into
>> irq_create_of_mapping(). You could argue that this behaviour is crazy,
>> and I wouldn't disagree.
> 
> Mooo.

Quite.

>> See http://www.spinics.net/lists/devicetree/msg53164.html for more gory
>> details.
>>
>>> And why would this check only apply if domain->ops->xlate is set?
>>> irq_create_mapping() does it unconditionally.
>>
>> My original code used the xlate callback to parse the opaque irq_data,
>> computing hwirq, and I suspect this is a leftover of it. The above code
>> seems to pull hwirq out of thin air, which is probably not the intended
>> behaviour. Joe?
> 
> No. Here is the full patch from Joe:
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296543.html
> 
> hwirq gets either set from hwirq = irq_data->args[0] or from the xlate
> call.

Ah, that makes a lot more sense.

> But my question still stands:
> 
> Why would this check only apply if domain->ops->xlate is set?
> irq_create_mapping() does it unconditionally.

I don't think we should consider xlate at all. We already resolved hwirq
(either directly or through a xlate call), and the check should always
be performed (otherwise we're likely to fall into the same trap again).
Looks like a bug to me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

