Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbbAVKQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:16:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbbAVKP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:15:57 -0500
Message-ID: <54C0CDD8.2010205@suse.com>
Date: Thu, 22 Jan 2015 11:15:52 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        stefan.bader@canonical.com,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        ville.syrjala@linux.intel.com, David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <jbeulich@suse.com>, toshi.kani@hp.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH V6 01/18] x86: Make page cache mode a real type
References: <1415019724-4317-1-git-send-email-jgross@suse.com>	<1415019724-4317-2-git-send-email-jgross@suse.com> <CAKbGBLhzOPXqWuDwEoqnvC05c1cFgXrJMHFmeCjwUYcff==F3A@mail.gmail.com>
In-Reply-To: <CAKbGBLhzOPXqWuDwEoqnvC05c1cFgXrJMHFmeCjwUYcff==F3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 08:11 AM, Steven Noonan wrote:
> On Mon, Nov 3, 2014 at 5:01 AM, Juergen Gross <jgross@suse.com> wrote:
>> At the moment there are a lot of places that handle setting or getting
>> the page cache mode by treating the pgprot bits equal to the cache mode.
>> This is only true because there are a lot of assumptions about the setup
>> of the PAT MSR. Otherwise the cache type needs to get translated into
>> pgprot bits and vice versa.
>>
>> This patch tries to prepare for that by introducing a separate type
>> for the cache mode and adding functions to translate between those and
>> pgprot values.
>>
>> To avoid too much performance penalty the translation between cache mode
>> and pgprot values is done via tables which contain the relevant
>> information.  Write-back cache mode is hard-wired to be 0, all other
>> modes are configurable via those tables. For large pages there are
>> translation functions as the PAT bit is located at different positions
>> in the ptes of 4k and large pages.
>>
>> Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
...
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 66dba36..a9776ba 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -27,6 +27,35 @@
>>
>>   #include "mm_internal.h"
>>
>> +/*
>> + * Tables translating between page_cache_type_t and pte encoding.
>> + * Minimal supported modes are defined statically, modified if more supported
>> + * cache modes are available.
>> + * Index into __cachemode2pte_tbl is the cachemode.
>> + * Index into __pte2cachemode_tbl are the caching attribute bits of the pte
>> + * (_PAGE_PWT, _PAGE_PCD, _PAGE_PAT) at index bit positions 0, 1, 2.
>> + */
>> +uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
>> +       [_PAGE_CACHE_MODE_WB]           = 0,
>> +       [_PAGE_CACHE_MODE_WC]           = _PAGE_PWT,
>> +       [_PAGE_CACHE_MODE_UC_MINUS]     = _PAGE_PCD,
>> +       [_PAGE_CACHE_MODE_UC]           = _PAGE_PCD | _PAGE_PWT,
>> +       [_PAGE_CACHE_MODE_WT]           = _PAGE_PCD,
>> +       [_PAGE_CACHE_MODE_WP]           = _PAGE_PCD,
>> +};
>> +EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
>> +uint8_t __pte2cachemode_tbl[8] = {
>> +       [__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
>> +       [__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
>> +       [__pte2cm_idx(_PAGE_PCD)] = _PAGE_CACHE_MODE_UC_MINUS,
>> +       [__pte2cm_idx(_PAGE_PWT | _PAGE_PCD)] = _PAGE_CACHE_MODE_UC,
>> +       [__pte2cm_idx(_PAGE_PAT)] = _PAGE_CACHE_MODE_WB,
>> +       [__pte2cm_idx(_PAGE_PWT | _PAGE_PAT)] = _PAGE_CACHE_MODE_WC,
>> +       [__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
>> +       [__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
>> +};
>> +EXPORT_SYMBOL_GPL(__pte2cachemode_tbl);
>> +
>
> I notice these two symbols are exported GPL-only. This breaks builds
> of several out-of-tree non-GPL modules such as the NVIDIA driver, and
> VMware modules, etc. What is the appropriate code path for proprietary
> modules to use when setting page cache mode flags? Alternatively, is
> it possible for these EXPORT_SYMBOL_GPLs to be changed to
> EXPORT_SYMBOL?

I don't mind you sending a patch to change this. I won't object such a
patch. OTOH this is more kind of a political question and I don't want
to spend my time on arguing.

Juergen

