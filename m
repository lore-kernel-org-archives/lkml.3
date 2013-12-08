Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3LHFey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 00:34:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3LHFev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 00:34:51 -0500
Date: Sat, 7 Dec 2013 21:36:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: Bug in tty cooked mode kernel 3.12.3
Message-ID: <20131208053621.GA6445@kroah.com>
References: <20131107184607.eklhad@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107184607.eklhad@comcast.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 06:46:07PM -0500, Karl Dahlke wrote:
> This may have appeared in 3.9.11 with the changes to tty.
> Don't know; I just started running 3.12 from kernel.org.
> Perhaps nobody saw it before because nobody runs command line programs,
> we're all on desktops or x or whatever,
> and even those in the command line are still raw.
> bash is raw by default, but I run it cooked.
> You can supress its readline functions like this.
> 
> set +o emacs
> set +o vi
> set +o histexpand
> set +o history
> 
> That puts its tty back into cooked mode.
> 
> Come up in run level 3, command line mode,
> and bring up two consoles with bash in cooked mode as above.
> Set a simple prompt like this.
> 
> PS1='$ '
> 
> Switch to console 2 via alt-f2.
> Hit return.
> The cursor should drop to a new line then give you the $ prompt.
> But it puts the $ prompt next too the old one, then drops down
> to a blank line.
> The $ prompt and the crlf are out of sequence.
> Hit return a few more times and it will straighten itself out.
> Then switch back to console 1 alt-f1
> Hit return and the same bug,
> $ $
> 
> hit return a few more times to straighten it out.
> Switch back to console 2 and the same problem.
> For me it's repeatable.
> 
> It's also very confusing when I'm running other command line programs with cooked tty.
> For unknown reasons the crlf can come out at the wrong time,
> breaking lines or leaving lines together.
> My editor can run either way, so I've switched it over to readline mode
> and I haven't noticed any problems this way, yet.
> But I would prefer the cooked mode.
> 
> I looked through MAINTAINERS but couldn't find
> a clear maintainer for drivers/tty/tty*.c

Did you see the big "TTY LAYER" section in MAINTAINERS?  :)

Anyway, we've had a number of fixes in this area, I've just sent a pull
request to Linus to fix this issue (I think.)  If you could test the
patch below, that would be great.

thanks,

greg k-h

----------------
commit 39434abd942c8e4b9c14c06a03b3245beaf8467f
Author: Peter Hurley <peter@hurleysoftware.com>
Date:   Fri Nov 29 12:56:10 2013 -0500

    n_tty: Fix missing newline echo
    
    When L_ECHONL is on, newlines are echoed regardless of the L_ECHO
    state; if set, ensure accumulated echoes are flushed before finishing
    the current input processing and before more output.
    
    Cc: <stable@vger.kernel.org> # 3.12.x
    Reported-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com
    Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0f74945af624..268b62768f2b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -810,7 +810,8 @@ static void process_echoes(struct tty_struct *tty)
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t echoed;
 
-	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
+	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
+	    ldata->echo_commit == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
@@ -825,7 +826,8 @@ static void flush_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_head)
+	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
+	    ldata->echo_commit == ldata->echo_head)
 		return;
 
 	mutex_lock(&ldata->output_lock);

