Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3EPVxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:53:07 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49743 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752097Ab3EPVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:53:05 -0400
Message-ID: <5195553C.90608@hurleysoftware.com>
Date: Thu, 16 May 2013 17:53:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: BUG: tty: memory corruption through tty_release/tty_ldisc_release
References: <519480A1.6030909@ahsoftware.de> <5194E380.1030109@hurleysoftware.com> <5194E64A.3040003@ahsoftware.de>
In-Reply-To: <5194E64A.3040003@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 09:59 AM, Alexander Holler wrote:
> Am 16.05.2013 15:47, schrieb Peter Hurley:
>> On 05/16/2013 02:45 AM, Alexander Holler wrote:
>>> Hello,
>>>
>>> after some pain because the "big step" (ecbbfd4) happened while the
>>> support for my AMD CPU was broken and thus git bisect hit a series of
>>> kernels which didn't boot, I've finally found the cause for a memory
>>> corruption: tty_ldisc_release().
>>>
>>> What happens is the following:
>>>
>>> tty_port is self-destructing, that means it destroys itself in
>>> tty_port.c:tty_port_destructor() when the last reference is gone. E.g.
>>> in case of rfcomm this happens with the call to tty->ops->close() in
>>> tty_io.c:tty_release().
>>>
>>> The problem here is that tty_io.c:tty_release() calls
>>> tty_ldisc.c:tty_ldisc_release() which uses the tty_port to flush the
>>> ldisc work queues.
>>>
>>> In the best case this hits a BUG() in cancel_work_sync() but often it
>>> just causes a memory corruption without a BUG() got hit before.
>>
>> Hi Alexander,
>>
>> Actually, the problem is that tty->ops->close() shouldn't be
>> the last kref on the port.
>>
>> It doesn't look to me like device removal is being handled
>> properly.
>>
>
> Maybe, but if so, that should be documented (and ideally prevented).

The tty_port documentation is trapped in the place as _all_ the
bluetooth documentation :)

And the tty layer can't really _prevent_ the tty driver from mishandling
the port kref.

> Especially since it seemed to have been worked before tty_ports got introduced.

Well, at the time tty_port was introduced to RFCOMM, there was nothing
to tear-down in tty_port. Now that tty_port owns the flip buffers and
must do proper tear-down, the problem has surfaced.

> But I can't add much more to this discussion, as I'm rather a novice in regard to the tty subsystem. I even don't know much about the task sharing between tty, tty_port and tty_ldisc, except the stuff I found out because I got hit by that bug and therefor have read some of the sources.

Ok. Could you paste the BUG() and steps to reproduce?
I have a plan to fix it but I'd like to review what you have
first.

Regards,
Peter Hurley

