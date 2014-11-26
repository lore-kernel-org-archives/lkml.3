Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaKZGWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:22:32 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:45246 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaKZGWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:22:30 -0500
MIME-Version: 1.0
In-Reply-To: <1416944441-12066-3-git-send-email-sbranden@broadcom.com>
References: <sbranden@broadcom.com>
	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>
	<1416944441-12066-3-git-send-email-sbranden@broadcom.com>
Date: Tue, 25 Nov 2014 22:22:30 -0800
Message-ID: <CAD7vxxKgcu9QLY8qH8WR0b_5WBu+MNxcemmZ8syYa__JaC6tsQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pwm: kona: Fix incorrect enable after channel
 polarity change
From: Tim Kryger <tim.kryger@gmail.com>
To: Scott Branden <sbranden@broadcom.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-pwm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com> wrote:
> From: Arun Ramamurthy <arunrama@broadcom.com>
>
> The pwm core code requires a separate call for enabling the channel
> and hence the driver does not need to set pwm_trigger after a
> polarity change

The framework does restrict when polarity changes can occur but it
isn't clear to me that there is any reason to delay applying the
polarity change.  Keep in mind that polarity matters even when a PWM
is disabled.  While disabled, the output should be equivalent to an
enabled configuration with zero duty.  Thus for normal polarity the
output is constant low and for inversed polarity the output is
constant high. I believe there is an expectation that the output is
updated to reflect the requested polarity change prior to returning to
the caller.

>
> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
> Reviewed-by: Ray Jui <rjui@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> ---
>  drivers/pwm/pwm-bcm-kona.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
> index 29eef9e..fa0b5bf 100644
> --- a/drivers/pwm/pwm-bcm-kona.c
> +++ b/drivers/pwm/pwm-bcm-kona.c
> @@ -173,11 +173,6 @@ static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>
>         writel(value, kp->base + PWM_CONTROL_OFFSET);
>
> -       kona_pwmc_apply_settings(kp, chan);
> -
> -       /* Wait for waveform to settle before gating off the clock */
> -       ndelay(400);
> -
>         clk_disable_unprepare(kp->clk);
>
>         return 0;
> --
> 2.1.3
>
