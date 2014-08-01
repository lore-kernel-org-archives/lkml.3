Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaHAOwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:52:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:55662 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaHAOwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:52:31 -0400
X-IronPort-AV: E=Sophos;i="5.01,780,1400025600"; 
   d="scan'208";a="158488317"
Message-ID: <53DBA9AC.8000302@citrix.com>
Date: Fri, 1 Aug 2014 15:52:28 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Matt Rushton <mvrushton@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <msw@amazon.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v2 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1405814495-10868-1-git-send-email-mrushton@amazon.com> <1405814495-10868-2-git-send-email-mrushton@amazon.com> <53DA805D.4020300@citrix.com>
In-Reply-To: <53DA805D.4020300@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/14 18:43, David Vrabel wrote:
> On 20/07/14 01:01, Matt Rushton wrote:
>> Instead of ballooning up and down dom0 memory this remaps the existing mfns
>> that were replaced by the identity map. The reason for this is that the
>> existing implementation ballooned memory up and and down which caused dom0
>> to have discontiguous pages. In some cases this resulted in the use of bounce
>> buffers which reduced network I/O performance significantly. This change will
>> honor the existing order of the pages with the exception of some boundary
>> conditions.
>>
>> To do this we need to update both the Linux p2m table and the Xen m2p table.
>> Particular care must be taken when updating the p2m table since it's important
>> to limit table memory consumption and reuse the existing leaf pages which get
>> freed when an entire leaf page is set to the identity map. To implement this,
>> mapping updates are grouped into blocks with table entries getting cached
>> temporarily and then released.
>>
>> On my test system before:
>> Total pages: 2105014
>> Total contiguous: 1640635
>>
>> After:
>> Total pages: 2105014
>> Total contiguous: 2098904
> 
> Applied to devel/for-linus-3.17

Unfortunately, this produces too many WARNINGs on some boxes or
with certain configurations.

