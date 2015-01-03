Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbbACAep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 19:34:45 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:57989 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbbACAen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 19:34:43 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] arch: arm: mach-omap2: voltage:  Remove some unused functions
Date: Sat,  3 Jan 2015 01:37:43 +0100
Message-Id: <1420245463-5511-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
omap_change_voltscale_method() voltdm_add_pwrdm()
voltdm_for_each() voltdm_for_each_pwrdm()

And remove define VOLTSCALE_VPFORCEUPDATE and VOLTSCALE_VCBYPASS

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap2/powerdomain.c |    1 -
 arch/arm/mach-omap2/voltage.c     |  110 -------------------------------------
 arch/arm/mach-omap2/voltage.h     |   13 -----
 3 files changed, 124 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index 7fb033e..20fae59 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -115,7 +115,6 @@ static int _pwrdm_register(struct powerdomain *pwrdm)
 	}
 	pwrdm->voltdm.ptr = voltdm;
 	INIT_LIST_HEAD(&pwrdm->voltdm_node);
-	voltdm_add_pwrdm(voltdm, pwrdm);
 skip_voltdm:
 	spin_lock_init(&pwrdm->_lock);
 
diff --git a/arch/arm/mach-omap2/voltage.c b/arch/arm/mach-omap2/voltage.c
index 3783b86..cba8cad 100644
--- a/arch/arm/mach-omap2/voltage.c
+++ b/arch/arm/mach-omap2/voltage.c
@@ -224,37 +224,6 @@ int omap_voltage_register_pmic(struct voltagedomain *voltdm,
 }
 
 /**
- * omap_change_voltscale_method() - API to change the voltage scaling method.
- * @voltdm:	pointer to the VDD whose voltage scaling method
- *		has to be changed.
- * @voltscale_method:	the method to be used for voltage scaling.
- *
- * This API can be used by the board files to change the method of voltage
- * scaling between vpforceupdate and vcbypass. The parameter values are
- * defined in voltage.h
- */
-void omap_change_voltscale_method(struct voltagedomain *voltdm,
-				  int voltscale_method)
-{
-	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warn("%s: VDD specified does not exist!\n", __func__);
-		return;
-	}
-
-	switch (voltscale_method) {
-	case VOLTSCALE_VPFORCEUPDATE:
-		voltdm->scale = omap_vp_forceupdate_scale;
-		return;
-	case VOLTSCALE_VCBYPASS:
-		voltdm->scale = omap_vc_bypass_scale;
-		return;
-	default:
-		pr_warn("%s: Trying to change the method of voltage scaling to an unsupported one!\n",
-			__func__);
-	}
-}
-
-/**
  * omap_voltage_late_init() - Init the various voltage parameters
  *
  * This API is to be called in the later stages of the
@@ -316,90 +285,11 @@ static struct voltagedomain *_voltdm_lookup(const char *name)
 	return voltdm;
 }
 
-/**
- * voltdm_add_pwrdm - add a powerdomain to a voltagedomain
- * @voltdm: struct voltagedomain * to add the powerdomain to
- * @pwrdm: struct powerdomain * to associate with a voltagedomain
- *
- * Associate the powerdomain @pwrdm with a voltagedomain @voltdm.  This
- * enables the use of voltdm_for_each_pwrdm().  Returns -EINVAL if
- * presented with invalid pointers; -ENOMEM if memory could not be allocated;
- * or 0 upon success.
- */
-int voltdm_add_pwrdm(struct voltagedomain *voltdm, struct powerdomain *pwrdm)
-{
-	if (!voltdm || !pwrdm)
-		return -EINVAL;
-
-	pr_debug("voltagedomain: %s: associating powerdomain %s\n",
-		 voltdm->name, pwrdm->name);
-
-	list_add(&pwrdm->voltdm_node, &voltdm->pwrdm_list);
-
-	return 0;
-}
-
-/**
- * voltdm_for_each_pwrdm - call function for each pwrdm in a voltdm
- * @voltdm: struct voltagedomain * to iterate over
- * @fn: callback function *
- *
- * Call the supplied function @fn for each powerdomain in the
- * voltagedomain @voltdm.  Returns -EINVAL if presented with invalid
- * pointers; or passes along the last return value of the callback
- * function, which should be 0 for success or anything else to
- * indicate failure.
- */
-int voltdm_for_each_pwrdm(struct voltagedomain *voltdm,
-			  int (*fn)(struct voltagedomain *voltdm,
-				    struct powerdomain *pwrdm))
-{
-	struct powerdomain *pwrdm;
-	int ret = 0;
-
-	if (!fn)
-		return -EINVAL;
-
-	list_for_each_entry(pwrdm, &voltdm->pwrdm_list, voltdm_node)
-		ret = (*fn)(voltdm, pwrdm);
-
-	return ret;
-}
-
-/**
- * voltdm_for_each - call function on each registered voltagedomain
- * @fn: callback function *
- *
- * Call the supplied function @fn for each registered voltagedomain.
- * The callback function @fn can return anything but 0 to bail out
- * early from the iterator.  Returns the last return value of the
- * callback function, which should be 0 for success or anything else
- * to indicate failure; or -EINVAL if the function pointer is null.
- */
-int voltdm_for_each(int (*fn)(struct voltagedomain *voltdm, void *user),
-		    void *user)
-{
-	struct voltagedomain *temp_voltdm;
-	int ret = 0;
-
-	if (!fn)
-		return -EINVAL;
-
-	list_for_each_entry(temp_voltdm, &voltdm_list, node) {
-		ret = (*fn)(temp_voltdm, user);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
 static int _voltdm_register(struct voltagedomain *voltdm)
 {
 	if (!voltdm || !voltdm->name)
 		return -EINVAL;
 
-	INIT_LIST_HEAD(&voltdm->pwrdm_list);
 	list_add(&voltdm->node, &voltdm_list);
 
 	pr_debug("voltagedomain: registered %s\n", voltdm->name);
diff --git a/arch/arm/mach-omap2/voltage.h b/arch/arm/mach-omap2/voltage.h
index f7f2879..e645503 100644
--- a/arch/arm/mach-omap2/voltage.h
+++ b/arch/arm/mach-omap2/voltage.h
@@ -23,10 +23,6 @@
 
 struct powerdomain;
 
-/* XXX document */
-#define VOLTSCALE_VPFORCEUPDATE		1
-#define VOLTSCALE_VCBYPASS		2
-
 /*
  * OMAP3 GENERIC setup times. Revisit to see if these needs to be
  * passed from board or PMIC file
@@ -55,7 +51,6 @@ struct omap_vfsm_instance {
  * @name: Name of the voltage domain which can be used as a unique identifier.
  * @scalable: Whether or not this voltage domain is scalable
  * @node: list_head linking all voltage domains
- * @pwrdm_list: list_head linking all powerdomains in this voltagedomain
  * @vc: pointer to VC channel associated with this voltagedomain
  * @vp: pointer to VP associated with this voltagedomain
  * @read: read a VC/VP register
@@ -71,7 +66,6 @@ struct voltagedomain {
 	char *name;
 	bool scalable;
 	struct list_head node;
-	struct list_head pwrdm_list;
 	struct omap_vc_channel *vc;
 	const struct omap_vfsm_instance *vfsm;
 	struct omap_vp_instance *vp;
@@ -163,8 +157,6 @@ struct omap_volt_data *omap_voltage_get_voltdata(struct voltagedomain *voltdm,
 		unsigned long volt);
 int omap_voltage_register_pmic(struct voltagedomain *voltdm,
 			       struct omap_voltdm_pmic *pmic);
-void omap_change_voltscale_method(struct voltagedomain *voltdm,
-		int voltscale_method);
 int omap_voltage_late_init(void);
 
 extern void omap2xxx_voltagedomains_init(void);
@@ -175,11 +167,6 @@ extern void omap54xx_voltagedomains_init(void);
 struct voltagedomain *voltdm_lookup(const char *name);
 void voltdm_init(struct voltagedomain **voltdm_list);
 int voltdm_add_pwrdm(struct voltagedomain *voltdm, struct powerdomain *pwrdm);
-int voltdm_for_each(int (*fn)(struct voltagedomain *voltdm, void *user),
-		    void *user);
-int voltdm_for_each_pwrdm(struct voltagedomain *voltdm,
-			  int (*fn)(struct voltagedomain *voltdm,
-				    struct powerdomain *pwrdm));
 int voltdm_scale(struct voltagedomain *voltdm, unsigned long target_volt);
 void voltdm_reset(struct voltagedomain *voltdm);
 unsigned long voltdm_get_voltage(struct voltagedomain *voltdm);
-- 
1.7.10.4

