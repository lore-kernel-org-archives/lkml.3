Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab3EABlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 21:41:52 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:37674 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab3EABlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 21:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxNGBpoVCx3Vm_fmCPF4XrUfHCM8GqQMa-qh3RLYOOS7w@mail.gmail.com>
References: <20130429184752.435249613@linuxfoundation.org>
	<20130429184752.700428715@linuxfoundation.org>
	<20130430001445.GA17260@hostway.ca>
	<20130430002117.GA4202@kroah.com>
	<20130430003639.GB17260@hostway.ca>
	<20130430013724.GA5358@kroah.com>
	<CA+55aFxNGBpoVCx3Vm_fmCPF4XrUfHCM8GqQMa-qh3RLYOOS7w@mail.gmail.com>
Date: Tue, 30 Apr 2013 18:41:44 -0700
X-Google-Sender-Auth: u1xVkpDURKdRjaMUMC_wnjX0quI
Message-ID: <CA+55aFzfxMvWVRjqV4pzz7XtpDGbxwGumGVeRT7OsF95noG4xw@mail.gmail.com>
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

On Tue, Apr 30, 2013 at 5:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Patch is whitespace-damaged and totally untested! Caveat applicator.

Ok, so it's still whitespace-damaged, but it seems to work. The
appended has the "8 second rule" too..

Comments? Simon?

           Linus

--- snip snip ---
 drivers/tty/pty.c    | 3 +++
 drivers/tty/tty_io.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index a62798fcc014..59bfaecc4e14 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -681,6 +681,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)

        nonseekable_open(inode, filp);

+       /* We refuse fsnotify events on ptmx, since it's a shared resource */
+       filp->f_mode |= FMODE_NONOTIFY;
+
        retval = tty_alloc_file(filp);
        if (retval)
                return retval;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 97ebc8c5864e..6464029e4860 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -988,10 +988,10 @@ void start_tty(struct tty_struct *tty)

 EXPORT_SYMBOL(start_tty);

+/* We limit tty time update visibility to every 8 seconds or so. */
 static void tty_update_time(struct timespec *time)
 {
-       unsigned long sec = get_seconds();
-       sec -= sec % 60;
+       unsigned long sec = get_seconds() & ~7;
        if ((long)(sec - time->tv_sec) > 0)
                time->tv_sec = sec;
 }
