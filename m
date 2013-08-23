Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3HWARz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 20:17:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab3HWARy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 20:17:54 -0400
Date: Thu, 22 Aug 2013 20:17:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] dm: allow error target to replace either bio-based and
 request-based targets
Message-ID: <20130823001750.GA29366@redhat.com>
References: <5214CC25.1070307@oracle.com>
 <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
 <52157C6E.6080406@oracle.com>
 <20130822201900.GB22556@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822201900.GB22556@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22 2013 at  4:19pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Joe,
> 
> Unfortunately this isn't going to work properly.  Mikulas suggested a
> new "error-rq" target.
> 
> I do like the idea of a single error target that is hybrid (supports
> both bio-based and request-based) but the DM core would need to be
> updated to support this.
> 
> Specifically, we'd need to check if the device (and active table) is
> already bio-based or request-based and select the appropriate type.  If
> it is a new device, default to selecting bio-based.
> 
> There are some wrappers and other logic thoughout DM core that will need
> auditing too.

Here is a patch that should work for your needs (I tested it to work
with 'dmsetup wipe_table' on both request-based and bio-based devices):

From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 22 Aug 2013 18:21:38 -0400
Subject: [PATCH] dm: allow error target to replace either bio-based and request-based targets

In may be useful to switch a request-based table to the "error" target.
Enhance the DM core to allow a single hybrid target to be capable of
handling either bios or requests.

Add a request-based (.map_rq) member to the error target_type and train
dm_table_set_type() to prefer the md's established type (request-based
or bio-based).  If the md doesn't have an established type default to
making the hybrid target bio-based.

Cc: Joe Jin <joe.jin@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c  |   18 +++++++++++++++++-
 drivers/md/dm-target.c |    9 ++++++++-
 drivers/md/dm.h        |   11 +++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

Index: linux/drivers/md/dm-table.c
===================================================================
--- linux.orig/drivers/md/dm-table.c
+++ linux/drivers/md/dm-table.c
@@ -864,10 +864,26 @@ static int dm_table_set_type(struct dm_t
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices;
+	unsigned live_md_type;
+
+	dm_lock_md_type(t->md);
+	live_md_type = dm_get_md_type(t->md);
+	dm_unlock_md_type(t->md);
 
 	for (i = 0; i < t->num_targets; i++) {
 		tgt = t->targets + i;
-		if (dm_target_request_based(tgt))
+		if (dm_target_hybrid(tgt)) {
+			switch (live_md_type) {
+			case DM_TYPE_NONE:
+			case DM_TYPE_BIO_BASED:
+				bio_based = 1;
+				break;
+			case DM_TYPE_REQUEST_BASED:
+				request_based = 1;
+				break;
+			}
+		}
+		else if (dm_target_request_based(tgt))
 			request_based = 1;
 		else
 			bio_based = 1;
Index: linux/drivers/md/dm-target.c
===================================================================
--- linux.orig/drivers/md/dm-target.c
+++ linux/drivers/md/dm-target.c
@@ -131,12 +131,19 @@ static int io_err_map(struct dm_target *
 	return -EIO;
 }
 
+static int io_err_map_rq(struct dm_target *ti, struct request *clone,
+			 union map_info *map_context)
+{
+	return -EIO;
+}
+
 static struct target_type error_target = {
 	.name = "error",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
+	.map_rq = io_err_map_rq,
 };
 
 int __init dm_target_init(void)
Index: linux/drivers/md/dm.h
===================================================================
--- linux.orig/drivers/md/dm.h
+++ linux/drivers/md/dm.h
@@ -91,10 +91,21 @@ int dm_setup_md_queue(struct mapped_devi
 #define dm_target_is_valid(t) ((t)->table)
 
 /*
+ * To check whether the target type is bio-based or not (request-based).
+ */
+#define dm_target_bio_based(t) ((t)->type->map != NULL)
+
+/*
  * To check whether the target type is request-based or not (bio-based).
  */
 #define dm_target_request_based(t) ((t)->type->map_rq != NULL)
 
+/*
+ * To check whether the target type is a hybrid (capable of being
+ * either request-based or bio-based).
+ */
+#define dm_target_hybrid(t) (dm_target_bio_based(t) && dm_target_request_based(t))
+
 /*-----------------------------------------------------------------
  * A registry of target types.
  *---------------------------------------------------------------*/
