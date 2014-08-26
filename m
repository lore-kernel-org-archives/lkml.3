Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaHZJxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:53:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:63136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbaHZJw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,403,1406617200"; 
   d="scan'208";a="589933375"
Date: Tue, 26 Aug 2014 12:52:21 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Bugfix] x86, irq: Fix bug in setting IOAPIC pin attributes
Message-ID: <20140826095221.GO1660@lahna.fi.intel.com>
References: <20140822124145.GF1660@lahna.fi.intel.com>
 <1409042706-11958-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409042706-11958-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:45:01PM +0800, Jiang Liu wrote:
> On startup, IOAPIC driver preallocates IRQ descriptors and programs
> IOAPIC pins with default level and polarity attributes for all legacy
> IRQs. Later legacy IRQ users may fail to set IOAPIC pin attributes
> if the requested attributes conflicts with the default IOAPIC pin
> attributes. So change mp_irqdomain_map() to allow the first legacy IRQ
> user to reprogram IOAPIC pin with different attributes.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

I tried this and now we get further in setting up the IOAPIC but it
still doesn't work :-(

I noticed that mp_set_gsi_attr() never programs the IOAPIC in case
info->set is 0 so I added following on top of your patch. With the below
patch, the system seems to work as expected.

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 66c2700c9f83..777762a0ad09 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3942,10 +3942,16 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 
 	mutex_lock(&ioapic_mutex);
 	if (!info->set) {
+		struct io_apic_irq_attr attr;
+
 		info->trigger = trigger;
 		info->polarity = polarity;
 		info->node = node;
 		info->set = 1;
+
+		/* Now program the IOAPIC with the new attributes */
+		set_io_apic_irq_attr(&attr, ioapic, pin, trigger, polarity);
+		ret = io_apic_setup_irq_pin(gsi, node, &attr);
 	} else if (info->trigger != trigger || info->polarity != polarity) {
 		ret = -EBUSY;
 	}
