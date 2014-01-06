Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaAFR1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:27:18 -0500
Received: from fujitsu24.fnanic.fujitsu.com ([192.240.6.14]:39128 "EHLO
	fujitsu24.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755273AbaAFR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:16 -0500
X-Greylist: delayed 2295 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 12:27:16 EST
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
CC: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        Nick Piggin <npiggin@suse.de>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 08:47:23 -0800
Subject: RE: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
Thread-Topic: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
Thread-Index: Ac8I4nh/yI4qwULXRx2N6crKp2ehEwCEqqzQ
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E2BF812BC82@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com>
	<52B11765.8030005@oracle.com>
	<52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com>
	<52B166CF.6080300@suse.cz>
	<52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com>
	<20131218134316.977d5049209d9278e1dad225@linux-foundation.org>
	<52C71ACC.20603@oracle.com>
	<CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
	<52C74972.6050909@suse.cz>
 <CA+55aFzq1iQqddGo-m=vutwMYn5CPf65Ergov5svKR4AWC3rUQ@mail.gmail.com>
In-Reply-To: <CA+55aFzq1iQqddGo-m=vutwMYn5CPf65Ergov5svKR4AWC3rUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-06_02:2014-01-06,2014-01-06,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06HRMtH008379



> -----Original Message-----
> From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus
> Torvalds
> Sent: Friday, January 03, 2014 7:18 PM
> To: Vlastimil Babka
> Cc: Sasha Levin; Andrew Morton; Wanpeng Li; Michel Lespinasse; Bob Liu;
> Nick Piggin; Motohiro Kosaki JP; Rik van Riel; David Rientjes; Mel Gorman;
> Minchan Kim; Hugh Dickins; Johannes Weiner; linux-mm; Linux Kernel Mailing
> List
> Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear
> VMAs
> 
> On Fri, Jan 3, 2014 at 3:36 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > I'm for going with the removal of BUG_ON. The TestSetPageMlocked
> > should provide enough race protection.
> 
> Maybe. But dammit, that's subtle, and I don't think you're even right.
> 
> It basically depends on mlock_vma_page() and munlock_vma_page() being
> able to run CONCURRENTLY on the same page. In particular, you could have a
> mlock_vma_page() set the bit on one CPU, and munlock_vma_page()
> immediately clearing it on another, and then the rest of those functions
> could run with a totally arbitrary interleaving when working with the exact
> same page.
> 
> They both do basically
> 
>     if (!isolate_lru_page(page))
>         putback_lru_page(page);
> 
> but one or the other would randomly win the race (it's internally protected
> by the lru lock), and *if* the munlock_vma_page() wins it, it would also do
> 
>     try_to_munlock(page);
> 
> but if mlock_vma_page() wins it, that wouldn't happen. That looks entirely
> broken - you end up with the PageMlocked bit clear, but
> try_to_munlock() was never called on that page, because
> mlock_vma_page() got to the page isolation before the "subsequent"
> munlock_vma_page().
> 
> And this is very much what the page lock serialization would prevent.
> So no, the PageMlocked in *no* way gives serialization. It's an atomic bit op,
> yes, but that only "serializes" in one direction, not when you can have a mix
> of bit setting and clearing.
> 
> So quite frankly, I think you're wrong. The BUG_ON() is correct, or at least
> enforces some kind of ordering. And try_to_unmap_cluster() is just broken
> in calling that without the page being locked. That's my opinion. There may
> be some *other* reason why it all happens to work, but no,
> "TestSetPageMlocked should provide enough race protection" is simply not
> true, and even if it were, it's way too subtle and odd to be a good rule.
> 
> So I really object to just removing the BUG_ON(). Not with a *lot* more
> explanation as to why these kinds of issues wouldn't matter.

I don't have a perfect answer. But I can explain a bit history. Let's me try.

First off, 5 years ago, Lee's original putback_lru_page() implementation required
page-lock, but I removed the restriction months later. That's why we can see 
strange BUG_ON here. 

5 years ago, both mlock(2) and munlock(2) called do_mlock() and it was protected  by 
mmap_sem (write mdoe). Then, mlock and munlock had no race. 
Now, __mm_populate() (called by mlock(2)) is only protected by mmap_sem read-mode. However it is enough to
protect against munlock.

Next, In case of mlock vs reclaim, the key is that mlock(2) has two step operation. 1) turn on VM_LOCKED under
mmap_sem write-mode, 2) turn on Page_Mlocked under mmap_sem read-mode. If reclaim race against step (1),
reclaim must lose because it uses trylock. On the other hand, if reclaim race against step (2), reclaim must detect
VM_LOCKED because both VM_LOCKED modifier and observer take mmap-sem.

By the way, page isolation is still necessary because we need to protect another page modification like page migration.


My memory was alomostly flushed and I might lost some technical concern and past discussion. Please point me out,
If I am overlooking something.

Thanks.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
