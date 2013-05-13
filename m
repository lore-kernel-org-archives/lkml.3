Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3EMHrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:47:13 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:19871 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab3EMHrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:47:10 -0400
Date: Mon, 13 May 2013 09:47:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 04/11] hwmon/lm63,lm90: take msecs_to_jiffies_min into
 use
Message-ID: <20130513094700.7d134abc@endymion.delvare>
In-Reply-To: <1368188011-23661-4-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	<1368188011-23661-4-git-send-email-imre.deak@intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Imre,

On Fri, 10 May 2013 15:13:22 +0300, Imre Deak wrote:
> Use msecs_to_jiffies_min instead of open-coding the same.
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/hwmon/lm63.c |    2 +-
>  drivers/hwmon/lm90.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> index f644a2e..db44bcb 100644
> --- a/drivers/hwmon/lm63.c
> +++ b/drivers/hwmon/lm63.c
> @@ -248,7 +248,7 @@ static struct lm63_data *lm63_update_device(struct device *dev)
>  	mutex_lock(&data->update_lock);
>  
>  	next_update = data->last_updated
> -	  + msecs_to_jiffies(data->update_interval) + 1;
> +	  + msecs_to_jiffies_min(data->update_interval);
>  
>  	if (time_after(jiffies, next_update) || !data->valid) {
>  		if (data->config & 0x04) { /* tachometer enabled  */
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 8eeb141..314f9d3 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -471,7 +471,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  	mutex_lock(&data->update_lock);
>  
>  	next_update = data->last_updated
> -	  + msecs_to_jiffies(data->update_interval) + 1;
> +	  + msecs_to_jiffies_min(data->update_interval);
>  	if (time_after(jiffies, next_update) || !data->valid) {
>  		u8 h, l;
>  		u8 alarms;

I don't like this. The + 1 aren't there because msecs_to_jiffies() may
return less than the required time, as you claim. I don't think this is
the case (see the doubts expressed in my reply to patch 1/11.)

These + 1 are there because the chip may need exactly
data->update_interval for the data sampling and the datasheet isn't
completely clear about what would happen if the host polls for results
at exactly the same frequency the chip is sampling.

Most likely it is just paranoia from me and the + 1 can be removed.
Especially when time_after (as opposed to time_after_eq) already adds
some margin - probably exactly what we need here. I have a few chips
here I could test this on, BTW (ADM1032 and LM64.)

And even if this was actually needed, then it is written the wrong way.
We don't need one more jiffy, the SMBus slave doesn't even know what a
jiffy is. We need an arbitrary additional amount of time, expressed in
a standard time unit like ms. So
  msecs_to_jiffies(data->update_interval + 1)
would be the right way to write it.

On top of that, your proposed change will make the resulting binary
larger, the compilation longer, the future code reviews harder, and
backporting these drivers harder. Each of these points only by a very
small fraction, of course, but for a benefit which is even smaller
IMHO, if it even exists (which I doubt.)

So I'm not going to apply this patch, sorry.

-- 
Jean Delvare
