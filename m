Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3L2Cmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:42:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55318 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509Ab3L2CKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:31 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mikulas Patocka" <mpatocka@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.498316727@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 132/185] dm table: fail dm_table_create on dm_round_up
 overflow
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5b2d06576c5410c10d95adfd5c4d8b24de861d87 upstream.

The dm_round_up function may overflow to zero.  In this case,
dm_table_create() must fail rather than go on to allocate an empty array
with alloc_targets().

This fixes a possible memory corruption that could be caused by passing
too large a number in "param->target_count".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-table.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -215,6 +215,11 @@ int dm_table_create(struct dm_table **re
 
 	num_targets = dm_round_up(num_targets, KEYS_PER_NODE);
 
+	if (!num_targets) {
+		kfree(t);
+		return -ENOMEM;
+	}
+
 	if (alloc_targets(t, num_targets)) {
 		kfree(t);
 		t = NULL;

