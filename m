Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3BELkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:40:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51973 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3BELkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:40:11 -0500
Message-ID: <5110EF95.4060402@suse.cz>
Date: Tue, 05 Feb 2013 12:40:05 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] TTY: switch tty_schedule_flip
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>  <1357224789-2853-8-git-send-email-jslaby@suse.cz>  <1359722247.3381.16.camel@thor.lan> <510BD9E9.9000400@suse.cz> <1359751171.22968.6.camel@thor.lan>
In-Reply-To: <1359751171.22968.6.camel@thor.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 09:39 PM, Peter Hurley wrote:
> On Fri, 2013-02-01 at 16:06 +0100, Jiri Slaby wrote:
>> On 02/01/2013 01:37 PM, Peter Hurley wrote:
>>> On Thu, 2013-01-03 at 15:53 +0100, Jiri Slaby wrote:
>>>> Now, we start converting tty buffer functions to actually use
>>>> tty_port. This will allow us to get rid of the need of tty in many
>>>> call sites. Only tty_port will needed and hence no more
>>>> tty_port_tty_get in those paths.
>>>>
>>>> This is the last one: tty_schedule_flip
>>>
>>> [snip]
>>>
>>>> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
>>>> index 5aace4d..a9af1b9a 100644
>>>> --- a/drivers/tty/vt/keyboard.c
>>>> +++ b/drivers/tty/vt/keyboard.c
>>>> @@ -307,26 +307,17 @@ int kbd_rate(struct kbd_repeat *rep)
>>>>   */
>>>>  static void put_queue(struct vc_data *vc, int ch)
>>>>  {
>>>> -	struct tty_struct *tty = vc->port.tty;
>>>> -
>>>>  	tty_insert_flip_char(&vc->port, ch, 0);
>>>> -	if (tty) {
>>>> -		tty_schedule_flip(tty);
>>>> -	}
>>>> +	tty_schedule_flip(&vc->port);
>>>>  }
>>>>  
>>>>  static void puts_queue(struct vc_data *vc, char *cp)
>>>>  {
>>>> -	struct tty_struct *tty = vc->port.tty;
>>>> -
>>>> -	if (!tty)
>>>> -		return;
>>>> -
>>>>  	while (*cp) {
>>>>  		tty_insert_flip_char(&vc->port, *cp, 0);
>>>>  		cp++;
>>>>  	}
>>>> -	tty_schedule_flip(tty);
>>>> +	tty_schedule_flip(&vc->port);
>>>>  }
>>>
>>> Umm. So even though the vt driver knows the tty has been shutdown,
>>> keystrokes will still be buffered? And then fed to whichever tty happens
>>> to next get installed on the same port?
>>
>> Unless I completely missed something, they should be flushed. If that's
>> not the case, that's a bug. I will check next week.
> 
> Ok.
> 
> I'm fairly sure this is happening. Try repeatedly tapping arrow-down
> while booting (I suggest a VM) and you won't be able to login at tty1
> (ie, text mode). Repeatable 1 time in 5 or so.

I can reproduce... with 3.0! Are you sure this is new and introduced by
the tty buffers switch?

> FWIW, I don't agree that the best way is to flush the flip buffers. Why
> buffer and then schedule the cpu to do work which we already know it
> can't do and which we're going to discard anyway?

Because the drivers needn't care whether there is any tty behind and
listening. This simplifies and speeds up the paths _a lot_. No spin
locks, no ttys around, no two code paths etc.

> In any event, since -next is already carrying these patches, and
> by-design, these patches _expect_ the tty to be NULL, are you going to
> remove the warning in flush_to_ldisc() or shall I?

I think I don't understand you here, could you elaborate?

thanks,
-- 
js
suse labs
