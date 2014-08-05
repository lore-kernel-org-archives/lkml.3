Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaHESkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:40:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaHESO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 18/39] dm bufio: fully initialize shrinker
Date: Tue,  5 Aug 2014 11:13:55 -0700
Message-Id: <20140805181336.593223657@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Thelen <gthelen@google.com>

commit d8c712ea471ce7a4fd1734ad2211adf8469ddddc upstream.

1d3d4437eae1 ("vmscan: per-node deferred work") added a flags field to
struct shrinker assuming that all shrinkers were zero filled.  The dm
bufio shrinker is not zero filled, which leaves arbitrary kmalloc() data
in flags.  So far the only defined flags bit is SHRINKER_NUMA_AWARE.
But there are proposed patches which add other bits to shrinker.flags
(e.g. memcg awareness).

Rather than simply initializing the shrinker, this patch uses kzalloc()
when allocating the dm_bufio_client to ensure that the embedded shrinker
and any other similar structures are zeroed.

This fixes theoretical over aggressive shrinking of dm bufio objects.
If the uninitialized dm_bufio_client.shrinker.flags contains
SHRINKER_NUMA_AWARE then shrink_slab() would call the dm shrinker for
each numa node rather than just once.  This has been broken since 3.12.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1541,7 +1541,7 @@ struct dm_bufio_client *dm_bufio_client_
 	BUG_ON(block_size < 1 << SECTOR_SHIFT ||
 	       (block_size & (block_size - 1)));
 
-	c = kmalloc(sizeof(*c), GFP_KERNEL);
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;


