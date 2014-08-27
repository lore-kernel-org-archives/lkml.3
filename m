Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987AbaH0Sz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:55:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58561 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935477AbaH0SzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:55:24 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Paul Walmsley <paul@pwsan.com>, Tero Kristo <t-kristo@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <j-keerthy@ti.com>,
        <bcousson@baylibre.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 4/7] ARM: OMAP2+: powerdomain: introduce logic for finding valid power domain
Date: Wed, 27 Aug 2014 13:54:54 -0500
Message-ID: <1409165694-26568-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerdomain configuration in OMAP is done using PWRSTCTRL register for
each power domain. However, PRCM lets us write any value we'd like to
the logic and power domain target states, however the SoC integration
tends to actually function only at a few discrete states. These valid
states are already in our powerdomains_xxx_data.c file.

So, provide a function to easily query valid low power state that the
power domain is allowed to go to.

Based on work originally done by Jean Pihet <j-pihet@ti.com>
https://patchwork.kernel.org/patch/1325091/ . There is no attempt to
create a new powerdomain solution here, except fixing issues seen
attempting invalid programming attempts. Future consolidation to the
generic powerdomain framework should consider this requirement as
well.

Similar solutions have been done in product kernels in the past such
as:
https://android.googlesource.com/kernel/omap.git/+blame/android-omap-panda-3.0/arch/arm/mach-omap2/pm44xx.c

Reviewed-by: Kevin Hilman <khilman@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Not posting the entire series again and updating just this patch..

V2: drop BUG in favor of WARN, picked up Santosh and Kevin's acks.

V1: https://patchwork.kernel.org/patch/4764131/

 arch/arm/mach-omap2/powerdomain.c |   76 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/powerdomain.h |    3 ++
 2 files changed, 79 insertions(+)

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index f391948..7fb033e 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -1081,6 +1081,82 @@ int pwrdm_post_transition(struct powerdomain *pwrdm)
 }
 
 /**
+ * pwrdm_get_valid_lp_state() - Find best match deep power state
+ * @pwrdm:	power domain for which we want to find best match
+ * @is_logic_state: Are we looking for logic state match here? Should
+ *		    be one of PWRDM_xxx macro values
+ * @req_state:	requested power state
+ *
+ * Returns: closest match for requested power state. default fallback
+ * is RET for logic state and ON for power state.
+ *
+ * This does a search from the power domain data looking for the
+ * closest valid power domain state that the hardware can achieve.
+ * PRCM definitions for PWRSTCTRL allows us to program whatever
+ * configuration we'd like, and PRCM will actually attempt such
+ * a transition, however if the powerdomain does not actually support it,
+ * we endup with a hung system. The valid power domain states are already
+ * available in our powerdomain data files. So this function tries to do
+ * the following:
+ * a) find if we have an exact match to the request - no issues.
+ * b) else find if a deeper power state is possible.
+ * c) failing which, it tries to find closest higher power state for the
+ * request.
+ */
+u8 pwrdm_get_valid_lp_state(struct powerdomain *pwrdm,
+			    bool is_logic_state, u8 req_state)
+{
+	u8 pwrdm_states = is_logic_state ? pwrdm->pwrsts_logic_ret :
+			pwrdm->pwrsts;
+	/* For logic, ret is highest and others, ON is highest */
+	u8 default_pwrst = is_logic_state ? PWRDM_POWER_RET : PWRDM_POWER_ON;
+	u8 new_pwrst;
+	bool found;
+
+	/* If it is already supported, nothing to search */
+	if (pwrdm_states & BIT(req_state))
+		return req_state;
+
+	if (!req_state)
+		goto up_search;
+
+	/*
+	 * So, we dont have a exact match
+	 * Can we get a deeper power state match?
+	 */
+	new_pwrst = req_state - 1;
+	found = true;
+	while (!(pwrdm_states & BIT(new_pwrst))) {
+		/* No match even at OFF? Not available */
+		if (new_pwrst == PWRDM_POWER_OFF) {
+			found = false;
+			break;
+		}
+		new_pwrst--;
+	}
+
+	if (found)
+		goto done;
+
+up_search:
+	/* OK, no deeper ones, can we get a higher match? */
+	new_pwrst = req_state + 1;
+	while (!(pwrdm_states & BIT(new_pwrst))) {
+		if (new_pwrst > PWRDM_POWER_ON) {
+			WARN(1, "powerdomain: %s: Fix max powerstate to ON\n",
+			     pwrdm->name);
+			return PWRDM_POWER_ON;
+		}
+
+		if (new_pwrst == default_pwrst)
+			break;
+		new_pwrst++;
+	}
+done:
+	return new_pwrst;
+}
+
+/**
  * omap_set_pwrdm_state - change a powerdomain's current power state
  * @pwrdm: struct powerdomain * to change the power state of
  * @pwrst: power state to change to
diff --git a/arch/arm/mach-omap2/powerdomain.h b/arch/arm/mach-omap2/powerdomain.h
index a754c82..11bd4dd 100644
--- a/arch/arm/mach-omap2/powerdomain.h
+++ b/arch/arm/mach-omap2/powerdomain.h
@@ -220,6 +220,9 @@ struct voltagedomain *pwrdm_get_voltdm(struct powerdomain *pwrdm);
 
 int pwrdm_get_mem_bank_count(struct powerdomain *pwrdm);
 
+u8 pwrdm_get_valid_lp_state(struct powerdomain *pwrdm,
+			    bool is_logic_state, u8 req_state);
+
 int pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst);
 int pwrdm_read_next_pwrst(struct powerdomain *pwrdm);
 int pwrdm_read_pwrst(struct powerdomain *pwrdm);
-- 
1.7.9.5

