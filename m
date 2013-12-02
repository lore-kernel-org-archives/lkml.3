Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab3LBVA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:00:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3LBTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 072/173] dm: allocate buffer for messages with small number of arguments using GFP_NOIO
Date: Mon,  2 Dec 2013 11:10:55 -0800
Message-Id: <20131202191151.321798776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -580,14 +580,28 @@ static int adjoin(struct dm_table *table
 
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


