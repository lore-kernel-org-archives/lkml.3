Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaLHLRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:17:51 -0500
Received: from mail2.tiolive.com ([94.23.229.207]:35228 "EHLO
	mail2.tiolive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaLHLRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:17:50 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2014 06:17:50 EST
From: Kirill Smelkov <kirr@nexedi.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@nexedi.com>
Subject: [PATCH] tools/liblockdep: Fix debug_check thinko in mutex destroy
Date: Mon,  8 Dec 2014 14:07:59 +0300
Message-Id: <1418036879-31944-1-git-send-email-kirr@nexedi.com>
X-Mailer: git-send-email 2.2.0.309.gc3c329f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mutex destroy code currently we pass to debug_check_no_locks_freed()

    [mem_from, mem_end)

address region. But debug_check_no_locks_freed() accepts

    mem_from, mem_*len*

i.e. second parameter is region length, not end address. And it was
always so, starting from 2006 (fbb9ce95 "lockdep: core").

Fix it, or else on a mutex destroy we wrongly check
much-wider-than-mutex region and can find not-yet-released other locks
there and wrongly report BUGs on them.

Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
---
 tools/lib/lockdep/preload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
index 6f80360..0b0112c 100644
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -317,7 +317,7 @@ int pthread_mutex_destroy(pthread_mutex_t *mutex)
 	 *
 	 * TODO: Hook into free() and add that check there as well.
 	 */
-	debug_check_no_locks_freed(mutex, mutex + sizeof(*mutex));
+	debug_check_no_locks_freed(mutex, sizeof(*mutex));
 	__del_lock(__get_lock(mutex));
 	return ll_pthread_mutex_destroy(mutex);
 }
@@ -341,7 +341,7 @@ int pthread_rwlock_destroy(pthread_rwlock_t *rwlock)
 {
 	try_init_preload();
 
-	debug_check_no_locks_freed(rwlock, rwlock + sizeof(*rwlock));
+	debug_check_no_locks_freed(rwlock, sizeof(*rwlock));
 	__del_lock(__get_lock(rwlock));
 	return ll_pthread_rwlock_destroy(rwlock);
 }
-- 
2.2.0.309.gc3c329f
