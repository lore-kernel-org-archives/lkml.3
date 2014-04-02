Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbaDBTu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:50:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:54977 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:50:26 -0400
Date: Wed, 2 Apr 2014 21:50:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1404022146530.14882@ionos.tec.linutronix.de>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014, Andrew Morton wrote:
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

Can we make that strncmp(current->comm, "systemd", 7) please? So we
catch the systemd-xxx stuff as well!

Otherwise Acked-by-me

	  tglx
