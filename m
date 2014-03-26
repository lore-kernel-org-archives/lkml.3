Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaCZSWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:22:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40062 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaCZSWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:22:22 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-35-53331adc262c
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, b.brezillon@overkiz.com,
        khilman@linaro.org, festevam@gmail.com, shawn.guo@linaro.org,
        kernel@pengutronix.de, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] clk: register fixed-clock only if #clock-cells property is
 present
Date: Wed, 26 Mar 2014 19:22:07 +0100
Message-id: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jQd27UsbBBvcOslhcOHeY0WL+kXOs
	Fg+v+lusmrqTxeLr4RWMFpseX2O1uLxrDpvF7cu8Fk8nXGSz+Ha5md1i3cMXTBaH37SzWjxd
	t4TZYv2M1ywOfB4tzT1sHgt+bWXx2DnrLrvHqwt3WDzuXNvD5rF5Sb3HpMV/2Dz6/xp49G1Z
	xejxeZNcAFcUl01Kak5mWWqRvl0CV8aJk8dZC66KVxydN5+9gfGDcBcjJ4eEgInE2jP/2CBs
	MYkL99YD2VwcQgLTGSUuLPgNlhAS6GCS+HwyFMRmEzCU6D3axwhiiwjYS/yY8JIFpIFZYDeT
	RNPmiUAJDg5hgVCJ3zNFQGpYBFQlZkzZxQRi8wq4SZyav4IJpERCQEFiziSbCYzcCxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEh+Qz6R2MqxosDjEKcDAq8fDuuG8ULMSaWFZcmXuI
	UYKDWUmE94KocbAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYO
	TqkGxmT+1QxTRPV61vOfj5jd+uhGxIUX2rHbIyPaZHQP+6ndkHph0rdY223Xfg/JdcZPz9lP
	1t0R878snVe1Pnjdkc4q6duufxaxn6letVSkfPm8lJ8vl90IZLjmvbe69zHbj6lJiu7ek/4m
	9TwVUP/LxbPodF7C2fCtUztC90xvPK8tu9HZNmXHXyWW4oxEQy3mouJEAARp7t1FAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 1771b10d605d26ccee771a7fb4b08718c124097a
"clk: respect the clock dependencies in of_clk_init"
the order of registering clock providers and their corresponding
clocks may change. This commit currently causes a regression
on Exynos4 platforms, where fixed clocks are now being registered
through the standard "fixed-clock" compatible device driver, rather
than through a custom mechanism within the clk-exynos4 driver.
Then any attempts to register the fixed clocks in clk-exynos4
fail, since clocks named "xxti", "xusbxti" are already registered.
This means that some clock specifiers do not work any more, i.e.
those with phandle to the main clock controller node and fixed
indexes. This in turn causes wrong frequency of the root clocks
and various division by zero errors.

Hence for old dtbs, where #clock-cells property is missing in the
fixed-clock DT nodes for exynos4 this patch has a positive side
effect that the fixed clocks will not get registered through the
standard mechanism and the required clock names won't be taken
at the time the main clock controller driver's init callback is
called.

To make exynos use the standard fixed-clock registration mechanism,
related dts files could be updated, i.e. #clock-cells property
added together with required dependencies, that is a 'clocks'
property with phandles to the fixed clock nodes listed in it.
The dependencies specified in devicetree would then ensure proper
order of clocks registration.

Now the issue is that this patch affects not only exynos, but also
imx and at91 platforms. However, those use a custom compatible
string in addition to "fixed-clock" and I suspect registering
fixed clocks through the drivers/clk/clk-fixed-rate.c driver has
been  failing silently for them anyway. This patch could be
actually fixing similar issue as for exynos, seen after commit
"clk: respect the clock dependencies in of_clk_init".

There is one board that will likely break after this patch, i.e.
arch/arm/boot/dts/vf610-twr.dts. Nonetheless, it doesn't specify
the #clock-cells property, which is documented as mandatory in
Documentation/devicetree/bindings/clock/fixed-clock.txt.
So perhaps we could add the missing property to dts as a fix.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/clk/clk-fixed-rate.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 0fc56ab..cbbef2b 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -122,6 +122,11 @@ void of_fixed_clk_setup(struct device_node *node)
 	if (of_property_read_u32(node, "clock-frequency", &rate))
 		return;

+	if (!of_find_property(node, "#clock-cells", NULL)) {
+		pr_warn("clk: missing #clock-cells property at %s\n",
+			node->full_name);
+		return;
+	}
 	of_property_read_u32(node, "clock-accuracy", &accuracy);

 	of_property_read_string(node, "clock-output-names", &clk_name);
--
1.7.9.5

