Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaK0JFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:05:52 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37159 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaK0JFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:05:46 -0500
Date: Thu, 27 Nov 2014 01:05:42 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on
 Acer C720
Message-ID: <20141127090542.GA8346@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, linux-kernel@vger.kernel.org
References: <20141124085059.GA15770@hudson.localdomain>
 <20141125100703.GA9287@hudson.localdomain>
 <af603da34acc4caca630ca58eda7eb1e@BN1PR06MB070.namprd06.prod.outlook.com>
 <20141126200238.GB27014@hudson.localdomain>
 <000d01d00a05$7ffe4970$7ffadc50$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000d01d00a05$7ffe4970$7ffadc50$@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Thu, Nov 27, 2014 at 01:45:49PM +0800, Dudley Du wrote:
> Jeremiah,
> 
> I didn't make the special patch for the linux-next before, so I don't know why
> this patch is there and have issue.
> Based on current code in the linux-next, I made below patch to fix this issue.
> Could you please try again with attached patch fix.
> 
> Thanks,
> Dudley
> 
> > -----Original Message-----
> > From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> > Sent: 2014?11?27? 4:03
> > To: Dudley Du
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on Acer
> > C720
> > 
> > Dudley,
> > 
> > On Wed, Nov 26, 2014 at 06:16:00AM +0000, Dudley Du wrote:
> > > More info: I did all testings based on kernel 3.14.0 on Acer C70.
> > >
> > 
> > I am testing with linux-next 3.18-rc6 on an Acer C720.
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
> > 
> > > Thanks,
> > > Dudley
> > >
> > []
> > 
> > --
> > - Jeremiah Mahler
> 
> From bb717b1c1525ef6b889f0ef735d920eed9e76e72 Mon Sep 17 00:00:00 2001
> From: Dudley Du <dudley.dulixin@gmail.com>
> Date: Thu, 27 Nov 2014 13:35:09 +0800
> Subject: [PATCH] input: cyapa: fix irq error issue in cyapa_resume
> To: dmitry.torokhov@gmail.com,
>     jmmahler@gmail.com
> Cc: bleung@google.com,
>     linux-input@vger.kernel.org
> 
> This patch is aimed to fix the irq error happened on cyapa_resume when
> doing suspend/resume testing.
>From my perspective this doesn't really describe the problem.  It makes
no mention of the touchpad becoming inoperative or what machine it occurred
on.  Perhaps something like the following.

  This patch fixes a problem found on Acer C720 computers which would
  cause the touchpad to become inoperative after a resume.

> The root cause of this issue is that the cyapa->irq has been removed but
> still used in the driver.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>

It is a nice courtesy to give credit to those who help you with your code.

Reported-by: Jeremiah Mahler <jmmahler@gmail.com>

> ---
>  drivers/input/mouse/cyapa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index c84a9eb..caaba7b 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -938,7 +938,7 @@ static int __maybe_unused cyapa_suspend(struct device *dev)
>  			 power_mode, error);
>  
>  	if (device_may_wakeup(dev))
> -		cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
> +		cyapa->irq_wake = (enable_irq_wake(cyapa->client->irq) == 0);
>  
Looks good.  I missed the _may_wakeup parts in my patch.

Since the client object is available in this context is there a reason
why cyapa->client->irq is better than client->irq?

>  	mutex_unlock(&input->mutex);
>  
> @@ -956,7 +956,7 @@ static int __maybe_unused cyapa_resume(struct device *dev)
>  	mutex_lock(&input->mutex);
>  
>  	if (device_may_wakeup(dev) && cyapa->irq_wake)
> -		disable_irq_wake(cyapa->irq);
> +		disable_irq_wake(cyapa->client->irq);
>  
Looks good, same as other.

>  	power_mode = input->users ? PWR_MODE_FULL_ACTIVE : PWR_MODE_OFF;
>  	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> @@ -964,7 +964,7 @@ static int __maybe_unused cyapa_resume(struct device *dev)
>  		dev_warn(dev, "resume: set power mode to %d failed: %d\n",
>  			 power_mode, error);
>  
> -	enable_irq(cyapa->irq);
> +	enable_irq(cyapa->client->irq);
>  
This was the main problem.  My patch used client->irq, but
cyapa->client->irq works too.

>  	mutex_unlock(&input->mutex);
>  
> -- 
> 1.9.1

I tested the patch and it works.

Tested-by: Jeremiah Mahler <jmmahler@gmail.com>

Thanks,
-- 
- Jeremiah Mahler
