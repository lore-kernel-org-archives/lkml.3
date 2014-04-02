Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbaDBTFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:05:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41585 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbaDBTFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:05:37 -0400
Date: Wed, 2 Apr 2014 21:05:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402190520.GC21167@pd.tnic>
References: <20140402144219.4cafbe37@gandalf.local.home>
 <20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 12:04:40PM -0700, Andrew Morton wrote:
> On Wed, 2 Apr 2014 14:42:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > It has come to our attention that a system running a specific user
> > space init program will not boot if you add "debug" to the kernel
> > command line. What happens is that the user space tool parses the
> > kernel command line, and if it sees "debug" it will spit out so much
> > information that the system fails to boot. This basically renders the
> > "debug" option for the kernel useless.
> > 
> > This bug has been reported to the developers of said tool
> > here:
> > 
> >   https://bugs.freedesktop.org/show_bug.cgi?id=76935
> > 
> > The response is:
> > 
> > "Generic terms are generic, not the first user owns them."
> > 
> > That is, the "debug" statement on the *kernel* command line is not
> > owned by the kernel just because it was the first user of it, and
> > they refuse to fix their bug.
> > 
> > Well, my response is, we OWN the kernel command line, and as such, we
> > can keep the users from seeing stuff on it if we so choose. And with
> > that, I propose this patch, which hides "debug" from /proc/cmdline,
> > such that we don't have to worry about tools parsing for it and causing
> > hardship for those trying to debug the kernel.
> > 
> 
> I had to check the date on this but surprisingly, it's all post
> April 1.
> 
> --- a/fs/read_write.c~a
> +++ a/fs/read_write.c
> @@ -513,6 +513,8 @@ SYSCALL_DEFINE3(read, unsigned int, fd,
>  	struct fd f = fdget_pos(fd);
>  	ssize_t ret = -EBADF;
>  
> +	BUG_ON(!strcmp(current->comm, "systemd"));
> +
>  	if (f.file) {
>  		loff_t pos = file_pos_read(f.file);
>  		ret = vfs_read(f.file, buf, count, &pos);

ACK!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
