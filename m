Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3FYUze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:55:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:29038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3FYUzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,939,1363158000"; 
   d="scan'208";a="335434114"
From: "Love, Robert W" <robert.w.love@intel.com>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: fcoe pull request for 3.9-rc
Thread-Topic: fcoe pull request for 3.9-rc
Thread-Index: AQHOceZTUhudfXOeMUiQto/NC5I3wQ==
Date: Tue, 25 Jun 2013 20:55:30 +0000
Message-ID: <51CA03C1.1040901@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <BD103AD665EDD848B3732F06C1EDA6D8@intel.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1e876e3b1a9df25bb04682b0d48aaa7e8ae1fc82:

   Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2013-06-25 
09:08:07 -1000)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/critical_fix_for_3.9

for you to fetch changes up to 2884d4230867c8a46cf701214051e923301e7429:

   fcoe: Use correct API to set vlan tag for FCoE Ethertype skbs 
(2013-06-25 12:23:19 -0700)

----------------------------------------------------------------
This patch fixes a critical bug that was introduced in 3.9
related to VLAN tagging FCoE frames.

----------------------------------------------------------------
Robert Love (1):
       fcoe: Use correct API to set vlan tag for FCoE Ethertype skbs

  drivers/scsi/fcoe/fcoe.c |    7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 292b24f..32ae6c6 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1656,9 +1656,12 @@ static int fcoe_xmit(struct fc_lport *lport, 
struct fc_frame *fp)

      if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN &&
          fcoe->realdev->features & NETIF_F_HW_VLAN_CTAG_TX) {
-        skb->vlan_tci = VLAN_TAG_PRESENT |
-                vlan_dev_vlan_id(fcoe->netdev);
+        /* must set skb->dev before calling vlan_put_tag */
          skb->dev = fcoe->realdev;
+        skb = __vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+                         vlan_dev_vlan_id(fcoe->netdev));
+        if (!skb)
+            return -ENOMEM;
      } else
          skb->dev = fcoe->netdev;

