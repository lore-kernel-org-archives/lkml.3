Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab3EANGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 09:06:13 -0400
Received: from zep00a03.dent.med.uni-muenchen.de ([138.246.161.8]:47694 "HELO
	md.dent.med.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753899Ab3EANGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 09:06:02 -0400
From: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
In-Reply-To: <CA+55aFzfxMvWVRjqV4pzz7XtpDGbxwGumGVeRT7OsF95noG4xw@mail.gmail.com>
References: <CA+55aFzfxMvWVRjqV4pzz7XtpDGbxwGumGVeRT7OsF95noG4xw@mail.gmail.com>
CC: wmglo@dent.med.uni-muenchen.de
Date: Wed, 01 May 2013 15:05:58 +0200
Message-ID: <u4obcuetop.fsf@md.dent.med.uni-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> --- snip snip ---
>  drivers/tty/pty.c    | 3 +++
>  drivers/tty/tty_io.c | 4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index a62798fcc014..59bfaecc4e14 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -681,6 +681,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
>
>         nonseekable_open(inode, filp);
>
> +       /* We refuse fsnotify events on ptmx, since it's a shared resource */
> +       filp->f_mode |= FMODE_NONOTIFY;
> +
>         retval = tty_alloc_file(filp);
>         if (retval)
>                 return retval;

This is definitely good.  But of course you can still poll on mtime.

> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 97ebc8c5864e..6464029e4860 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -988,10 +988,10 @@ void start_tty(struct tty_struct *tty)
>
>  EXPORT_SYMBOL(start_tty);
>
> +/* We limit tty time update visibility to every 8 seconds or so. */
>  static void tty_update_time(struct timespec *time)
>  {
> -       unsigned long sec = get_seconds();
> -       sec -= sec % 60;
> +       unsigned long sec = get_seconds() & ~7;
>         if ((long)(sec - time->tv_sec) > 0)
>                 time->tv_sec = sec;
>  }

I still find this mildly ugly.  I would prefer this:

--- linux-3.8.10/drivers/tty/tty_io.c~	2013-02-19 00:58:34.000000000 +0100
+++ linux-3.8.10/drivers/tty/tty_io.c	2013-05-01 13:46:16.000000000 +0200
@@ -1080,8 +1080,11 @@
 		cond_resched();
 	}
 	if (written) {
+		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
+		    tty->driver->subtype != PTY_TYPE_MASTER) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 		inode->i_mtime = current_fs_time(inode->i_sb);
+		}
 		ret = written;
 	}
 out:

(without the tty_update_time change).  This prevents polling on
/dev/ptmx, but not on /dev/pts/*.  The latter seems unnecessary to me,
because during password entry, echo mode is off so no bytes are read,
and canonical mode is ON so no bytes are written until NL is entered.
So you can only obtain the total time taken to enter the password, not
individual keystrokes.

The canonical mode is also the reason why my suggestion to fix this in
userspace (in the other subthread) is quite problematic (I tried to
change PAM) as it looks impossible to delay or obfuscate the write
events on /dev/ptmx.

Regards,
Wolfram.
