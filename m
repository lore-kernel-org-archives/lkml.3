Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3HBCUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:20:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43332 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3HBCUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:20:48 -0400
Date: Fri, 2 Aug 2013 10:20:28 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Xiong Zhou <jencce.kernel@gmail.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
In-Reply-To: <20130801004149.GA30696@kroah.com>
Message-ID: <alpine.DEB.2.02.1308021019220.8333@M2420>
References: <alpine.DEB.2.02.1307300827010.2625@M2420> <CA+a=Yy4FAOhKkwgzuCj-rtd9rE2jc8WOf=E8OMQ=o=JUrGgW1w@mail.gmail.com> <alpine.DEB.2.02.1307311028001.25194@M2420> <20130801004149.GA30696@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1707405825-1375410045=:8333"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1707405825-1375410045=:8333
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT



On Wed, 31 Jul 2013, Greg Kroah-Hartman wrote:

> On Wed, Jul 31, 2013 at 10:30:41AM +0800, Xiong Zhou wrote:
> > From: Xiong Zhou <jencce.kernel@gmail.com>
> > 
> > First version of this patch makes LUSTRE_FS depends on BLOCK.  Second
> > version makes only lloop depends on BLOCK with a config option for this
> > dependence, and remove unnecessary jdb header files which depends on
> > BLOCK.
> > 
> > This version removes the wrapper ll_unregister_blkdev which depends on
> > BLOCK in header and just call unregister_blkdev in lloop.c based on Peng
> > Tao's comment.
> 
> This isn't all needed in the patch changelog info, just say what it
> does.
> 
> Also, it doesn't apply for some reason, care to refresh this against my
> latest tree and resend?
> 
> thanks,
> 
> greg k-h
> 

OK, this patch is based on the staging-next branch of your staging tree.


From: Xiong Zhou <jencce.kernel@gmail.com>

Add a config option for llite/lloop in lustre driver, making it 
depends on BLOCK to fix this better:
drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2: 
error: implicit declaration of function ¡unregister_blkdev¢ 

Also, remove the wrapper ll_unregister_blkdev which depends on BLOCK in
the header and just call unregister_blkdev in lloop.c based on Peng Tao's
comment. Drop the redundant dependency on STAGING for LUSTRE_FS, remove 
some unnecessary jdb header files which depends on BLOCK btw.

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
Reviewed-by: Peng Tao <tao.peng@emc.com>
---
 drivers/staging/lustre/lustre/Kconfig              |    7 ++++++-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |    1 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |    1 -
 .../lustre/lustre/include/linux/lustre_compat25.h  |    7 -------
 drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    6 ++----
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |    1 -
 7 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 0b45de0..4e898e4 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,6 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
-	depends on STAGING && INET && BLOCK && m
+	depends on INET && m
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
@@ -53,3 +53,8 @@ config LUSTRE_TRANSLATE_ERRNOS
 	bool
 	depends on LUSTRE_FS && !X86
 	default true
+
+config LUSTRE_LLITE_LLOOP
+	bool "Lustre virtual block device"
+	depends on LUSTRE_FS && BLOCK
+	default m
diff --git a/drivers/staging/lustre/lustre/fld/fld_cache.c b/drivers/staging/lustre/lustre/fld/fld_cache.c
index 347f2ae..8410107 100644
--- a/drivers/staging/lustre/lustre/fld/fld_cache.c
+++ b/drivers/staging/lustre/lustre/fld/fld_cache.c
@@ -45,7 +45,6 @@
 
 # include <linux/libcfs/libcfs.h>
 # include <linux/module.h>
-# include <linux/jbd.h>
 # include <asm/div64.h>
 
 #include <obd.h>
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index c99b945..049322a 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -44,7 +44,6 @@
 
 # include <linux/libcfs/libcfs.h>
 # include <linux/module.h>
-# include <linux/jbd.h>
 # include <asm/div64.h>
 
 #include <obd.h>
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index 426533b..018e604 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -111,13 +111,6 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define TREE_READ_LOCK_IRQ(mapping)	spin_lock_irq(&(mapping)->tree_lock)
 #define TREE_READ_UNLOCK_IRQ(mapping)	spin_unlock_irq(&(mapping)->tree_lock)
 
-static inline
-int ll_unregister_blkdev(unsigned int dev, const char *name)
-{
-	unregister_blkdev(dev, name);
-	return 0;
-}
-
 #define ll_invalidate_bdev(a,b)	 invalidate_bdev((a))
 
 #ifndef FS_HAS_FIEMAP
diff --git a/drivers/staging/lustre/lustre/llite/Makefile b/drivers/staging/lustre/lustre/llite/Makefile
index dff0c04..f493e07 100644
--- a/drivers/staging/lustre/lustre/llite/Makefile
+++ b/drivers/staging/lustre/lustre/llite/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_LUSTRE_FS) += lustre.o
-obj-$(CONFIG_LUSTRE_FS) += llite_lloop.o
+obj-$(CONFIG_LUSTRE_LLITE_LLOOP) += llite_lloop.o
 lustre-y := dcache.o dir.o file.o llite_close.o llite_lib.o llite_nfs.o \
 	    rw.o lproc_llite.o namei.o symlink.o llite_mmap.o \
 	    xattr.o remote_perm.o llite_rmtacl.o llite_capa.o \
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index e063efc..ae3dc9d 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -848,10 +848,8 @@ static void lloop_exit(void)
 		blk_cleanup_queue(loop_dev[i].lo_queue);
 		put_disk(disks[i]);
 	}
-	if (ll_unregister_blkdev(lloop_major, "lloop"))
-		CWARN("lloop: cannot unregister blkdev\n");
-	else
-		CDEBUG(D_CONFIG, "unregistered lloop major %d\n", lloop_major);
+
+	unregister_blkdev(lloop_major, "lloop");
 
 	OBD_FREE(disks, max_loop * sizeof(*disks));
 	OBD_FREE(loop_dev, max_loop * sizeof(*loop_dev));
diff --git a/drivers/staging/lustre/lustre/lvfs/fsfilt.c b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
index 064445c..ce71f80 100644
--- a/drivers/staging/lustre/lustre/lvfs/fsfilt.c
+++ b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
@@ -35,7 +35,6 @@
 #define DEBUG_SUBSYSTEM S_FILTER
 
 #include <linux/fs.h>
-#include <linux/jbd.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
--8323328-1707405825-1375410045=:8333--
