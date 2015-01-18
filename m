Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbbARWoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 17:44:10 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:46837 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbARWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 17:44:09 -0500
X-Greylist: delayed 2085 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2015 17:44:09 EST
Message-ID: <54BC3730.706@symas.com>
Date: Sun, 18 Jan 2015 22:44:00 +0000
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0 SeaMonkey/2.34a1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC2F0A.8040404@symas.com> <54BC3236.1030004@hurleysoftware.com>
In-Reply-To: <54BC3236.1030004@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> Hi Howard,
>
> On 01/18/2015 05:09 PM, Howard Chu wrote:
>> Peter Hurley wrote:
>>> Commit 26df6d13406d1 ("tty: Add EXTPROC support for LINEMODE") added
>>> the undocumented EXTPROC input processing mode, which ignores the ICANON
>>> setting and forces pty slave input to be processed in non-canonical
>>> mode.
>>>
>>> Although intended to provide a transparent mechanism for local line
>>> edit with telnetd (and other remote shell protocols), the transparency
>>> is limited.
>>>
>>> Userspace usage is abandoned; telnetd does not even compile with
>>> LINEMODE support. readline/bash and sshd never supported this.
>>
>> I object to this. Code for all of the above exists and works. I use this code daily.
>>
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=585527
>> http://lists.gnu.org/archive/html/bug-readline/2011-01/msg00004.html
>> https://github.com/hyc/OpenSSH-LINEMODE
>>
>> The lack of LINEMODE support in upstream sshd can only be considered a security hole.
>>
>> http://www.metzdowd.com/pipermail/cryptography/2015-January/024288.html
>
> These are all bug reports about userspace _not_ supporting this extension.

Bug reports *with working patches* attached. And the fact remains that 
not supporting this feature *is* a security liability.

> Where is a working userspace consumer of this interface?

The OpenSSH fork on github is a full working client and server using 
this interface.

> I seriously doubt this works reliably.
> What happens when the pty slave reader is in canonical mode and gets unterminated
> input because only a portion of the input is available yet? The way this is
> coded does _not_ require line termination before returning data to userspace.

Userspace already has to deal with incomplete lines if the input line is 
longer than the input buffer.

> Also, ioctl(FIONREAD) doesn't match what read() returns, nor that poll()/select()
> indicated input was available.

Hm, I think you're mistaken about poll/select.

     if ((!ldata->icanon && (ldata->read_cnt >= tty->minimum_to_wake)) ||
         L_EXTPROC(tty)) {
         kill_fasync(&tty->fasync, SIGIO, POLL_IN);
         if (waitqueue_active(&tty->read_wait))
             wake_up_interruptible(&tty->read_wait);
     }


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
