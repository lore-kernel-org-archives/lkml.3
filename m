Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbaKUJAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:00:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53020 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752836AbaKUJAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:00:07 -0500
Date: Fri, 21 Nov 2014 09:59:54 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Jason Cooper" <jason@lakedaemon.net>, "Andrew Lunn" <andrew@lunn.ch>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
        "Gregory Clement" <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        "Tawfik Bayouk" <tawfik@marvell.com>,
        "Nadav Haklai" <nadavh@marvell.com>,
        "Lior Amsalem" <alior@marvell.com>,
        "Ezequiel Garcia" <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 08/16] clk: mvebu: add suspend/resume for gatable
 clocks
Message-ID: <20141121095954.5f708f54@free-electrons.com>
In-Reply-To: <20141117224604.25314.96198@quantum>
References: <1415978496-9334-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<1415978496-9334-9-git-send-email-thomas.petazzoni@free-electrons.com>
	<20141117224604.25314.96198@quantum>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mike Turquette,

On Mon, 17 Nov 2014 14:46:04 -0800, Mike Turquette wrote:
> Quoting Thomas Petazzoni (2014-11-14 07:21:28)
> > This commit adds suspend/resume support for the gatable clock driver
> > used on Marvell EBU platforms. When getting out of suspend, the
> > Marvell EBU platforms go through the bootloader, which re-enables all
> > gatable clocks. However, upon resume, the clock framework will not
> > disable again all gatable clocks that are not used.
> > 
> > Therefore, if the clock driver does not save/restore the state of the
> > gatable clocks, all gatable clocks that are not claimed by any device
> > driver will remain enabled after a resume. This is why this driver
> > saves and restores the state of those clocks.
> 
> It might be a good idea to call clk_disable_unused() from the clk core
> after resuming from suspend.

Yes, this might be an interesting clk core improvement.

> > @@ -177,14 +178,18 @@ struct clk_gating_ctrl {
> >         spinlock_t *lock;
> >         struct clk **gates;
> >         int num_gates;
> > +       struct syscore_ops syscore_ops;
> 
> You are registering suspend/resume ops per clock. Have you considered
> registering a single set of ops for your clock controller driver? See
> drivers/clk/samsung/clk-exynos5420.c for an example.
> 
> Combined with a table of clocks registered by your driver, centralized
> suspend/resume methods might be a cleaner solution.

Ok, I've changed. To be honest, I don't think it makes much change: if
we had two instances of a gatable clock controller, then we would have
two calls to mvebu_clk_gating_setup(), which would register twice the
same syscore_ops. But we were anyway already assuming that we have
already one instance of a gatable clock controller, since the
syscore_ops operation implementation already used a global pointer to
the gatable clock controller.

Will be part of the upcoming v3.

Thanks for the review!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
