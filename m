Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaGHWcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:32:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:52423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbaGHWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,628,1400050800"; 
   d="scan'208";a="540491162"
Message-ID: <53BC717E.6020705@intel.com>
Date: Tue, 08 Jul 2014 15:32:30 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 1/3] mm: introduce fincore()
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404756006-23794-2-git-send-email-n-horiguchi@ah.jp.nec.com> <53BAEE95.50807@intel.com> <20140708190326.GA28595@nhori> <53BC49C2.8090409@intel.com> <20140708204132.GA16195@nhori.redhat.com>
In-Reply-To: <20140708204132.GA16195@nhori.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 01:41 PM, Naoya Horiguchi wrote:
>> >  It would only set the first two bytes of a
>> > 256k BMAP buffer since only two pages were encountered in the radix tree.
> Hmm, this example shows me a problem, thanks.
> 
> If the user knows the fd is for 1GB hugetlbfs file, it just prepares
> the 2 bytes buffer, so no problem.
> But if the user doesn't know whether the fd is from hugetlbfs file,
> the user must prepare the large buffer, though only first few bytes
> are used. And the more problematic is that the user could interpret
> the data in buffer differently:
>   1. only the first two 4kB-pages are loaded in the 2GB range,
>   2. two 1GB-pages are loaded.
> So for such callers, fincore() must notify the relevant page size
> in some way on return.
> Returning it via fincore_extra is my first thought but I'm not sure
> if it's elegant enough.

That does limit the interface to being used on a single page size per
call, which doesn't sound too bad since we don't mix page sizes in a
single file.  But, you mentioned using this interface along with
/proc/$pid/mem.  How would this deal with a process which had two sizes
of pages mapped?

Another option would be to have userspace pass in its desired
granularity.  Such an interface could be used to find holes in a file
fairly easily.  But, introduces a whole new set of issues, like what
BMAP means if only a part of the granule is in-core, and do you need a
new option to differentiate BMAP_AND vs. BMAP_OR operations.

I honestly think we need to take a step back and enumerate what you're
trying to do here before going any further.