I will remove this patch from the queue for 3.17.

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at /home/build/linux-boris/arch/x86/xen/setup.c:237 xen_update_mem_tables+0xae/0xb8()
[    0.000000] Failed to set m2p mapping for mfn=2302110 pfn=255744
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5upstream-00266-gf83c52f #1
[    0.000000]  000000ed c17e9d2c c1615056 c1730590 c17e9d5c c109032f c1730618 c17e9d88
[    0.000000]  00000000 c1730590 000000ed c185b4c3 c185b4c3 deadbeef deadbeef 0000009e
[    0.000000]  c17e9d74 c10903ce 00000009 c17e9d6c c1730618 c17e9d88 c17e9db4 c185b4c3
[    0.000000] Call Trace:
[    0.000000]  [<c1615056>] dump_stack+0x48/0x60
[    0.000000]  [<c109032f>] warn_slowpath_common+0x7f/0xa0
[    0.000000]  [<c185b4c3>] ? xen_update_mem_tables+0xae/0xb8
[    0.000000]  [<c185b4c3>] ? xen_update_mem_tables+0xae/0xb8
[    0.000000]  [<c10903ce>] warn_slowpath_fmt+0x2e/0x30
[    0.000000]  [<c185b4c3>] xen_update_mem_tables+0xae/0xb8
[    0.000000]  [<c185bbbf>] xen_memory_setup+0x544/0xb33
[    0.000000]  [<c12de82c>] ? sprintf+0x1c/0x20
[    0.000000]  [<c1861b32>] setup_memory_map+0x19/0x3b
[    0.000000]  [<c185b332>] ? xen_arch_setup+0xad/0xe1
[    0.000000]  [<c185fc33>] setup_arch+0x246/0xe68
[    0.000000]  [<c103bd7e>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
[    0.000000]  [<c10dc5ec>] ? vprintk_emit+0x19c/0x4a0
[    0.000000]  [<c1614efe>] ? printk+0x48/0x4a
[    0.000000]  [<c18569dc>] start_kernel+0x76/0x435
[    0.000000]  [<c103bf77>] ? xen_setup_runstate_info+0x27/0x40
[    0.000000]  [<c1856373>] i386_start_kernel+0x12e/0x131
[    0.000000]  [<c185b106>] xen_start_kernel+0x661/0x66c
[    0.000000] ---[ end trace db4b7fde7786bb07 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at /home/build/linux-boris/arch/x86/xen/setup.c:350 xen_memory_setup+0x580/0xb33()
[    0.000000] Failed to update mem mapping for pfn=256000 mfn=2302110
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W     3.16.0-rc5upstream-00266-gf83c52f #1
[    0.000000]  0000015e c17e9d6c c1615056 c1730590 c17e9d9c c109032f c17306b4 c17e9dc8
[    0.000000]  00000000 c1730590 0000015e c185bbfb c185bbfb 00000062 0003e700 0023209e
[    0.000000]  c17e9db4 c10903ce 00000009 c17e9dac c17306b4 c17e9dc8 c17e9e80 c185bbfb
[    0.000000] Call Trace:
[    0.000000]  [<c1615056>] dump_stack+0x48/0x60
[    0.000000]  [<c109032f>] warn_slowpath_common+0x7f/0xa0
[    0.000000]  [<c185bbfb>] ? xen_memory_setup+0x580/0xb33
[    0.000000]  [<c185bbfb>] ? xen_memory_setup+0x580/0xb33
[    0.000000]  [<c10903ce>] warn_slowpath_fmt+0x2e/0x30
[    0.000000]  [<c185bbfb>] xen_memory_setup+0x580/0xb33
[    0.000000]  [<c12de82c>] ? sprintf+0x1c/0x20
[    0.000000]  [<c1861b32>] setup_memory_map+0x19/0x3b
[    0.000000]  [<c185b332>] ? xen_arch_setup+0xad/0xe1
[    0.000000]  [<c185fc33>] setup_arch+0x246/0xe68
[    0.000000]  [<c103bd7e>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
[    0.000000]  [<c10dc5ec>] ? vprintk_emit+0x19c/0x4a0
[    0.000000]  [<c1614efe>] ? printk+0x48/0x4a
[    0.000000]  [<c18569dc>] start_kernel+0x76/0x435
[    0.000000]  [<c103bf77>] ? xen_setup_runstate_info+0x27/0x40
[    0.000000]  [<c1856373>] i386_start_kernel+0x12e/0x131
[    0.000000]  [<c185b106>] xen_start_kernel+0x661/0x66c
[    0.000000] ---[ end trace db4b7fde7786bb08 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at /home/build/linux-boris/arch/x86/xen/setup.c:436 xen_memory_setup+0x654/0xb33()
[    0.000000] Failed to remap 1:1 memory cur_pfn=158 size=98 remap_pfn=255744
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W     3.16.0-rc5upstream-00266-gf83c52f #1
[    0.000000]  000001b4 c17e9d6c c1615056 c1730590 c17e9d9c c109032f c17306e8 c17e9dc8
[    0.000000]  00000000 c1730590 000001b4 c185bccf c185bccf c17e9e70 0003e700 0023209e
[    0.000000]  c17e9db4 c10903ce 00000009 c17e9dac c17306e8 c17e9dc8 c17e9e80 c185bccf
[    0.000000] Call Trace:
[    0.000000]  [<c1615056>] dump_stack+0x48/0x60
[    0.000000]  [<c109032f>] warn_slowpath_common+0x7f/0xa0
[    0.000000]  [<c185bccf>] ? xen_memory_setup+0x654/0xb33
[    0.000000]  [<c185bccf>] ? xen_memory_setup+0x654/0xb33
[    0.000000]  [<c10903ce>] warn_slowpath_fmt+0x2e/0x30
[    0.000000]  [<c185bccf>] xen_memory_setup+0x654/0xb33
[    0.000000]  [<c1861b32>] setup_memory_map+0x19/0x3b
[    0.000000]  [<c185b332>] ? xen_arch_setup+0xad/0xe1
[    0.000000]  [<c185fc33>] setup_arch+0x246/0xe68
[    0.000000]  [<c103bd7e>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
[    0.000000]  [<c10dc5ec>] ? vprintk_emit+0x19c/0x4a0
[    0.000000]  [<c1614efe>] ? printk+0x48/0x4a
[    0.000000]  [<c18569dc>] start_kernel+0x76/0x435
[    0.000000]  [<c103bf77>] ? xen_setup_runstate_info+0x27/0x40
[    0.000000]  [<c1856373>] i386_start_kernel+0x12e/0x131
[    0.000000]  [<c185b106>] xen_start_kernel+0x661/0x66c
[    0.000000] ---[ end trace db4b7fde7786bb09 ]---
[    0.000000] Freeing 9e-100 pfn range: 98 pages freed
[    0.000000] Set 266437667 page(s) to 1-1 mapping
[    0.000000] Remapped 0 page(s), last_pfn=255744
[    0.000000] Released 98 page(s)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at /home/build/linux-boris/arch/x86/xen/setup.c:95 xen_memory_setup+0x9c4/0xb33()
[    0.000000] Trying to remove 3e700 which has 23209e mfn!
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W     3.16.0-rc5upstream-00266-gf83c52f #1
[    0.000000]  0000005f c17e9d6c c1615056 c1730590 c17e9d9c c109032f c17307d0 c17e9dc8
[    0.000000]  00000000 c1730590 0000005f c185c03f c185c03f 3e700000 00000000 00000003
[    0.000000]  c17e9db4 c10903ce 00000009 c17e9dac c17307d0 c17e9dc8 c17e9e80 c185c03f
[    0.000000] Call Trace:
[    0.000000]  [<c1615056>] dump_stack+0x48/0x60
[    0.000000]  [<c109032f>] warn_slowpath_common+0x7f/0xa0
[    0.000000]  [<c185c03f>] ? xen_memory_setup+0x9c4/0xb33
[    0.000000]  [<c185c03f>] ? xen_memory_setup+0x9c4/0xb33
[    0.000000]  [<c10903ce>] warn_slowpath_fmt+0x2e/0x30
[    0.000000]  [<c185c03f>] xen_memory_setup+0x9c4/0xb33
[    0.000000]  [<c1861b32>] setup_memory_map+0x19/0x3b
[    0.000000]  [<c185b332>] ? xen_arch_setup+0xad/0xe1
[    0.000000]  [<c185fc33>] setup_arch+0x246/0xe68
[    0.000000]  [<c103bd7e>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
[    0.000000]  [<c10dc5ec>] ? vprintk_emit+0x19c/0x4a0
[    0.000000]  [<c1614efe>] ? printk+0x48/0x4a
[    0.000000]  [<c18569dc>] start_kernel+0x76/0x435
[    0.000000]  [<c103bf77>] ? xen_setup_runstate_info+0x27/0x40
[    0.000000]  [<c1856373>] i386_start_kernel+0x12e/0x131
[    0.000000]  [<c185b106>] xen_start_kernel+0x661/0x66c
[    0.000000] ---[ end trace db4b7fde7786bb0a ]---
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] Xen: [mem 0x000000000009ec00-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000004d061fff] usable
[    0.000000] Xen: [mem 0x000000004d062000-0x00000000a79b7fff] unusable
[    0.000000] Xen: [mem 0x00000000a79b8000-0x00000000a79fefff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a79ff000-0x00000000a7a08fff] ACPI data
[    0.000000] Xen: [mem 0x00000000a7a09000-0x00000000a7a65fff] reserved
[    0.000000] Xen: [mem 0x00000000a7a66000-0x00000000a7a68fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a7a69000-0x00000000a7a6afff] unusable
[    0.000000] Xen: [mem 0x00000000a7a6b000-0x00000000a7a6bfff] reserved
[    0.000000] Xen: [mem 0x00000000a7a6c000-0x00000000a7a6cfff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a7a6d000-0x00000000a7aa3fff] reserved
[    0.000000] Xen: [mem 0x00000000a7aa4000-0x00000000a7aaafff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a7aab000-0x00000000a7ad1fff] reserved
[    0.000000] Xen: [mem 0x00000000a7ad2000-0x00000000a7b14fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a7b15000-0x00000000a7d91fff] unusable
[    0.000000] Xen: [mem 0x00000000a7d92000-0x00000000a7ef6fff] reserved
[    0.000000] Xen: [mem 0x00000000a7ef7000-0x00000000a7efffff] unusable
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] Xen: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] Xen: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] Xen: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100001000-0x000000023fffffff] unusable
[    0.000000] Xen: [mem 0x000000fd00000000-0x000000ffffffffff] reserved

David
