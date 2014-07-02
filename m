Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231AbaGBBJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:09:09 -0400
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:40940 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757225AbaGBBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:09:08 -0400
X-Greylist: delayed 969 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 21:09:08 EDT
Message-ID: <53B357E8.1090909@nominal-animal.net>
Date: Wed, 02 Jul 2014 03:52:56 +0300
From: Nominal Animal <kernel@nominal-animal.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH] dup3(): option to detect close() error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6347260725240595264
X-Ovh-Remote: 62.78.228.143 (cs78228143.pp.htv.fi)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedruddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedruddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RFC patch below adds a new flag for dup3().
(For simplicity, I'm just reusing O_EXCL for now.)

I am assuming calling f_op->flush() twice instead of just once
before closing the file is not harmful.

The idea is to extend dup3() so that we can catch close() errors
for the descriptor to be replaced, if we want to. Existing code
will not see any changes. (Userspace might wish to replace a
descriptor exactly because there is a problem, so we don't want
to make this unconditional.

This approach relies on close() having a single error path in Linux:
the file has an f_op->flush() handler, and it returns an error.
Here, if the flag is included in dup3(), f_op->flush() is called early
for newfd, and if it fails, dup3() will return with -EIO.

It will still be called again in filp_close(), but since the descriptor
is to be closed, there should be no activity between the two
f_op->flush() calls, so the latter should not fail.

Is there a reason (besides having yet another O_ flag) why this
would not work, or why we would not want to do this?
Am I missing something?
I just want be able to know if a problem was detected, that's all.

Best,
    Nominal Animal

diff -u5 -bar linux-3.16-rc3/fs/file.c linux-3.16-rc3.new/fs/file.c
--- linux-3.16-rc3/fs/file.c	2014-06-30 00:11:36.000000000 +0300
+++ linux-3.16-rc3.new/fs/file.c	2014-07-02 02:04:23.708114821 +0300
@@ -816,21 +816,31 @@
 SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 {
 	int err = -EBADF;
-	struct file *file;
+	struct file *file, *tofree;
 	struct files_struct *files = current->files;
 
-	if ((flags & ~O_CLOEXEC) != 0)
+	if ((flags & ~(O_CLOEXEC | O_EXCL)) != 0)
 		return -EINVAL;
 
 	if (unlikely(oldfd == newfd))
 		return -EINVAL;
 
 	if (newfd >= rlimit(RLIMIT_NOFILE))
 		return -EBADF;
 
 	spin_lock(&files->file_lock);
+	if (unlikely(flags & O_EXCL)) {
+		tofree = fcheck(newfd);
+		if (tofree && file_count(tofree) && tofree->f_op->flush) {
+			spin_unlock(&files->file_lock);
+			err = tofree->f_op->flush(tofree, files);
+			if (unlikely(err < 0))
+				return -EIO;
+			spin_lock(&files->file_lock);
+		}
+	}
 	err = expand_files(files, newfd);
 	file = fcheck(oldfd);
 	if (unlikely(!file))
 		goto Ebadf;
 	if (unlikely(err < 0)) {
