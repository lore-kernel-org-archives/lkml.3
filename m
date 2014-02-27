Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaB0UpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:45:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:62535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaB0Uo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:44:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 02/16] scsi: atari_scsi: fix sleep_on race
Date: Thu, 27 Feb 2014 21:44:50 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de> <1393412516-3762435-3-git-send-email-arnd@arndb.de> <530EF01D.6000208@gmail.com>
In-Reply-To: <530EF01D.6000208@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402272144.50946.arnd@arndb.de>
X-Provags-ID: V02:K0:SM+pEkmaTqQh6i+uPsUdlLMLJ4Qmr7S3e+WOFRmaigZ
 8xDkgVSduAvaHiMDktnGjzpWNNSyb++Ae9RVy86R9CND+N6Emp
 fZ54hV3VZWGExsmXiDqVhP+XMMJSiBzAdMoikjkccuYTSz9+D3
 gA/cH5m7C1J1Epw4cgdm5yFbejfL3oCDBccqfU1zt+BtIUOmkb
 CIGkxWVTkO369NxXUgij3tShBvq9oZcOw8aBFiEN70lLBBS5cu
 elMUaF56I5jN5DmNq9OT1L6IxHe9vO6Xsa2Lzgt9Hhv328dv2C
 0PtMBbeyozaQ/1d37ybzkjwIloxqDv9SmTVCpBq3rKaBtkX8Ek
 BbYf89RwyDlCm0SGSxPk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014, Michael Schmitz wrote:
> Arnd Bergmann wrote:
> >   
> Nack - the completion condition in the first hunk has its logic 
> reversed. Try this instead (while() loops while condition true, do {} 
> until () loops while condition false, no?)

Sorry about messing it up again. I though I had fixed it up the
way you commented when you said it worked.
 
> I'm 99% confident I had tested your current version of the patch before 
> and found it still attempts to schedule while in interrupt. I can retest 
> if you prefer, but that'll have to wait a few days.

I definitely trust you to have the right version, since you did the
testing.

> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index a3e6c8a..cc1b013 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -90,6 +90,7 @@
>  #include <linux/init.h>
>  #include <linux/nvram.h>
>  #include <linux/bitops.h>
> +#include <linux/wait.h>
>  
>  #include <asm/setup.h>
>  #include <asm/atarihw.h>
> @@ -549,8 +550,10 @@ static void falcon_get_lock(void)
>  
>         local_irq_save(flags);
>  
> -       while (!in_irq() && falcon_got_lock && stdma_others_waiting())
> -               sleep_on(&falcon_fairness_wait);
> +       wait_event_cmd(falcon_fairness_wait,
> +               in_irq() || !falcon_got_lock || !stdma_others_waiting(),
> +               local_irq_restore(flags),
> +               local_irq_save(flags));
>  
>         while (!falcon_got_lock) {
>                 if (in_irq())

Yes, by inspection your version looks correct and mine looks wrong.
I had figured this out before, just sent the wrong version.

> @@ -562,7 +565,10 @@ static void falcon_get_lock(void)
>                         falcon_trying_lock = 0;
>                         wake_up(&falcon_try_wait);
>                 } else {
> -                       sleep_on(&falcon_try_wait);
> +                       wait_event_cmd(falcon_try_wait,
> +                               falcon_got_lock && !falcon_trying_lock,
> +                               local_irq_restore(flags),
> +                               local_irq_save(flags));
>                 }

I did correct this part compared to my first patch, but forgot
to change the other hunk.

Can you send your version of the patch to Geert for inclusion?
That way I don't have the danger of missing another negation.
This code is clearly too weird to rely on inspection alone and
we know that your version was working when you last tested it.

	Arnd
