Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbbAUDgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:36:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41416 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAUDgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:36:08 -0500
Date: Wed, 21 Jan 2015 03:36:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Moore <pmoore@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121033600.GN29656@ZenIV.linux.org.uk>
References: <20150120165655.GA10904@kria>
 <20150120232726.GA16913@kria>
 <1517211.UYLV49hvpg@sifl>
 <1528536.jyty2pu4Mz@sifl>
 <20150121004117.GM29656@ZenIV.linux.org.uk>
 <54BF1292.2080902@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF1292.2080902@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 06:44:34PM -0800, Guenter Roeck wrote:
> >The shit hits the fan earlier - when we end up missing /dev.  There are
> >two places where it could've been created (depending on CONFIG_BLK_DEV_INITRD);
> >	sys_mkdir(collected, mode);
> >in init/initramfs.c (line 353 in linux-next) and
> >         err = sys_mkdir((const char __user __force *) "/dev", 0755);
> >in init/noinitramfs.c (line 32).  The latter would've screamed on failure;
> >could you printk of collected (%s), mode (%o) and return value (%d) in the
> >former and see what happens?
> >
> 
> sys_mkdir .:40775 returned -17
> sys_mkdir usr:40775 returned 0
> sys_mkdir usr/lib:40775 returned -2
> sys_mkdir usr/share:40755 returned -2
> sys_mkdir usr/share/udhcpc:40755 returned -2
> sys_mkdir usr/bin:40775 returned -2
> sys_mkdir usr/sbin:40775 returned -2
> sys_mkdir mnt:40775 returned 0
> sys_mkdir proc:40775 returned 0
> sys_mkdir root:40775 returned 0
> sys_mkdir lib:40775 returned 0
> sys_mkdir lib/modules:40775 returned -2
> sys_mkdir lib/modules/3.9.2:40775 returned -2
> sys_mkdir lib/modules/3.9.2/kernel:40775 returned -2
> 
> with
> 	int err = sys_mkdir(collected, mode);
> 	pr_info("sys_mkdir %s:%o returned %d\n", collected, mode, err);
> added in init/initramfs.c.

Just what is lib/modules/3.9.2 doing there?  In any case, I think I have at
least a plausible direction for digging.  Look:

struct dentry *user_path_create(int dfd, const char __user *pathname,
                                struct path *path, unsigned int lookup_flags)
{
        struct filename *tmp = getname(pathname);
        struct dentry *res;
        if (IS_ERR(tmp))
                return ERR_CAST(tmp);
        res = kern_path_create(dfd, tmp->name, path, lookup_flags);

struct dentry *kern_path_create(int dfd, const char *pathname,
                                struct path *path, unsigned int lookup_flags)
{
        struct dentry *dentry = ERR_PTR(-EEXIST);
        struct nameidata nd;
        int err2;
        int error;
        bool is_dir = (lookup_flags & LOOKUP_DIRECTORY);

        /*
         * Note that only LOOKUP_REVAL and LOOKUP_DIRECTORY matter here. Any
         * other flags passed in are ignored!
         */
        lookup_flags &= LOOKUP_REVAL;

        error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);

static int do_path_lookup(int dfd, const char *name,
                                unsigned int flags, struct nameidata *nd)
{
        int retval;
        struct filename *filename;

        filename = getname_kernel(name);
        if (unlikely(IS_ERR(filename)))
                return PTR_ERR(filename);
        retval = filename_lookup(dfd, filename, flags, nd);

and we have done getname_kernel() on the name->name of result of getname().
At the very least, it's pointless - we already *have* struct filename for
that sucker.  Now, it shouldn't have screwed the things up - it would better
not, anyway, since we might legitimately have two identical pathname
among the syscall arguments.  However, let's see if this (on top of
linux-next, in addition to the same printks) changes behaviour:

diff --git a/fs/namei.c b/fs/namei.c
index 323957f..c7d107c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3314,7 +3314,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-struct dentry *kern_path_create(int dfd, const char *pathname,
+static struct dentry *__kern_path_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3329,7 +3329,7 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
+	error = filename_lookup(dfd, name, LOOKUP_PARENT|lookup_flags, &nd);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3383,6 +3383,19 @@ out:
 	path_put(&nd.path);
 	return dentry;
 }
+
+struct dentry *kern_path_create(int dfd, const char *pathname,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct filename *filename = getname_kernel(pathname);
+	struct dentry *res = ERR_CAST(filename);
+
+	if (!IS_ERR(filename)) {
+		res = __kern_path_create(dfd, filename, path, lookup_flags);
+		putname(filename);
+	}
+	return res;
+}
 EXPORT_SYMBOL(kern_path_create);
 
 void done_path_create(struct path *path, struct dentry *dentry)
@@ -3401,7 +3414,7 @@ struct dentry *user_path_create(int dfd, const char __user *pathname,
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
+	res = __kern_path_create(dfd, tmp, path, lookup_flags);
 	putname(tmp);
 	return res;
 }
