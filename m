Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796Ab3CLXKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:10:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3CLWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, NeilBrown <neilb@suse.de>,
        Paul Menzel <paulepanter@users.sourceforge.net>
Subject: [ 039/100] md: protect against crash upon fsync on ro array
Date: Tue, 12 Mar 2013 15:31:24 -0700
Message-Id: <20130312223127.191142956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: NeilBrown <neilb@suse.de>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -307,6 +307,10 @@ static void md_make_request(struct reque
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


