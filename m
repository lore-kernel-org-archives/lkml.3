Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3JNN1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:27:18 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:36250 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3JNN1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:27:16 -0400
Date: Mon, 14 Oct 2013 09:27:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH driver-core-next] sysfs: make sysfs_file_ops() follow
 ignore_lockdep flag
Message-ID: <20131014132711.GC4722@htj.dyndns.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
 <20131006004032.GA3601@kroah.com>
 <20131007170005.GB2481@htj.dyndns.org>
 <20131007231136.GB27270@kroah.com>
 <CAE9FiQV-bs0hiTDSzOR0GREMf=whichBocLPBF_uV09=LjTCtw@mail.gmail.com>
 <20131011204904.GA1308@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011204904.GA1308@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

375b611e60 ("sysfs: remove sysfs_buffer->ops") introduced
sysfs_file_ops() which determines the associated file operation of a
given sysfs_dirent.  As file ops access should be protected by an
active reference, the new function includes a lockdep assertion on the
sysfs_dirent; unfortunately, I forgot to take attr->ignore_lockdep
flag into account and the lockdep assertion trips spuriously for files
which opt out from active reference lockdep checking.

# cat /sys/devices/pci0000:00/0000:00:01.2/usb1/authorized

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 540 at /work/os/work/fs/sysfs/file.c:79 sysfs_file_ops+0x4e/0x60()
 Modules linked in:
 CPU: 1 PID: 540 Comm: cat Not tainted 3.11.0-work+ #3
 Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  0000000000000009 ffff880016205c08 ffffffff81ca0131 0000000000000000
  ffff880016205c40 ffffffff81096d0d ffff8800166cb898 ffff8800166f6f60
  ffffffff8125a220 ffff880011ab1ec0 ffff88000aff0c78 ffff880016205c50
 Call Trace:
  [<ffffffff81ca0131>] dump_stack+0x4e/0x82
  [<ffffffff81096d0d>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff81096dea>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8125994e>] sysfs_file_ops+0x4e/0x60
  [<ffffffff8125a274>] sysfs_open_file+0x54/0x300
  [<ffffffff811df612>] do_dentry_open.isra.17+0x182/0x280
  [<ffffffff811df820>] finish_open+0x30/0x40
  [<ffffffff811f0623>] do_last+0x503/0xd90
  [<ffffffff811f0f6b>] path_openat+0xbb/0x6d0
  [<ffffffff811f23ba>] do_filp_open+0x3a/0x90
  [<ffffffff811e09a9>] do_sys_open+0x129/0x220
  [<ffffffff811e0abe>] SyS_open+0x1e/0x20
  [<ffffffff81caf3c2>] system_call_fastpath+0x16/0x1b
 ---[ end trace aa48096b111dafdb ]---

Rename fs/sysfs/dir.c::ignore_lockdep() to sysfs_ignore_lockdep() and
move it to fs/sysfs/sysfs.h and make sysfs_file_ops() skip lockdep
assertion if sysfs_ignore_lockdep() is true.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yinghai Lu <yinghai@kernel.org>
---
 fs/sysfs/dir.c   |   22 ++--------------------
 fs/sysfs/file.c  |    3 ++-
 fs/sysfs/sysfs.h |   16 ++++++++++++++++
 3 files changed, 20 insertions(+), 21 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -144,24 +144,6 @@ static void sysfs_unlink_sibling(struct
 		sd->s_parent->s_flags &= ~SYSFS_FLAG_HAS_NS;
 }
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-/* Test for attributes that want to ignore lockdep for read-locking */
-static bool ignore_lockdep(struct sysfs_dirent *sd)
-{
-	return sysfs_type(sd) == SYSFS_KOBJ_ATTR &&
-			sd->s_attr.attr->ignore_lockdep;
-}
-
-#else
-
-static inline bool ignore_lockdep(struct sysfs_dirent *sd)
-{
-	return true;
-}
-
-#endif
-
 /**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
@@ -180,7 +162,7 @@ struct sysfs_dirent *sysfs_get_active(st
 	if (!atomic_inc_unless_negative(&sd->s_active))
 		return NULL;
 
-	if (likely(!ignore_lockdep(sd)))
+	if (likely(!sysfs_ignore_lockdep(sd)))
 		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
 	return sd;
 }
@@ -199,7 +181,7 @@ void sysfs_put_active(struct sysfs_diren
 	if (unlikely(!sd))
 		return;
 
-	if (likely(!ignore_lockdep(sd)))
+	if (likely(!sysfs_ignore_lockdep(sd)))
 		rwsem_release(&sd->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&sd->s_active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -76,7 +76,8 @@ static const struct sysfs_ops *sysfs_fil
 {
 	struct kobject *kobj = sd->s_parent->s_dir.kobj;
 
-	lockdep_assert_held(sd);
+	if (!sysfs_ignore_lockdep(sd))
+		lockdep_assert_held(sd);
 	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
 }
 
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -103,6 +103,7 @@ static inline unsigned int sysfs_type(st
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 #define sysfs_dirent_init_lockdep(sd)				\
 do {								\
 	struct attribute *attr = sd->s_attr.attr;		\
@@ -112,8 +113,23 @@ do {								\
 								\
 	lockdep_init_map(&sd->dep_map, "s_active", key, 0);	\
 } while (0)
+
+/* Test for attributes that want to ignore lockdep for read-locking */
+static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
+{
+	return sysfs_type(sd) == SYSFS_KOBJ_ATTR &&
+		sd->s_attr.attr->ignore_lockdep;
+}
+
 #else
+
 #define sysfs_dirent_init_lockdep(sd) do {} while (0)
+
+static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
+{
+	return true;
+}
+
 #endif
 
 /*
