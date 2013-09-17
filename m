Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3IQUjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:39:13 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45537 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753007Ab3IQUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:39:12 -0400
Message-ID: <5238BDEC.1070400@hurleysoftware.com>
Date: Tue, 17 Sep 2013 16:39:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: disassociate_ctty() sends the extra SIGCONT
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com>
In-Reply-To: <20130915155026.GA11917@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2013 11:50 AM, Oleg Nesterov wrote:
> Starting from v3.10 (probably f91e2590 "tty: Signal foreground
> group processes in hangup") disassociate_ctty() sends SIGCONT
> if tty && on_exit. This breaks LSB test-suite, in particular
> test8 in _exit.c and test40 in sigcon5.c.

Yes, this regression was introduced by me in that commit.
The effect of the regression is that ptys will receive a
SIGCONT when, in similar circumstances, ttys would not.

The fact that two test vectors accidentally tripped over
this regression suggests that some other apps may as well.

Thanks for catching this.

> Put the "!on_exit" check back to restore the old behaviour.
>
> Cc: stable@vger.kernel.org # v3.10+
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reported-by: Karel Srot <ksrot@redhat.com>

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

> ---
>   drivers/tty/tty_io.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index a9355ce..3a1a01a 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -854,7 +854,8 @@ void disassociate_ctty(int on_exit)
>   			struct pid *tty_pgrp = tty_get_pgrp(tty);
>   			if (tty_pgrp) {
>   				kill_pgrp(tty_pgrp, SIGHUP, on_exit);
> -				kill_pgrp(tty_pgrp, SIGCONT, on_exit);
> +				if (!on_exit)
> +					kill_pgrp(tty_pgrp, SIGCONT, on_exit);
>   				put_pid(tty_pgrp);
>   			}
>   		}
>

