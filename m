Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab3EAA5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:57:48 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64848 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab3EAA5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130430013724.GA5358@kroah.com>
References: <20130429184752.435249613@linuxfoundation.org>
	<20130429184752.700428715@linuxfoundation.org>
	<20130430001445.GA17260@hostway.ca>
	<20130430002117.GA4202@kroah.com>
	<20130430003639.GB17260@hostway.ca>
	<20130430013724.GA5358@kroah.com>
Date: Tue, 30 Apr 2013 17:57:38 -0700
X-Google-Sender-Auth: weSaSryC9BnBrhvLezOmjDhKG6c
Message-ID: <CA+55aFxNGBpoVCx3Vm_fmCPF4XrUfHCM8GqQMa-qh3RLYOOS7w@mail.gmail.com>
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 6:37 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Ah, it's using inotify on the /dev/ptmx device.  Jiri, your change
> really doesn't affect that at all :(

Hmm. Maybe something like the appended? Together with making the time
modification be 10 seconds to make Simon happy (that's what Jiri
originally did, it was me who said "why not make it a natural human
timeframe"). In fact, maybe we should just make it a power-of-two (8?
4?) and avoid the nasty division..

Patch is whitespace-damaged and totally untested! Caveat applicator.

              Linus

--- snip snip ---

   drivers/tty/pty.c | 3 +++
   1 file changed, 3 insertions(+)

  diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
  index a62798fcc014..59bfaecc4e14 100644
  --- a/drivers/tty/pty.c
  +++ b/drivers/tty/pty.c
  @@ -681,6 +681,9 @@ static int ptmx_open(struct inode *inode, struct
file *filp)

    nonseekable_open(inode, filp);

  + /* We refuse fsnotify events on ptmx, since it's a shared resource */
  + filp->f_mode |= FMODE_NONOTIFY;
  +
    retval = tty_alloc_file(filp);
    if (retval)
    return retval;
