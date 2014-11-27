Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaK0V0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:26:51 -0500
Received: from plane.gmane.org ([80.91.229.3]:43911 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaK0V0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:26:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix lubbock interrupts handling
Date: Thu, 27 Nov 2014 21:26:35 +0000 (UTC)
Message-ID: <m584ub$cat$1@ger.gmane.org>
References: <1417113721-9062-1-git-send-email-robert.jarzmik@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp78-37-148-93.pppoe.avangarddsl.ru
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 19:42:01 +0100, Robert Jarzmik wrote:
> When gpio-pxa was moved to drivers/pxa, it became a driver, and its
> initialization and probing happen at postcore initcall. The lubbock code
> used to install the chained lubbock interrupt handler at init_irq()
> time.
> 
> The consequence of the gpio-pxa change is that the installed chained irq
> handler lubbock_irq_handler() was overwritten in pxa_gpio_probe(_dt)(),
> removing :
>  - the handler - the falling edge detection setting of GPIO0, which
>  revealed the
>    interrupt request from the lubbock IO board.
> 
> As a fix, move the gpio0 chained handler setup to a place where we have
> the guarantee that pxa_gpio_probe() was called before, so that lubbock
> handler becomes the true IRQ chained handler of GPIO0, demuxing the
> lubbock IO board interrupts.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> For Thomas: as a side note, I'm not very happy with this patch. What
>             makes me unhappy is that I don't know how to express the
>             dependency between gpio-pxa probe time and
>             irq_set_chained_handler(irq, lubbock_irq_handler).
> 
>             At the moment I rely on the fact that
>             lubbock_irq_device_init() is called as device initcall while
>             pxa_gpio_probe() is called as postcore initcall.
> 
>             If you have a better idea I'm all ears.

What about just making a lubbock CPLD a special separate device?
Then it will have normal probe callback and a possibility to return
-EPROBE_DEFER? If only syscon (drivers/mfd/syscon.c) could support
irq generation, it would fit ideally.

-- 
With best wishes
Dmitry

