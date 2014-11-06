Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaKFQeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:34:19 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48620 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaKFQeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:34:17 -0500
Message-ID: <545BA301.8000709@arm.com>
Date: Thu, 06 Nov 2014 16:34:09 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com> <5458CE31.3040404@linux.intel.com> <545ABB4C.8010103@amd.com> <545ABF6C.1000308@amd.com> <alpine.DEB.2.11.1411060146050.24960@nanos> <alpine.DEB.2.11.1411061131330.24960@nanos>
In-Reply-To: <alpine.DEB.2.11.1411061131330.24960@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 06 Nov 2014 16:34:10.0696 (UTC) FILETIME=[7E2D6080:01CFF9DF]
X-MC-Unique: 114110616341209101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 06/11/14 10:42, Thomas Gleixner wrote:
> On Thu, 6 Nov 2014, Thomas Gleixner wrote:
>> On Wed, 5 Nov 2014, Suravee Suthikulanit wrote:
>>> On 11/5/2014 6:05 PM, Suravee Suthikulanit wrote:
>>>> - Overall, it seems that msi_domain_alloc() could be quite different
>>>> across architectures. Would it be possible to declare this function as
>>>> weak, and allow arch to override (similar to arch_setup_msi_irq)?
>>>
>>> Actually, declaring "msi_domain_ops" as non-static, and allow other code to
>>> override the .alloc and .free?
>>
>> Why do you want to do that?
> 
> I know why. Because you want to spare a level of hierarchy. But thats
> wrong simply because MSI itself is an interrupt chip at the device
> level.
> 
> [ MSI ] ---> [ GIC-MSI ] ---> [ GIC ]
> 
> So the MSI level only cares about the allocation of the virq
> space. GIC-MSI allocates out of the bitmap which handles the hard
> wired range of MSI capable GIC interrupts and GIC handles the
> underlying functionality.
> 
> And this makes a lot of sense, if you think about interrupt
> remapping. If ARM ever grows that you simply insert it into the chain:
> 
> [ MSI ] ---> [ Remap] ---> [ GIC-MSI ] ---> [ GIC ]

I think ARM has reached that stage with the ITS block in GICv3:
- Each device gets programmed with a set of  "event IDs" ranging from 0
to N-1, with N being the number of MSI vectors used by the device
- the ITS uses both the device ID (basically the PCI requester ID) and
the event ID to parse a set of software-managed tables (think page
tables for interrupts).

The x86 remapping thing looks quite similar to that, by reading a couple
of pages from the VT-D document.

So the way I understand the layout (and please correct me if I'm wrong,
which is certainly the case) is that the MSI domain is entirely generic,
allocates the virq, uses Remap as a parent, and uses
irq_chip_compose_msi_msg to call into the parent and generate whatever
goes into the MSI message.

I'm still struggling a bit to see how the remapping layer can access the
requester ID. x86 uses the irq_alloc_info to store that (the result of
an msi_get_hwirq call), but we don't have an equivalent structure on
arm/arm64.

I'll try to hack something with my current ITS driver and come back with
the results.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

