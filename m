Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaAJRtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:49:25 -0500
Received: from fujitsu24.fnanic.fujitsu.com ([192.240.6.14]:56061 "EHLO
	fujitsu24.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbaAJRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:49:20 -0500
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        Nick Piggin <npiggin@suse.de>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 10 Jan 2014 09:48:54 -0800
Subject: RE: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
Thread-Topic: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
Thread-Index: Ac8LuWRC6YlwtjWzQlW7/lclSrDc3gA8ZrUQ
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E2C386DF586@SV-EXCHANGE1.Corp.FC.LOCAL>
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
 <6B2BA408B38BA1478B473C31C3D2074E2BF812BC82@SV-EXCHANGE1.Corp.FC.LOCAL>
 <52CC16DC.9070308@suse.cz>
In-Reply-To: <52CC16DC.9070308@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-10_05:2014-01-10,2014-01-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0AHnanH010840

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 068522d..b99c742 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1389,9 +1389,19 @@ static int try_to_unmap_cluster(unsigned long
> cursor, unsigned int *mapcount,
>  		BUG_ON(!page || PageAnon(page));
> 
>  		if (locked_vma) {
> -			mlock_vma_page(page);   /* no-op if already
> mlocked */
> -			if (page == check_page)
> +			if (page == check_page) {
> +				/* we know we have check_page locked */
> +				mlock_vma_page(page);
>  				ret = SWAP_MLOCK;
> +			} else if (trylock_page(page)) {
> +				/*
> +				 * If we can lock the page, perform mlock.
> +				 * Otherwise leave the page alone, it will be
> +				 * eventually encountered again later.
> +				 */
> +				mlock_vma_page(page);
> +				unlock_page(page);
> +			}
>  			continue;	/* don't unmap */
>  		}

I audited all related mm code. However I couldn't find any race that it can close.

First off,  current munlock code is crazy tricky.

munlock
	down_write(mmap_sem)
	do_mlock()
		mlock_fixup
			munlock_vma_pages_range
				__munlock_pagevec
					spin_lock_irq(zone->lru_lock)
					TestClearPageMlocked(page)
					del_page_from_lru_list
					spin_unlock_irq(zone->lru_lock)
					lock_page
					__munlock_isolated_page
					unlock_page
				
	up_write(mmap_sem)

Look, TestClearPageMlocked(page) is not protected by lock_page. But this is still
safe because Page_mocked mean one or more vma marked VM_LOCKED then we
only need care about turning down final VM_LOCKED. I.e. mmap_sem protect them.

And,

					spin_lock_irq(zone->lru_lock)
					del_page_from_lru_list
					spin_unlock_irq(zone->lru_lock)

This idiom ensures I or someone else isolate the page from lru and isolated pages
will be put back by putback_lru_page in anycase. So, the pages will move the right
lru eventually.

And then, taking page-lock doesn't help to close vs munlock race.

On the other hands, page migration has the following call stack. 

some-caller [isolate_lru_page]
	unmap_and_move
		__unmap_and_move
		trylock_page
		try_to_unmap
		move_to_new_page
			migrate_page
				migrate_page_copy
		unlock_page

The critical part (i.e. migrate_page_copy) is protected by both page isolation and page lock.
Page fault path take lock page and doesn't use page isolation. This is correct.
try_to_unmap_cluster doesn't take page lock, but it ensure the page is isolated. This is correct too.

Plus, do_wp_page() has the following comment. But it is wrong. This lock is necessary to protect against
page migration, but not lru manipulation.

		if ((ret & VM_FAULT_WRITE) && (vma->vm_flags & VM_LOCKED)) {
			lock_page(old_page);	/* LRU manipulation */
			munlock_vma_page(old_page);
			unlock_page(old_page);
		}


But, you know, this is crazy ugly lock design. I'm ok to change the rule to that PG_mlocked must be protected
page lock. If so, I propose to add PageMlocked() like this

			} else if (!PageMlocked() && trylock_page(page)) {
				/*
				 * If we can lock the page, perform mlock.
				 * Otherwise leave the page alone, it will be
				 * eventually encountered again later.
				 */
				mlock_vma_page(page);
				unlock_page(page);

This is safe. Even if race is happen and vmscan failed to mark PG_mlocked, that's no problem. Next vmscan may
do the right job and will fix the mistake.

Anyway,  I'm also sure this is not recent issue. It lived 5 years. It is no reason to rush.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
