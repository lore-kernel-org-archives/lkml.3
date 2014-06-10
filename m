Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaFJMau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:30:50 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46031 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888AbaFJMas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:30:48 -0400
Message-ID: <5396FA75.8020400@hurleysoftware.com>
Date: Tue, 10 Jun 2014 08:30:45 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>
Subject: Re: [PATCH 1/2] serial: core: Don't drop DTR if system console
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>	<1401891371-4946-1-git-send-email-peter@hurleysoftware.com>	<20140609140823.6013838d@alan.etchedpixels.co.uk>	<53965D53.3010107@hurleysoftware.com> <20140610120136.2c2cb881@alan.etchedpixels.co.uk>
In-Reply-To: <20140610120136.2c2cb881@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 07:01 AM, One Thousand Gnomes wrote:
>> This patch only affects the line state if the last tty reference is closed
>> or the tty is hung up by software (like on controlling process exit).
>> In this case, any login session is already dying, and it would not be possible
>> to hijack a live session. A successful re-login is still required.
>
> It breaks the other direction - yes sorry.
>
>> Notwithstanding what I wrote above, this patch does change behavior
>> with remote consoles, which may be unacceptable.
>
>> For example, if the remote user logs out, the current behavior hangs up
>> the modem (if HUPCL), whereas the patch behavior just presents a new
>> login prompt.
>
> which means the modem will probably no longer answer calls.

I would expect the vast majority of modems to be configured to hang-up
after carrier loss (when the remote user hangs up).

I think the more significant impact is that killing the login process
(by the sysadmin) wouldn't disconnect a malicious user (but would still
force the re-login). I see this as more nuisance value than any
realistic DoS.

>> So yeah, I agree; this patch should be dropped.
>
> Possibly we should also fix this the other way in tty_port_shutdown,
> which does wrongly skip dtr/rts handling of consoles.
>
> As far as I can see providing HUPCL is clear the desired console
> behaviour for most situations with a remote console link is obtained.

I agree that serial core and tty port should handle the console
identically, so if the serial core defaults are the expected behavior,
then, yes, tty_port_shutdown() should not skip dropping dtr/rts.

However, a console on USB tty is much more likely to be local, rather
than remote, so changing dtr/rts handling could impact these setups.

Since the termios c_cflag is inherited from the console, what about adding
new flow control flag decodes to uart_set_options(); eg.,
  'r'     =  CRTSCTS |  HUPCL  /* existing */
  'R'     =  CRTSCTS | !HUPCL
  default = !CRTSCTS |  HUPCL
  'd'     = !CRTSCTS | !HUPCL
?

Regards,
Peter Hurley

