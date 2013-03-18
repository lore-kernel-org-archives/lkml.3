Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3CREa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33387 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab3CREaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:02 -0400
Message-Id: <20130318042144.531436620@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.de>,
        Paul Menzel <paulepanter@users.sourceforge.net>
Subject: [ 03/82] md: protect against crash upon fsync on ro array
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -345,6 +345,10 @@ static void md_make_request(struct reque
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


