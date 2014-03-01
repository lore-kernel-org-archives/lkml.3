Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaCAAYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:24:33 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47756 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaCAAYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:24:32 -0500
Message-ID: <531128CA.5040700@gmail.com>
Date: Sat, 01 Mar 2014 13:24:42 +1300
From: Michael Schmitz <schmitzmic@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/16] scsi: atari_scsi: fix sleep_on race
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de> <1393412516-3762435-3-git-send-email-arnd@arndb.de> <530EF01D.6000208@gmail.com> <201402272144.50946.arnd@arndb.de>
In-Reply-To: <201402272144.50946.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,
> On Thursday 27 February 2014, Michael Schmitz wrote:
>   
>> Arnd Bergmann wrote:
>>     
>>>   
>>>       
>> Nack - the completion condition in the first hunk has its logic 
>> reversed. Try this instead (while() loops while condition true, do {} 
>> until () loops while condition false, no?)
>>     
>
> Sorry about messing it up again. I though I had fixed it up the
> way you commented when you said it worked.
>  
>   
>> I'm 99% confident I had tested your current version of the patch before 
>> and found it still attempts to schedule while in interrupt. I can retest 
>> if you prefer, but that'll have to wait a few days.
>>     
>
> I definitely trust you to have the right version, since you did the
> testing.
>   

I'm glad I double checked, since there's one other error left in my 
correction to your patch below:

The in_irq() condition is not sufficient, we need in_interrupt() there. 
This has somehow slipped into a related patch sent to linux-scsi, so 
I'll have to refactor the lot. Bugger.

I'll resend the correct version via Geert.

>   
>> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
>> index a3e6c8a..cc1b013 100644
>> --- a/drivers/scsi/atari_scsi.c
>> +++ b/drivers/scsi/atari_scsi.c
>> @@ -90,6 +90,7 @@
>>  #include <linux/init.h>
>>  #include <linux/nvram.h>
>>  #include <linux/bitops.h>
>> +#include <linux/wait.h>
>>  
>>  #include <asm/setup.h>
>>  #include <asm/atarihw.h>
>> @@ -549,8 +550,10 @@ static void falcon_get_lock(void)
>>  
>>         local_irq_save(flags);
>>  
>> -       while (!in_irq() && falcon_got_lock && stdma_others_waiting())
>> -               sleep_on(&falcon_fairness_wait);
>> +       wait_event_cmd(falcon_fairness_wait,
>> +               in_irq() || !falcon_got_lock || !stdma_others_waiting(),
>> +               local_irq_restore(flags),
>> +               local_irq_save(flags));
>>  
>>         while (!falcon_got_lock) {
>>                 if (in_irq())
>>     
>
> Yes, by inspection your version looks correct and mine looks wrong.
> I had figured this out before, just sent the wrong version.
>   

These things happen if you bother fixing other people's weird code :-)
And as I mentioned above, I missed another detail myself

>   
>> @@ -562,7 +565,10 @@ static void falcon_get_lock(void)
>>                         falcon_trying_lock = 0;
>>                         wake_up(&falcon_try_wait);
>>                 } else {
>> -                       sleep_on(&falcon_try_wait);
>> +                       wait_event_cmd(falcon_try_wait,
>> +                               falcon_got_lock && !falcon_trying_lock,
>> +                               local_irq_restore(flags),
>> +                               local_irq_save(flags));
>>                 }
>>     
>
> I did correct this part compared to my first patch, but forgot
> to change the other hunk.
>
> Can you send your version of the patch to Geert for inclusion?
> That way I don't have the danger of missing another negation.
> This code is clearly too weird to rely on inspection alone and
> we know that your version was working when you last tested it.
>   

Will do - I'll CC: you in so you can ACK the patch if Geert needs 
convincing.

Cheers,

    Michael

