Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbbAZQvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:51:37 -0500
Received: from gloria.sntech.de ([95.129.55.99]:47566 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbbAZQvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:51:20 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: rockchip: Only mask interrupts; never disable
Date: Mon, 26 Jan 2015 17:56:19 +0100
Message-ID: <1844800.Wx1PProku3@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1422289444-15142-1-git-send-email-dianders@chromium.org>
References: <1422289444-15142-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. Januar 2015, 08:24:03 schrieb Doug Anderson:
> The Rockchip GPIO interrupt controller totally throws away all status
> about an interrupt when you "disable" the interrupt.  That has
> unfortunate consequences in the following situation:
> 
> 1. An edge-triggered interrupt is enabled and should wake the system.
> 2. System suspend happens: interrupt is disabled and marked for wake.
> 3. rockchip_irq_suspend() reenables the interrupt so we can wake.
> 4. Interrupt happens when asleep.
> 5. rockchip_irq_resume() redisables the interrupt.
> 6. Disabling the interrupt throws away all status about it.
> 7. Normal system resume happens and we enable the interrupt again,
>    since we threw away status about the interrupt we don't know it
>    fired while suspended.  Even worse: if we need both edges of the
>    interrupt the logic to swap edges never runs.
> 
> Note: even if we somehow can post the status about wakeup interrupts
> in rockchip_irq_resume() we would still have a window of losing any
> edges that came in while interrupts were disabled.
> 
> If we use mask only then we don't need to worry.  The GPIO Interrupt
> controller keeps track of pending interrupts that are enabled and just
> masked.
> 
> There was no real strong reason to support the enable/disable
> functionality (other than that it seemed right), so let's go back to
> just supporting mask/unmask but actually map it to the real
> mask/unmask.  This ends up with slightly different (and more correct)
> behavior than before (f2dd028 pinctrl: rockchip: Fix
> enable/disable/mask/unmask).
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I talked with Doug about it and this looks sane, so
Reviewed-by: Heiko Stuebner <heiko@sntech.de>


Heiko
