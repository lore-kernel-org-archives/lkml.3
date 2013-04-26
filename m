Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3DZRCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:02:15 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:40073 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3DZRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <1366976933-5514-1-git-send-email-jslaby@suse.cz>
References: <CA+55aFxVDub+aXyOrojz_yRCHHG50MnviOjP_-uRxKLuQRYXUw@mail.gmail.com>
	<1366976933-5514-1-git-send-email-jslaby@suse.cz>
Date: Fri, 26 Apr 2013 10:02:12 -0700
X-Google-Sender-Auth: moS-N3m0w7D3Vq_1Wq4-EPaxkN4
Message-ID: <CA+55aFxwCY3uagCUf1th6sr5+HGO0Mba-dhS-OtsnJ6o41JANw@mail.gmail.com>
Subject: Re: [PATCH v2] TTY: fix atime/mtime regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>, Craig Small <csmall-git@enc.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 4:48 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>
> To revert to the old behaviour while still preventing attackers to
> guess the password length, we update the timestamps in one-minute
> intervals by this patch.

Thanks, applied.

And now that I see the behavior of "w", I can kind of understand why
you picked 10s intervals. That "w" output is really really quite ugly.
Talking about "27.00s" idle for the current terminal when we only
update at even minutes ends up not being sensible.

Giving the resulting (now completely bogus) second-level accuracy looks odd.

But at this point it's just a visual oddity, and not really a bug. The
fact that "w" tries to display things with way more precision than the
kernel actually really gives it just results in slightly odd-looking
output. The "old-style" output of w ("-o") seems a much better
interface. Maybe some day procps can go back to doing that as the
default.

I'm adding Craig Small to the cc, since he seems to be the active
procps-ng developer.

Craig, background: the current git kernel (so 3.9, and these commits
will presumably be back-ported) does not update tty timestamps very
often, because you can use the timestamps to look at peoples typing
behavior. Initially it didn't update the timestamps AT ALL, but that
broke the whole idle routine. Now it updates it only at minute
boundaries, so things like "w" _work_, but the hundreth-of-a-second
idle precision is obviously just totally random noise.

Not a biggie, I doubt I would even have noticed unless I was
explicitly looking at that field, but....

                 Linus
