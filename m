Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaACXg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:36:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbaACXgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:36:25 -0500
Message-ID: <52C74972.6050909@suse.cz>
Date: Sat, 04 Jan 2014 00:36:18 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        Nick Piggin <npiggin@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com>	<52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com>	<52B11765.8030005@oracle.com>	<52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com>	<52B166CF.6080300@suse.cz>	<52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com>	<20131218134316.977d5049209d9278e1dad225@linux-foundation.org>	<52C71ACC.20603@oracle.com> <CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
In-Reply-To: <CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 09:52 PM, Linus Torvalds wrote:
> On Fri, Jan 3, 2014 at 12:17 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> Ping? This BUG() is triggerable in 3.13-rc6 right now.
> 
> So Andrew suggested just removing the BUG_ON(), but it's been there
> for a *long* time.

Yes, Andrew also merged this patch for that:
 http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-bug_on-from-mlock_vma_page.patch

But there wasn't enough confidence in the fix to sent it to you yet, I guess.

The related thread: http://www.spinics.net/lists/linux-mm/msg66972.html

> And I detest the patch that was sent out that said "Should I check?"
> 
> Maybe we should just remove that mlock_vma_page() thing instead in

You mean that it it's already undeterministic because it can be already skipped when
mmap_sem can't be acquired for read? I think the assumption for this case is that mmap_sem
is already held for write which means VM_LOCKED is unset anyway (per comments at
try_to_unmap_file(), which calls try_to_unmap_cluster()). I'm however not sure how it is
protected from somebody else holding the semaphore...

> try_to_unmap_cluster()? Or maybe actually lock the page around calling
> it?

check_page is already locked, see try_to_munlock() which calls try_to_unmap_file(). So
this might smell of potential deadlock?

I'm for going with the removal of BUG_ON. The TestSetPageMlocked should provide enough
race protection.

>              Linus
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

