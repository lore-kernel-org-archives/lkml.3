Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaCEAfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:35:51 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60677 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbaCEAfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:35:46 -0500
Subject: [PATCH] phy: fix compiler array bounds warning on settings[]
To: netdev@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 17:35:44 -0700
Message-ID: <20140305003544.23016.55079.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With -Werror=array-bounds, gcc v4.7.x warns that in phy_find_valid(), the
settings[] "array subscript is above array bounds", I think because idx is
a signed integer and if the caller supplied idx < 0, we pass the guard but
still reference out of bounds.

Fix this by making idx unsigned here and elsewhere.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/net/phy/phy.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 19c9eca0ef26..76d96b9ebcdb 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -164,9 +164,9 @@ static const struct phy_setting settings[] = {
  *   of that setting.  Returns the index of the last setting if
  *   none of the others match.
  */
-static inline int phy_find_setting(int speed, int duplex)
+static inline unsigned int phy_find_setting(int speed, int duplex)
 {
-	int idx = 0;
+	unsigned int idx = 0;
 
 	while (idx < ARRAY_SIZE(settings) &&
 	       (settings[idx].speed != speed || settings[idx].duplex != duplex))
@@ -185,7 +185,7 @@ static inline int phy_find_setting(int speed, int duplex)
  *   the mask in features.  Returns the index of the last setting
  *   if nothing else matches.
  */
-static inline int phy_find_valid(int idx, u32 features)
+static inline unsigned int phy_find_valid(unsigned int idx, u32 features)
 {
 	while (idx < MAX_NUM_SETTINGS && !(settings[idx].setting & features))
 		idx++;
@@ -204,7 +204,7 @@ static inline int phy_find_valid(int idx, u32 features)
 static void phy_sanitize_settings(struct phy_device *phydev)
 {
 	u32 features = phydev->supported;
-	int idx;
+	unsigned int idx;
 
 	/* Sanitize settings based on PHY capabilities */
 	if ((features & SUPPORTED_Autoneg) == 0)
@@ -954,7 +954,8 @@ int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
 	    (phydev->interface == PHY_INTERFACE_MODE_RGMII))) {
 		int eee_lp, eee_cap, eee_adv;
 		u32 lp, cap, adv;
-		int idx, status;
+		int status;
+		unsigned int idx;
 
 		/* Read phy status to properly get the right settings */
 		status = phy_read_status(phydev);

