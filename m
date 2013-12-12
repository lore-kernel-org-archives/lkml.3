Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3LLL6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:58:07 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:58428 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab3LLL6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:58:04 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Mateusz Guzik <mguzik@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] fs: bits in .close_on_exec are only defined for matching bits in .open_fds bits
Date: Thu, 12 Dec 2013 12:57:24 +0100
Message-Id: <1386849444-15751-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386848190.9959.12.camel@localhost.localdomain>
References: <1386796107-4197-1-git-send-email-ydroneaud@opteya.com> <20131211223634.GA13828@mguzik.redhat.com> <20131211233011.GA10323@ZenIV.linux.org.uk> <1386845150.9959.3.camel@localhost.localdomain> <1386848190.9959.12.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flag close-on-exec can only be set on an allocated (but perhaps not yet
installed) file descriptor. So if the bit in struct fdtable .open_fds array
is not set, then value of matching bit in the .close_on_exec array is
meaningless.

This patch rely on this property to
- remove initialization of unused part of .close_on_exec array;
- remove clear of .close_on_exec bit when releasing a file descriptor.
The patch takes care of adding the required check on .open_fds bit
before looking for .close_on_exec bit.

Link: http://lkml.kernel.org/r/1386796107-4197-1-git-send-email-ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---

Hi Al and Mateusz,

First of all, thank you for reviewing my previous patch and pointing out
the error I've missed.

Please consider this new patch which take the opposite approach:
my previous patch assumed that .close_on_exec bit where defaulting to 0,
but you prove this was a wrong assumption. This new patch assume that
.close_on_exec bit are in a unknown, meaningless value when the file
descriptor is not allocated. This way, there's no need to clear the value
when releasing a file descriptor, and there's no need to initialize the
.close_on_exec array.

Unlike my previous patch, I haven't yet tested it. It's known to compile.

Please try to find some corner cases I've missed in this other attempt.

Regards.


 fs/file.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f981557a..3016e09d0290 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -78,7 +78,7 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 	memcpy(nfdt->open_fds, ofdt->open_fds, cpy);
 	memset((char *)(nfdt->open_fds) + cpy, 0, set);
 	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
-	memset((char *)(nfdt->close_on_exec) + cpy, 0, set);
+	/* remaining portion of close_on_exec left uninitialized */
 }
 
 static struct fdtable * alloc_fdtable(unsigned int nr)
@@ -335,7 +335,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 		int start = open_files / BITS_PER_LONG;
 
 		memset(&new_fdt->open_fds[start], 0, left);
-		memset(&new_fdt->close_on_exec[start], 0, left);
+		/* remaining portion of close_on_exec left uninitialized */
 	}
 
 	rcu_assign_pointer(newf->fdt, new_fdt);
@@ -599,7 +599,6 @@ int __close_fd(struct files_struct *files, unsigned fd)
 	if (!file)
 		goto out_unlock;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
-	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 	return filp_close(file, files);
@@ -622,10 +621,9 @@ void do_close_on_exec(struct files_struct *files)
 		fdt = files_fdtable(files);
 		if (fd >= fdt->max_fds)
 			break;
-		set = fdt->close_on_exec[i];
+		set = fdt->close_on_exec[i] & fdt->open_fds[i];
 		if (!set)
 			continue;
-		fdt->close_on_exec[i] = 0;
 		for ( ; set ; fd++, set >>= 1) {
 			struct file *file;
 			if (!(set & 1))
@@ -772,7 +770,7 @@ bool get_close_on_exec(unsigned int fd)
 	bool res;
 	rcu_read_lock();
 	fdt = files_fdtable(files);
-	res = close_on_exec(fd, fdt);
+	res = fd_is_open(fd, fdt) && close_on_exec(fd, fdt);
 	rcu_read_unlock();
 	return res;
 }
-- 
1.8.4.2

