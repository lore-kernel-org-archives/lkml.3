Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaAIQOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:14:38 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:48999 "EHLO viti.kaiser.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaAIQOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:14:30 -0500
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 11:14:30 EST
Date: Thu, 9 Jan 2014 16:59:09 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH -next] qlcnic: fix compiler warning
Message-ID: <20140109155908.GA4351@reykholt.kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an explicit cast to fix the following warning
(seen on Debian Wheezy, gcc 4.7.2)

CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/trx.o
    drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c: In function ‘qlcnic_send_filter’:
    drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:349:3: warning:
    passing argument 2 of ‘ether_addr_equal’ from incompatible pointer type [enabled by default]
    In file included from include/linux/if_vlan.h:16:0,
    from drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:9:
    include/linux/etherdevice.h:244:20: note: expected ‘const u8 *’ but argument is of type ‘u64 *’

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 6373f60..3557154 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -346,7 +346,7 @@ static void qlcnic_send_filter(struct qlcnic_adapter *adapter,
 	head = &(adapter->fhash.fhead[hindex]);
 
 	hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
-		if (ether_addr_equal(tmp_fil->faddr, &src_addr) &&
+		if (ether_addr_equal(tmp_fil->faddr, (const u8 *)&src_addr) &&
 		    tmp_fil->vlan_id == vlan_id) {
 			if (jiffies > (QLCNIC_READD_AGE * HZ + tmp_fil->ftime))
 				qlcnic_change_filter(adapter, &src_addr,
-- 
1.7.10.4

