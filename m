Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161725Ab3LFXvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:51:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161360Ab3LFXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 037/152] dm: allocate buffer for messages with small number of arguments using GFP_NOIO
Date: Fri,  6 Dec 2013 15:09:21 -0800
Message-Id: <1386371476-2477-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit f36afb3957353d2529cb2b00f78fdccd14fc5e9c upstream.

dm-mpath and dm-thin must process messages even if some device is
suspended, so we allocate argv buffer with GFP_NOIO. These messages have
a small fixed number of arguments.

On the other hand, dm-switch needs to process bulk data using messages
so excessive use of GFP_NOIO could cause trouble.

The patch also lowers the default number of arguments from 64 to 8, so
that there is smaller load on GFP_NOIO allocations.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-table.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 62545f6..ee51e08 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -581,14 +581,28 @@ static int adjoin(struct dm_table *table, struct dm_target *ti)
 
 /*
  * Used to dynamically allocate the arg array.
+ *
+ * We do first allocation with GFP_NOIO because dm-mpath and dm-thin must
+ * process messages even if some device is suspended. These messages have a
+ * small fixed number of arguments.
+ *
+ * On the other hand, dm-switch needs to process bulk data using messages and
+ * excessive use of GFP_NOIO could cause trouble.
  */
 static char **realloc_argv(unsigned *array_size, char **old_argv)
 {
 	char **argv;
 	unsigned new_size;
+	gfp_t gfp;
 
-	new_size = *array_size ? *array_size * 2 : 64;
-	argv = kmalloc(new_size * sizeof(*argv), GFP_KERNEL);
+	if (*array_size) {
+		new_size = *array_size * 2;
+		gfp = GFP_KERNEL;
+	} else {
+		new_size = 8;
+		gfp = GFP_NOIO;
+	}
+	argv = kmalloc(new_size * sizeof(*argv), gfp);
 	if (argv) {
 		memcpy(argv, old_argv, *array_size * sizeof(*argv));
 		*array_size = new_size;
-- 
1.8.3.2

