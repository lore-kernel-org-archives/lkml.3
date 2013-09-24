Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3IXGTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:19:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48946 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3IXGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:19:07 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>,
        stable@vger.kernel.org
Subject: [PATCH 07/11] bcache: Fix a flush/fua performance bug
Date: Mon, 23 Sep 2013 23:17:32 -0700
Message-Id: <1380003456-19938-8-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bch_journal_meta() was missing the flush to make the journal write
actually go down (instead of waiting up to journal_delay_ms)...

Whoops

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index f5203df..8435f81 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -695,6 +695,7 @@ void bch_journal_meta(struct cache_set *c, struct closure *cl)
 		if (cl)
 			BUG_ON(!closure_wait(&w->wait, cl));
 
+		closure_flush(&c->journal.io);
 		__journal_try_write(c, true);
 	}
 }
-- 
1.8.4.rc3

