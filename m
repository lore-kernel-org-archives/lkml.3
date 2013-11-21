Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab3KUFEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:04:51 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39880 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770Ab3KUFEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:04:49 -0500
Message-ID: <528D946B.8030000@hurleysoftware.com>
Date: Thu, 21 Nov 2013 00:04:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Maximiliano Curia <maxy@gnuservers.com.ar>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org,
        Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com> <201309030717.57866.a.miskiewicz@gmail.com> <201310241800.18490.a.miskiewicz@gmail.com> <20131029135036.GA30992@gnuservers.com.ar> <5270EBA9.6070302@hurleysoftware.com> <20131117182906.GE30012@xo-6d-61-c0.localdomain>
In-Reply-To: <20131117182906.GE30012@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2013 01:29 PM, Pavel Machek wrote:
> Hi!
>
> On Wed 2013-10-30 07:21:13, Peter Hurley wrote:
>> On 10/29/2013 09:50 AM, Maximiliano Curia wrote:
>>> ??Hola Arkadiusz!
>>>
>>> El 2013-10-24 a las 18:00 +0200, Arkadiusz Miskiewicz escribió:
>>>> Was just going over bug-readline and lkml archives and found no continuation
>>>> of this.
>>>
>>>> There was a patch proposed but didn't get applied.
>>>> https://lkml.org/lkml/2013/8/17/31
>>>> Maybe it only needs proper patch submission?
>>>
>>> The latest patch is: https://lkml.org/lkml/2013/9/3/539
>>>
>>> And the latest reply is: https://lkml.org/lkml/2013/9/11/825
>>>
>>> Where Peter Hurley suggests that the patch needs a complete and detailed
>>> analysis, but sadly I'm still not sure how to provide it. If anybody is up for
>>> the task, by all means, go ahead.
>>
>> The analysis is on my TODO list. I'll include it with a proper patch, this or
>> next weekend.
>
> Any news?
> 									Pavel
>

A quick overview of the problem and proposed solution:

Larger than 4k pastes immediately fill the line discipline buffer
and trigger an error recovery path which discards input. The error
recovery path exists to avoid wedging userspace when the line
discipline buffer is full but no newline has been received. Without
the error recovery, a canonical (line-by-line) reader will _never_
receive more input when the line discipline buffer is full because,
since no more input will be accepted, no pending newline will
be received, which is a pre-condition for a canonical reader to
read input.

readline() can inadvertently trigger the error recovery path
with pastes larger than 4k because it changes the termios to non-canonical
mode to perform its read() and restores the canonical mode for the caller.
When canonical mode is restored, the error recovery path is triggered and
input is discarded until a newline is received.

The proposed patch below disables the error recovery path unless a blocking
reader/poll is waiting. IOW, if a blocking reader/poll is waiting and the
line discipline buffer is full, input will continue to be accepted but
discarded until a newline is received. If a blocking reader is not waiting,
the receive_buf() worker is aborted and no further input is processed.


From: Maximiliano Curia <maxy@gnuservers.com.ar>
Date: Tue, 3 Sep 2013 22:48:34 +0200
Subject: [PATCH] Only let characters through when there are active readers.

If there is an active reader, previous behavior is in place. When there is no
active reader, input is blocked until the next read call unblocks it.

This fixes a long standing issue with readline when pasting more than 4096
bytes.
---
  drivers/tty/n_tty.c | 9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4bf0fc0..cdc3b19 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -147,9 +147,16 @@ static int set_room(struct tty_struct *tty)
  	 * pending newlines, let characters through without limit, so
  	 * that erase characters will be handled.  Other excess
  	 * characters will be beeped.
+	 * If there is no reader waiting for the input, block instead of
+	 * letting the characters through.
  	 */
  	if (left <= 0)
-		left = ldata->icanon && !ldata->canon_data;
+		if (waitqueue_active(&tty->read_wait)) {
+			left = ldata->icanon && !ldata->canon_data;
+		} else {
+			left = 0;
+		}
+
  	old_left = tty->receive_room;
  	tty->receive_room = left;

-- 

Analysis:

There are two concerns that require analysis:
1) Does the patch function as designed? and
2) Does the error recovery continue to function as designed? If not, are there
    suitable alternatives?

For the first concern; yes, the patch functions as designed (provided the
departing reader is not on the waitqueue when n_tty_set_room() is called;
currently a patch queued for 3.13 has re-ordered the exit in n_tty_read() so
that would need to be re-re-ordered).

The central concept of the proposed patch is to ensure that the error
recovery path is only evaluated when a read() is in-progress, and thus only when
the termios state corresponding with that read() has already been set.

Also, since a blocking reader will evaluate the buffer state before sleeping,
if the buffer is full, the worker will be started and the error recovery path
correctly triggered, which will in turn re-wake the reader when a newline is
received.

However, error recovery will only continue to function correctly for that
one i/o model, blocking reads.

Users of the signal-driven i/o model would become wedged when the line discipline
buffer is full because there is no thread on the read_wait queue and SIGIO will
no longer be sent.

The non-blocking i/o model also becomes susceptible to wedging, if, for example,
poll() is called _after_ the worker has discovered the buffer is full; poll()
won't see input available and the worker will not be restarted.

ioctl(FIONREAD) will also indicate no input is available; emacs uses this
in conjunction with both select() and SIGIO to determine if a read() is
even necessary.


Other possible solutions:

1) I experimented with forcing would-be readers to accept input from partially
completed lines; that is, to wakeup readers/send SIGIO if the line discipline
buffer is full and return read data as if newline had been received when it
had not. While I got that working, I couldn't really convince myself that
this wouldn't cause buffer overruns or access faults for readers not
expecting lines > 4096.

2) A variation of #1 would be to do the wakeup/send SIGIO but have the
reader discard input instead. Unfortunately, there may not be a newline
in the buffered input, which would require returning an error from
the read; I'm not sure how some apps might interpret that.

3) Simplify the whole process and let user apps get wedged; they can be
un-wedged with tcflush(TCIFLUSH/TCIOFLUSH).

4) Unwedge with a watchdog timer.

5) Something I haven't thought of (like fix console selection ioctls and
use those).

6) Fix this in userspace.


Regards,
Peter Hurley


