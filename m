Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab3DYPnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:43:12 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:51529 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab3DYPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <1366893601-26699-1-git-send-email-jslaby@suse.cz>
References: <1366893601-26699-1-git-send-email-jslaby@suse.cz>
Date: Thu, 25 Apr 2013 08:43:09 -0700
X-Google-Sender-Auth: rk2ON0Mq6A_OyB2p2ie8hsBTFR4
Message-ID: <CA+55aFxVDub+aXyOrojz_yRCHHG50MnviOjP_-uRxKLuQRYXUw@mail.gmail.com>
Subject: Re: [PATCH] TTY: fix atime/mtime regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 5:40 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>
> To revert to the old behaviour while still preventing attackers to
> guess the password length, we update the timestamps in ten-second
> intervals by this patch.

Hmm. Why ten seconds? Wouldn't it make more sense to use some natural
boundary, like a full minute?

Also, if I read the code correctly, this can actually make time go
*backwards* for the inode when the tty is first created. So it would
seem to be much better for tty_get_inode_time() to be passed in the
pointer to the tty time to be updated, so that it can avoid doing a
backwards jump.

Finally, if you're just interested in the seconds (like you are),
don't use "current_kernel_time()" that unnecessarily does the whole
nsec calculation. Just do "get_seconds()".

IOW, the end result would be something like

  void tty_update_time(struct timespec *time)
  {
    unsigned long sec = get_seconds();
    sec -= sec % 60;
    if ((long)(sec - time->tv_sec) > 0)
      time->tv_sec = sec;
  }

(That whole "(long)(sec - time->tv_sec)" is to handle wrapping time
correctly, we don't want to stop updating the inode in 2038 on 32-bit
machines).

Hmm?

             Linus
