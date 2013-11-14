Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3KNQiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:38:46 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37394 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3KNQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:33 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/39] staging/lustre/hsm: remove hsm_nl proc file
Date: Fri, 15 Nov 2013 00:32:24 +0800
Message-Id: <1384446782-13741-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the file /proc/fs/lustre/mdc/*/hsm_nl which was introduced "for
testing purposes."

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2489
Lustre-change: http://review.whamcloud.com/6656
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c |   73 -------------------------
 1 file changed, 73 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index e0b8f18..084f9a6 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -77,78 +77,6 @@ static ssize_t mdc_max_rpcs_in_flight_seq_write(struct file *file,
 }
 LPROC_SEQ_FOPS(mdc_max_rpcs_in_flight);
 
-static int mdc_kuc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, NULL, PDE_DATA(inode));
-}
-
-/* temporary for testing */
-static ssize_t mdc_kuc_write(struct file *file, const char *buffer,
-			     size_t count, loff_t *off)
-{
-	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
-	struct kuc_hdr		*lh;
-	struct hsm_action_list	*hal;
-	struct hsm_action_item	*hai;
-	int			 len;
-	int			 fd, rc;
-
-	rc = lprocfs_write_helper(buffer, count, &fd);
-	if (rc)
-		return rc;
-
-	if (fd < 0)
-		return -ERANGE;
-	CWARN("message to fd %d\n", fd);
-
-	len = sizeof(*lh) + sizeof(*hal) + MTI_NAME_MAXLEN +
-		/* for mockup below */ 2 * cfs_size_round(sizeof(*hai));
-
-	OBD_ALLOC(lh, len);
-
-	lh->kuc_magic = KUC_MAGIC;
-	lh->kuc_transport = KUC_TRANSPORT_HSM;
-	lh->kuc_msgtype = HMT_ACTION_LIST;
-	lh->kuc_msglen = len;
-
-	hal = (struct hsm_action_list *)(lh + 1);
-	hal->hal_version = HAL_VERSION;
-	hal->hal_archive_id = 1;
-	hal->hal_flags = 0;
-	obd_uuid2fsname(hal->hal_fsname, obd->obd_name, MTI_NAME_MAXLEN);
-
-	/* mock up an action list */
-	hal->hal_count = 2;
-	hai = hai_zero(hal);
-	hai->hai_action = HSMA_ARCHIVE;
-	hai->hai_fid.f_oid = 5;
-	hai->hai_len = sizeof(*hai);
-	hai = hai_next(hai);
-	hai->hai_action = HSMA_RESTORE;
-	hai->hai_fid.f_oid = 10;
-	hai->hai_len = sizeof(*hai);
-
-	/* This works for either broadcast or unicast to a single fd */
-	if (fd == 0) {
-		rc = libcfs_kkuc_group_put(KUC_GRP_HSM, lh);
-	} else {
-		struct file *fp = fget(fd);
-
-		rc = libcfs_kkuc_msg_put(fp, lh);
-		fput(fp);
-	}
-	OBD_FREE(lh, len);
-	if (rc < 0)
-		return rc;
-	return count;
-}
-
-struct file_operations mdc_kuc_fops = {
-	.open		= mdc_kuc_open,
-	.write		= mdc_kuc_write,
-	.release	= single_release,
-};
-
 LPROC_SEQ_FOPS_WR_ONLY(mdc, ping);
 
 LPROC_SEQ_FOPS_RO_TYPE(mdc, uuid);
@@ -197,7 +125,6 @@ static struct lprocfs_vars lprocfs_mdc_obd_vars[] = {
 	{ "timeouts",		&mdc_timeouts_fops,    0, 0 },
 	{ "import",		&mdc_import_fops, 0 },
 	{ "state",		&mdc_state_fops, 0, 0 },
-	{ "hsm_nl",		&mdc_kuc_fops, 0, 0200 },
 	{ "pinger_recov",	&mdc_pinger_recov_fops, 0, 0 },
 	{ 0 }
 };
-- 
1.7.9.5

