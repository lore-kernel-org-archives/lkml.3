Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbATSCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:02:45 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:43621 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbATSCn (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:02:43 -0500
Message-ID: <54BE9840.8080808@hurleysoftware.com>
Date: Tue, 20 Jan 2015 13:02:40 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com> <54BD5E54.3050909@symas.com>
In-Reply-To: <54BD5E54.3050909@symas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 02:43 PM, Howard Chu wrote:
> Peter Hurley wrote:
>> On 01/19/2015 11:36 AM, Howard Chu wrote:
>>> Peter Hurley wrote:
>>>> On 01/19/2015 07:46 AM, Howard Chu wrote:
>>>>> Peter Hurley wrote:

[...]

>>>> Which brings up another point: only a pty master should be able to set EXTPROC
>>>> mode. Right now, any tty can be set to EXTPROC and the pty slave can even
>>>> accidentally unset it. This argues for a new pty ioctl() to set EXTPROC in
>>>> termios. pty_set_termios() can silently merge the bit.
>>>
>>> Historically EXTPROC could also be set on regular ttys, for lines that were hooked up to special terminal interfaces. E.g. X.29 PADs that did their own input processing. I'm not sure how relevant this is now, but this is the reason EXTPROC is not a pty-specific ioctl.
>>
>> How does the remote end find out when non-canon mode is selected?
>> And who does the EXTPROC setting, because if it's the program that opened the
>> tty, then it can just select raw mode instead.
> 
> There's a few significant differences in semantics between raw mode and EXTPROC mode.

Sorry, I have this unfortunate habit of referring to non-canonical modes
as 'raw' (which stems from the way the terminal driver handles input).

> The point of EXTPROC is to maintain the tty driver state as if cooked mode were still in effect. One obvious difference is that VMIN/VTIME are overlaid on VEOL/VEOF in raw mode

Not in Linux; these are different c_cc[] slots.

> , so the two are not directly interchangeable.
> 
> The fact that EXTPROC can be manually unset is by design. Quoting from the original again:
> 
>> stty.diff:
>>     This file contains the changes needed for the stty(1) program
>>     to report on the current status of the TS_EXTPROC bit.  It also
>>     allows the user to turn on/off the TS_EXTPROC bit.  This is useful
>>     because it allows the user to say "stty -extproc", and the
>>     LINEMODE option will be automatically disabled, and saying "stty
>>     extproc" will re-enable the LINEMODE option.

This option is not supported by gnu coreutils.

So it's really back to the question of, does allowing EXTPROC for regular
ttys have _value_?


>>>>>> 6. EXTPROC still does some input processing on the server. For example,
>>>>>>       7-bit mode (ISTRIP), tolower mode (IUCLC) and processing while
>>>>>>       closing; if input processing is being done on the local/client side,
>>>>>>       why the extra work here?
>>>>>
>>>>> That's defensive, on the assumption that something else might break if e.g. the tty expected only 7-bit input but 8-bit characters were sent to it.
>>>>
>>>> Ok, is that because RFC 1116 doesn't specify ISTRIP and IUCLC handling so
>>>> the server can't be sure the client did it? If so, that should be documented
>>>> so that refactors don't remove that handling.
>>
>> Could you get back to me about this, as well?
> 
> The telnet protocol (RFC854) defines a Network Virtual Terminal (NVT) as using 7-bit USASCII in an 8-bit field. As such, it expects the client to be able to generate both upper and lower case itself, so there's no analogue to IUCLC, and there would be no reason to use ISTRIP.
> 
> RFC5198 updates the protocols to use UTF8. So again, it assumes full octets are being transmitted.
> 
> Perhaps we can drop these special cases from the driver.

I don't mind leaving it in, but without comments it looks like a
refactoring error.

Regards,
Peter Hurley

