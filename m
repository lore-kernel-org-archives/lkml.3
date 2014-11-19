Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbaKSWkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:40:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbaKSUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 015/141] net: ptp: fix time stamp matching logic for VLAN packets.
Date: Wed, 19 Nov 2014 12:50:38 -0800
Message-Id: <20141119205151.175240916@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

[ Upstream commit cca04b2854ecfb7cd1b8ee84ab38bc99af59f526 ]

Commit ae5c6c6d "ptp: Classify ptp over ip over vlan packets" changed the
code in two drivers that matches time stamps with PTP frames, with the goal
of allowing VLAN tagged PTP packets to receive hardware time stamps.

However, that commit failed to account for the VLAN header when parsing
IPv4 packets. This patch fixes those two drivers to correctly match VLAN
tagged IPv4/UDP PTP messages with their time stamps.

This patch should also be applied to v3.17.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpts.c |    2 +-
 drivers/net/phy/dp83640.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -264,7 +264,7 @@ static int cpts_match(struct sk_buff *sk
 
 	switch (ptp_class & PTP_CLASS_PMASK) {
 	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
 		break;
 	case PTP_CLASS_IPV6:
 		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -784,7 +784,7 @@ static int match(struct sk_buff *skb, un
 
 	switch (type & PTP_CLASS_PMASK) {
 	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
 		break;
 	case PTP_CLASS_IPV6:
 		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
@@ -927,7 +927,7 @@ static int is_sync(struct sk_buff *skb,
 
 	switch (type & PTP_CLASS_PMASK) {
 	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
 		break;
 	case PTP_CLASS_IPV6:
 		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;


