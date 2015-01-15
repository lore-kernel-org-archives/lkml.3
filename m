Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbbAOEdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:33:02 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbAOEc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:32:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Yijing Wang <wangyijing@huawei.com>, Sam Ravnborg <sam@ravnborg.org>,
        sparclinux@vger.kernel.org
Subject: [PATCH v2 10/10] PCI, sparc: clip firmware assigned resource under parent bridge's
Date: Wed, 14 Jan 2015 20:31:37 -0800
Message-Id: <1421296297-6371-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

We'd like to fix other arches instead of just x86.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index b36365f..9ce5afe 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -639,7 +639,10 @@ static void pci_claim_bus_resources(struct pci_bus *bus)
 				       (unsigned long long)r->end,
 				       (unsigned int)r->flags);
 
-			pci_claim_resource(dev, i);
+			if (pci_claim_resource(dev, i) == 0)
+				continue;
+
+			pci_claim_bridge_resource(dev, i);
 		}
 	}
 
-- 
1.8.4.5

