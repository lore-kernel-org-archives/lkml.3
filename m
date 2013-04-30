Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab3D3XtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:49:12 -0400
Received: from peace.netnation.com ([204.174.223.2]:47742 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab3D3XtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:49:09 -0400
Date: Tue, 30 Apr 2013 16:49:07 -0700
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Craig Small <csmall-git@enc.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] TTY: fix atime/mtime regression
Message-ID: <20130430234907.GA17908@hostway.ca>
References: <CA+55aFxVDub+aXyOrojz_yRCHHG50MnviOjP_-uRxKLuQRYXUw@mail.gmail.com>
 <1366976933-5514-1-git-send-email-jslaby@suse.cz>
 <CA+55aFxwCY3uagCUf1th6sr5+HGO0Mba-dhS-OtsnJ6o41JANw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwCY3uagCUf1th6sr5+HGO0Mba-dhS-OtsnJ6o41JANw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:02:12AM -0700, Linus Torvalds wrote:

> On Fri, Apr 26, 2013 at 4:48 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> >
> > To revert to the old behaviour while still preventing attackers to
> > guess the password length, we update the timestamps in one-minute
> > intervals by this patch.
> 
> Thanks, applied.
> 
> And now that I see the behavior of "w", I can kind of understand why
> you picked 10s intervals. That "w" output is really really quite ugly.
> Talking about "27.00s" idle for the current terminal when we only
> update at even minutes ends up not being sensible.

Ah, so it was your suggestion to go with one minute.

I objected to the stable-backporting of this, since it was broken and
didn't actually fix the inotify path, but I care more about the time
granularity chosen here.

> Craig, background: the current git kernel (so 3.9, and these commits
> will presumably be back-ported) does not update tty timestamps very
> often, because you can use the timestamps to look at peoples typing
> behavior. Initially it didn't update the timestamps AT ALL, but that
> broke the whole idle routine. Now it updates it only at minute
> boundaries, so things like "w" _work_, but the hundreth-of-a-second
> idle precision is obviously just totally random noise.
> 
> Not a biggie, I doubt I would even have noticed unless I was
> explicitly looking at that field, but....

I look at this field all the time, and would really like to see seconds.
Surely anybody typing a password types it faster than 1 character per
second. Why stretch it out so much? Can we at least make it 10 seconds?

Simon-

---

Subject: [PATCH] TTY: increase atime/mtime update rate

37b7f3c76595 introduces an update interval for TTY atime updates, making
"w"'s IDLE column less useful than in the past. Since this is often used
for checking to see if other users are actually using the system, reduce
the time to 10 seconds.

Signed-off-by: Simon Kirby <sim@hostway.ca>
Cc: <stable@vger.kernel.org> # follow 37b7f3c76595e23257f61bd80b223de865
---
 drivers/tty/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b045268..dee88ff 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -944,7 +944,7 @@ EXPORT_SYMBOL(start_tty);
 static void tty_update_time(struct timespec *time)
 {
 	unsigned long sec = get_seconds();
-	sec -= sec % 60;
+	sec -= sec % 10;
 	if ((long)(sec - time->tv_sec) > 0)
 		time->tv_sec = sec;
 }
-- 
1.7.10.4
