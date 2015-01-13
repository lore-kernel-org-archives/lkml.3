Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbbAMKJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:09:15 -0500
Received: from smtp.citrix.com ([66.165.176.89]:1253 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbbAMKJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:09:12 -0500
X-IronPort-AV: E=Sophos;i="5.07,748,1413244800"; 
   d="scan'208";a="215253236"
Message-ID: <54B4EEC5.1090107@citrix.com>
Date: Tue, 13 Jan 2015 10:09:09 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Grant Likely <grant.likely@linaro.org>,
        Yinghai Lu <yinghai@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] [Bugfix] x86/apic: Fix xen IRQ allocation
 failure caused by commit b81975eade8c
References: <1767175032.20150110201202@eikelenboom.it>	<1421069966-19729-1-git-send-email-jiang.liu@linux.intel.com>	<54B3E1AC.6080902@citrix.com> <54B48190.9000906@linux.intel.com>
In-Reply-To: <54B48190.9000906@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/15 02:23, Jiang Liu wrote:
> On 2015/1/12 23:01, David Vrabel wrote:
>> On 12/01/15 13:39, Jiang Liu wrote:
>>> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
>>> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
>>> setup_IO_APIC(), so no irqdomains created for IOAPICs and
>>> mp_map_pin_to_irq() fails at the very beginning.
>>>
>>> Enhance xen_smp_prepare_cpus() to call setup_IO_APIC() to initialize
>>> irqdomain for IOAPICs.
>>
>> Having Xen call setup_IO_APIC() to initialize the irq domains then having to
>> add special cases to it is just wrong.
>>
>> The bits of init deferred by mp_register_apic() are also deferred to
>> two different places which looks odd.
>>
>> What about something like the following (untested) patch?
> Hi David,
> 	Really appreciate your suggestions about Xen IOAPIC:)
> Your patch solves the issue, but it will break a coming patch
> set to enable hierarchy irqdomain on x86.

For 3.19 I would recommend this patch.  Since it's been tested and it's
pretty small.  Can you spin a version of this with a proper changelog.
please?

> 	To enable hierarchy irqdomain on x86, need to build
> irqdomains in following order:
> 1) create irqdomain for CPU vector domain
> 2) create irqdomains for interrupt remapping unit if interrupt
>    remapping is enabled.
> 3) create irqdomains for IOAPIC/MSI/HPET etc.
> 
> Function arch_early_ioapic_init() is called before initializing
> interrupt remapping subsystem. So creating IOAPIC irqdomains in
> arch_early_ioapic_init() will break hierarchy irqdomain with
> interrupt remapping enabled. I will post the x86 hierarchy
> irqdomain patch soon.
> 
> So could you please help to advice on:

I don't know enough about this area to comment on these authoritatively
and I don't have time to look into this in more detail right now, but to
the best of my understanding.

> 1) Is IOAPIC irqdomain needed for PV?

PV dom0 only requires a mechanism to obtain properties of the IOAPIC
interrupt lines.  The actual physical interrupts are delivered to the
hypervisor.  It doesn't require any of the irq setup.

> 2) Is IOAPIC irqdomain needed for HVM?

Yes.

> 3) Is IOAPIC irqdomain needed for Dom0?


See (1) above.

> 4) What's the proper hook point to create IOAPIC irqdomain for Xen
>    UP systems?

Don't know.

David
