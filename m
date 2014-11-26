Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaKZFvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:51:46 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62286 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaKZFvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:51:44 -0500
MIME-Version: 1.0
In-Reply-To: <1416944441-12066-2-git-send-email-sbranden@broadcom.com>
References: <sbranden@broadcom.com>
	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>
	<1416944441-12066-2-git-send-email-sbranden@broadcom.com>
Date: Tue, 25 Nov 2014 21:51:43 -0800
Message-ID: <CAD7vxxJFD8Xgsd1Jrf=vA5-duqG21UWXMr4oRM6MEmMxQ9V49A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pwm: kona: Remove setting default smooth type and
 polarity for all channels
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
> The probe routine unnecessarily sets the smooth type and polarity for
> all channels. This causes the channel for the speaker to click at the same
> time the backlight turns on. The smooth type and polarity should be set individually
> for each channel as required and no defaults need to be set.

I am guessing you are talking about a PWM controlled beeper/buzzer.

Can you mention what board you are observing this issue on?

Also please explain why setting these bits result in an audible click.

>
> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
> Reviewed-by: Ray Jui <rjui@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> ---
>  drivers/pwm/pwm-bcm-kona.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
> index 02bc048..29eef9e 100644
> --- a/drivers/pwm/pwm-bcm-kona.c
> +++ b/drivers/pwm/pwm-bcm-kona.c
> @@ -266,12 +266,9 @@ static int kona_pwmc_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> -       /* Set smooth mode, push/pull, and normal polarity for all channels */
> -       for (chan = 0; chan < kp->chip.npwm; chan++) {
> -               value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
> +       /* Set push/pull for all channels */
> +       for (chan = 0; chan < kp->chip.npwm; chan++)
>                 value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
> -               value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
> -       }
>
>         writel(value, kp->base + PWM_CONTROL_OFFSET);

While the smooth bit need not be set here, it is important that the
polarity bit be set.

Otherwise software will report the polarity as normal when it it is
actually inversed.

Consider the case where a userspace process is controlling the PWM via sysfs.
