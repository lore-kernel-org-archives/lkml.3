Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaKLBYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaKLBYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.17 090/319] dm bufio: update last_accessed when relinking a buffer
Date: Wed, 12 Nov 2014 10:13:48 +0900
Message-Id: <20141112011007.470138783@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit eb76faf53b1ff7a77ce3f78cc98ad392ac70c2a0 upstream.

The 'last_accessed' member of the dm_buffer structure was only set when
the the buffer was created.  This led to each buffer being discarded
after dm_bufio_max_age time even if it was used recently.  In practice
this resulted in all thinp metadata being evicted soon after being read
-- this is particularly problematic for metadata intensive workloads
like multithreaded small random IO.

'last_accessed' is now updated each time the buffer is moved to the head
of the LRU list, so the buffer is now properly discarded if it was not
used in dm_bufio_max_age time.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -465,6 +465,7 @@ static void __relink_lru(struct dm_buffe
 	c->n_buffers[dirty]++;
 	b->list_mode = dirty;
 	list_move(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed = jiffies;
 }
 
 /*----------------------------------------------------------------


