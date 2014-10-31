Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaJaRgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:36:13 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:60867 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaJaRgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <030ed753d9764825b1bd5c845b360c7d@BN1AFFO11FD036.protection.gbl>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
	<CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
	<5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
	<CACRpkdZjJQTxVhvq5BT3mHBDHge_wHBNi9N_6u0WVbPB3wBDKw@mail.gmail.com>
	<030ed753d9764825b1bd5c845b360c7d@BN1AFFO11FD036.protection.gbl>
Date: Fri, 31 Oct 2014 18:36:10 +0100
Message-ID: <CACRpkdb9Gg90GwTpUm7S6SFkFjKTRaZLWa2JLnXJK4H-ZMbQ6A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 5:57 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Fri, 2014-10-31 at 09:17AM +0100, Linus Walleij wrote:

>> Again it seems to be a sequencing problem. And device tree is
>> not good at sequences, therefore all states should be self-contained.
>
> I agree, but how would I define a pin with pull-up enabled and
> tri-state disabled - assume the pin is currently in a random state that
> can have those things set/not set arbitrarily.

I was more thinking as everything you don't enable explicitly
in a state is per definition disabled.

So if you are in state A and tri-state is enabled there and you
move to state B where pull-up is enabled, then tri-state should
be disabled, since it is not explicitly enabled.

> I can't put bias-disable in DT since it would potentially disable both
> and the pull-up enable would have only a transient effect.

Well look at the callback from the core:

        int (*pin_config_set) (struct pinctrl_dev *pctldev,
                               unsigned pin,
                               unsigned long *configs,
                               unsigned num_configs);

You get all configs in an array. The driver can walk over the list and
make informed decisions on what to do *BEFORE* poking any registers.

Avoiding transients as you describe is part of why the callback
looks as it does. This is why every driver has its own for-loop.

> I can't do the sequencing in the driver either. If I see pull-up enable,
> I can't imply an effect on tri-state since I can't know whether there
> was/will be a tri-state property that sets it as well.

If you define that each state is self-contained you can.

Yours,
Linus Walleij
