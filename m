Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3BTWWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:22:20 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56866 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3BTWWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:22:18 -0500
Message-ID: <1361395671.29360.26.camel@falcor1>
Subject: [PATCH] ima: prevent dead lock when a file is opened for direct io
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 20 Feb 2013 16:27:51 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022022-5518-0000-0000-00000BC72EAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Are there any negative repercussions to temporarily removing the
o_direct flag in order to calculate the file hash?

thanks,

Mimi
-----

Files are measured or appraised based on the IMA policy.  When a file
in policy is opened for read with the O_DIRECT flag set, a deadlock
occurs due to do_blockdev_direct_IO() taking i_mutex before calling
filemap_write_and_wait_range(). The i_mutex was previously taken in
process_measurement().  This patch temporarily removes the O_DIRECT
flag in order to calculate the hash and restores it once completed.

[    3.751980]
[    3.752074] =============================================
[    3.752074] [ INFO: possible recursive locking detected ]
[    3.752074] 3.7.5+ #30 Not tainted
[    3.752074] ---------------------------------------------
[    3.752074] startpar/1067 is trying to acquire lock:
[    3.752074]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c1156866>] do_blockdev_direct_IO+0x16a6/0x1900
[    3.752074]
[    3.752074] but task is already holding lock:
[    3.752074]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c125cbd1>] process_measurement+0x71/0x1f0
[    3.752074]
[    3.752074] other info that might help us debug this:
[    3.752074]  Possible unsafe locking scenario:
[    3.752074]
[    3.752074]        CPU0
[    3.752074]        ----
[    3.752074]   lock(&sb->s_type->i_mutex_key#10);
[    3.752074]   lock(&sb->s_type->i_mutex_key#10);
[    3.752074]
[    3.752074]  *** DEADLOCK ***
[    3.752074]
[    3.752074]  May be due to missing lock nesting notation
[    3.752074]
[    3.752074] 1 lock held by startpar/1067:
[    3.752074]  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c125cbd1>] process_measurement+0x71/0x1f0
[    3.752074]
[    3.752074] stack backtrace:
[    3.752074] Pid: 1067, comm: startpar Not tainted 3.7.5+ #30
[    3.752074] Call Trace:
[    3.752074]  [<c108b57a>] __lock_acquire+0x5da/0x1490
[    3.752074]  [<c108ad6b>] ? trace_hardirqs_on+0xb/0x10
[    3.752074]  [<c108c4b2>] lock_acquire+0x82/0xf0
[    3.752074]  [<c1156866>] ? do_blockdev_direct_IO+0x16a6/0x1900
[    3.752074]  [<c16e9256>] __mutex_lock_common+0x46/0x350
[    3.752074]  [<c1156866>] ? do_blockdev_direct_IO+0x16a6/0x1900
[    3.752074]  [<c111a99d>] ? kmem_cache_alloc+0xcd/0x120
[    3.752074]  [<c16e9651>] mutex_lock_nested+0x31/0x40
[    3.752074]  [<c1156866>] ? do_blockdev_direct_IO+0x16a6/0x1900
[    3.752074]  [<c1156866>] do_blockdev_direct_IO+0x16a6/0x1900
[    3.752074]  [<c106f7d6>] ? find_busiest_group+0x26/0x440
[    3.752074]  [<c10652b8>] ? finish_task_switch+0x38/0xe0
[    3.752074]  [<c1156b30>] __blockdev_direct_IO+0x70/0x80
[    3.752074]  [<c118ed90>] ? noalloc_get_block_write+0x50/0x50
[    3.752074]  [<c11cb3d0>] ext4_ind_direct_IO+0x120/0x500
[    3.752074]  [<c118ed90>] ? noalloc_get_block_write+0x50/0x50
[    3.752074]  [<c1190426>] ext4_direct_IO+0x276/0x430
[    3.752074]  [<c10e2597>] generic_file_aio_read+0x6f7/0x740
[    3.752074]  [<c108b2b0>] ? __lock_acquire+0x310/0x1490
[    3.752074]  [<c1086920>] ? noop_count+0x10/0x10
[    3.752074]  [<c111f653>] do_sync_read+0x93/0xd0
[    3.752074]  [<c111f997>] vfs_read+0x97/0x160
[    3.752074]  [<c111f5c0>] ? do_sync_write+0xd0/0xd0
[    3.752074]  [<c11255f0>] kernel_read+0x30/0x50
[    3.752074]  [<c125d23b>] ima_calc_hash+0xbb/0x1c0
[    3.752074]  [<c1060476>] ? lg_local_unlock+0x16/0x30
[    3.752074]  [<c113cb27>] ? mntput_no_expire+0x37/0x120
[    3.752074]  [<c125d466>] ima_collect_measurement+0x56/0xa0
[    3.752074]  [<c1133cb2>] ? d_path+0xb2/0xd0
[    3.752074]  [<c125cca6>] process_measurement+0x146/0x1f0
[    3.752074]  [<c125cd93>] ima_file_check+0x43/0x1c0
[    3.752074]  [<c112ae95>] do_last+0x485/0xb80
[    3.752074]  [<c1128e81>] ? inode_permission+0x11/0x50
[    3.752074]  [<c112b5f8>] ? link_path_walk+0x68/0x760
[    3.752074]  [<c112d7fd>] path_openat+0x9d/0x3a0
[    3.752074]  [<c12ff96c>] ? tty_release+0x32c/0x4c0
[    3.752074]  [<c112dbf0>] do_filp_open+0x30/0x80
[    3.752074]  [<c111dc9f>] do_sys_open+0xef/0x1d0
[    3.752074]  [<c111dded>] sys_open+0x2d/0x40
[    3.752074]  [<c16ebe4c>] syscall_call+0x7/0xb

Reported-by: Cédric BERTHION <cedric.berthion@amossys.fr>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_crypto.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index b691e0f..99aea6a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -45,6 +45,7 @@ int ima_calc_file_hash(struct file *file, char *digest)
 	loff_t i_size, offset = 0;
 	char *rbuf;
 	int rc, read = 0;
+	unsigned int unset_flags = file->f_flags & O_DIRECT;
 	struct {
 		struct shash_desc shash;
 		char ctx[crypto_shash_descsize(ima_shash_tfm)];
@@ -62,6 +63,10 @@ int ima_calc_file_hash(struct file *file, char *digest)
 		rc = -ENOMEM;
 		goto out;
 	}
+
+	if (unset_flags)
+		file->f_flags &= ~unset_flags;
+
 	if (!(file->f_mode & FMODE_READ)) {
 		file->f_mode |= FMODE_READ;
 		read = 1;
@@ -88,6 +93,8 @@ int ima_calc_file_hash(struct file *file, char *digest)
 		rc = crypto_shash_final(&desc.shash, digest);
 	if (read)
 		file->f_mode &= ~FMODE_READ;
+	if (unset_flags)
+		file->f_flags |= unset_flags;
 out:
 	return rc;
 }
-- 
1.8.1.rc3



