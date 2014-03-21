Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbaCULVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:21:31 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41937 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760185AbaCULVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:21:30 -0400
Message-ID: <532C20B7.2070806@hurleysoftware.com>
Date: Fri, 21 Mar 2014 07:21:27 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Subject: Re: man termios
References: <532B3691.1070602@hurleysoftware.com> <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com>
In-Reply-To: <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 06:45 AM, Michael Kerrisk (man-pages) wrote:
>> This is also true of the other non-canonical
>> read()'s with timeout (TIME > 0).
>
> Here, if I understand you correctly, you mean this case:
> * TIME > 0
> * MIN == 0
> * O_NONBLOCK set on the FD
> * No input available
>
> You are saying that read() returns 0 in this case? This doesn't appear
> to me to be correct (on Linux). How did you verify this?

Apologies, my mistake here.

(aside: O_NONBLOCK can be changed while the reader is blocked, but that's
not what I meant originally, and I wouldn't document it there)

>> 'man termios' is silent here, but 62.6.2 in LPI implies that O_NONBLOCK will
>> return -1 with errno==EAGAIN; it does not.
>
> I guess you are referring to this text in TLPI:

Yes.

> [[
> This mode is somewhat similar to setting the O_NONBLOCK flag for the
> terminal (Section 5.9). However, with O_NONBLOCK, if no bytes are
> available for reading, then read() returns –1 with the error
> EAGAIN.
> ]]
>
> Oops. The text was not meant to imply that. Rather the comparison was
> intended to be with O_NONBLOCK *in canonical mode*. However, I agree
> that I could have made that more explicit. (I'll add an erratum to
> mention canonical mode.)
>
>> This is unspecified by POSIX (11.1.7).
>
> Yep, I see. XBD 11.1.7 says:
>
> [[
> Therefore, if O_NONBLOCK is set, read( ) may return immediately,
> regardless of the setting of MIN or TIME. Also, if no data is
> available, read( ) may either return 0, or return -1 with errno set to
> [EAGAIN].
> ]]
>
> So, it seems to be saying that either behavior is allowed, right?

Exactly.

> And as far as I can see, for the TIME>0 case on Linux, read() returns
> -1 + EGAIN.

You're right about the TIME>0 case.

> In any case, I've added this text to termios(3):
>
>         POSIX  does  not  specify whether the setting of the O_NONBLOCK
>         file status flag takes precedence over the MIN  and  TIME  set‐
>         tings.  If O_NONBLOCK is set, a read() in noncanonical mode may
>         return immediately, regardless of the setting of MIN  or  TIME.
>         Furthermore, if no data is available, POSIX permits a read() in
>         noncanonical mode to return either 0, or -1 with errno  set  to
>         EAGAIN.


Great; I think that will really help clarify the usage wrt O_NONBLOCK.


>> Secondly, in all 4 of the non-canonical read() modes, the MIN value does not
>> limit the number of bytes which may be returned by the read(). Only the
>> 'count' parameter to read() has this effect.
>>
>> LPI has this to say (man-pages reads similar):
>>
>> "MIN > 0, TIME == 0 (blocking read)
>>
>> The read() blocks (possibly indefinitely) until the lesser of the number of
>> bytes requested or MIN bytes are available, and returns the lesser of the
>> two values."
>>
>> However, read() may unblock when MIN bytes are available but return up to
>> the 'count' parameter if more input arrives in between waking and copying
>> into the user buffer.
>
> Yup, you are obviously correct. It would make no sense for read() to
> return the lesser of [MIN, count]. I got myself into a small thinko as
> I wrote that text.
>
> I've applied this patch to the termios.3 page:
>
> [[
> diff --git a/man3/termios.3 b/man3/termios.3
> index b069ec0..63aba07 100644
> --- a/man3/termios.3
> +++ b/man3/termios.3
> @@ -728,8 +728,7 @@ completes; there are four distinct cases:
>   MIN == 0; TIME == 0:
>   If data is available,
>   .BR read (2)
> -returns immediately, with the lesser of the number of bytes
> -available, or the number of bytes requested.
> +returns immediately, returning up to the number of bytes requested.
>   If no data is available,
>   .BR read (2)
>   returns 0.
> ]]
>
> I'll write a similar erratum for TLPI.

Thanks.

> [...]
>
>> Finally, if the 'count' parameter is less than MIN, read() may return before
>> MIN bytes have been received, if 'count' bytes have been received.
>
> Yes. But it's not clear to me here: do you mean that something in the
> man page (or in TLPI) needs fixing?

Well, what I mean here is that read() may also _not_ return until MIN bytes have
been received, even if 'count' bytes have been received.

Regards,
Peter Hurley



