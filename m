Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaCaABA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:01:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbaC3XnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David Rientjes" <rientjes@google.com>,
        "Cong Wang" <cwang@twopensource.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.286800043@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 100/200] fs/file.c:fdtable: avoid triggering OOMs from
 alloc_fdmem
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -47,7 +47,7 @@ static void *alloc_fdmem(unsigned int si
 	 * vmalloc() if the allocation size will be considered "large" by the VM.
 	 */
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
 		if (data != NULL)
 			return data;
 	}

