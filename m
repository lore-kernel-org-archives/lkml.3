Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3KFQU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:20:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42416 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KFQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:20:27 -0500
Date: Wed, 6 Nov 2013 16:19:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
Message-ID: <20131106161911.GA16735@n2100.arm.linux.org.uk>
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com> <20131106111534.GW16735@n2100.arm.linux.org.uk> <527A2C9C.4080409@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A2C9C.4080409@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:48:44PM +0200, Tomi Valkeinen wrote:
> On 2013-11-06 13:15, Russell King - ARM Linux wrote:
> > On Wed, Nov 06, 2013 at 01:06:48PM +0200, Tomi Valkeinen wrote:
> >> This means that the following code works a bit oddly:
> >>
> >> rate = clk_round_rate(clk, 123428572);
> >> clk_set_rate(clk, rate);
> > 
> > You're right, but the above sequence is quite a crass thing to do.  Why?
> 
> Do you mean that you think the fix is right, but the above example
> sequence is silly, or that the fix is not needed either?

I think a fix _is) required, because:

	rate = clk_get_rate(clk);
	clk_set_rate(clk, rate);
	assert(clk_get_rate(clk) == rate);

If not, there's something quite wrong.  However, I am saying that the
sequence you provided was nevertheless silly - I've seen it in real code
in the kernel, which is why I've commented about it.

> Ok, if defined like that, then the current behavior is logical.
> 
> The comment in clk.h says "adjust a rate to the exact rate a clock can
> provide", which does not contradict with what you said, but doesn't
> really confirm it either. If I get "the exact rate a clock can provide"
> I don't see why I can't use that exact clock rate for clk_set_rate.
> Maybe the comment should be improved to state explicitly what it does.
> 
> However, how about the following sequence:
> 
> 	clk_set_rate(clk, 123428572);
> 	rate = clk_get_rate(clk);
> 	clk_set_rate(clk, rate);
> 
> I didn't test that but it should result in the clock first set to
> 123428571, and then to 108000000. Obviously pointless if done exactly
> like that, but I don't see why the above code sequence is wrong, yet it
> gives a bit surprising result.

Does this help clarify it?

--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -228,6 +228,20 @@
  * @clk: clock source
  * @rate: desired clock rate in Hz
  *
+ * This answers the question "if I were to pass @rate to clk_set_rate(),
+ * what clock rate would I end up with?" without changing the hardware
+ * in any way.  In other words:
+ *
+ *   rate = clk_round_rate(clk, r);
+ *
+ * and:
+ *
+ *   clk_set_rate(clk, r);
+ *   rate = clk_get_rate(clk);
+ *
+ * are equivalent except the former does not modify the clock hardware
+ * in any way.
+ *
  * Returns rounded clock rate in Hz, or negative errno.
  */
 long clk_round_rate(struct clk *clk, unsigned long rate);

