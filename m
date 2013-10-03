Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3JCEF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:05:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3JCEF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:05:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [ 07/13] dm snapshot: workaround for a false positive lockdep warning
Date: Wed,  2 Oct 2013 21:04:32 -0700
Message-Id: <20131003040401.265604441@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040400.753642257@linuxfoundation.org>
References: <20131003040400.753642257@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5ea330a75bd86b2b2a01d7b85c516983238306fb upstream.

The kernel reports a lockdep warning if a snapshot is invalidated because
it runs out of space.

The lockdep warning was triggered by commit 0976dfc1d0cd80a4e9dfaf87bd87
("workqueue: Catch more locking problems with flush_work()") in v3.5.

The warning is false positive.  The real cause for the warning is that
the lockdep engine treats different instances of md->lock as a single
lock.

This patch is a workaround - we use flush_workqueue instead of flush_work.
This code path is not performance sensitive (it is called only on
initialization or invalidation), thus it doesn't matter that we flush the
whole workqueue.

The real fix for the problem would be to teach the lockdep engine to treat
different instances of md->lock as separate locks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-snap-persistent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -251,7 +251,7 @@ static int chunk_io(struct pstore *ps, v
 	 */
 	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
-	flush_work(&req.work);
+	flush_workqueue(ps->metadata_wq);
 
 	return req.result;
 }


