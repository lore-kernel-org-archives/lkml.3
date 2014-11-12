Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaKLO6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:58:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:54153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaKLO6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:58:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,369,1413270000"; 
   d="scan'208";a="606626413"
Message-ID: <54637576.7030004@intel.com>
Date: Wed, 12 Nov 2014 06:57:58 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Borislav Petkov <bp@suse.de>, the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
References: <5462999A.7090706@intel.com> <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 01:24 AM, Matt Fleming wrote:
> On Tue, 2014-11-11 at 15:19 -0800, Dave Hansen wrote:
>> I'm seeing a BUG() at boot in __phys_addr when it has DEBUG_VIRTUAL enabled:
>>
>>>> [    1.193264] ------------[ cut here ]------------
>>>> [    1.198502] kernel BUG at /home/davehans/linux.git/arch/x86/mm/physaddr.c:36!
>>> ...
>>>> [    1.368810] Call Trace:
>>>> [    1.371590]  [<ffffffff8105824c>] __change_page_attr_set_clr+0x42c/0xff0
>>>> [    1.379197]  [<ffffffff81059e42>] kernel_map_pages_in_pgd+0x72/0x110
>>>> [    1.386410]  [<ffffffff81fe2be2>] __map_region+0x45/0x63
>>>> [    1.392437]  [<ffffffff81fe2e13>] efi_map_region+0x32/0xce
>>>> [    1.398663]  [<ffffffff81fe2936>] efi_enter_virtual_mode+0x18c/0x3a4
>>>> [    1.405876]  [<ffffffff81fcb0b6>] start_kernel+0x421/0x4a1
>>>> [    1.412101]  [<ffffffff81fcaa85>] ? set_init_arg+0x55/0x55
>>>> [    1.418327]  [<ffffffff81fca120>] ? early_idt_handlers+0x120/0x120
>>>> [    1.425342]  [<ffffffff81fca5f2>] x86_64_start_reservations+0x2a/0x2c
>>>> [    1.432652]  [<ffffffff81fca746>] x86_64_start_kernel+0x152/0x161
>>>> [    1.439565] Code: 0f 94 c2 31 c0 e8 a6 47 83 00 48 c7 c7 41 49 cc 81 31 c0 e8 98 47 83 00 31 d2 be 01 00 00 00 48 c7 c7 a0 49 f2 81 e8 ab 4a 0e 00 <0f> 0b 0f 0b 4c 89 e2 48 c7 c6 b3 e5 a0 81 48 c7 c7 5c 7a ca 81 
>>>> [    1.461866] RIP  [<ffffffff8105c055>] __phys_addr+0x185/0x260
>>>> [    1.468400]  RSP <ffffffff81e03cf8>
>>>> [    1.472396] ---[ end trace b59b0f17341a4bc4 ]---
> 
> I'm having trouble linking that BUG_ON() with a line in Linus' tree.
> What's the failing expression?

It's actually tripping over this in __phys_addr:

     VIRTUAL_BUG_ON((x > y) || !phys_addr_valid(x));

I dumped out a few of the variables too:

[    1.161406] __phys_addr() x: 0x000078009d3c6000
[    1.166567] __phys_addr() origx: 0x000000009d3c6000
[    1.171832] __phys_addr() y: 0x000000011d3c6000
[    1.176999] __phys_addr() __START_KERNEL_map: 0xffffffff80000000
[    1.183841] __phys_addr() PAGE_OFFSET: 0xffff880000000000
[    1.189993] __phys_addr() x valid: 0

So it looks like the root cause is a physical address getting pass in in
the first place instead of a virtual.
