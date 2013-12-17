Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3LQSU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:20:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab3LQSPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 087/103] dm table: fail dm_table_create on dm_round_up overflow
Date: Tue, 17 Dec 2013 18:13:16 +0000
Message-Id: <1387304012-23805-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-table.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d509f23..43e19b7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -215,6 +215,11 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 
 	num_targets = dm_round_up(num_targets, KEYS_PER_NODE);
 
+	if (!num_targets) {
+		kfree(t);
+		return -ENOMEM;
+	}
+
 	if (alloc_targets(t, num_targets)) {
 		kfree(t);
 		t = NULL;
-- 
1.8.3.2

