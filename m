Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbaH1Gkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:40:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:50785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533AbaH1Gkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:40:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,416,1406617200"; 
   d="scan'208";a="590985224"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH RFC] x86 early_ioremap: increase FIX_BTMAPS_SLOTS to 8
Thread-Topic: [PATCH RFC] x86 early_ioremap: increase FIX_BTMAPS_SLOTS to 8
Thread-Index: AQHPwQ0Bwj1x3Lk6iUqGwGGNx9JY2JvlktAw
Date: Thu, 28 Aug 2014 06:40:10 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026602C6@SHSMSX101.ccr.corp.intel.com>
References: <20140826090641.GA16550@darkstar.nay.redhat.com>
In-Reply-To: <20140826090641.GA16550@darkstar.nay.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Dave Young
> Sent: Tuesday, August 26, 2014 5:07 PM
> 
> 3.16 kernel boot fail with earlyprintk=efi, it keeps scrolling at the
> bottom line of screen.
> 
> Bisected, the first bad commit is below:
> commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> Author: Lv Zheng <lv.zheng@intel.com>
> Date:   Fri Apr 4 12:38:57 2014 +0800
> 
>     ACPICA: Tables: Fix table checksums verification before installation.
> 
> 
> I did some debugging by enabling both serial and efi earlyprintk, below is
> some debug dmesg, seems early_ioremap fails in scroll up function due to
> no free slot, see below dmesg output:
> 
> [snip]
> [    0.000000] RAMDISK: [mem 0x3e1b0000-0x3e982fff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000DB752000 000024 (v02 HPQOEM)
> [    0.000000] ACPI: XSDT 0x00000000DB752088 00008C (v01 HPQOEM SLIC-WKS 01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 0x00000000DB759590 00010C (v05 HPQOEM SLIC-WKS 01072009 AMI  00010013)
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:116 __early_ioremap+0x90/0x1c4()
> [    0.000000] __early_ioremap(ed00c800, 00000c80) not found slot
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc1+ #204
> [    0.000000] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/09/2013
> [    0.000000]  0000000000000000 ffffffff8173b970 ffffffff814bb919 ffffffff8173b9b8
> [    0.000000]  ffffffff8173b9a8 ffffffff810638c9 ffffffff8184ee81 ffffffffff538000
> [    0.000000]  0000000000000c80 0000000000000003 0000000000000c80 ffffffff8173ba08
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff814bb919>] dump_stack+0x4e/0x7a
> [    0.000000]  [<ffffffff810638c9>] warn_slowpath_common+0x75/0x8e
> [    0.000000]  [<ffffffff8184ee81>] ? __early_ioremap+0x90/0x1c4
> [    0.000000]  [<ffffffff81063929>] warn_slowpath_fmt+0x47/0x49
> [    0.000000]  [<ffffffff8184ee81>] __early_ioremap+0x90/0x1c4
> [    0.000000]  [<ffffffff8124cf4d>] ? sprintf+0x46/0x48
> [    0.000000]  [<ffffffff8184f169>] early_ioremap+0x13/0x15
> [    0.000000]  [<ffffffff814ae4f0>] early_efi_map+0x24/0x26
> [    0.000000]  [<ffffffff81060985>] early_efi_scroll_up+0x6d/0xc0
> [    0.000000]  [<ffffffff81060b88>] early_efi_write+0x1b0/0x214
> [    0.000000]  [<ffffffff8109ec3a>] call_console_drivers.constprop.21+0x73/0x7e
> [    0.000000]  [<ffffffff8109fab4>] console_unlock+0x151/0x3b2
> [    0.000000]  [<ffffffff810a01b4>] ? vprintk_emit+0x49f/0x532
> [    0.000000]  [<ffffffff810a0236>] vprintk_emit+0x521/0x532
> [    0.000000]  [<ffffffff8109fce6>] ? console_unlock+0x383/0x3b2
> [    0.000000]  [<ffffffff814b6f01>] printk+0x4f/0x51
> [    0.000000]  [<ffffffff81292f9c>] acpi_os_vprintf+0x2b/0x2d
> [    0.000000]  [<ffffffff81292fe1>] acpi_os_printf+0x43/0x45
> [    0.000000]  [<ffffffff812bc44c>] acpi_info+0x5c/0x63
> [    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
> [    0.000000]  [<ffffffff814afc88>] ? acpi_os_map_iomem+0x21/0x147
> [    0.000000]  [<ffffffff812b7e59>] acpi_tb_print_table_header+0x177/0x186
> [    0.000000]  [<ffffffff812b79da>] acpi_tb_install_table_with_override+0x4b/0x62
> [    0.000000]  [<ffffffff812b7b80>] acpi_tb_install_standard_table+0xd9/0x215
> [    0.000000]  [<ffffffff8184f169>] ? early_ioremap+0x13/0x15
> [    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
> [    0.000000]  [<ffffffff81857545>] acpi_tb_parse_root_table+0x16e/0x1b4
> [    0.000000]  [<ffffffff818575e2>] acpi_initialize_tables+0x57/0x59
> [    0.000000]  [<ffffffff8185591d>] acpi_table_init+0x50/0xce
> [    0.000000]  [<ffffffff8183cea2>] acpi_boot_table_init+0x1e/0x85
> [    0.000000]  [<ffffffff81834638>] setup_arch+0x9b7/0xcc4
> [    0.000000]  [<ffffffff81830b3e>] start_kernel+0x94/0x42d
> [    0.000000]  [<ffffffff81830120>] ? early_idt_handlers+0x120/0x120
> [    0.000000]  [<ffffffff818304a2>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff81830597>] x86_64_start_kernel+0xf3/0x100
> [    0.000000] ---[ end trace 48732c7db414b8fe ]---
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:116 __early_ioremap+0x90/0x1c4()
> [    0.000000] __early_ioremap(ed00c800, 00000c80) not found slot
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W      3.17.0-rc1+ #204
> [    0.000000] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/09/2013
> [    0.000000]  0000000000000000 ffffffff8173b970 ffffffff814bb919 ffffffff8173b9b8
> [    0.000000]  ffffffff8173b9a8 ffffffff810638c9 ffffffff8184ee81 ffffffffff538000
> [    0.000000]  0000000000000c80 0000000000000003 0000000000000c80 ffffffff8173ba08
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff814bb919>] dump_stack+0x4e/0x7a
> [    0.000000]  [<ffffffff810638c9>] warn_slowpath_common+0x75/0x8e
> [    0.000000]  [<ffffffff8184ee81>] ? __early_ioremap+0x90/0x1c4
> [    0.000000]  [<ffffffff81063929>] warn_slowpath_fmt+0x47/0x49
> [    0.000000]  [<ffffffff8184ee81>] __early_ioremap+0x90/0x1c4
> [    0.000000]  [<ffffffff8184f169>] early_ioremap+0x13/0x15
> [    0.000000]  [<ffffffff814ae4f0>] early_efi_map+0x24/0x26
> [    0.000000]  [<ffffffff81060985>] early_efi_scroll_up+0x6d/0xc0
> [    0.000000]  [<ffffffff81060b88>] early_efi_write+0x1b0/0x214
> [    0.000000]  [<ffffffff8109ec3a>] call_console_drivers.constprop.21+0x73/0x7e
> [    0.000000]  [<ffffffff8109fb5d>] console_unlock+0x1fa/0x3b2
> [    0.000000]  [<ffffffff810a0236>] vprintk_emit+0x521/0x532
> [    0.000000]  [<ffffffff8109fce6>] ? console_unlock+0x383/0x3b2
> [    0.000000]  [<ffffffff814b6f01>] printk+0x4f/0x51
> [    0.000000]  [<ffffffff81292f9c>] acpi_os_vprintf+0x2b/0x2d
> [    0.000000]  [<ffffffff81292fe1>] acpi_os_printf+0x43/0x45
> [    0.000000]  [<ffffffff812bc44c>] acpi_info+0x5c/0x63
> [    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
> [    0.000000]  [<ffffffff814afc88>] ? acpi_os_map_iomem+0x21/0x147
> [    0.000000]  [<ffffffff812b7e59>] acpi_tb_print_table_header+0x177/0x186
> [    0.000000]  [<ffffffff812b79da>] acpi_tb_install_table_with_override+0x4b/0x62
> [    0.000000]  [<ffffffff812b7b80>] acpi_tb_install_standard_table+0xd9/0x215
> [    0.000000]  [<ffffffff8184f169>] ? early_ioremap+0x13/0x15
> [    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
> [    0.000000]  [<ffffffff81857545>] acpi_tb_parse_root_table+0x16e/0x1b4
> [    0.000000]  [<ffffffff818575e2>] acpi_initialize_tables+0x57/0x59
> [    0.000000]  [<ffffffff8185591d>] acpi_table_init+0x50/0xce
> [    0.000000]  [<ffffffff8183cea2>] acpi_boot_table_init+0x1e/0x85
> [    0.000000]  [<ffffffff81834638>] setup_arch+0x9b7/0xcc4
> [    0.000000]  [<ffffffff81830b3e>] start_kernel+0x94/0x42d
> [    0.000000]  [<ffffffff81830120>] ? early_idt_handlers+0x120/0x120
> [    0.000000]  [<ffffffff818304a2>] x86_64_start_reservations+0x2a/0x2c
> 
> 
> Quote reply from Lv.zheng about the early ioremap slot usage in this case:
> 
> """
> In early_efi_scroll_up(), 2 mapping entries will be used for the src/dst screen buffer.
> In drivers/acpi/acpica/tbutils.c, we've improved the early table loading code in acpi_tb_parse_root_table().
> We now need 2 mapping entries:
> 1. One mapping entry is used for RSDT table mapping. Each RSDT entry contains an address for another ACPI table.
> 2. For each entry in RSDP, we need another mapping entry to map the table to perform necessary check/override before installing it.
> 
> When acpi_tb_parse_root_table() prints something through EFI earlyprintk console, we'll have 4 mapping entries used.
> The current 4 slots setting of early_ioremap() seems to be too small for such a use case.
> """

In my reply, I only talked about 4 mapping entries which doesn't exceed the current number of early ioremap slot.
Was it better to offer early_ioremap_debug log to prove that we really need to increase it?
And to prove that all of the mappings are done by the code already upstreamed?

Thanks and best regards
-Lv

> 
> Thus increase the slot to 8 in this patch to fix this issue.
> boot-time mappings become 512 page with this patch.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
> I'm not sure if this is ok in 32bit, review and comments are appreciated.
>  arch/x86/include/asm/fixmap.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/include/asm/fixmap.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/fixmap.h
> +++ linux/arch/x86/include/asm/fixmap.h
> @@ -106,14 +106,14 @@ enum fixed_addresses {
>  	__end_of_permanent_fixed_addresses,
> 
>  	/*
> -	 * 256 temporary boot-time mappings, used by early_ioremap(),
> +	 * 512 temporary boot-time mappings, used by early_ioremap(),
>  	 * before ioremap() is functional.
>  	 *
> -	 * If necessary we round it up to the next 256 pages boundary so
> +	 * If necessary we round it up to the next 512 pages boundary so
>  	 * that we can have a single pgd entry and a single pte table:
>  	 */
>  #define NR_FIX_BTMAPS		64
> -#define FIX_BTMAPS_SLOTS	4
> +#define FIX_BTMAPS_SLOTS	8
>  #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
>  	FIX_BTMAP_END =
>  	 (__end_of_permanent_fixed_addresses ^
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
