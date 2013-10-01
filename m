Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3JAVmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:42:04 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36253 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3JAVmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:02 -0400
Message-ID: <1380663718.19002.49.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: spinlock contention of files->file_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 01 Oct 2013 14:41:58 -0700
In-Reply-To: <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
	 <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

On Mon, 2013-09-30 at 18:44 -0700, Linus Torvalds wrote:

> Now, that only gets rid of fd_install(), but I suspect you could do
> something similar for put_unused_fd() (that one does need cmpxchg for
> the "next_fd" thing, though). We'd have to replace the non-atomic
> bitops on open_fds[] with atomic ones, just to make sure adjacent bit
> clearings don't screw up concurrent adjacent bit values, but that
> looks fairly straightforward too.

While looking at this (exciting) stuff, I found following bug.

Maybe I am missing something obvious ?

Thanks

[PATCH] fs: fix a race in do_close_on_exec()

commit 6a6d27de ("take close-on-exec logics to fs/file.c, clean it up a
bit") added a possible race, as another thread could resize file table
once we released files->file_lock.

We must reload fdt after getting the lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 fs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..b614f13 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -616,10 +616,10 @@ void do_close_on_exec(struct files_struct *files)
 
 	/* exec unshares first */
 	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
 	for (i = 0; ; i++) {
 		unsigned long set;
 		unsigned fd = i * BITS_PER_LONG;
-		fdt = files_fdtable(files);
 		if (fd >= fdt->max_fds)
 			break;
 		set = fdt->close_on_exec[i];
@@ -639,6 +639,9 @@ void do_close_on_exec(struct files_struct *files)
 			filp_close(file, files);
 			cond_resched();
 			spin_lock(&files->file_lock);
+
+			/* We released files->file_lock, we must reload fdt */
+			fdt = files_fdtable(files);
 		}
 
 	}


