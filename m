Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393AbaCUKpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:45:51 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60125 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbaCUKpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:45:49 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <532B3691.1070602@hurleysoftware.com>
References: <532B3691.1070602@hurleysoftware.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 21 Mar 2014 11:45:28 +0100
Message-ID: <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com>
Subject: Re: man termios
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Thu, Mar 20, 2014 at 7:42 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> Hi Michael,
>
> Some issues have arisen [1] regarding a discrepancy between the Linux
> behavior of
> read() on a tty and 'man termios' and 'Linux Programming Interface', Chapter
> 62.
>
> Firstly, if MIN==0 and TIME==0 and no input is available, read() returns 0,
> even if O_NONBLOCK is set.

Yes.

> This is also true of the other non-canonical
> read()'s with
> timeout (TIME > 0).

Here, if I understand you correctly, you mean this case:
* TIME > 0
* MIN == 0
* O_NONBLOCK set on the FD
* No input available

You are saying that read() returns 0 in this case? This doesn't appear
to me to be correct (on Linux). How did you verify this?

> 'man termios' is silent here, but 62.6.2 in LPI implies that O_NONBLOCK will
> return
> -1 with errno==EAGAIN; it does not.

I guess you are referring to this text in TLPI:

[[
This mode is somewhat similar to setting the O_NONBLOCK flag for the
terminal (Section 5.9). However, with O_NONBLOCK, if no bytes are
available for reading, then read() returns –1 with the error
EAGAIN.
]]

Oops. The text was not meant to imply that. Rather the comparison was
intended to be with O_NONBLOCK *in canonical mode*. However, I agree
that I could have made that more explicit. (I'll add an erratum to
mention canonical mode.)

> This is unspecified by POSIX (11.1.7).

Yep, I see. XBD 11.1.7 says:

[[
Therefore, if O_NONBLOCK is set, read( ) may return immediately,
regardless of the setting of MIN or TIME. Also, if no data is
available, read( ) may either return 0, or return -1 with errno set to
[EAGAIN].
]]

So, it seems to be saying that either behavior is allowed, right? And
as far as I can see, for the TIME>0 case on Linux, read() returns -1 +
EGAIN.

In any case, I've added this text to termios(3):

       POSIX  does  not  specify whether the setting of the O_NONBLOCK
       file status flag takes precedence over the MIN  and  TIME  set‐
       tings.  If O_NONBLOCK is set, a read() in noncanonical mode may
       return immediately, regardless of the setting of MIN  or  TIME.
       Furthermore, if no data is available, POSIX permits a read() in
       noncanonical mode to return either 0, or -1 with errno  set  to
       EAGAIN.

> Secondly, in all 4 of the non-canonical read() modes, the MIN value does not
> limit
> the number of bytes which may be returned by the read(). Only the 'count'
> parameter
> to read() has this effect.
>
> LPI has this to say (man-pages reads similar):
>
> "MIN > 0, TIME == 0 (blocking read)
>
> The read() blocks (possibly indefinitely) until the lesser of the number of
> bytes
> requested or MIN bytes are available, and returns the lesser of the two
> values."
>
> However, read() may unblock when MIN bytes are available but return up to
> the
> 'count' parameter if more input arrives in between waking and copying into
> the
> user buffer.

Yup, you are obviously correct. It would make no sense for read() to
return the lesser of [MIN, count]. I got myself into a small thinko as
I wrote that text.

I've applied this patch to the termios.3 page:

[[
diff --git a/man3/termios.3 b/man3/termios.3
index b069ec0..63aba07 100644
--- a/man3/termios.3
+++ b/man3/termios.3
@@ -728,8 +728,7 @@ completes; there are four distinct cases:
 MIN == 0; TIME == 0:
 If data is available,
 .BR read (2)
-returns immediately, with the lesser of the number of bytes
-available, or the number of bytes requested.
+returns immediately, returning up to the number of bytes requested.
 If no data is available,
 .BR read (2)
 returns 0.
]]

I'll write a similar erratum for TLPI.

[...]

> Finally, if the 'count' parameter is less than MIN, read() may return before
> MIN
> bytes have been received, if 'count' bytes have been received.

Yes. But it's not clear to me here: do you mean that something in the
man page (or in TLPI) needs fixing?

Thanks for the report, Peter.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
