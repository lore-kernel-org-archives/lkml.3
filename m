Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaHVMmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:42:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:61628 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbaHVMl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:41:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,380,1406617200"; 
   d="scan'208";a="562119328"
Date: Fri, 22 Aug 2014 15:41:45 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [Patch V4 29/42] x86, irq: introduce two helper functions to
 support irqdomain map operation
Message-ID: <20140822124145.GF1660@lahna.fi.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
 <1402302011-23642-30-git-send-email-jiang.liu@linux.intel.com>
 <20140821141729.GT1660@lahna.fi.intel.com>
 <20140821165728.GV1660@lahna.fi.intel.com>
 <53F641E0.8040401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F641E0.8040401@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 03:00:48AM +0800, Jiang Liu wrote:
> Hi Mika,
> 	I'm out of office until next Tuesday. Will handle this
> when back to work. Could you please help to take a look at
> mp_set_gsi_attr() to check whether it could be used to resolve
> this issue.

The problem seems to be that when we allocate the legacy 16 IRQ range,
they will be set to edge-triggered and then info->set is set to 1
preventing any further configuration (if I understand that part right).

I tried simply following and it seems to work. Not sure how correct it
is, though.

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 29290f554e79..29c5d4fa9e86 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1531,8 +1531,7 @@ static void __init setup_IO_APIC_irqs(void)
 				    KERN_DEBUG " apic %d pin %d not connected\n",
 				    mpc_ioapic_id(ioapic), pin);
 		else
-			pin_2_irq(idx, ioapic, pin,
-				  ioapic ? 0 : IOAPIC_MAP_ALLOC);
+			pin_2_irq(idx, ioapic, pin, 0);
 	}
 }
 
