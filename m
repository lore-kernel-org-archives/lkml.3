Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaDBTEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:04:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbaDBTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:04:41 -0400
Date: Wed, 2 Apr 2014 12:04:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-Id: <20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org>
In-Reply-To: <20140402144219.4cafbe37@gandalf.local.home>
References: <20140402144219.4cafbe37@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 14:42:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> It has come to our attention that a system running a specific user
> space init program will not boot if you add "debug" to the kernel
> command line. What happens is that the user space tool parses the
> kernel command line, and if it sees "debug" it will spit out so much
> information that the system fails to boot. This basically renders the
> "debug" option for the kernel useless.
> 
> This bug has been reported to the developers of said tool
> here:
> 
>   https://bugs.freedesktop.org/show_bug.cgi?id=76935
> 
> The response is:
> 
> "Generic terms are generic, not the first user owns them."
> 
> That is, the "debug" statement on the *kernel* command line is not
> owned by the kernel just because it was the first user of it, and
> they refuse to fix their bug.
> 
> Well, my response is, we OWN the kernel command line, and as such, we
> can keep the users from seeing stuff on it if we so choose. And with
> that, I propose this patch, which hides "debug" from /proc/cmdline,
> such that we don't have to worry about tools parsing for it and causing
> hardship for those trying to debug the kernel.
> 

I had to check the date on this but surprisingly, it's all post
April 1.

--- a/fs/read_write.c~a
+++ a/fs/read_write.c
@@ -513,6 +513,8 @@ SYSCALL_DEFINE3(read, unsigned int, fd,
 	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
+	BUG_ON(!strcmp(current->comm, "systemd"));
+
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_read(f.file, buf, count, &pos);
_

