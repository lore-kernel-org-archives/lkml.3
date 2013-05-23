Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3EWRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:54:18 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:52245 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab3EWRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <519DB8E6.4020709@signal11.us>
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
	<1369188080-8904-1-git-send-email-alan@signal11.us>
	<519C278F.5030809@signal11.us>
	<CAO+c-UV1bZZEE=9=7VVn3f1eLWzCpYCK9eZnnvzNwcPOKKtKLA@mail.gmail.com>
	<519DB8E6.4020709@signal11.us>
Date: Thu, 23 May 2013 19:54:12 +0200
X-Google-Sender-Auth: ZW3SQZGUqf5WnISU-swdDWYzyJ8
Message-ID: <CAO+c-UVMoctgG2qM2EzOVJwsEY_2TT79J-AuzX-xrPkSUHrQtw@mail.gmail.com>
Subject: Re: [PATCH beta 1] 0/3] Fix race conditions in mrf24j40 interrupts
From: David Hauweele <david@hauweele.net>
To: Alan Ott <alan@signal11.us>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/23 Alan Ott <alan@signal11.us>:
> On 5/22/13 4:32 PM, David Hauweele wrote:
>>
>> I cannot use level-triggered interrupts with GPIO on the RPi, so I
>> cannot test this specific patch.
>
>
> Is there another interrupt line you can tie into which does support
> level-trigger interrupts (INT0 or something)?

According to the datasheet it should be possible but the bcm2708 port
does not support it. I've been told that we shouldn't use level-triggered
interrupts in the first place.

>
>
>> However I agree with the idea of level-triggered interrupts, that
>> would fix all major problems related to missed interrupts.
>>
>> Beside this I'm running a ping -f since more than two hours now and it
>> seems to work well.
>>
>
> So that surprises me. I thought level-trigger interrupts were the thing that
> would fix this problem, and if you're not running with that patch, you just
> have the INIT_COMPLETION() fix (which you said didn't fix your issue) and
> the threaded interrupts patch, which I was fairly sure I had determined
> wasn't fixing any actual race-condition-related problems.

I should have been more clear about this. I've tested [PATCH 1/3]
which fixes the race condition with tx_complete. That is the
INIT_COMPLETION() fix. But it is still possible to miss an interrupt,
perhaps it just took longer this time. I ran the test again today and
it failed after 30 minutes.

I did not test [PATCH 2/3], that is the threaded IRQ. Instead I
removed interrupt enable/disable from the IRQ handler and the
workqueue. Without this the driver would fail within seconds of a ping
-f. Have you observed this too ? Perhaps this problem is specific to
the bcm2708 port.

David

>
> I'm glad, but surprised that you're no longer seeing issues.
>
> Alan.
>
>
>>
>> 2013/5/22 Alan Ott <alan@signal11.us>:
>>>
>>> On 05/21/2013 10:01 PM, Alan Ott wrote:
>>>>
>>>> David Hauweele noticed that the mrf24j40 would hang arbitrarily after
>>>> some
>>>> period of heavy traffic.  Two race conditions were discovered, and the
>>>> driver was changed to use threaded interrupts, since the enable/disable
>>>> of
>>>> interrupts in the driver has recently been a lighning rod whenever
>>>> issues
>>>> arise related to interrupts (costing engineering time), and since
>>>> threaded
>>>> interrupts are the right way to do it.
>>>>
>>>> Alan Ott (3):
>>>>    mrf24j40: Move INIT_COMPLETION() to before packet transmission
>>>>    mrf24j40: Use threaded IRQ handler
>>>>    mrf24j40: Use level-triggered interrupts
>>>>
>>>>   drivers/net/ieee802154/mrf24j40.c | 31 +++++++++----------------------
>>>>   1 file changed, 9 insertions(+), 22 deletions(-)
>>>
>>>
>>> I forgot to add, I ran ping -f both ways all afternoon (6.5 hours), and
>>> it seems solid.
>>>
>
