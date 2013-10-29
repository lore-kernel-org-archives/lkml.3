Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3J2BsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:48:18 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42174 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3J2BsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:48:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG-pURzs512=6zu2_vBz5vtJu3Dm8hsdV=qZuUa5GJng6Eceg@mail.gmail.com>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	<1381185204.2081.221.camel@joe-AO722>
	<CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
	<1381191145.2081.230.camel@joe-AO722>
	<CAGG-pUQJCGcY=hAobBodH-dTLLohUpe6KJbuMvwWkhdt3RSk+A@mail.gmail.com>
	<CAFkjPTmFOkw5n964zGuiON1oLSy1CsPQQ8TrGNho6L-+M5Z7SA@mail.gmail.com>
	<CAGG-pUTHAnPOiX0n6FjbkhtFeiOY-704_rEvrhkzo4uv1rQ=hA@mail.gmail.com>
	<CAGG-pUTfWiVznsKkQH0bBiHgbi+waHNw0zmoTMVk4pVJGPUN_A@mail.gmail.com>
	<CAGG-pUQyB_4ivOvJWvq_5p-o-5vOC6srNVRk0GAvqqG-PVGMrQ@mail.gmail.com>
	<CAFkjPTm_JhrWVzk0njqaUwpn5RxqYgRWYV2ZvPyrYoFKZHkgog@mail.gmail.com>
	<CAGG-pURzs512=6zu2_vBz5vtJu3Dm8hsdV=qZuUa5GJng6Eceg@mail.gmail.com>
Date: Mon, 28 Oct 2013 23:48:11 -0200
Message-ID: <CAGG-pUTqVk5JkhWDU6-EicWzQT-rhiXBuXRm6uPmVSVifQ_FzQ@mail.gmail.com>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Joe Perches <joe@perches.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/28 Geyslan Gregório Bem <geyslan@gmail.com>
>
> 2013/10/27 Eric Van Hensbergen <ericvh@gmail.com>
>>
>> Looks like the right approach.  The one other optional thing I mentioned was support for passing NULL for rdev and not trying to parse the device info when rdev == NULL.  Its a very slight optimization in the grand scheme of things, but would seem to be cleaner for the folks calling the function who don't touch rdev after the fact...
>>
>>      -eric
>>
> Great. Let me do the changes this afternoon.
>
>
Hi Eric and all.

You requested to avoid the parsing of device when rdev is NULL, all
right? But I'm afraid that that manner the res (return value) can be
returned wrong when the bit mode is a device. Well, I did some
changes. In this new approach, when rdev is NULL, the function only
doesn't make the device, but returns the res (umode_t) nicely.

Tell me if this approach is correct. Do I have to modify something else?

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 94de6d1..e3d56f1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -63,7 +63,7 @@ static const struct inode_operations
v9fs_symlink_inode_operations;

 static u32 unixmode2p9mode(struct v9fs_session_info *v9ses, umode_t mode)
 {
-    int res;
+    u32 res;
     res = mode & 0777;
     if (S_ISDIR(mode))
         res |= P9_DMDIR;
@@ -125,10 +125,9 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
                    struct p9_wstat *stat, dev_t *rdev)
 {
-    int res;
+    umode_t res;
     u32 mode = stat->mode;

-    *rdev = 0;
     res = p9mode2perm(v9ses, stat);

     if ((mode & P9_DMDIR) == P9_DMDIR)
@@ -144,10 +143,15 @@ static umode_t p9mode2unixmode(struct
v9fs_session_info *v9ses,
     else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
          && (v9ses->nodev == 0)) {
         char type = 0, ext[32];
-        int major = -1, minor = -1;
+        u32 major = 0, minor = 0;

         strlcpy(ext, stat->extension, sizeof(ext));
-        sscanf(ext, "%c %u %u", &type, &major, &minor);
+        if (sscanf(ext, "%c %u %u", &type, &major, &minor) < 3) {
+            p9_debug(P9_DEBUG_ERROR,
+                 "It's necessary define type [%c], major [%u] and minor [%u]" \
+                 "values when mode is P9_DMDEVICE\n", type, major, minor);
+            goto err_dev;
+        }
         switch (type) {
         case 'c':
             res |= S_IFCHR;
@@ -158,11 +162,18 @@ static umode_t p9mode2unixmode(struct
v9fs_session_info *v9ses,
         default:
             p9_debug(P9_DEBUG_ERROR, "Unknown special type %c %s\n",
                  type, stat->extension);
-        };
-        *rdev = MKDEV(major, minor);
+            goto err_dev;
+        }
+        /* Only make device if rdev pointer isn't NULL */
+        if (rdev)
+            *rdev = MKDEV(major, minor);
     } else
         res |= S_IFREG;
-
+    goto ret;
+err_dev:
+    if (rdev)
+        rdev = ERR_PTR(-EIO);
+ret:
     return res;
 }

@@ -460,13 +471,12 @@ void v9fs_evict_inode(struct inode *inode)

 static int v9fs_test_inode(struct inode *inode, void *data)
 {
-    int umode;
-    dev_t rdev;
+    umode_t umode;
     struct v9fs_inode *v9inode = V9FS_I(inode);
     struct p9_wstat *st = (struct p9_wstat *)data;
     struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);

-    umode = p9mode2unixmode(v9ses, st, &rdev);
+    umode = p9mode2unixmode(v9ses, st, NULL);
     /* don't match inode of different type */
     if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
         return 0;
@@ -526,6 +536,10 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
      */
     inode->i_ino = i_ino;
     umode = p9mode2unixmode(v9ses, st, &rdev);
+    if (IS_ERR_VALUE(rdev)) {
+        retval = rdev;
+        goto error;
+    }
     retval = v9fs_init_inode(v9ses, inode, umode, rdev);
     if (retval)
         goto error;
@@ -1461,8 +1475,7 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry
*dentry, umode_t mode, dev_t rde

 int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 {
-    int umode;
-    dev_t rdev;
+    umode_t umode;
     loff_t i_size;
     struct p9_wstat *st;
     struct v9fs_session_info *v9ses;
@@ -1474,7 +1487,7 @@ int v9fs_refresh_inode(struct p9_fid *fid,
struct inode *inode)
     /*
      * Don't update inode if the file type is different
      */
-    umode = p9mode2unixmode(v9ses, st, &rdev);
+    umode = p9mode2unixmode(v9ses, st, NULL);
     if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
         goto out;


-- 
Regards,

Geyslan G. Bem
hackingbits.com
