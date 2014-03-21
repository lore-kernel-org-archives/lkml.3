Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbaCUNPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:15:47 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:56602 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbaCUNPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:15:40 -0400
Message-ID: <532C3B6F.2000300@gmail.com>
Date: Fri, 21 Mar 2014 14:15:27 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: mtk.manpages@gmail.com, linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Subject: Re: man termios
References: <532B3691.1070602@hurleysoftware.com> <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com> <532C20B7.2070806@hurleysoftware.com>
In-Reply-To: <532C20B7.2070806@hurleysoftware.com>
Content-Type: multipart/mixed;
 boundary="------------050508070206040901010509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050508070206040901010509
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/21/2014 12:21 PM, Peter Hurley wrote:
> On 03/21/2014 06:45 AM, Michael Kerrisk (man-pages) wrote:
>>> This is also true of the other non-canonical
>>> read()'s with timeout (TIME > 0).
>>
>> Here, if I understand you correctly, you mean this case:
>> * TIME > 0
>> * MIN == 0
>> * O_NONBLOCK set on the FD
>> * No input available
>>
>> You are saying that read() returns 0 in this case? This doesn't appear
>> to me to be correct (on Linux). How did you verify this?
> 
> Apologies, my mistake here.

Okay -- thanks for confirming.

> (aside: O_NONBLOCK can be changed while the reader is blocked, but that's
> not what I meant originally, and I wouldn't document it there)
> 
>>> 'man termios' is silent here, but 62.6.2 in LPI implies that O_NONBLOCK will
>>> return -1 with errno==EAGAIN; it does not.
>>
>> I guess you are referring to this text in TLPI:
> 
> Yes.
> 
>> [[
>> This mode is somewhat similar to setting the O_NONBLOCK flag for the
>> terminal (Section 5.9). However, with O_NONBLOCK, if no bytes are
>> available for reading, then read() returns –1 with the error
>> EAGAIN.
>> ]]
>>
>> Oops. The text was not meant to imply that. Rather the comparison was
>> intended to be with O_NONBLOCK *in canonical mode*. However, I agree
>> that I could have made that more explicit. (I'll add an erratum to
>> mention canonical mode.)
>>
>>> This is unspecified by POSIX (11.1.7).
>>
>> Yep, I see. XBD 11.1.7 says:
>>
>> [[
>> Therefore, if O_NONBLOCK is set, read( ) may return immediately,
>> regardless of the setting of MIN or TIME. Also, if no data is
>> available, read( ) may either return 0, or return -1 with errno set to
>> [EAGAIN].
>> ]]
>>
>> So, it seems to be saying that either behavior is allowed, right?
> 
> Exactly.
> 
>> And as far as I can see, for the TIME>0 case on Linux, read() returns
>> -1 + EGAIN.
> 
> You're right about the TIME>0 case.
> 
>> In any case, I've added this text to termios(3):
>>
>>         POSIX  does  not  specify whether the setting of the O_NONBLOCK
>>         file status flag takes precedence over the MIN  and  TIME  set‐
>>         tings.  If O_NONBLOCK is set, a read() in noncanonical mode may
>>         return immediately, regardless of the setting of MIN  or  TIME.
>>         Furthermore, if no data is available, POSIX permits a read() in
>>         noncanonical mode to return either 0, or -1 with errno  set  to
>>         EAGAIN.
> 
> 
> Great; I think that will really help clarify the usage wrt O_NONBLOCK.

[...]

>>> Finally, if the 'count' parameter is less than MIN, read() may return before
>>> MIN bytes have been received, if 'count' bytes have been received.
>>
>> Yes. But it's not clear to me here: do you mean that something in the
>> man page (or in TLPI) needs fixing?
> 
> Well, what I mean here is that read() may also _not_ return until MIN bytes have
> been received, even if 'count' bytes have been received.

Ahh -- I see what you mean. And, it looks like there is a point here where Linux
differs from POSIX and (at least) Solaris. See the current man-page text below,
in particular the MIN>0, TIME>0 case. I've also attached a simple test program 
that I used, below.

       In noncanonical mode input is available immediately (without  the
       user  having  to  type a line-delimiter character), no input pro‐
       cessing is performed, and line editing is disabled.  The settings
       of  MIN (c_cc[VMIN]) and TIME (c_cc[VTIME]) determine the circum‐
       stances in which a read(2) completes;  there  are  four  distinct
       cases:

       MIN == 0; TIME == 0:
              If  data  is  available, read(2) returns immediately, with
              the lesser of the number of bytes available, or the number
              of  bytes  requested.   If  no  data is available, read(2)
              returns 0.

       MIN > 0; TIME == 0:
              read(2) blocks until MIN bytes are available, and  returns
              up to the number of bytes requested.

       MIN == 0; TIME > 0:
              TIME  specifies  the limit for a timer in tenths of a sec‐
              ond.   The  timer  is  started  when  read(2)  is  called.
              read(2)  returns  either when at least one byte of data is
              available, or  when  the  timer  expires.   If  the  timer
              expires  without  any  input  becoming  available, read(2)
              returns 0.  If data is already available at  the  time  of
              the call to read() the call behaves as though the data was
              received immediately after the call.

       MIN > 0; TIME > 0:
              TIME specifies the limit for a timer in tenths of  a  sec‐
              ond.  Once an initial byte of input becomes available, the
              timer is restarted after each further  byte  is  received.
              read(2)  returns  when  any of the following conditions is
              met:

              *  MIN bytes have been received.

              *  The interbyte timer expires.

              *  The number of  bytes  requested  by  read(2)  has  been
                 received.   (POSIX  does  not  specify this termination
                 condition, and on  some  other  implementations  read()
                 does not return in this case.)

              Because  the  timer is started only after the initial byte
              becomes available, at least one byte  will  be  read.   If
              data  is  already  available  at  the  time of the call to
              read() the call behaves as though the  data  was  received
              immediately after the call.

       POSIX does not specify whether the setting of the O_NONBLOCK file
       status flag takes precedence over the MIN and TIME settings.   If
       O_NONBLOCK is set, a read() in noncanonical mode may return imme‐
       diately, regardless of the setting of MIN or TIME.   Furthermore,
       if  no  data is available, POSIX permits a read() in noncanonical
       mode to return either 0, or -1 with errno set to EAGAIN.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--------------050508070206040901010509
Content-Type: text/x-csrc;
 name="noncanonical.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="noncanonical.c"

/*#* noncanonical.c

   Usage: see below.
*/
#include <termios.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#define errExit(msg) 	do { perror(msg); exit(EXIT_FAILURE); \
			} while (0)


