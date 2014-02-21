Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaBUN26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:28:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaBUMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <cwang@twopensource.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 092/121] fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem
Date: Fri, 21 Feb 2014 12:48:36 +0000
Message-Id: <1392986945-9693-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 96c7a2ff21501691587e1ae969b83cbec8b78e08 upstream.

Recently due to a spike in connections per second memcached on 3
separate boxes triggered the OOM killer from accept.  At the time the
OOM killer was triggered there was 4GB out of 36GB free in zone 1.  The
problem was that alloc_fdtable was allocating an order 3 page (32KiB) to
hold a bitmap, and there was sufficient fragmentation that the largest
page available was 8KiB.

I find the logic that PAGE_ALLOC_COSTLY_ORDER can't fail pretty dubious
but I do agree that order 3 allocations are very likely to succeed.

There are always pathologies where order > 0 allocations can fail when
there are copious amounts of free memory available.  Using the pigeon
hole principle it is easy to show that it requires 1 page more than 50%
of the pages being free to guarantee an order 1 (8KiB) allocation will
succeed, 1 page more than 75% of the pages being free to guarantee an
order 2 (16KiB) allocation will succeed and 1 page more than 87.5% of
the pages being free to guarantee an order 3 allocate will succeed.

A server churning memory with a lot of small requests and replies like
memcached is a common case that if anything can will skew the odds
against large pages being available.

Therefore let's not give external applications a practical way to kill
linux server applications, and specify __GFP_NORETRY to the kmalloc in
alloc_fdmem.  Unless I am misreading the code and by the time the code
reaches should_alloc_retry in __alloc_pages_slowpath (where
__GFP_NORETRY becomes signification).  We have already tried everything
reasonable to allocate a page and the only thing left to do is wait.  So
not waiting and falling back to vmalloc immediately seems like the
reasonable thing to do even if there wasn't a chance of triggering the
OOM killer.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Cong Wang <cwang@twopensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..9de2026 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -34,7 +34,7 @@ static void *alloc_fdmem(size_t size)
 	 * vmalloc() if the allocation size will be considered "large" by the VM.
 	 */
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
 		if (data != NULL)
 			return data;
 	}
-- 
1.9.0

