Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161200AbaDJNT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:19:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19587 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030725AbaDJNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:19:49 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-37-53469a7406fd
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 08/13] extcon: extcon-class: simplify extcon_updata_state()
 function
Date: Thu, 10 Apr 2014 15:16:46 +0200
Message-id: <1397135811-12866-9-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRwG8N6dy46jyWmtOk3EsVmkpWVFvJGFUcpLEBiKH4LQqQcVdY5N
	RSNwYtM0dVNR0ayceZtORVNx6ua8fMgutjA0yLTykpopyNRAu3iMvv3g+T88H/4UJmrHJVSc
	MplVKxUJMlKAv/o9S/skVwaFnNlaPQrNiwFwsMsLDs5kwEnnNwIWz61h8OnIGAGLTCUY1K8Y
	CajvvA7tOz0AZj1rI+HYsgnA3DdzGHTM55OwztaMQ2N2LQ7He6tI+KhWj8Oaeh0G54yvebBu
	8h0PfsxsJGHDjz8kNJS34PDzsIUPW5fKcaizjvChzbFDwIH3NwLckfmJGaDNjWIcjRcW8FCv
	pYpABv06QJbKT3xkanCSaHjDiKPnjd6ooymXRMvNFQSamugn0cBjMx8VZK2SaKlom0SWLS0/
	WHxb4B/NJsSlsurTVyIEsRUP+0nVlGfaSvYXTAuG3fOAC8XQ5xn7RDfvnw8zjuk2Mg8IKBFd
	A5jpB/kkF4joHB5zXxfMmaRPMZ1bBsBZTGNMdelbwBUwepRgmgYHMC44SIcxE7++E5xx+hjj
	dKztLQjpQGbW/HLX1O6alKkq9ufoQgcx1nE5R9HuRWmLzACE1WBfEzjEqqJUmsiYRD9fjSJR
	k6KM8Y1KSuwAe49ckPQAkxYOAZoCsv1Ce31giIhQpGrSE4cAQ2EysbC9NChEJIxWpN9l1Unh
	6pQEVjME3ChcdkRo1126JaJjFMlsPMuqWPX/lEe5SLSA0c1IPYSh106eKFOEWrtvnltfzNCR
	utG+suObi/fA2SG51BP2YC19/j/FghKvMqlfPr9FZbnspPzdcuWu4bav9jjnTPKBBWTb7rka
	u+YuCbzoY03zGtx2j4jHcrIyeWEXnsybqyON8I68y6ewOaI9b7PVVenh8sHkPfpCLcM1sQo/
	b0ytUfwFwmrKGsQCAAA=
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies extcon_updata_state() function. There is greatly
simplified kobject_uevent preparation. Also meaning of variable passed
to raw_notifier_call_chain() (and in effect to _call_per_cable()) has
changed. Now positions on ones in variable 'val' in _call_per_cable()
indicates numbers of cables which changed their status. It allowed
to simplify also _call_per_cable() function.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-class.c |   81 ++++++++++++++++-------------------------
 include/linux/extcon.h        |    1 -
 2 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 2659805..ce76c08 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -206,59 +206,48 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 {
 	char name_buf[120];
 	char state_buf[120];
-	char *prop_buf;
+	char *tmp;
 	char *envp[3];
 	int env_offset = 0;
 	int length;
 	unsigned long flags;
+	u32 change;
 
 	spin_lock_irqsave(&edev->lock, flags);
 
-	if (edev->state != ((edev->state & ~mask) | (state & mask))) {
-		u32 old_state = edev->state;
-
-		if (check_mutually_exclusive(edev, (edev->state & ~mask) |
-						   (state & mask))) {
+	change = (edev->state & mask) ^ (state & mask);
+	if (change) {
+		if (check_mutually_exclusive(edev, edev->state ^ change)) {
 			spin_unlock_irqrestore(&edev->lock, flags);
 			return -EPERM;
 		}
 
-		edev->state &= ~mask;
-		edev->state |= state & mask;
-
-		raw_notifier_call_chain(&edev->nh, old_state, edev);
-		/* This could be in interrupt handler */
-		prop_buf = (char *)get_zeroed_page(GFP_ATOMIC);
-		if (prop_buf) {
-			length = name_show(&edev->dev, NULL, prop_buf);
-			if (length > 0) {
-				if (prop_buf[length - 1] == '\n')
-					prop_buf[length - 1] = 0;
-				snprintf(name_buf, sizeof(name_buf),
-					"NAME=%s", prop_buf);
-				envp[env_offset++] = name_buf;
-			}
-			length = state_show(&edev->dev, NULL, prop_buf);
-			if (length > 0) {
-				if (prop_buf[length - 1] == '\n')
-					prop_buf[length - 1] = 0;
-				snprintf(state_buf, sizeof(state_buf),
-					"STATE=%s", prop_buf);
-				envp[env_offset++] = state_buf;
-			}
-			envp[env_offset] = NULL;
-			/* Unlock early before uevent */
-			spin_unlock_irqrestore(&edev->lock, flags);
+		edev->state ^= change;
 
-			kobject_uevent_env(&edev->dev.kobj, KOBJ_CHANGE, envp);
-			free_page((unsigned long)prop_buf);
-		} else {
-			/* Unlock early before uevent */
-			spin_unlock_irqrestore(&edev->lock, flags);
+		raw_notifier_call_chain(&edev->nh, change, edev);
+
+		tmp = name_buf + sprintf(name_buf, "NAME=");
+		length = name_show(&edev->dev, NULL, tmp);
+		if (length > 0) {
+			if (tmp[length - 1] == '\n')
+				tmp[length - 1] = 0;
+			envp[env_offset++] = name_buf;
+		}
 
-			dev_err(&edev->dev, "out of memory in extcon_set_state\n");
-			kobject_uevent(&edev->dev.kobj, KOBJ_CHANGE);
+		tmp = state_buf + sprintf(state_buf, "STATE=");
+		length = state_show(&edev->dev, NULL, tmp);
+		if (length > 0) {
+			if (tmp[length - 1] == '\n')
+				tmp[length - 1] = 0;
+			envp[env_offset++] = state_buf;
 		}
+
+		envp[env_offset] = NULL;
+
+		/* Unlock early before uevent */
+		spin_unlock_irqrestore(&edev->lock, flags);
+
+		kobject_uevent_env(&edev->dev.kobj, KOBJ_CHANGE, envp);
 	} else {
 		/* No changes */
 		spin_unlock_irqrestore(&edev->lock, flags);
@@ -464,18 +453,10 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 {
 	struct extcon_cable_nb *obj = container_of(nb,
 			struct extcon_cable_nb, internal_nb);
-	struct extcon_dev *edev = ptr;
-
-	if ((val & (1 << obj->cable->cable_index)) !=
-			(edev->state & (1 << obj->cable->cable_index))) {
-		bool cable_state = true;
-
-		obj->previous_value = val;
-
-		if (val & (1 << obj->cable->cable_index))
-			cable_state = false;
 
-		return obj->notifier_function(obj, cable_state);
+	if ((1 << obj->cable->cable_index) & val) {
+		int state = extcon_get_cable_state(obj->cable);
+		return obj->notifier_function(obj, !!state);
 	}
 
 	return NOTIFY_OK;
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 939a7b0..4194931 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -177,7 +177,6 @@ typedef int (*extcon_notifier_fn_t)(struct extcon_cable_nb *cable_nb,
  */
 struct extcon_cable_nb {
 	struct notifier_block internal_nb;
-	unsigned long previous_value;
 	extcon_notifier_fn_t notifier_function;
 	struct extcon_cable *cable;
 };
-- 
1.7.9.5

