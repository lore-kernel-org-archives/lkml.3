Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3BAPGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:06:07 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:33559 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3BAPGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:06:05 -0500
Message-ID: <510BD9E9.9000400@suse.cz>
Date: Fri, 01 Feb 2013 16:06:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] TTY: switch tty_schedule_flip
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>  <1357224789-2853-8-git-send-email-jslaby@suse.cz> <1359722247.3381.16.camel@thor.lan>
In-Reply-To: <1359722247.3381.16.camel@thor.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 01:37 PM, Peter Hurley wrote:
> On Thu, 2013-01-03 at 15:53 +0100, Jiri Slaby wrote:
>> Now, we start converting tty buffer functions to actually use
>> tty_port. This will allow us to get rid of the need of tty in many
>> call sites. Only tty_port will needed and hence no more
>> tty_port_tty_get in those paths.
>>
>> This is the last one: tty_schedule_flip
> 
> [snip]
> 
>> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
>> index 5aace4d..a9af1b9a 100644
>> --- a/drivers/tty/vt/keyboard.c
>> +++ b/drivers/tty/vt/keyboard.c
>> @@ -307,26 +307,17 @@ int kbd_rate(struct kbd_repeat *rep)
>>   */
>>  static void put_queue(struct vc_data *vc, int ch)
>>  {
>> -	struct tty_struct *tty = vc->port.tty;
>> -
>>  	tty_insert_flip_char(&vc->port, ch, 0);
>> -	if (tty) {
>> -		tty_schedule_flip(tty);
>> -	}
>> +	tty_schedule_flip(&vc->port);
>>  }
>>  
>>  static void puts_queue(struct vc_data *vc, char *cp)
>>  {
>> -	struct tty_struct *tty = vc->port.tty;
>> -
>> -	if (!tty)
>> -		return;
>> -
>>  	while (*cp) {
>>  		tty_insert_flip_char(&vc->port, *cp, 0);
>>  		cp++;
>>  	}
>> -	tty_schedule_flip(tty);
>> +	tty_schedule_flip(&vc->port);
>>  }
> 
> Umm. So even though the vt driver knows the tty has been shutdown,
> keystrokes will still be buffered? And then fed to whichever tty happens
> to next get installed on the same port?

Unless I completely missed something, they should be flushed. If that's
not the case, that's a bug. I will check next week.

thanks,
-- 
js
suse labs
