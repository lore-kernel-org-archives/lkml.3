Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3BIRBC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:01:02 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:59575 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760759Ab3BIRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:01:00 -0500
Message-ID: <511680CB.9010502@linux-ipv6.org>
Date: Sun, 10 Feb 2013 02:00:59 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: fengguang.wu@intel.com, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next] net neighbour,decnet: Ensure to align device private
 data on preferred alignment.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow both of protocol-specific data and device-specific data
attached with neighbour entry, and to eliminate size calculation
cost when allocating entry, sizeof protocol-speicic data must be
multiple of NEIGH_PRIV_ALIGN.  On 64bit archs,
sizeof(struct dn_neigh) is multiple of NEIGH_PRIV_ALIGN, but on
32bit archs, it was not.

Introduce NEIGH_ENTRY_SPACE() macro to ensure that protocol-specific
entry-size meets our requirement.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 include/net/neighbour.h |    1 +
 net/decnet/dn_neigh.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 629ee57..7e748ad 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -181,6 +181,7 @@ struct neigh_table {
 };
 
 #define NEIGH_PRIV_ALIGN	sizeof(long long)
+#define NEIGH_ENTRY_SIZE(size)	ALIGN((size), NEIGH_PRIV_ALIGN)
 
 static inline void *neighbour_priv(const struct neighbour *n)
 {
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 3aede1b..856636a 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -95,7 +95,7 @@ static u32 dn_neigh_hash(const void *pkey,
 
 struct neigh_table dn_neigh_table = {
 	.family =			PF_DECnet,
-	.entry_size =			sizeof(struct dn_neigh),
+	.entry_size =			NEIGH_ENTRY_SIZE(sizeof(struct dn_neigh)),
 	.key_len =			sizeof(__le16),
 	.hash =				dn_neigh_hash,
 	.constructor =			dn_neigh_construct,
-- 
1.7.9.5

