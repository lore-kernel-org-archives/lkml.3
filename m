Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3LLHAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:00:20 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:36047 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3LLHAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:00:17 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Wed, 11 Dec 2013 23:00:16 -0800
Message-ID: <CAOesGMjcmeiBfc=EOvWazebg-9vnMuQtRC0aeHJy7Q=02RdRPA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] net: macb updates
From: Olof Johansson <olof@lixom.net>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On Tue, Dec 10, 2013 at 4:07 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Soren Brinkmann (5):
>   net: macb: Adjust tx_clk when link speed changes

This patch causes build issues on some at91 platforms, namely
at91sam9263 that lacks programmable clocks. So it doesn't implement
clk_set_rate() and clk_round_rate().

I don't know if there's any reasonable config option to check for
(that wouldn't add at91-specific stuff to the driver which we don't
want). So I suspect the best way would be to implement dummy versions
for at91 when CONFIG_AT91_PROGRAMMABLE_CLOCKS isn't set.

Nicolas, you OK with that? It'd be something like the below
(copy-paste, whitespace damage, just RFC):

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 6b2630a..17c52a7 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -459,6 +459,22 @@ static void __init init_programmable_clock(struct clk *clk)
        clk->rate_hz = parent->rate_hz / pmc_prescaler_divider(pckr);
 }

+#else  /* CONFIG_AT91_PROGRAMMABLE_CLOCKS */
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+       if (rate == clk_get_rate(clk))
+               return 0;
+
+       return -EINVAL;
+}
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+       /* There's really nothing sane to return here. */
+       return clk_get_rate(clk);
+}
+
 #endif /* CONFIG_AT91_PROGRAMMABLE_CLOCKS */
