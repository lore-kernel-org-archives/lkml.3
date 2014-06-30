Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaF3MOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:14:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51976 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <kmo@daterainc.com>, Mateusz Guzik <mguzik@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/181] aio: fix aio request leak when events are reaped by userspace
Date: Mon, 30 Jun 2014 13:51:15 +0200
Message-Id: <f6404be526b84d044dadecd171cc120d3d93bf50.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f8567a3845ac05bb28f3c1b478ef752762bd39ef upstream.

The aio cleanups and optimizations by kmo that were merged into the 3.10
tree added a regression for userspace event reaping.  Specifically, the
reference counts are not decremented if the event is reaped in userspace,
leading to the application being unable to submit further aio requests.
This patch applies to 3.12+.  A separate backport is required for 3.10/3.11.
This issue was uncovered as part of CVE-2014-0206.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: stable@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 829bda2b26d7..e609e15f36b9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1021,6 +1021,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
+	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -1103,8 +1104,6 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, tail);
-
-	put_reqs_available(ctx, ret);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
-- 
2.0.0

