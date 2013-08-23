Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3HWDVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 23:21:17 -0400
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:57798 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3HWDVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 23:21:15 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 23:21:15 EDT
Message-ID: <5216D3A2.8020209@ce.jp.nec.com>
Date: Fri, 23 Aug 2013 12:14:42 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC: Joe Jin <joe.jin@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: allow error target to replace either bio-based
 and request-based targets
References: <5214CC25.1070307@oracle.com> <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com> <52157C6E.6080406@oracle.com> <20130822201900.GB22556@redhat.com> <20130823001750.GA29366@redhat.com>
In-Reply-To: <20130823001750.GA29366@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 08/23/13 09:17, Mike Snitzer wrote:
>> I do like the idea of a single error target that is hybrid (supports
>> both bio-based and request-based) but the DM core would need to be
>> updated to support this.
>>
>> Specifically, we'd need to check if the device (and active table) is
>> already bio-based or request-based and select the appropriate type.  If
>> it is a new device, default to selecting bio-based.
>>
>> There are some wrappers and other logic thoughout DM core that will need
>> auditing too.
> 
> Here is a patch that should work for your needs (I tested it to work
> with 'dmsetup wipe_table' on both request-based and bio-based devices):

How about moving the default handling in dm_table_set_type() outside of
the for-each-target loop, like the modified patch below?

For example, if a table has 2 targets, hybrid and request_based,
and live_md_type is DM_TYPE_NONE, the table should be considered as
request_based, not inconsistent.
Though the end result is same as such a table is rejected by other
constraint anyway, I think it's good to keep the semantics clean
and error messages consistent.

I.e. for the above case, the error message should be
"Request-based dm doesn't support multiple targets yet",
not "Inconsistent table: different target types can't be mixed up".

---
Jun'ichi Nomura, NEC Corporation


diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f221812..6e683c8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -860,14 +860,16 @@ EXPORT_SYMBOL(dm_consume_args);
 static int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
-	unsigned bio_based = 0, request_based = 0;
+	unsigned bio_based = 0, request_based = 0, hybrid = 0;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices;
 
 	for (i = 0; i < t->num_targets; i++) {
 		tgt = t->targets + i;
-		if (dm_target_request_based(tgt))
+		if (dm_target_hybrid(tgt))
+			hybrid = 1;
+		else if (dm_target_request_based(tgt))
 			request_based = 1;
 		else
 			bio_based = 1;
@@ -879,6 +881,25 @@ static int dm_table_set_type(struct dm_table *t)
 		}
 	}
 
+	if (hybrid && !bio_based && !request_based) {
+		/*
+		 * The targets can work either way.
+		 * Determine the type from the live device.
+		 */
+		unsigned live_md_type;
+		dm_lock_md_type(t->md);
+		live_md_type = dm_get_md_type(t->md);
+		dm_unlock_md_type(t->md);
+		switch (live_md_type) {
+		case DM_TYPE_REQUEST_BASED:
+			request_based = 1;
+			break;
+		default:
+			bio_based = 1;
+			break;
+		}
+	}
+
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 37ba5db..242e3ce 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -131,12 +131,19 @@ static int io_err_map(struct dm_target *tt, struct bio *bio)
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
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 45b97da..8b4c075 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -89,10 +89,21 @@ int dm_setup_md_queue(struct mapped_device *md);
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
