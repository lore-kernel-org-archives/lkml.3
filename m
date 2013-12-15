Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3LOODp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 09:03:45 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45394 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754154Ab3LOODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 09:03:43 -0500
Message-ID: <52ADB6B7.5010503@hurleysoftware.com>
Date: Sun, 15 Dec 2013 09:03:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>, marcel@holtmann.org
CC: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
References: <1377620926-23370-1-git-send-email-gianluca@sottospazio.it> <20130919162413.GG4006@joana> <52AA1854.500@ahsoftware.de> <52AA1E62.1030109@hurleysoftware.com> <52AA483E.4080706@ahsoftware.de> <20131215112413.GA8980@sottospazio.it>
In-Reply-To: <20131215112413.GA8980@sottospazio.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2013 06:24 AM, Gianluca Anzolin wrote:
> On Fri, Dec 13, 2013 at 12:35:26AM +0100, Alexander Holler wrote:
>> Am 12.12.2013 21:36, schrieb Peter Hurley:
>>
>>>> What currently happens is that when one kills rfcomm (and any other
>>>> terminal which might use that tty), the entry in /dev doesn't
>>>> disappear. That means the same call to refcomm with the same device
>>>> (e.g. [/dev/]rfcomm1 doesn't work.
>>>
>>> Thanks for the report, Alexander.
>>>
>>> Point 4 above details a different situation; something else is
>>> happening.
>>>
>>> Would you please detail the necessary steps to reproduce this regression?
>>> (How do you 'kill' rfcomm? etc.  Shell command lines would be best.)
>>
>> Just call
>>
>> rfcomm connect rfcomm9 01:23:45:67:89:ab
>>
>> wait until the connection happened  (a message will appear) and then
>> press ctrl-c. This still terminates the bluetooth connection, but the
>> device in /dev is now left.
>
> Yes I'm able to reproduce the regression which is indeed caused by that
> commit.
>
> However I'm puzzled. Surely there is a fifth case I didn't cover because
> when rfcomm_dev_state_change() is called, the tty_port is there but the tty is
> not, and therefore I cannot get a reference to it and send the HUP.

There is a fifth case, but it's crazy.

The tty has been properly shutdown and destroyed because the tty file handle
was closed, not hungup. The rfcomm device reference was properly put
when the tty was released.

But when the remote hangs up (and sends disc), then rfcomm_dev_state_change()
is called -- to kill the port reference (thus the rfcomm device) that was
instantiated locally! Ridiculous. Doubly ridiculous because it's the local
port shutdown that closes the dlc locally that sends the disconnect (and sets
the local dlc state) that triggers the received rfcomm_dev_state_change()!

If this behavior is desirable (or necessary because it's been exposed to
userspace), then why was the design ever reference-counted to begin with?

Regards,
Peter Hurley
