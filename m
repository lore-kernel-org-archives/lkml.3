Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaK0XYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:24:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:59254 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaK0XYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:24:54 -0500
Date: Fri, 28 Nov 2014 00:24:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xunlei Pang <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 4/4] rtc/imxdi: Update driver to address time
 issues
In-Reply-To: <1417089760-26848-5-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1411280019590.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org> <1417089760-26848-5-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Xunlei Pang wrote:
> @@ -213,17 +213,16 @@ static int dryice_rtc_set_mmss(struct device *dev, time64_t secs)
>  {
>  	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
>  	int rc;
> +	u32 hwtime;
> +
> +	rc = rtc_time64_to_hw32(secs, &hwtime);
> +	if (rc < 0)
> +		return rc;
>  
>  	/* zero the fractional part first */
>  	rc = di_write_wait(imxdi, 0, DTCLR);
>  	if (rc == 0)
> -		/*
> -		 * y2106 issue:
> -		 *   On 32bit systems the time64_t secs value gets cast to
> -		 *   a 32bit long, and thus we can only write a maximum value
> -		 *   of y2016
> -		 */
> -		rc = di_write_wait(imxdi, secs, DTCMR);
> +		rc = di_write_wait(imxdi, hwtime, DTCMR);

So you repeat the same thing what I complained about last time. First
you add crap to a driver then you remove it again instead of analyzing
the necessary conversions in the first place, provide the
infrastructure and then do a per driver conversion. It's not that
hard, really and I'm getting tired of your approach.

Step 1:	     Provide rtc.set_mmss64

Step 2:	     Implement the epoch helper functions for 32bit hardware

Step 3:	     Convert drivers

Step 4:	     Remove obsolete interfaces

I wont explain that once more, really.

Thanks,

	tglx

