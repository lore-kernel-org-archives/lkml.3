Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3KVM5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:57:15 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51880 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146Ab3KVM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:57:13 -0500
Message-ID: <528F54A2.5000802@hurleysoftware.com>
Date: Fri, 22 Nov 2013 07:57:06 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Maximiliano Curia <maxy@gnuservers.com.ar>,
        Margarita Manterola <margamanterola@gmail.com>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com> <201309030717.57866.a.miskiewicz@gmail.com> <201310241800.18490.a.miskiewicz@gmail.com> <20131029135036.GA30992@gnuservers.com.ar> <5270EBA9.6070302@hurleysoftware.com> <20131117182906.GE30012@xo-6d-61-c0.localdomain> <528D946B.8030000@hurleysoftware.com>
In-Reply-To: <528D946B.8030000@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 12:04 AM, Peter Hurley wrote:
> On 11/17/2013 01:29 PM, Pavel Machek wrote:
>> Hi!
>>
>> On Wed 2013-10-30 07:21:13, Peter Hurley wrote:
>>> On 10/29/2013 09:50 AM, Maximiliano Curia wrote:
>>>> ??Hola Arkadiusz!
>>>>
>>>> El 2013-10-24 a las 18:00 +0200, Arkadiusz Miskiewicz escribió:
>>>>> Was just going over bug-readline and lkml archives and found no continuation
>>>>> of this.
>>>>
>>>>> There was a patch proposed but didn't get applied.
>>>>> https://lkml.org/lkml/2013/8/17/31
>>>>> Maybe it only needs proper patch submission?
>>>>
>>>> The latest patch is: https://lkml.org/lkml/2013/9/3/539
>>>>
>>>> And the latest reply is: https://lkml.org/lkml/2013/9/11/825
>>>>
>>>> Where Peter Hurley suggests that the patch needs a complete and detailed
>>>> analysis, but sadly I'm still not sure how to provide it. If anybody is up for
>>>> the task, by all means, go ahead.
>>>
>>> The analysis is on my TODO list. I'll include it with a proper patch, this or
>>> next weekend.
>>
>> Any news?
>>                                     Pavel
>>
> Other possible solutions:

<...>
7) Rescan line discipline buffer when changing from non-canonical to canonical
mode. The real problem with this approach (besides the inefficiency) is that this
solution could break some (admittedly unknown) program that contrived to exchange
data in non-canonical mode but read in canonical mode (just not exceeding the
line discipline buffer limit).

8) Don't restart the input processing worker with the termios change, but rather
wait for the future reader (which is woken if waiting) to restart input processing
instead (if it needs to).

If signal-driven i/o is being used for this tty, then the input processing worker
is immediately restarted in the line buffer is full. This is necessary to ensure
a full line buffer does not wedge a userspace program using signal-driven i/o
exclusively (because there is no waiting reader).

Similarly, since non-blocking i/o will not have a waiting reader, poll() must
restart the input processing iff there is no input and the tty is in canonical
mode and the line buffer was full. These conditions can only exist immediately
after a termios change (since terminals always start in canonical mode, the
line buffer cannot become full and have no input available without first having
been changed to non-canonical mode and then reset back to canonical mode).

Test patch below

--- >% ---
Subject: [PATCH] n_tty: Fix buffer overruns with larger-than-4k pastes

readline() inadvertently triggers an error recovery path when
pastes larger than 4k overrun the line discipline buffer. The
error recovery path discards input when the line discipline buffer
is full and operating in canonical mode and no newline has been
received. Because readline() changes the termios to non-canonical
mode to read the line char-by-char, the line discipline buffer
can become full, and then when readline() restores termios back
to canonical mode for the caller, the now-full line discipline
buffer triggers the error recovery.

Instead of restarting the input processing worker from the
change in termios, let the waking reader restart the worker.
In this way, the termios set at the time of the actual read() will
apply if/when the worker restarts.

Because signal-driven i/o may not have an active reader to restart
the worker, the change in termios must restart the worker if
O_ASYNC flag was set.

Similarly, because a poll() may not be waiting at the time the
termios is changed, the worker may need to be restarted by the
poll() (if the specific conditions exist; namely, canonical mode
&& no input available && receive buffer was full).

Reported-by: Margarita Manterola <margamanterola@gmail.com>
Cc: Maximiliano Curia <maxy@gnuservers.com.ar>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
  drivers/tty/n_tty.c | 9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0f74945..ddc0129 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1809,7 +1809,12 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
  		else
  			ldata->real_raw = 0;
  	}
-	n_tty_set_room(tty);
+
+	/* Only restart worker if tty is using signal-driven i/o.
+	 * Otherwise, let the reader restart the worker
+	 */
+	if (tty->fasync)
+		n_tty_set_room(tty);
  	/*
  	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
  	 * been stopped by STOP_CHAR(tty) before it.
@@ -2393,6 +2398,8 @@ static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
  	poll_wait(file, &tty->write_wait, wait);
  	if (input_available_p(tty, TIME_CHAR(tty) ? 0 : MIN_CHAR(tty)))
  		mask |= POLLIN | POLLRDNORM;
+	else if (ldata->icanon)
+		n_tty_set_room(tty);
  	if (tty->packet && tty->link->ctrl_status)
  		mask |= POLLPRI | POLLIN | POLLRDNORM;
  	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
-- 
1.8.1.2


