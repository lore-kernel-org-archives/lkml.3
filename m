Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab3CMRsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:48:18 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:65484 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932905Ab3CMRsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:48:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19uMZUZxlX+GxsEBa+mlNoCDPllairN+3E=
From: Jason Cooper <jason@lakedaemon.net>
To: David Woodhouse <dwmw2@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2] pinctrl: mvebu: prevent walking off the end of group array
Date: Wed, 13 Mar 2013 17:48:04 +0000
Message-Id: <1363196884-20193-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362872371.3690.106.camel@shinybook.infradead.org>
References: <1362872371.3690.106.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

While investigating (ab)use of krealloc, David found this bug.  It's
unlikely to occur, but now we detect the condition and error out
appropriately.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Changes from v1:
 - correct typo (s/ nt / int /) I should've caught before sending.

David, please double check that this is as you intended.  I had to hand-jam it
in due to some peculiarities on my side.

 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index c689c04..5db5fad 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -478,16 +478,21 @@ static struct pinctrl_ops mvebu_pinctrl_ops = {
 	.dt_free_map = mvebu_pinctrl_dt_free_map,
 };
 
-static int _add_function(struct mvebu_pinctrl_function *funcs, const char *name)
+static int _add_function(struct mvebu_pinctrl_function *funcs, int nr_funcs,
+			const char *name)
 {
-	while (funcs->num_groups) {
+	while (nr_funcs && funcs->num_groups) {
 		/* function already there */
 		if (strcmp(funcs->name, name) == 0) {
 			funcs->num_groups++;
 			return -EEXIST;
 		}
 		funcs++;
+		nr_funcs--;
 	}
+	if (!nr_funcs)
+		return -EOVERFLOW;
+
 	funcs->name = name;
 	funcs->num_groups = 1;
 	return 0;
@@ -501,7 +506,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
 	int n, s;
 
 	/* we allocate functions for number of pins and hope
-	 * there are less unique functions than pins available */
+	 * there are fewer unique functions than pins available */
 	funcs = devm_kzalloc(&pdev->dev, pctl->desc.npins *
 			     sizeof(struct mvebu_pinctrl_function), GFP_KERNEL);
 	if (!funcs)
@@ -510,26 +515,26 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
 	for (n = 0; n < pctl->num_groups; n++) {
 		struct mvebu_pinctrl_group *grp = &pctl->groups[n];
 		for (s = 0; s < grp->num_settings; s++) {
+			int ret;
+
 			/* skip unsupported settings on this variant */
 			if (pctl->variant &&
 			    !(pctl->variant & grp->settings[s].variant))
 				continue;
 
 			/* check for unique functions and count groups */
-			if (_add_function(funcs, grp->settings[s].name))
+			ret = _add_function(funcs, pctl->desc.npins,
+					    grp->settings[s].name);
+			if (ret == -EOVERFLOW)
+				dev_err(&pdev->dev,
+					"More functions than pins(%d)\n",
+					pctl->desc.npins);
 				continue;
 
 			num++;
 		}
 	}
 
-	/* with the number of unique functions and it's groups known,
-	   reallocate functions and assign group names */
-	funcs = krealloc(funcs, num * sizeof(struct mvebu_pinctrl_function),
-			 GFP_KERNEL);
-	if (!funcs)
-		return -ENOMEM;
-
 	pctl->num_functions = num;
 	pctl->functions = funcs;
 
-- 
1.8.1.5

