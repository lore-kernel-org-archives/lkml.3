Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbaCDV0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:26:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbaCDUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell Senior <russell@personaltelco.net>,
        Daniel <daniel@makrotopia.org>, cmsv <cmsv@wirelesspt.net>,
        Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 065/172] batman-adv: release vlan object after checking the CRC
Date: Tue,  4 Mar 2014 12:02:29 -0800
Message-Id: <20140304200301.812751515@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@meshcoding.com>

[ Upstream commit 91c2b1a9f680ff105369d49abc7e19ca7efb33e1 ]

There is a refcounter unbalance in the CRC checking routine
invoked on OGM reception. A vlan object is retrieved (thus
its refcounter is increased by one) but it is never properly
released. This leads to a memleak because the vlan object
will never be free'd.

Fix this by releasing the vlan object after having read the
CRC.

Reported-by: Russell Senior <russell@personaltelco.net>
Reported-by: Daniel <daniel@makrotopia.org>
Reported-by: cmsv <cmsv@wirelesspt.net>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -2248,6 +2248,7 @@ static bool batadv_tt_global_check_crc(s
 {
 	struct batadv_tvlv_tt_vlan_data *tt_vlan_tmp;
 	struct batadv_orig_node_vlan *vlan;
+	uint32_t crc;
 	int i;
 
 	/* check if each received CRC matches the locally stored one */
@@ -2267,7 +2268,10 @@ static bool batadv_tt_global_check_crc(s
 		if (!vlan)
 			return false;
 
-		if (vlan->tt.crc != ntohl(tt_vlan_tmp->crc))
+		crc = vlan->tt.crc;
+		batadv_orig_node_vlan_free_ref(vlan);
+
+		if (crc != ntohl(tt_vlan_tmp->crc))
 			return false;
 	}
 


