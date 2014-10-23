Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaJWRNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:13:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41031 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaJWRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:13:10 -0400
Date: Thu, 23 Oct 2014 10:13:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        khilman@linaro.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v3 1/5] PM / clock_ops: Add pm_clk_add_clk()
Message-ID: <20141023171305.GA24671@dtor-ws>
References: <1414074182-25980-1-git-send-email-grygorii.strashko@ti.com>
 <1414074182-25980-2-git-send-email-grygorii.strashko@ti.com>
 <20141023154928.GC18714@dtor-ws>
 <54492A69.5070505@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54492A69.5070505@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 07:18:49PM +0300, Grygorii Strashko wrote:
> On 10/23/2014 06:49 PM, Dmitry Torokhov wrote:
> >On Thu, Oct 23, 2014 at 05:22:58PM +0300, Grygorii Strashko wrote:
> >>From: Geert Uytterhoeven <geert+renesas@glider.be>
> >>
> >>The existing pm_clk_add() allows to pass a clock by con_id. However,
> >>when referring to a specific clock from DT, no con_id is available.
> >>
> >>Add pm_clk_add_clk(), which allows to specify the struct clk * directly.
> >>
> >>CC: Ulf Hansson <ulf.hansson@linaro.org>
> >>CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >>Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>Reviewed-by: Kevin Hilman <khilman@linaro.org>
> >>Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >>---
> >>  drivers/base/power/clock_ops.c | 41 +++++++++++++++++++++++++++++++----------
> >>  include/linux/pm_clock.h       |  8 ++++++++
> >>  2 files changed, 39 insertions(+), 10 deletions(-)
> >>
> >>diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> >>index 7836930..f14b767 100644
> >>--- a/drivers/base/power/clock_ops.c
> >>+++ b/drivers/base/power/clock_ops.c
> >>@@ -53,7 +53,8 @@ static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
> >>   */
> >>  static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
> >>  {
> >>-	ce->clk = clk_get(dev, ce->con_id);
> >>+	if (!ce->clk)
> >>+		ce->clk = clk_get(dev, ce->con_id);
> >>  	if (IS_ERR(ce->clk)) {
> >>  		ce->status = PCE_STATUS_ERROR;
> >>  	} else {
> >>@@ -63,15 +64,8 @@ static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
> >>  	}
> >>  }
> >>
> >>-/**
> >>- * pm_clk_add - Start using a device clock for power management.
> >>- * @dev: Device whose clock is going to be used for power management.
> >>- * @con_id: Connection ID of the clock.
> >>- *
> >>- * Add the clock represented by @con_id to the list of clocks used for
> >>- * the power management of @dev.
> >>- */
> >>-int pm_clk_add(struct device *dev, const char *con_id)
> >>+static int __pm_clk_add(struct device *dev, const char *con_id,
> >>+			struct clk *clk)
> >>  {
> >>  	struct pm_subsys_data *psd = dev_to_psd(dev);
> >>  	struct pm_clock_entry *ce;
> >>@@ -93,6 +87,8 @@ int pm_clk_add(struct device *dev, const char *con_id)
> >>  			kfree(ce);
> >>  			return -ENOMEM;
> >>  		}
> >>+	} else {
> >
> >You need __clk_get(clk) here, otherwise when you will be removing clocks
> >you'll be dropping a reference that does not belong to you (as yiou have
> >not taken it).
> 
> No, I don't ;)
> 
> pm_clk_add_clk is intended to be used with valid pointer on clk,
> which means clk_get() has been called already. In our case:
> 	clk = of_clk_get(dev->of_node, i));
> 	ret = pm_clk_add_clk(dev, clk);
> 
> It's just a different way to fill list of clocks for device,
> once pm_clk_add_clk() is called - PM clock framework will be the owner
> of clock.

No, this is not how the rest of refcounted APIs work in the kernel. You
do not take over other's references and if you need to store pointer to
refcounted object you are responsible for taking your own reference. See
how we work with device structures, OF nodes, etc, etc.

The proper pattern here should be (unless the driver wants to hold on to
the clock for its own purposes):

	clk = of_clk_get(dev->of_node, i));
	ret = pm_clk_add_clk(dev, clk);
	clk_put(clk);

with pm_clk_add_clk() taking and managing _its own_ reference and the
caller (driver) managing _its_ reference.

So FWIW strong NAK here from me.

Thanks.

-- 
Dmitry