int
main(int argc, char *argv[])
{
    char buf[100000];
    struct termios tp;
    ssize_t numRead;
    int sleepTime;

    if (argc < 4) {
	fprintf(stderr, "Usage: %s TIME MIN num-bytes-to-read "
		"[sleep-secs [O_NONBLOCK flag]]\n", argv[0]);
	exit(EXIT_FAILURE);
    }

    if (tcgetattr(STDIN_FILENO, &tp) == -1)
	errExit("tcgetattr");

    tp.c_lflag &= ~ICANON;
    tp.c_cc[VTIME] = atoi(argv[1]);
    tp.c_cc[VMIN] = atoi(argv[2]);

    if (tcsetattr(STDIN_FILENO, TCSANOW, &tp) == -1)
        errExit("tcsetattr");

    if (argc > 5) {
	int flags;

	flags = fcntl(STDIN_FILENO, F_GETFL);
	if (flags == -1)
	    errExit("fcntl");
	flags |= O_NONBLOCK;
	if (fcntl(STDIN_FILENO, F_SETFL, flags) == -1)
	    errExit("fcntl");
    }

    sleepTime = (argc > 4) ? atoi(argv[4]) : 5;
    printf("About to sleep for %d seconds\n", sleepTime);
    sleep(sleepTime);
    printf("Done sleeping\n");

    printf("About to read %d bytes\n", atoi(argv[3]));
    numRead = read(STDIN_FILENO, buf, atoi(argv[3]));
    if (numRead == -1)
	errExit("read");
    printf("read returned %ld\n", (long) numRead);

    exit(EXIT_SUCCESS);
} /* main */

--------------050508070206040901010509--
