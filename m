Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbaAHUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:04:05 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:51055 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753591AbaAHUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:04:03 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 15:04:03 EST
Date: Wed, 8 Jan 2014 21:03:46 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Doug Anderson <dianders@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: s3c2410_wdt: Handle rounding a little better for timeout
Message-ID: <20140108200346.GA30951@spo001.leaseweb.com>
References: <1385490637-10306-1-git-send-email-dianders@chromium.org> <1385513839-17181-1-git-send-email-dianders@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385513839-17181-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

> The existing watchdog timeout worked OK but didn't deal with
> rounding in an ideal way when dividing out all of its clocks.
> 
> Specifically if you had a timeout of 32 seconds and an input clock of
> 66666666, you'd end up setting a timeout of 31.9998 seconds and
> reporting a timeout of 31 seconds.
> 
> Specifically DBG printouts showed:
>   s3c2410wdt_set_heartbeat: count=16666656, timeout=32, freq=520833
>   s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666656 (0000ff4f)
> and the final timeout reported to the user was:
>   ((count / divisor) * divisor) / freq
>   (0xff4f * 255) / 520833 = 31 (truncated from 31.9998)
> the technically "correct" value is:
>   (0xff4f * 255) / (66666666.0 / 128) = 31.9998
> 
> By using "DIV_ROUND_UP" we can be a little more correct.
>   s3c2410wdt_set_heartbeat: count=16666688, timeout=32, freq=520834
>   s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666688 (0000ff50)
> and the final timeout reported to the user:
>   (0xff50 * 255) / 520834 = 32
> the technically "correct" value is:
>   (0xff50 * 255) / (66666666.0 / 128) = 32.0003
> 
> We'll use a DIV_ROUND_UP to solve this, generally erroring on the side
> of reporting shorter values to the user and setting the watchdog to
> slightly longer than requested:
> * Round input frequency up to assume watchdog is counting faster.
> * Round divisions by divisor up to give us extra time.
> 
> At the same time we can avoid a for loop by just doing the right math.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Avoid a for loop as per Guenter.

Patch added to linux-watchdog-next.

Kind regards,
Wim.

