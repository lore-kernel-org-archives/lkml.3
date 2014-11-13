Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbaKMXhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:37:52 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:43956 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933762AbaKMXhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:37:51 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: matthew.vick@intel.com, jeffrey.t.kirsher@intel.com, linux.nics@intel.com,
        therbert@google.com, gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 net 1/2] fm10k: Check tunnel header length in encap offload
Date: Thu, 13 Nov 2014 15:36:40 -0800
Message-Id: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fm10k supports up to 184 bytes of inner+outer headers. Add an initial
check to fail encap offload if these are too large.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
Matthew, I didn't see the equivalent patch on netdev so I went ahead and
created it. If I've missed this somewhere, then please disregard.

v2: First post.
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index e645af4..3a85291 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -732,6 +732,12 @@ static __be16 fm10k_tx_encap_offload(struct sk_buff *skb)
 	struct ethhdr *eth_hdr;
 	u8 l4_hdr = 0;
 
+/* fm10k supports 184 octets of outer+inner headers. Minus 20 for inner L4. */
+#define FM10K_MAX_ENCAP_TRANSPORT_OFFSET	164
+	if (skb_inner_transport_header(skb) - skb_mac_header(skb) >
+	    FM10K_MAX_ENCAP_TRANSPORT_OFFSET)
+		return 0;
+
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
 		l4_hdr = ip_hdr(skb)->protocol;
-- 
1.7.10.4

