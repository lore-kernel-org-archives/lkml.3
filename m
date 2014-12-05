Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaLEXHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:07:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaLEXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maurizio Lombardi <mlombard@redhat.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.10 43/45] bnx2fc: do not add shared skbs to the fcoe_rx_list
Date: Fri,  5 Dec 2014 14:45:26 -0800
Message-Id: <20141205223323.612113292@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

commit 01a4cc4d0cd6a836c7b923760e8eb1cbb6a47258 upstream.

In some cases, the fcoe_rx_list may contains multiple instances
of the same skb (the so called "shared skbs").

the bnx2fc_l2_rcv thread is a loop that extracts a skb from the list,
modifies (and destroys) its content and then proceed to the next one.
The problem is that if the skb is shared, the remaining instances will
be corrupted.

The solution is to use skb_share_check() before adding the skb to the
fcoe_rx_list.

[ 6286.808725] ------------[ cut here ]------------
[ 6286.808729] WARNING: at include/scsi/fc_frame.h:173 bnx2fc_l2_rcv_thread+0x425/0x450 [bnx2fc]()
[ 6286.808748] Modules linked in: bnx2x(-) mdio dm_service_time bnx2fc cnic uio fcoe libfcoe 8021q garp stp mrp libfc llc scsi_transport_fc scsi_tgt sg iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel e1000e ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper ptp cryptd hpilo serio_raw hpwdt lpc_ich pps_core ipmi_si pcspkr mfd_core ipmi_msghandler shpchp pcc_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc dm_multipath xfs libcrc32c ata_generic pata_acpi sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit ata_piix drm_kms_helper ttm drm libata i2c_core hpsa dm_mirror dm_region_hash dm_log dm_mod [last unloaded: mdio]
[ 6286.808750] CPU: 3 PID: 1304 Comm: bnx2fc_l2_threa Not tainted 3.10.0-121.el7.x86_64 #1
[ 6286.808750] Hardware name: HP ProLiant DL120 G7, BIOS J01 07/01/2013
[ 6286.808752]  0000000000000000 000000000b36e715 ffff8800deba1e00 ffffffff815ec0ba
[ 6286.808753]  ffff8800deba1e38 ffffffff8105dee1 ffffffffa05618c0 ffff8801e4c81888
[ 6286.808754]  ffffe8ffff663868 ffff8801f402b180 ffff8801f56bc000 ffff8800deba1e48
[ 6286.808754] Call Trace:
[ 6286.808759]  [<ffffffff815ec0ba>] dump_stack+0x19/0x1b
[ 6286.808762]  [<ffffffff8105dee1>] warn_slowpath_common+0x61/0x80
[ 6286.808763]  [<ffffffff8105e00a>] warn_slowpath_null+0x1a/0x20
[ 6286.808765]  [<ffffffffa054f415>] bnx2fc_l2_rcv_thread+0x425/0x450 [bnx2fc]
[ 6286.808767]  [<ffffffffa054eff0>] ? bnx2fc_disable+0x90/0x90 [bnx2fc]
[ 6286.808769]  [<ffffffff81085aef>] kthread+0xcf/0xe0
[ 6286.808770]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
[ 6286.808772]  [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
[ 6286.808773]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
[ 6286.808774] ---[ end trace c6cdb939184ccb4e ]---

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -411,6 +411,7 @@ static int bnx2fc_rcv(struct sk_buff *sk
 	struct fc_frame_header *fh;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_percpu_s *bg;
+	struct sk_buff *tmp_skb;
 	unsigned short oxid;
 
 	interface = container_of(ptype, struct bnx2fc_interface,
@@ -423,6 +424,12 @@ static int bnx2fc_rcv(struct sk_buff *sk
 		goto err;
 	}
 
+	tmp_skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!tmp_skb)
+		goto err;
+
+	skb = tmp_skb;
+
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
 		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
 		goto err;


