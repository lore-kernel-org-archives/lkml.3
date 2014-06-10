Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaFJBUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:20:24 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43628 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbaFJBUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:20:23 -0400
Message-ID: <53965D53.3010107@hurleysoftware.com>
Date: Mon, 09 Jun 2014 21:20:19 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>
Subject: Re: [PATCH 1/2] serial: core: Don't drop DTR if system console
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>	<1401891371-4946-1-git-send-email-peter@hurleysoftware.com> <20140609140823.6013838d@alan.etchedpixels.co.uk>
In-Reply-To: <20140609140823.6013838d@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 09:08 AM, One Thousand Gnomes wrote:
> On Wed,  4 Jun 2014 10:16:10 -0400
> Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> If a tty is opened on a serial console, don't drop DTR on
>> last tty close, on tty hangup, or when resetting port hardware
>> via TIOCSSERIAL and TIOCSERCONFIG ioctls.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>
> NAK
>
> This introduces a security flaw.
>
> If you have a system with a remote console you dial into then with this
> patch applied a modem drop eg from a bad line will no longer drop any
> live session and ensure a login is required as it was before.

There's no security flaw here.

The situation you're referring to above is managed by the CLOCAL termios
setting (which by default does _not_ hangup the tty on carrier loss).

This patch only affects the line state if the last tty reference is closed
or the tty is hung up by software (like on controlling process exit).
In this case, any login session is already dying, and it would not be possible
to hijack a live session. A successful re-login is still required.

> That's a pretty bad regression case.
>
> If you are running a serial console and want to leave DTR high either
> wire the cable that way or don't set HUPCL in the first place. The
> technology for fixing this problem already exists!

Notwithstanding what I wrote above, this patch does change behavior
with remote consoles, which may be unacceptable.

For example, if the remote user logs out, the current behavior hangs up
the modem (if HUPCL), whereas the patch behavior just presents a new
login prompt.

So yeah, I agree; this patch should be dropped.

Regards,
Peter Hurley
