Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab3JCFLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:11:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3JCEU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 07/57] bcache: Fix a flush/fua performance bug
Date: Wed,  2 Oct 2013 21:08:33 -0700
Message-Id: <20131003040637.108806122@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 1394d6761b6e9e15ee7c632a6d48791188727b40 upstream.

bch_journal_meta() was missing the flush to make the journal write
actually go down (instead of waiting up to journal_delay_ms)...

Whoops

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/journal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -695,6 +695,7 @@ void bch_journal_meta(struct cache_set *
 		if (cl)
 			BUG_ON(!closure_wait(&w->wait, cl));
 
+		closure_flush(&c->journal.io);
 		__journal_try_write(c, true);
 	}
 }


