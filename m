Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaKLPWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:22:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:53298 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaKLPWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:22:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,369,1413270000"; 
   d="scan'208";a="630842304"
Message-ID: <54637AD5.6060300@intel.com>
Date: Wed, 12 Nov 2014 07:20:53 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Matt Fleming <matt.fleming@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
References: <5462999A.7090706@intel.com> <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com> <54637576.7030004@intel.com> <20141112151106.GB17793@pd.tnic>
In-Reply-To: <20141112151106.GB17793@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 07:11 AM, Borislav Petkov wrote:
>> > [    1.161406] __phys_addr() x: 0x000078009d3c6000
>> > [    1.166567] __phys_addr() origx: 0x000000009d3c6000
>> > [    1.171832] __phys_addr() y: 0x000000011d3c6000
>> > [    1.176999] __phys_addr() __START_KERNEL_map: 0xffffffff80000000
>> > [    1.183841] __phys_addr() PAGE_OFFSET: 0xffff880000000000
>> > [    1.189993] __phys_addr() x valid: 0
>> > 
>> > So it looks like the root cause is a physical address getting pass in in
>> > the first place instead of a virtual.
> I'd say that's on purpose as we're mapping kernel text 1:1 in the EFI
> page table.

__pa and friends do their calculations *against* PAGE_OFFSET to do the
virt<->phys translation.  If that's not what a caller wants, then
they're calling the wrong function.

The path that we're actually hitting this from is:

> __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long
...
>         if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
>                                 PFN_DOWN(__pa(address)) + 1))
>                 split_page_count(level);

So perhaps efi_map_region() is handing an address from the EFI identity
map down in here.  __pa() gets called on it, but that fails since __pa()
only works on the *KERNEL* identity map.

I think we might actually need to walk the page tables in there.  Even
the pfn_range_is_mapped() code looks to be dealing with the kernel
identity map.
