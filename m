Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaFJFbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:31:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:38216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaFJFbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:31:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1007,1392192000"; 
   d="scan'208";a="553024914"
Message-ID: <53969834.3040404@linux.intel.com>
Date: Tue, 10 Jun 2014 13:31:32 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 12/42] x86, ioapic: kill static variable nr_irqs_gsi
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com> <1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1406100121090.3830@nanos>
In-Reply-To: <alpine.DEB.2.10.1406100121090.3830@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	This piece of code is inherited from current IOAPIC driver
and I think it's a workaround for some weird platforms.
	For normal platforms with both 8259A and IOAPIC controllers,
legacy ISA IRQs should be connected to both 8259A and IOAPIC pins
(ignore timer and cascade IRQs for simplicity). According to comments
 in current kernel, there are some platforms on which:
1) some ISA IRQs are only connected to 8259A controllers.
2) the corresponding IOAPIC pins are connected to some non-ISA IRQs.
	For such platforms, IRQ0-15 are used for ISA IRQs and another
16 IRQs just above gsi_top are reserved for IOAPIC pins 0-15 which
are connected to non-ISA IRQs.
	I have no real experience with such a platform, but just
guessing possible cases according to kernel comments and "Multiple
Processor Specification". Please look at these two pictures for quick
reference.
http://www.manualslib.com/manual/77733/Intel-Multiprocessor.html?page=31#manual
http://www.manualslib.com/manual/77733/Intel-Multiprocessor.html?page=63#manual

Thanks!
Gerry

On 2014/6/10 7:22, Thomas Gleixner wrote:
> On Mon, 9 Jun 2014, Jiang Liu wrote:
>>  unsigned int arch_dynirq_lower_bound(unsigned int from)
>>  {
>> -	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
>> +	unsigned int min = gsi_top + NR_IRQS_LEGACY;
> 
> Why is this gsi_top + NR_IRQ_LEGACY? The legacy interrupts are part of
> the gsi space, aren't they?
> 
> Thanks,
> 
> 	tglx
> 
