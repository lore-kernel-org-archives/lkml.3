Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3HXPtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:49:18 -0400
Received: from [213.199.154.189] ([213.199.154.189]:35111 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab3HXPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:49:15 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 12
X-BigFish: VPS12(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz70kd2iz1de098h177df4h17326ah186068h8275eh8275bh1de097h3284oa1495iz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
X-WSS-ID: 0MS1L35-07-C67-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 1/1 V2] AMD64_EDAC: Fix incorrect wrap arounds due to left shift beyond 32 bits.
Date: Sat, 24 Aug 2013 10:47:48 -0500
Message-ID: <1377359268-3435-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Link to the bug report:
http://marc.info/?l=linux-edac&m=137692201732220&w=2

dct_base and dct_limit obtain 32 bit register values when they read
their respective pci config space registers. A left shift beyond 32 bits will
cause them to wrap around. Similar case for chan_addr as can be seen from
the bug report. In the patch, we rectify this by casting chan_addr to
u64 and by comparing dct_base and dct_limit against (sys_addr >> 27)

Change from V1:
	- Fix chan_offset to use left-shifted version of dct_base.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b86228c..64cfcaf 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1558,11 +1558,12 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	}
 
 	/* Verify sys_addr is within DCT Range. */
-	dct_base = (dct_sel_baseaddr(pvt) << 27);
-	dct_limit = (((dct_cont_limit_reg >> 11) & 0x1FFF) << 27) | 0x7FFFFFF;
+	dct_base = (u64) dct_sel_baseaddr(pvt);
+	dct_limit = (dct_cont_limit_reg >> 11) & 0x1FFF;
 
 	if (!(dct_cont_base_reg & BIT(0)) &&
-	    !(dct_base <= sys_addr && dct_limit >= sys_addr))
+	    !(dct_base <= (sys_addr >> 27) &&
+	      dct_limit >= (sys_addr >> 27)))
 		return -EINVAL;
 
 	/* Verify number of dct's that participate in channel interleaving. */
@@ -1584,7 +1585,7 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	if (leg_mmio_hole && (sys_addr >= BIT_64(32)))
 		chan_offset = dhar_offset;
 	else
-		chan_offset = dct_base;
+		chan_offset = dct_base << 27;
 
 	chan_addr = sys_addr - chan_offset;
 
@@ -1614,7 +1615,7 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 		amd64_read_pci_cfg(pvt->F1,
 				   DRAM_CONT_HIGH_OFF + (int) channel * 4,
 				   &tmp);
-		chan_addr +=  ((tmp >> 11) & 0xfff) << 27;
+		chan_addr +=  (u64) ((tmp >> 11) & 0xfff) << 27;
 	}
 
 	f15h_select_dct(pvt, channel);
-- 
1.7.10.4


