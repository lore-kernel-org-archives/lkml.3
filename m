Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3JAWVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:21:06 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55601 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3JAWVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:21:04 -0400
Message-ID: <1380666060.19002.53.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: spinlock contention of files->file_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 01 Oct 2013 15:21:00 -0700
In-Reply-To: <20131001220453.GY13318@ZenIV.linux.org.uk>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
	 <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
	 <1380663718.19002.49.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131001220453.GY13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 23:04 +0100, Al Viro wrote:
> On Tue, Oct 01, 2013 at 02:41:58PM -0700, Eric Dumazet wrote:
> > Maybe I am missing something obvious ?
> 
> Yes.  do_execve_common() starts with unshare_files(); there can be
> no other thread capable of modifying that descriptor table.

Hmm, then what's the point of using spin_lock() here ?

This gives wrong hints ;)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..cdbca0d 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -615,11 +615,10 @@ void do_close_on_exec(struct files_struct *files)
 	struct fdtable *fdt;
 
 	/* exec unshares first */
-	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
 	for (i = 0; ; i++) {
 		unsigned long set;
 		unsigned fd = i * BITS_PER_LONG;
-		fdt = files_fdtable(files);
 		if (fd >= fdt->max_fds)
 			break;
 		set = fdt->close_on_exec[i];
@@ -635,14 +634,11 @@ void do_close_on_exec(struct files_struct *files)
 				continue;
 			rcu_assign_pointer(fdt->fd[fd], NULL);
 			__put_unused_fd(files, fd);
-			spin_unlock(&files->file_lock);
 			filp_close(file, files);
 			cond_resched();
-			spin_lock(&files->file_lock);
 		}
 
 	}
-	spin_unlock(&files->file_lock);
 }
 
 struct file *fget(unsigned int fd)


