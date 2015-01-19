Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbbASTng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:43:36 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:59178 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbASTnc (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Mon, 19 Jan 2015 14:43:32 -0500
Message-ID: <54BD5E54.3050909@symas.com>
Date: Mon, 19 Jan 2015 19:43:16 +0000
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0 SeaMonkey/2.34a1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com>
In-Reply-To: <54BD567C.8070200@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> On 01/19/2015 11:36 AM, Howard Chu wrote:
>> Peter Hurley wrote:
>>> Thanks, Howard.
>>>
>>> [ adding Ted too ]
>>>
>>> On 01/19/2015 07:46 AM, Howard Chu wrote:
>>>> Peter Hurley wrote:
>>>>> On 01/18/2015 05:45 PM, Howard Chu wrote:
>>>>>> Peter Hurley wrote:
>>>>>>> Commit 26df6d13406d1 ("tty: Add EXTPROC support for LINEMODE") added
>>>>>>> the undocumented EXTPROC input processing mode, which ignores the ICANON
>>>>>>> setting and forces pty slave input to be processed in non-canonical
>>>>>>> mode.
>>>>>>
>>>>>> What's the motivation to remove this code, rather than improve it if it
>>>>>> needs fixing? It has been removed from the Linux kernel at least once
>>>>>> before already, and that was a mistake back then too.
>>>>>
>>>>> It is a significant maintenance burden, and I have concerns about the
>>>>> level of support it's receiving. Here's some outstanding issues:
>>>>>
>>>>> 1. No man page documentation. At a minimum, tty_ioctl(4) and termios(3)
>>>>>       need the userspace visible definitions and behavior documented. Better
>>>>>       would be a LINEMODE (7) description of how this implementation works
>>>>>       wrt supporting RFC 1116.
>>>>
>>>> That can be added easily enough.
>>>
>>> Is this you signing up?  :)
>>
>> Sure. I suppose the obvious place to add it is near the TIOCPKT doc in tty_ioctl(4). But, about your further comment:
>
> Thanks.
>
>>> Which brings up another point: only a pty master should be able to set EXTPROC
>>> mode. Right now, any tty can be set to EXTPROC and the pty slave can even
>>> accidentally unset it. This argues for a new pty ioctl() to set EXTPROC in
>>> termios. pty_set_termios() can silently merge the bit.
>>
>> Historically EXTPROC could also be set on regular ttys, for lines that were hooked up to special terminal interfaces. E.g. X.29 PADs that did their own input processing. I'm not sure how relevant this is now, but this is the reason EXTPROC is not a pty-specific ioctl.
>
> How does the remote end find out when non-canon mode is selected?
> And who does the EXTPROC setting, because if it's the program that opened the
> tty, then it can just select raw mode instead.

There's a few significant differences in semantics between raw mode and 
EXTPROC mode. The point of EXTPROC is to maintain the tty driver state 
as if cooked mode were still in effect. One obvious difference is that 
VMIN/VTIME are overlaid on VEOL/VEOF in raw mode, so the two are not 
directly interchangeable.

The fact that EXTPROC can be manually unset is by design. Quoting from 
the original again:

> stty.diff:
>     This file contains the changes needed for the stty(1) program
>     to report on the current status of the TS_EXTPROC bit.  It also
>     allows the user to turn on/off the TS_EXTPROC bit.  This is useful
>     because it allows the user to say "stty -extproc", and the
>     LINEMODE option will be automatically disabled, and saying "stty
>     extproc" will re-enable the LINEMODE option.


>>>>> 6. EXTPROC still does some input processing on the server. For example,
>>>>>       7-bit mode (ISTRIP), tolower mode (IUCLC) and processing while
>>>>>       closing; if input processing is being done on the local/client side,
>>>>>       why the extra work here?
>>>>
>>>> That's defensive, on the assumption that something else might break if e.g. the tty expected only 7-bit input but 8-bit characters were sent to it.
>>>
>>> Ok, is that because RFC 1116 doesn't specify ISTRIP and IUCLC handling so
>>> the server can't be sure the client did it? If so, that should be documented
>>> so that refactors don't remove that handling.
>
> Could you get back to me about this, as well?

The telnet protocol (RFC854) defines a Network Virtual Terminal (NVT) as 
using 7-bit USASCII in an 8-bit field. As such, it expects the client to 
be able to generate both upper and lower case itself, so there's no 
analogue to IUCLC, and there would be no reason to use ISTRIP.

RFC5198 updates the protocols to use UTF8. So again, it assumes full 
octets are being transmitted.

Perhaps we can drop these special cases from the driver.

>>> Regular ptys dump input while closing so this should too.
>>>
>>>>> 7. This needs a reference userspace implementation which for the moment
>>>>>       could double as regression testing. A library with unit tests would
>>>>>       be ideal.
>>>>
>>>> telnet/telnetd can probably used as a starting point for this.
>>>
>>> Except telnet is unmaintained except by each distro. Your patches don't apply
>>> to my distro telnet; they had been applied but are now ifdef'd out. I messed
>>> around with rebuilding it but never got telnetd to actually set EXTPROC.
>>>
>>> My point is there is no straightforward way to test this, and that's a problem.
>>>
>>> In fact, this is my main concern: no matter how useful this might be, it's
>>> pointless if the complementary userspace puzzle piece is unsupported.
>>> I know you have written patches but that's not the same as support; for example
>>> your OpenSSH fork is 4 years old, which is a non-starter because I'm sure
>>> there's known exploits which have been fixed in those 4 years.
>>>
>>> Why doesn't Ubuntu/Debian telnet even compile for line mode support? Did the
>>> package maintainer shut it off because it was causing bug reports?
>>
>> I don't know. Looking at the package history it appears they have never enabled it. https://launchpad.net/ubuntu/+source/netkit-telnet/+changelog
>>
>> I also don't know where the actual VCS repo is for this code.
>
> There isn't one. The base code is from downloaded tarball.
>
> I don't know what distro you use (or if you even do), but for Ubuntu/Debian
> the base package information is here https://packages.debian.org/wheezy/telnetd
> including maintainer email, etc.
>
> Typically, to get changes merged requires making a patch(es) against the package
> source and sending/uploading those.

This was already done, and the package maintainer said he was going to 
integrate it. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=585527

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
