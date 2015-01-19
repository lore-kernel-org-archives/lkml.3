Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbbASO5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:57:30 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65516 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbASO52 (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:57:28 -0500
Message-ID: <54BD1B53.9030901@hurleysoftware.com>
Date: Mon, 19 Jan 2015 09:57:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com>
In-Reply-To: <54BCFC94.1040605@symas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Howard.

[ adding Ted too ]

On 01/19/2015 07:46 AM, Howard Chu wrote:
> Peter Hurley wrote:
>> On 01/18/2015 05:45 PM, Howard Chu wrote:
>>> Peter Hurley wrote:
>>>> Commit 26df6d13406d1 ("tty: Add EXTPROC support for LINEMODE") added
>>>> the undocumented EXTPROC input processing mode, which ignores the ICANON
>>>> setting and forces pty slave input to be processed in non-canonical
>>>> mode.
>>>
>>> What's the motivation to remove this code, rather than improve it if it
>>> needs fixing? It has been removed from the Linux kernel at least once
>>> before already, and that was a mistake back then too.
>>
>> It is a significant maintenance burden, and I have concerns about the
>> level of support it's receiving. Here's some outstanding issues:
>>
>> 1. No man page documentation. At a minimum, tty_ioctl(4) and termios(3)
>>     need the userspace visible definitions and behavior documented. Better
>>     would be a LINEMODE (7) description of how this implementation works
>>     wrt supporting RFC 1116.
> 
> That can be added easily enough.

Is this you signing up?  :)

> Historically EXTPROC has had very little documentation of its own. E.g. the FreeBSD manpage only shows that the flag exists.
> 
> https://www.freebsd.org/cgi/man.cgi?query=termios&sektion=4

A description of how the pty master uses EXTPROC to implement line mode would
be very helpful, especially to people working in the tty code (eg., me, although
I don't need it now).


>> 2. read(), poll()/select() and ioctl() with and without EXTPROC need to
>>     have _identical_ userspace behavior.
> 
> OK, this can be fixed.

Ok.

>> 3. Does the local edit guarantee canon lines <= 4096 chars? What happens
>>     if pty slave reader does this?
>>
>>     char buffer[4096];
>>     char *p = buffer;
>>
>>     n = read(tty, buffer, sizeof(buffer));
>>     if (n <= 0)
>>         goto done;
>>     while (*p++ != '\n')
>>         ;
> 
> This reader is broken, since the tty driver supports EOL and EOL2 and this code doesn't account for it.

This reader set EOL2 to DISABLED_CHAR earlier, and left EOL unchanged.
I have seen userspace code that expects a line to be no longer than 4096 chars.

> In practice your concern is misdirected - it's the job of whatever code is talking to the pty master to send valid data to the pty slave. There's no reason for the tty driver to second-guess the app here.

What about a malicious client?

>> 4. ioctl(TIOCSIG) can send _any_ signal to a different process without
>>     permission checks. That's not good.
> 
> It can only send to the pty slave. Permissions were already checked when the pty master was opened.

Still not ok.

> What further checks do you think are needed? You think it should be limited to tty-specific signals: INT, QUIT, CONT, TSTP, TTIN, TTOU, WINCH?

My first choice is to do away with TIOCSIG ioctl completely; see ending comments.
My second would be masked to only those already used: INT, QUIT, TSTP.

>> 5. This needs to work with readline(). Right now, I don't see how this
>>     won't have worst-case behavior, constantly sending termios changes,
>>     with scripted input where the reader switches back-and-forth between
>>     canonical and non-canonical mode (like readline() does). Database
>>     shells behave like this, but you can do a 20-line shell mockup with
>>     just readline().
> 
> readline() patched accordingly https://groups.google.com/forum/#!topic/gnu.bash.bug/o0UA55AhADs will cooperate. Sending one or two termios changes per input line is still far better than one character-at-a-time packets back and forth.

Ok, I misunderstood: the only incompatibility here is that readline()
simply doesn't use line mode. That's fine from the kernel perspective.

Although it does seem odd that the command shell doesn't support the
input mode :)

>> 6. EXTPROC still does some input processing on the server. For example,
>>     7-bit mode (ISTRIP), tolower mode (IUCLC) and processing while
>>     closing; if input processing is being done on the local/client side,
>>     why the extra work here?
> 
> That's defensive, on the assumption that something else might break if e.g. the tty expected only 7-bit input but 8-bit characters were sent to it.

Ok, is that because RFC 1116 doesn't specify ISTRIP and IUCLC handling so
the server can't be sure the client did it? If so, that should be documented
so that refactors don't remove that handling.

Regular ptys dump input while closing so this should too.

>> 7. This needs a reference userspace implementation which for the moment
>>     could double as regression testing. A library with unit tests would
>>     be ideal.
> 
> telnet/telnetd can probably used as a starting point for this.

Except telnet is unmaintained except by each distro. Your patches don't apply
to my distro telnet; they had been applied but are now ifdef'd out. I messed
around with rebuilding it but never got telnetd to actually set EXTPROC.

My point is there is no straightforward way to test this, and that's a problem.

In fact, this is my main concern: no matter how useful this might be, it's
pointless if the complementary userspace puzzle piece is unsupported.
I know you have written patches but that's not the same as support; for example
your OpenSSH fork is 4 years old, which is a non-starter because I'm sure
there's known exploits which have been fixed in those 4 years.

Why doesn't Ubuntu/Debian telnet even compile for line mode support? Did the
package maintainer shut it off because it was causing bug reports?

What more needs to be done to get line mode working 100% in bash?

>> ISTM the right implementation, if there is one, is for EXTPROC to process
>> input exactly like raw mode except that line termination wakes up read_wait
>> and there is no special casing in read/poll.
> 
> I agree that this sounds simpler but I feel there's a reason (which I can't remember at the moment) that it doesn't work out that way.
> 
>> Does SLC_FORW1 & SLC_FORW2
>> map directly to termios.c_cc[] line termination values?
> 
> Maps exactly to VEOL / VEOL2.
> 
>> I'd like to do away with the signalling part; just turn off EXTPROC
>> and send the appropriate signalling char from the pty master, like telnetd
>> does now. Same for EOF.
> 
> That introduces additional mode changes, which you were just worrying about above, re: readline. It would make the traffic stream less efficient overall.

Maybe you misunderstood. If local signalling is being performed by the client,
the over-the-wire traffic is the same. The pty master would turn off EXTPROC to
write the signalling char but would not reflect the termios to the client (because
it contains no relevant changes).

And the signalling char is isolated and unique: it's not as if it's being stuffed
within an existing stream of i/o, because the client should have already ceased
input if it's handling signals locally.

Which brings up another point: only a pty master should be able to set EXTPROC
mode. Right now, any tty can be set to EXTPROC and the pty slave can even
accidentally unset it. This argues for a new pty ioctl() to set EXTPROC in
termios. pty_set_termios() can silently merge the bit.

Regards,
Peter Hurley

