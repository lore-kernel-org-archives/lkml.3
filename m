Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaAWSrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:47:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:14781 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaAWSrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:36 -0500
X-IronPort-AV: E=Sophos;i="4.95,707,1384300800"; 
   d="scan'208";a="93831833"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@redhat.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next] bonding: Use do_div to divide 64 bit numbers
Date: Thu, 23 Jan 2014 18:47:18 +0000
Message-ID: <1390502838-21581-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolay Aleksandrov's recent bonding option API changes (25a9b54a and e4994612)
introduced u64 as the type of downdelay and updelay. On 32 bit the division and
modulo operations cause compile errors:

ERROR: "__udivdi3" [drivers/net/bonding/bonding.ko] undefined!
ERROR: "__umoddi3" [drivers/net/bonding/bonding.ko] undefined!

This patch use the do_div macro, which guaranteed to do the right thing.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/bonding/bond_options.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 4cee04a..4f94907 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ctype.h>
 #include <linux/inet.h>
+#include <asm/div64.h>
 #include "bonding.h"
 
 static struct bond_opt_value bond_mode_tbl[] = {
@@ -727,19 +728,20 @@ int bond_option_miimon_set(struct bonding *bond, struct bond_opt_value *newval)
 
 int bond_option_updelay_set(struct bonding *bond, struct bond_opt_value *newval)
 {
+	u64 quotient = newval->value;
+	u64 remainder = do_div(quotient, bond->params.miimon);
 	if (!bond->params.miimon) {
 		pr_err("%s: Unable to set up delay as MII monitoring is disabled\n",
 		       bond->dev->name);
 		return -EPERM;
 	}
-	if ((newval->value % bond->params.miimon) != 0) {
+	if (remainder != 0) {
 		pr_warn("%s: Warning: up delay (%llu) is not a multiple of miimon (%d), updelay rounded to %llu ms\n",
 			bond->dev->name, newval->value,
 			bond->params.miimon,
-			(newval->value / bond->params.miimon) *
-			bond->params.miimon);
+			quotient * bond->params.miimon);
 	}
-	bond->params.updelay = newval->value / bond->params.miimon;
+	bond->params.updelay = quotient;
 	pr_info("%s: Setting up delay to %d.\n",
 		bond->dev->name,
 		bond->params.updelay * bond->params.miimon);
@@ -750,19 +752,20 @@ int bond_option_updelay_set(struct bonding *bond, struct bond_opt_value *newval)
 int bond_option_downdelay_set(struct bonding *bond,
 			      struct bond_opt_value *newval)
 {
+	u64 quotient = newval->value;
+	u64 remainder = do_div(quotient, bond->params.miimon);
 	if (!bond->params.miimon) {
 		pr_err("%s: Unable to set down delay as MII monitoring is disabled\n",
 		       bond->dev->name);
 		return -EPERM;
 	}
-	if ((newval->value % bond->params.miimon) != 0) {
+	if (remainder != 0) {
 		pr_warn("%s: Warning: down delay (%llu) is not a multiple of miimon (%d), delay rounded to %llu ms\n",
 			bond->dev->name, newval->value,
 			bond->params.miimon,
-			(newval->value / bond->params.miimon) *
-			bond->params.miimon);
+			quotient * bond->params.miimon);
 	}
-	bond->params.downdelay = newval->value / bond->params.miimon;
+	bond->params.downdelay = quotient;
 	pr_info("%s: Setting down delay to %d.\n",
 		bond->dev->name,
 		bond->params.downdelay * bond->params.miimon);
