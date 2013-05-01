Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3EAFXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:23:13 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39868 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3EAFXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:23:05 -0400
Message-ID: <5180A6CA.1090404@suse.cz>
Date: Wed, 01 May 2013 07:23:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
References: <20130429184752.435249613@linuxfoundation.org> <20130429184752.700428715@linuxfoundation.org> <20130430001445.GA17260@hostway.ca> <20130430002117.GA4202@kroah.com> <20130430003639.GB17260@hostway.ca> <20130430013724.GA5358@kroah.com> <CA+55aFxNGBpoVCx3Vm_fmCPF4XrUfHCM8GqQMa-qh3RLYOOS7w@mail.gmail.com> <CA+55aFzfxMvWVRjqV4pzz7XtpDGbxwGumGVeRT7OsF95noG4xw@mail.gmail.com>
In-Reply-To: <CA+55aFzfxMvWVRjqV4pzz7XtpDGbxwGumGVeRT7OsF95noG4xw@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 03:41 AM, Linus Torvalds wrote:
> On Tue, Apr 30, 2013 at 5:57 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Patch is whitespace-damaged and totally untested! Caveat applicator.
> 
> Ok, so it's still whitespace-damaged, but it seems to work. The
> appended has the "8 second rule" too..
> 
> Comments?

Yeah, looks good to me.

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
> 

thanks,
-- 
js
suse labs
