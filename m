Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbaELO5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:57:03 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:1936 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaELO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:57:01 -0400
Message-ID: <5370E139.50806@imgtec.com>
Date: Mon, 12 May 2014 15:56:57 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in __compiletime_assert()
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>	 <5370CFAC.40705@imgtec.com> <1399905481.4337.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399905481.4337.16.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On 12/05/14 15:38, Johannes Berg wrote:
>> Unfortunately this breaks the build of today's linux-next for the Meta
>> architecture (arch/metag), which happens to use a fairly old compiler
>> (based on gcc 4.2.4) which I presume is the reason why.
> 
> That's very odd.
> 
> Unfortunately, I don't have most of arch/metag, it seems, where could I
> get it? In particular no gup.c exists for metag in Linus's current tree.

Hmm, mm/gup.c appears to be a new addition in linux-next from commit
3284cee59933 (mm: move get_user_pages()-related code to separate file)
so probably wasn't the best example.

My build output was from commit 0bed496ac091 (compiler.h: don't use
temporary variable in __compiletime_assert()) which is the first bad
commit according to a bisection of linux-next/stable..linux-next/master.

>> A bunch of compile time asserts fail, even in code which should be
>> optimised out. E.g. here's one which I analysed:
>>
>> mm/gup.c: In function ‘follow_page_mask’:
>> mm/gup.c:208: error: size of array ‘type name’ is negative
>>
>> Line 208 uses HPAGE_PMD_NR which expands to a HPAGE_PMD_SHIFT, which
>> expands to a BUILD_BUG(). However that line is inside an if block
>> conditioned on pmd_trans_huge(*pmd) which include/asm-generic/pgtable.h
>> defines inline to return 0, so the whole block should already be being
>> optimised out.
>>
>> I don't understand why your patch should break things, I suspect it's
>> related to the sparse behaviour you're trying to work around, but can we
>> please drop this patch until a more portable workaround can be found?
>> I'm happy to test further patches with metag if it helps.
> 
> I don't really understand that either - if the compiler could prove that
> the assignment to __cond was a constant, and remember that __cond is now
> constant, I don't really see why it can't follow that through and
> consider "!(condition)" a const??
> 
> I suppose the other option for the original problem is to ignore
> _compiletime_assert() for sparse, like we do for BUG_ON(), but it'd
> probably be good to analyse more why this particular code is broken now.

The first one I analysed was strange too (the fixmap.h one). It appears
that this particular assert was questionable anyway for metag which is
why I didn't mention it, the case above is much more clear cut.

Given an unsigned int idx argument the inline function fix_to_virt
basically did:
BUILD_BUG_ON(idx >= __end_of_fixed_addresses)

where __end_of_fixed_addresses is an enum value which is 0 when
CONFIG_HIGHMEM=n. In that case it took your patch for the compiler to
apparently realise that an unsigned int is always >= 0, therefore the
BUILD_BUG_ON will always fire, even though nothing actually called
fix_to_virt from that source file so the code wasn't being used. I
briefly attempted to reproduce this issue on other arches with newer
compilers without success.

Cheers
James
