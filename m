Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3GOO3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:29:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46527 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab3GOO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:25 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 13/17] staging/lustre: fix build warnning on 32bit system
Date: Mon, 15 Jul 2013 22:27:16 +0800
Message-Id: <1373898440-14208-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building on 32bit system, I got warnings like below:
drivers/staging/lustre/lustre/llite/../include/lprocfs_status.h:666:7: note: expected ‘long unsigned int *’ but argument is of type ‘size_t *’
 char *lprocfs_find_named_value(const char *buffer, const char *name,

drivers/staging/lustre/lustre/lov/lov_io.c: In function ‘lov_io_rw_iter_init’:
include/asm-generic/div64.h:43:28: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lprocfs_status.h |    4 ++--
 drivers/staging/lustre/lustre/lov/lov_io.c         |    2 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 55f1822..294fb78 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -663,8 +663,8 @@ extern int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
 extern int lprocfs_write_frac_u64_helper(const char *buffer,
 					 unsigned long count,
 					 __u64 *val, int mult);
-char *lprocfs_find_named_value(const char *buffer, const char *name,
-				unsigned long *count);
+extern char *lprocfs_find_named_value(const char *buffer, const char *name,
+				      size_t *count);
 void lprocfs_oh_tally(struct obd_histogram *oh, unsigned int value);
 void lprocfs_oh_tally_log2(struct obd_histogram *oh, unsigned int value);
 void lprocfs_oh_clear(struct obd_histogram *oh);
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index 1a87abd..022e0f4 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -430,7 +430,7 @@ static int lov_io_rw_iter_init(const struct lu_env *env,
 	struct lov_io	*lio = cl2lov_io(env, ios);
 	struct cl_io	 *io  = ios->cis_io;
 	struct lov_stripe_md *lsm = lio->lis_object->lo_lsm;
-	loff_t start = io->u.ci_rw.crw_pos;
+	__u64 start = io->u.ci_rw.crw_pos;
 	loff_t next;
 	unsigned long ssize = lsm->lsm_stripe_size;
 
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index f7af3d6..85163f4 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1873,7 +1873,7 @@ static char *lprocfs_strnstr(const char *s1, const char *s2, size_t len)
  * If \a name is not found the original \a buffer is returned.
  */
 char *lprocfs_find_named_value(const char *buffer, const char *name,
-				unsigned long *count)
+			       size_t *count)
 {
 	char *val;
 	size_t buflen = *count;
-- 
1.7.9.5

