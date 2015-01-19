Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbbASMqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:46:24 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:52806 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbASMqU (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Mon, 19 Jan 2015 07:46:20 -0500
Message-ID: <54BCFC94.1040605@symas.com>
Date: Mon, 19 Jan 2015 12:46:12 +0000
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0 SeaMonkey/2.34a1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com>
In-Reply-To: <54BC5EC7.1090202@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> On 01/18/2015 05:45 PM, Howard Chu wrote:
>> Peter Hurley wrote:
>>> Commit 26df6d13406d1 ("tty: Add EXTPROC support for LINEMODE") added
>>> the undocumented EXTPROC input processing mode, which ignores the ICANON
>>> setting and forces pty slave input to be processed in non-canonical
>>> mode.
>>
>> What's the motivation to remove this code, rather than improve it if it
>> needs fixing? It has been removed from the Linux kernel at least once
>> before already, and that was a mistake back then too.
>
> It is a significant maintenance burden, and I have concerns about the
> level of support it's receiving. Here's some outstanding issues:
>
> 1. No man page documentation. At a minimum, tty_ioctl(4) and termios(3)
>     need the userspace visible definitions and behavior documented. Better
>     would be a LINEMODE (7) description of how this implementation works
>     wrt supporting RFC 1116.

That can be added easily enough. Historically EXTPROC has had very 
little documentation of its own. E.g. the FreeBSD manpage only shows 
that the flag exists.

https://www.freebsd.org/cgi/man.cgi?query=termios&sektion=4

> 2. read(), poll()/select() and ioctl() with and without EXTPROC need to
>     have _identical_ userspace behavior.

OK, this can be fixed.

> 3. Does the local edit guarantee canon lines <= 4096 chars? What happens
>     if pty slave reader does this?
>
> 	char buffer[4096];
> 	char *p = buffer;
>
> 	n = read(tty, buffer, sizeof(buffer));
> 	if (n <= 0)
> 		goto done;
> 	while (*p++ != '\n')
> 		;

This reader is broken, since the tty driver supports EOL and EOL2 and 
this code doesn't account for it.

In practice your concern is misdirected - it's the job of whatever code 
is talking to the pty master to send valid data to the pty slave. 
There's no reason for the tty driver to second-guess the app here.

> 4. ioctl(TIOCSIG) can send _any_ signal to a different process without
>     permission checks. That's not good.

It can only send to the pty slave. Permissions were already checked when 
the pty master was opened. What further checks do you think are needed? 
You think it should be limited to tty-specific signals: INT, QUIT, CONT, 
TSTP, TTIN, TTOU, WINCH?

> 5. This needs to work with readline(). Right now, I don't see how this
>     won't have worst-case behavior, constantly sending termios changes,
>     with scripted input where the reader switches back-and-forth between
>     canonical and non-canonical mode (like readline() does). Database
>     shells behave like this, but you can do a 20-line shell mockup with
>     just readline().

readline() patched accordingly 
https://groups.google.com/forum/#!topic/gnu.bash.bug/o0UA55AhADs will 
cooperate. Sending one or two termios changes per input line is still 
far better than one character-at-a-time packets back and forth.

> 6. EXTPROC still does some input processing on the server. For example,
>     7-bit mode (ISTRIP), tolower mode (IUCLC) and processing while
>     closing; if input processing is being done on the local/client side,
>     why the extra work here?

That's defensive, on the assumption that something else might break if 
e.g. the tty expected only 7-bit input but 8-bit characters were sent to it.

> 7. This needs a reference userspace implementation which for the moment
>     could double as regression testing. A library with unit tests would
>     be ideal.

telnet/telnetd can probably used as a starting point for this.

> ISTM the right implementation, if there is one, is for EXTPROC to process
> input exactly like raw mode except that line termination wakes up read_wait
> and there is no special casing in read/poll.

I agree that this sounds simpler but I feel there's a reason (which I 
can't remember at the moment) that it doesn't work out that way.

> Does SLC_FORW1 & SLC_FORW2
> map directly to termios.c_cc[] line termination values?

Maps exactly to VEOL / VEOL2.

> I'd like to do away with the signalling part; just turn off EXTPROC
> and send the appropriate signalling char from the pty master, like telnetd
> does now. Same for EOF.

That introduces additional mode changes, which you were just worrying 
about above, re: readline. It would make the traffic stream less 
efficient overall.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
