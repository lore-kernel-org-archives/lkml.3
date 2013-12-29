Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3L2Cxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:53:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55068 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253Ab3L2CKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:07 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alasdair G Kergon" <agk@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.830153121@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 019/185] dm: allocate buffer for messages with small
 number of arguments using GFP_NOIO
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-table.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -581,14 +581,28 @@ static int adjoin(struct dm_table *table
 
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

