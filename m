Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443AbaKMV3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:09 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56382 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbaKMV3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:05 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <green@linuxhacker.ru>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, Jinshan Xiong <jinshan.xiong@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Perepechko <andrew_perepechko@xyratex.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Lai Siyao <lai.siyao@intel.com>, Li Xi <lixi@ddn.com>,
        Masanari Iida <standby24x7@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/56] fs/lustre: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:42 +0100
Message-Id: <1415913813-362-6-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from lustre file-system when the splice-family of
syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 drivers/staging/lustre/lustre/llite/file.c           | 10 +++++++---
 drivers/staging/lustre/lustre/llite/llite_internal.h |  2 ++
 drivers/staging/lustre/lustre/llite/vvp_io.c         |  2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index fd1b75a3..98573da 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1126,10 +1126,12 @@ restart:
 				down_read(&lli->lli_trunc_sem);
 			}
 			break;
+#ifdef CONFIG_SYSCALL_SPLICE
 		case IO_SPLICE:
 			vio->u.splice.cui_pipe = args->u.splice.via_pipe;
 			vio->u.splice.cui_flags = args->u.splice.via_flags;
 			break;
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 		default:
 			CERROR("Unknown IO type - %u\n", vio->cui_io_subtype);
 			LBUG();
@@ -1223,6 +1225,7 @@ static ssize_t ll_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return result;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 /*
  * Send file content (through pagecache) somewhere with helper
  */
@@ -1247,6 +1250,7 @@ static ssize_t ll_file_splice_read(struct file *in_file, loff_t *ppos,
 	cl_env_put(env, &refcheck);
 	return result;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static int ll_lov_recreate(struct inode *inode, struct ost_id *oi,
 			   obd_count ost_idx)
@@ -3078,7 +3082,7 @@ struct file_operations ll_file_operations = {
 	.release	= ll_file_release,
 	.mmap	   = ll_file_mmap,
 	.llseek	 = ll_file_seek,
-	.splice_read    = ll_file_splice_read,
+	SPLICE_READ_INIT(ll_file_splice_read)
 	.fsync	  = ll_fsync,
 	.flush	  = ll_flush
 };
@@ -3093,7 +3097,7 @@ struct file_operations ll_file_operations_flock = {
 	.release	= ll_file_release,
 	.mmap	   = ll_file_mmap,
 	.llseek	 = ll_file_seek,
-	.splice_read    = ll_file_splice_read,
+	SPLICE_READ_INIT(ll_file_splice_read)
 	.fsync	  = ll_fsync,
 	.flush	  = ll_flush,
 	.flock	  = ll_file_flock,
@@ -3111,7 +3115,7 @@ struct file_operations ll_file_operations_noflock = {
 	.release	= ll_file_release,
 	.mmap	   = ll_file_mmap,
 	.llseek	 = ll_file_seek,
-	.splice_read    = ll_file_splice_read,
+	SPLICE_READ_INIT(ll_file_splice_read)
 	.fsync	  = ll_fsync,
 	.flush	  = ll_flush,
 	.flock	  = ll_file_noflock,
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 634ffa6..44fa32a 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -861,7 +861,9 @@ enum vvp_io_subtype {
 	/** normal IO */
 	IO_NORMAL,
 	/** io started from splice_{read|write} */
+#ifdef CONFIG_SYSCALL_SPLICE
 	IO_SPLICE
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 };
 
 /* IO subtypes */
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index a4117d6..2f4aa39 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -530,6 +530,7 @@ static int vvp_io_read_start(const struct lu_env *env,
 		LASSERT(cio->cui_iocb->ki_pos == pos);
 		result = generic_file_read_iter(cio->cui_iocb, cio->cui_iter);
 		break;
+#ifdef CONFIG_SYSCALL_SPLICE
 	case IO_SPLICE:
 		result = generic_file_splice_read(file, &pos,
 				vio->u.splice.cui_pipe, cnt,
@@ -539,6 +540,7 @@ static int vvp_io_read_start(const struct lu_env *env,
 		 * buffers. */
 		io->ci_continue = 0;
 		break;
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 	default:
 		CERROR("Wrong IO type %u\n", vio->cui_io_subtype);
 		LBUG();
-- 
1.9.1

