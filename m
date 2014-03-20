Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaCTIRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:17:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:32890 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaCTIRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:17:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,693,1389772800"; 
   d="scan'208";a="503643970"
Message-ID: <532AA3F6.9090402@intel.com>
Date: Thu, 20 Mar 2014 16:16:54 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>, Stephane Eranian <eranian@google.com>
CC: "Lu, Aaron" <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
References: <20140224162400.GE16457@pd.tnic>	<4205942.Tp8ltEsv6e@vostro.rjw.lan>	<532A514C.5010106@intel.com>	<744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com> <CABPqkBTyti0owCA_cWf9GcvYnOSvbMQpRC29rgpicjW1iYBjYQ@mail.gmail.com> <744357E9AAD1214791ACBA4B0B9092630121F3B7@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B9092630121F3B7@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 03:53 PM, Zhang, Rui wrote:
> The resource length is also hardcoded to 0x6000, right?
> This is probably a problem, because
> only if the resource length read from PCI config space is larger than 0x4000,
> drivers/pnp/quirks.c will detect the conflict and disable the PNP0C02
> resource 0xfed10000 - 0xfed13fff, and the PCI device can request this
> resource successfully.
> In order to check this, can you please attach the dmesg output after boot?

maybe the issue can be fixed by below untested patch

---
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fd5e883..2b3d834 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1701,7 +1701,7 @@ static struct uncore_event_desc snb_uncore_imc_events[] = {
 #define SNB_UNCORE_PCI_IMC_BAR_OFFSET		0x48
 
 /* page size multiple covering all config regs */
-#define SNB_UNCORE_PCI_IMC_MAP_SIZE		0x6000
+#define SNB_UNCORE_PCI_IMC_MAP_SIZE		0x8
 
 #define SNB_UNCORE_PCI_IMC_DATA_READS		0x1
 #define SNB_UNCORE_PCI_IMC_DATA_READS_BASE	0x5050
@@ -1736,7 +1736,8 @@ static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
 
 	addr &= ~(PAGE_SIZE - 1);
 
-	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+	box->io_addr = ioremap(addr + SNB_UNCORE_PCI_IMC_CTR_BASE,
+			       SNB_UNCORE_PCI_IMC_MAP_SIZE);
 	box->hrtimer_duration = UNCORE_SNB_IMC_HRTIMER_INTERVAL;
 }
 
@@ -1832,7 +1833,7 @@ static int snb_uncore_imc_event_init(struct perf_event *event)
 	}
 
 	/* must be done before validate_group */
-	event->hw.event_base = base;
+	event->hw.event_base = base - SNB_UNCORE_PCI_IMC_CTR_BASE;
 	event->hw.config = cfg;
 	event->hw.idx = idx;
 
