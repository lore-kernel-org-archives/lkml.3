Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072AbaKLBmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:42:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739AbaKLBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:41:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 058/203] dm bufio: when done scanning return from __scan immediately
Date: Wed, 12 Nov 2014 10:15:28 +0900
Message-Id: <20141112011545.367277821@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0e825862f3c04cee40e25f55680333728a4ffa9b upstream.

When __scan frees the required number of buffer entries that the
shrinker requested (nr_to_scan becomes zero) it must return.  Before
this fix the __scan code exited only the inner loop and continued in the
outer loop -- which could result in reduced performance due to extra
buffers being freed (e.g. unnecessarily evicted thinp metadata needing
to be synchronously re-read into bufio's cache).

Also, move dm_bufio_cond_resched to __scan's inner loop, so that
iterating the bufio client's lru lists doesn't result in scheduling
latency.

Reported-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1486,9 +1486,9 @@ static long __scan(struct dm_bufio_clien
 		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
 			freed += __cleanup_old_buffer(b, gfp_mask, 0);
 			if (!--nr_to_scan)
-				break;
+				return freed;
+			dm_bufio_cond_resched();
 		}
-		dm_bufio_cond_resched();
 	}
 	return freed;
 }


