Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaG2FCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:02:32 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:56474 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750723AbaG2FCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:02:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3871:3872:4321:5007:7514:7652:7903:7904:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12740:13019:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hole53_1527252191e0f
X-Filterd-Recvd-Size: 2909
Message-ID: <1406610143.5285.14.camel@joe-AO725>
Subject: Re: [PATCH] Staging: android: timed_gpio.c: remove else statement
 after return
From: Joe Perches <joe@perches.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Mon, 28 Jul 2014 22:02:23 -0700
In-Reply-To: <1406589075-7483-1-git-send-email-mopsfelder@gmail.com>
References: <1406589075-7483-1-git-send-email-mopsfelder@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 20:11 -0300, Murilo Opsfelder Araujo wrote:
> This patch makes checkpatch.pl script happy by fixing the following
> warning:
> 
> WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> ---
>  drivers/staging/android/timed_gpio.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
> index 180c209..05cb578 100644
> --- a/drivers/staging/android/timed_gpio.c
> +++ b/drivers/staging/android/timed_gpio.c
> @@ -53,8 +53,9 @@ static int gpio_get_time(struct timed_output_dev *dev)
>  		struct timeval t = ktime_to_timeval(r);
>  
>  		return t.tv_sec * 1000 + t.tv_usec / 1000;
> -	} else
> -		return 0;
> +	}
> +
> +	return 0;
>  }

It may be better to reverse the logic here.
Something like:

 drivers/staging/android/timed_gpio.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index 180c209..8fa4758 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -45,16 +45,17 @@ static enum hrtimer_restart gpio_timer_func(struct hrtimer *timer)
 
 static int gpio_get_time(struct timed_output_dev *dev)
 {
-	struct timed_gpio_data	*data =
-		container_of(dev, struct timed_gpio_data, dev);
+	struct timed_gpio_data *data;
+	struct timeval t;
 
-	if (hrtimer_active(&data->timer)) {
-		ktime_t r = hrtimer_get_remaining(&data->timer);
-		struct timeval t = ktime_to_timeval(r);
+	data = container_of(dev, struct timed_gpio_data, dev);
 
-		return t.tv_sec * 1000 + t.tv_usec / 1000;
-	} else
+	if (!hrtimer_active(&data->timer))
 		return 0;
+
+	t = ktime_to_timeval(hrtimer_get_remaining(&data->timer));
+
+	return t.tv_sec * 1000 + t.tv_usec / 1000;
 }
 
 static void gpio_enable(struct timed_output_dev *dev, int value)



