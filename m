Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3GTRAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:00:54 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:47398 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754442Ab3GTRAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:00:51 -0400
Message-ID: <51EAC23F.9050101@hurleysoftware.com>
Date: Sat, 20 Jul 2013 13:00:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Andre Naujoks <nautsch2@gmail.com>,
        Dean Jenkins <Dean_Jenkins@mentor.com>
Subject: Re: [PATCH v2 20/20] tty: Remove extra wakeup from pty write() path
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com> <1371306096-5571-1-git-send-email-peter@hurleysoftware.com> <1371306096-5571-21-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1371306096-5571-21-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 10:21 AM, Peter Hurley wrote:
> Acquiring the write_wait queue spin lock now accounts for the largest
> slice of cpu time on the tty write path. Two factors contribute to
> this situation; a overly-pessimistic line discipline write loop which
> _always_ sets up a wait loop even if i/o will immediately succeed, and
> on ptys, a wakeup storm from reads and writes.
>
> Writer wakeup does not need to be performed by the pty driver.
> Firstly, since the actual i/o is performed within the write, the
> line discipline write loop will continue while space remains in
> the flip buffers. Secondly, when space becomes avail in the
> line discipline receive buffer (and thus also in the flip buffers),
> the pty unthrottle re-wakes the writer (non-flow-controlled line
> disciplines unconditionally unthrottle the driver when data is
> received). Thus, existing in-kernel i/o is guaranteed to advance.
> Finally, writer wakeup occurs at the conclusion of the line discipline
> write (in tty_write_unlock()). This guarantees that any user-space write
> waiters are woken to continue additional i/o.

Greg,

I thought I should let you know I'm tracking down a bug/regression
related to this patch.

In certain unusual pty/ldisc configurations, i/o fails to make
forward progress. I still stand by my commit message above, so I'm
in the process of instrumenting the i/o path so I can uncover the
cause of the failure.

I would still recommend applying this patch to tty-next, as it
resolves a much more critical bug discussed here [1].

Doing a write_wakeup() from a driver .write() method is a no-no;
recursion is possible and results in a thread stack overrun.

Regards,
Peter Hurley

[1]
https://lkml.org/lkml/2013/7/1/308

> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/pty.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index 0634dd9..b9bc5be 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -121,10 +121,8 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
>   		/* Stuff the data into the input queue of the other end */
>   		c = tty_insert_flip_string(to->port, buf, c);
>   		/* And shovel */
> -		if (c) {
> +		if (c)
>   			tty_flip_buffer_push(to->port);
> -			tty_wakeup(tty);
> -		}
>   	}
>   	return c;
>   }
>

