Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3H3OyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:54:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44976 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3H3OyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:54:18 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-06-5220b218c2e9
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 2/5] clkdev: Fix race condition in clock lookup from device
 tree
Date: Fri, 30 Aug 2013 16:53:19 +0200
Message-id: <1377874402-2944-3-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
References: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jAV2JTQpBBtcnmlq83ziPyaLnT6XF
	2aY37BadE5ewW2x6fI3V4vKuOWwWE6ZOYreY82cKs8Xty7wWTydcZLO43biCzeLwm3ZWi/Uz
	XrM48Hq0NPeweXz4GOcxu2Mmq8eda3vYPI6uXMvksXlJvcfur02MHn1bVjF6fN4kF8AZxWWT
	kpqTWZZapG+XwJUx651DwSL+ik+db5kaGI/ydDFyckgImEgcb7vJBGGLSVy4t56ti5GLQ0hg
	EaPEtWWtzBBOB5PElzPzGUGq2AQMJXqP9oHZIgIaElO6HrODFDELXGaS2PSlix0kISwQKnHl
	314wm0VAVeLu4/vMIDavgKvEnNuvWbsYOYDWKUjMmWQDEuYUcJO4MA1kMyfQMqCSE6sYJzDy
	LmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLDPpHYwrmywOMQowMGoxMObsFQhSIg1
	say4MvcQowQHs5II78fFQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtS
	i2CyTBycUg2MknMY6idxyhl+ed1ctXaVzjI3a8ZNS/f98XRhKU+Pt5rHOLn0l+q727UpVzy6
	H5fKRPH3SfDcD/DsYuNnfNiUGWaf9eOn6Ertb0e78v40iZsLn9kwz9/W29FNdUGkjaHuZ+cn
	Oz5obLJrsLhjkrFnCrtwb8eqXayrNv1zaarhkFuvEbB50kIlluKMREMt5qLiRACJFLouVAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently a race condition in the device tree part of clk_get()
function, since the pointer returned from of_clk_get_by_name() may become
invalid before __clk_get() call. E.g. due to the clock provider driver
remove() callback being called in between of_clk_get_by_name() and
__clk_get().

Fix this by doing both the look up and __clk_get() operations with the
clock providers list mutex held. This ensures that the clock pointer
returned from __of_clk_get_from_provider() call and passed to __clk_get()
is valid, as long as the clock supplier module first removes its clock
provider instance and then does clk_unregister() on the corresponding
clocks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Changes since v2:
 - none.

Changes since v1:
 - include "clk.h".
---
 drivers/clk/clkdev.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..48f6721 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -21,6 +21,8 @@
 #include <linux/clkdev.h>
 #include <linux/of.h>
 
+#include "clk.h"
+
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
@@ -39,7 +41,13 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	if (rc)
 		return ERR_PTR(rc);
 
-	clk = of_clk_get_from_provider(&clkspec);
+	of_clk_lock();
+	clk = __of_clk_get_from_provider(&clkspec);
+
+	if (!IS_ERR(clk) && !__clk_get(clk))
+		clk = ERR_PTR(-ENOENT);
+
+	of_clk_unlock();
 	of_node_put(clkspec.np);
 	return clk;
 }
@@ -157,7 +165,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 
 	if (dev) {
 		clk = of_clk_get_by_name(dev->of_node, con_id);
-		if (!IS_ERR(clk) && __clk_get(clk))
+		if (!IS_ERR(clk))
 			return clk;
 	}
 
-- 
1.7.9.5

