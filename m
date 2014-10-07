Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaJGPsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:48:02 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38510 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaJGPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:47:59 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c4-54340b2d3cab
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/2] power_supply: Add no_thermal property to prevent
 recursive get_temp calls
Date: Tue, 07 Oct 2014 17:47:36 +0200
Message-id: <1412696857-14803-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xK7q63CYhBhc65C0ObtW02DhjPavF
	9S/PWS0mPXnPbDFx5WRmi86zT5gtXr8wtDjb9Ibd4vKuOWwWn3uPMFqsPXKX3eJ24wo2i9O7
	Sxx4PSb0f2L02DnrLrvH5hVaHptWdbJ59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aEn39Z
	Cs4KVPzc2snSwHiHt4uRg0NCwETicKddFyMnkCkmceHeerYuRi4OIYGljBLNu3axQzh9TBLL
	7k9jAaliEzCW2Lx8CViViMAtJom9ezewgDjMAkcZJab3vmUCqRIWSJZ4euMYM4jNIqAqce7c
	XrA4r4C7ROf/u0wQ++QkTh6bzDqBkXsBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJAw
	+7qDcekxq0OMAhyMSjy8K7SMQ4RYE8uKK3MPMUpwMCuJ8E7lNAkR4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwKhsv31fYcHfpmO9THe5PwU+UV207Z7CDds96VOuavAuZbme5NMmusRrJrcEl6Tx
	rMRoHbGjqi4T/F+XnX1w81TtFKdpu9y18s84rnV4Vutw5EwUz4a3FU6hx/pPTgiSW/CCb8Xf
	c6y3rCf6XXktVPvn9c9e4fI7RlZT1dQdhPomnI2akhaoL63EUpyRaKjFXFScCAClVsKQEQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'no_thermal' property to the power supply class. If true then
thermal zone won't be created for this power supply in
power_supply_register().

Power supply drivers may want to set it if they support
POWER_SUPPLY_PROP_TEMP and they are forwarding this get property call to
other thermal zone.

If they won't set it lockdep may report false positive deadlock for
thermal zone's mutex because of nested calls to thermal_zone_get_temp().
First is the call to thermal_zone_get_temp() of the driver's thermal
zone. Thermal core gets POWER_SUPPLY_PROP_TEMP property from this
driver. The driver then calls other thermal zone thermal_zone_get_temp()
and returns result.

Example of such driver is charger manager.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. New patch (new idea).
---
 drivers/power/power_supply_core.c | 3 +++
 include/linux/power_supply.h      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 6cb7fe5c022d..694e8cddd5c1 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -417,6 +417,9 @@ static int psy_register_thermal(struct power_supply *psy)
 {
 	int i;
 
+	if (psy->no_thermal)
+		return 0;
+
 	/* Register battery zone device psy reports temperature */
 	for (i = 0; i < psy->num_properties; i++) {
 		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 3ed049673022..096dbced02ac 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -200,6 +200,12 @@ struct power_supply {
 	void (*external_power_changed)(struct power_supply *psy);
 	void (*set_charged)(struct power_supply *psy);
 
+	/*
+	 * Set if thermal zone should not be created for this power supply.
+	 * For example for virtual supplies forwarding calls to actual
+	 * sensors or other supplies.
+	 */
+	bool no_thermal;
 	/* For APM emulation, think legacy userspace. */
 	int use_for_apm;
 
-- 
1.9.1

