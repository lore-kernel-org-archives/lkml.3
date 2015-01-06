Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbbAFCy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:54:56 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33470 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbAFCyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:54:53 -0500
From: David Decotigny <ddecotig@gmail.com>
To: Amir Vadai <amirv@mellanox.com>, Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Ben Hutchings <ben@decadent.org.uk>,
        Masatake YAMATO <yamato@redhat.com>, Xi Wang <xii@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Subject: [PATCH net-next v2 1/8] net: ethtool: internal compatibility flags to reject non-zero reserved fields
Date: Mon,  5 Jan 2015 18:54:03 -0800
Message-Id: <1420512850-24699-2-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1420512850-24699-1-git-send-email-ddecotig@gmail.com>
References: <1420512850-24699-1-git-send-email-ddecotig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

The public ethtool API progressively shrinks "reserved" fields to
expand some other fields (eg. link mode masks). This patch allows
drivers to declare that they fully support expanded fields. When they
don't do so, the generic ethtool layer may reject (-EINVAL) userspace
requests that assign values utilizing the newly allocated areas in
these expanded fields (ie. when some reserved field receives != 0).

Signed-off-by: David Decotigny <decot@googlers.com>
---
 include/linux/ethtool.h      | 19 +++++++++++++++++--
 include/uapi/linux/ethtool.h |  6 +++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 653dc9c..dcb08c1 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -44,6 +44,17 @@ extern int __ethtool_get_settings(struct net_device *dev,
 				  struct ethtool_cmd *cmd);
 
 /**
+ * enum ethtool_compat_flags - bit indices used for %get_compat_flags() bitmaps
+ * @__ETHTOOL_COMPAT_PLACEHOLDER_BIT: to avoid a compiler error,
+ *                                    superseded by next patches
+ */
+enum ethtool_compat_flags {
+	__ETHTOOL_COMPAT_PLACEHOLDER_BIT,
+};
+
+#define __ETH_COMPAT_MASK(name)	(1UL << (ETHTOOL_COMPAT_ ## name ## _BIT))
+
+/**
  * enum ethtool_phys_id_state - indicator state for physical identification
  * @ETHTOOL_ID_INACTIVE: Physical ID indicator should be deactivated
  * @ETHTOOL_ID_ACTIVE: Physical ID indicator should be activated
@@ -99,6 +110,11 @@ static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
 
 /**
  * struct ethtool_ops - optional netdev operations
+ * @get_compat_flags: Internal function. Returns the internal ethtool
+ *      compatibility flags: in the absence of this method, or of
+ *      specific compatilibilty flags, the generic layer enforces
+ *      additional constraints on the user space values before
+ *      calling the callbacks below.
  * @get_settings: Get various device settings including Ethernet link
  *	settings. The @cmd parameter is expected to have been cleared
  *	before get_settings is called. Returns a negative error code or
@@ -279,7 +295,6 @@ struct ethtool_ops {
 			       const struct ethtool_tunable *, void *);
 	int	(*set_tunable)(struct net_device *,
 			       const struct ethtool_tunable *, const void *);
-
-
+	u32	(*get_compat_flags)(struct net_device *);
 };
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 5f66d9c..d063368 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -88,7 +88,8 @@
  * other than @cmd that are not described as read-only or deprecated,
  * and must ignore all fields described as read-only.
  *
- * Deprecated fields should be ignored by both users and drivers.
+ * Deprecated and reserved fields should be ignored by both users and
+ * drivers. If reserved fields must be set, store the value 0 in them.
  */
 struct ethtool_cmd {
 	__u32	cmd;
@@ -300,6 +301,9 @@ struct ethtool_eeprom {
  * @tx_lpi_timer: Time in microseconds the interface delays prior to asserting
  *	its tx lpi (after reaching 'idle' state). Effective only when eee
  *	was negotiated and tx_lpi_enabled was set.
+ *
+ * Deprecated and reserved fields should be ignored by both users and
+ * drivers. If reserved fields must be set, store the value 0 in them.
  */
 struct ethtool_eee {
 	__u32	cmd;
-- 
2.2.0.rc0.207.ga3a616c

