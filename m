Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3KNQjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:13 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61553 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3KNQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:45 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Dmitry Eremin <dmitry.eremin@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 04/39] staging/lustre/build: fix 'integer handling' issues
Date: Fri, 15 Nov 2013 00:32:27 +0800
Message-Id: <1384446782-13741-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'program hangs' defects found by Coverity version 6.5.1:
Improper use of negative value (NEGATIVE_RETURNS)
Variable is passed to a parameter that cannot be negative.
Macro compares unsigned to 0 (NO_EFFECT)
This comparison is always true.
Operands don't affect result (CONSTANT_EXPRESSION_RESULT)
Test is always false regardless of the values of its operands.
Wrong operator used (CONSTANT_EXPRESSION_RESULT)
Test is always true regardless of the values of its operand.

Lustre-change: http://review.whamcloud.com/5888
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3069
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/rw.c           |    1 -
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |    6 ++++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index e9ba38a..112368f 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -803,7 +803,6 @@ int ll_readahead(const struct lu_env *env, struct cl_io *io,
 	ret = ll_read_ahead_pages(env, io, queue,
 				  ria, &reserved, mapping, &ra_end);
 
-	LASSERTF(reserved >= 0, "reserved %lu\n", reserved);
 	if (reserved != 0)
 		ll_ra_count_put(ll_i2sbi(inode), reserved);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c b/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
index da558a5..b6ad505 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
@@ -90,7 +90,8 @@ static int llog_check_cb(const struct lu_env *env, struct llog_handle *handle,
 			 struct llog_rec_hdr *rec, void *data)
 {
 	struct obd_ioctl_data *ioc_data = (struct obd_ioctl_data *)data;
-	static int l, remains, from, to;
+	static int l, remains;
+	static long from, to;
 	static char *out;
 	char *endp;
 	int cur_index, rc = 0;
@@ -174,7 +175,8 @@ static int llog_print_cb(const struct lu_env *env, struct llog_handle *handle,
 			 struct llog_rec_hdr *rec, void *data)
 {
 	struct obd_ioctl_data *ioc_data = (struct obd_ioctl_data *)data;
-	static int l, remains, from, to;
+	static int l, remains;
+	static long from, to;
 	static char *out;
 	char *endp;
 	int cur_index;
-- 
1.7.9.5

