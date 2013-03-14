Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3CNKrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:47:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51992 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab3CNKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        NeilBrown <neilb@suse.de>,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 51/88] md: protect against crash upon fsync on ro array
Date: Thu, 14 Mar 2013 10:35:44 +0000
Message-Id: <1363257381-15900-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Riemer <sebastian.riemer@profitbricks.com>

commit bbfa57c0f2243a7c31fd248d22e9861a2802cad5 upstream.

If an fsync occurs on a read-only array, we need to send a
completion for the IO and may not increment the active IO count.
Otherwise, we hit a bug trace and can't stop the MD array anymore.

By advice of Christoph Hellwig we return success upon a flush
request but we return -EROFS for other writes.
We detect flush requests by checking if the bio has zero sectors.

This patch is suitable to any -stable kernel to which it applies.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 97edf9e..b7a551d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -344,6 +344,10 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 		bio_io_error(bio);
 		return;
 	}
+	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
+		bio_endio(bio, bio_sectors(bio) == 0 ? 0 : -EROFS);
+		return;
+	}
 	smp_rmb(); /* Ensure implications of  'active' are visible */
 	rcu_read_lock();
 	if (mddev->suspended) {
-- 
1.8.1.2

