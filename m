Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaLFXNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 18:13:22 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:38409 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaLFXNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 18:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <5480C286.6000405@broadcom.com>
References: <sbranden@broadcom.com>
	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>
	<1416944441-12066-2-git-send-email-sbranden@broadcom.com>
	<CAD7vxxJFD8Xgsd1Jrf=vA5-duqG21UWXMr4oRM6MEmMxQ9V49A@mail.gmail.com>
	<5479097B.6020108@broadcom.com>
	<CAD7vxxJr48p_1=obXkX5kvk96B18A8=F98ikqnzTKsz6nYZJbQ@mail.gmail.com>
	<54791F30.3050306@broadcom.com>
	<CAD7vxxJFuA8V0TiPLQo1LOnRQPbM-QOYDTLkg7Ty0N=Nr7frGQ@mail.gmail.com>
	<5480C286.6000405@broadcom.com>
Date: Sat, 6 Dec 2014 15:13:19 -0800
Message-ID: <CAD7vxx+zNx40TMtaJ=CjohTHr2xoH8yTT8hGTZFER1FArHaokQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pwm: kona: Remove setting default smooth type and
 polarity for all channels
From: Tim Kryger <tim.kryger@gmail.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-pwm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 12:22 PM, Jonathan Richardson
<jonathar@broadcom.com> wrote:
> Hi Tim,
>
> I'm going to take over this submission because I made the changes to the
> driver. Arun was filling in for me while I was on leave. Now I'm back
> and I think I can help clarify why these changes were made. A summary
> for all the changes should help.
>
> There were two problems. First was a problem caused by setting the
> polarity in probe. It caused the speaker to click when the polarity was
> set so we took that out as it didn't seem to serve any useful purpose
> that I could see. The polarity changes should be made in the polarity
> callback.

Please provide more details about your configuration.

Are you using the pwm-beeper driver with a piezo?

After a reset, all PWM output will be low until the PWM clock is
enabled at which point it will be constant high.  Are you confident
that this transition is not responsible for the click you are hearing?

> The second and bigger problem was the smooth type sequence. If it isn't
> done according to the spec then one in ten or twenty times you won't
> even get a signal when it's enabled. Following the correct sequence with
> the 400 ns delays solves this problem.

Would the following minor change be sufficient to fix the issue?

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index 02bc048..c537efd 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -85,6 +85,9 @@ static void kona_pwmc_apply_settings(struct kona_pwmc *kp, uns
        value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
        writel(value, kp->base + PWM_CONTROL_OFFSET);

+       ndelay(400);
+
        /* Set trigger bit and clear smooth bit to apply new settings */
        value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
        value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);

>
> Additionally, by not following the sequence you won't get a smooth
> transition. You'll get a change in the settings (duty cycle, period) but
> may get a non smooth transition. So it's important to follow the spec
> here. We don't want non-smooth transitions.

Please provide your rationale for requiring smooth transitions.

Thanks,
Tim Kryger
