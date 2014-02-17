Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaBQSIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:08:10 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:25243
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbaBQSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:08:07 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzbb2dIe0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N15JPA-07-AN5-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <dougthompson@xmission.com>, <bp@alien8.de>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Date: Mon, 17 Feb 2014 11:49:51 -0600
Message-ID: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If MCE decoding support does not exist for a particular family/model,
and if one tries to inject errors using mce_amd_inj module, it leads
to kernel OOPS. Especially if we inject errors to MC0, MC1, MC2 banks.

Sample:
[   60.567808] [Hardware Error]: MC0 Error:
[   60.567826] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   60.567840] IP: [<ffffffffa0019f36>] amd_decode_mce+0x526/0x900 [edac_mce_amd]
[   60.567855] PGD ba665067 PUD 37168067 PMD 0
[   60.567865] Oops: 0000 [#1] SMP
[   60.567872] Modules linked in: mce_amd_inj amd64_edac_mod edac_core edac_mce_amd r8169
[   60.567889] CPU: 2 PID: 2011 Comm: sh Not tainted 3.14.0-rc3.spinoff_ML+ #7
[   60.567898] Hardware name: AMD Lamar/Lamar, BIOS WLA3904N_Weekly_13_09_0 09/04/2013
[   60.567907] task: ffff88040a58e040 ti: ffff8800bb206000 task.ti: ffff8800bb206000
[   60.567916] RIP: 0010:[<ffffffffa0019f36>]  [<ffffffffa0019f36>] amd_decode_mce+0x526/0x900 [edac_mce_amd]
[   60.567930] RSP: 0018:ffff8800bb207dc8  EFLAGS: 00010206
[   60.567937] RAX: 0000000000000000 RBX: ffffffffa0014300 RCX: 00000000000010a5
[   60.567945] RDX: 0000000000002825 RSI: 0000000000000001 RDI: 0000000000000f0f
[   60.567953] RBP: ffff8800bb207e48 R08: 0000000000000000 R09: 0000000000000370
[   60.567961] R10: ffffffff81a6ace0 R11: f000000000000000 R12: 0000000000012980
[   60.567968] R13: a000000000010f0f R14: 0000000000000001 R15: ffff88041fc00000
[   60.567978] FS:  00007f4709286700(0000) GS:ffff88041fd00000(0000) knlGS:0000000000000000
[   60.567988] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   60.567995] CR2: 0000000000000000 CR3: 00000000bb1b3000 CR4: 00000000000407e0
[   60.568003] Stack:
[   60.568007]  ffffea0000daa000 0000000000000000 ffff88040a592020 0000000000c504a8
[   60.568021]  ffff880409e7b6d0 ffff8800bb207e60 ffff88040d99aba0 ffff8800bb207e38
[   60.568033]  ffffffff813ce4fc 0000000a00000006 0000000000c504a8 0000000000000002
[   60.568045] Call Trace:
[   60.568059]  [<ffffffff813ce4fc>] ? _kstrtoull+0x2c/0x90
[   60.568069]  [<ffffffffa0012056>] edac_inject_bank_store+0x56/0x90 [mce_amd_inj]
[   60.568083]  [<ffffffff81272b10>] ? kernfs_fop_write+0x50/0x150
[   60.568094]  [<ffffffff813bc56f>] kobj_attr_store+0xf/0x20
[   60.568104]  [<ffffffff8126ee25>] sysfs_kf_write+0x45/0x60
[   60.568114]  [<ffffffff81272b9e>] kernfs_fop_write+0xde/0x150
[   60.568125]  [<ffffffff811fb422>] vfs_write+0xc2/0x1d0
[   60.568134]  [<ffffffff811fb8f2>] SyS_write+0x52/0xa0
[   60.568144]  [<ffffffff8184361e>] ? do_page_fault+0xe/0x10
[   60.568154]  [<ffffffff81848512>] system_call_fastpath+0x16/0x1b
[   60.568162] Code: c7 17 ba 01 a0 31 c0 4a 8b 34 ed e0 b3 01 a0 e8 12 64 81 e1 4c 8b 2b e9 3f fb ff ff 48 8b 05 7a 33 00 00 41 0f b6 f6 41 0f b7 fd <ff> 10 84 c0 0f 85 fc fd ff ff 48 c7 c7 28 c3 01 a0 31 c0 e8 e3
[   60.568228] RIP  [<ffffffffa0019f36>] amd_decode_mce+0x526/0x900 [edac_mce_amd]
[   60.568240]  RSP <ffff8800bb207dc8>
[   60.568245] CR2: 0000000000000000
[   60.568252] ---[ end trace 6ba951fb82ecbc10 ]---

In this patch, we fix the bug by checking if fam_ops struct has been
alloc-ed before we proceed with fam/model specific decoding.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/mce_amd.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 30f7309..9b03daa 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -281,6 +281,12 @@ static void decode_mc0_mce(struct mce *m)
 
 	pr_emerg(HW_ERR "MC0 Error: ");
 
+	if (!fam_ops) {
+		pr_err("fam_ops structure not alloc-ed."
+		       " Cannot provide detailed family/model"
+		       " specific error decoding.\n");
+		return;
+	}
 	/* TLB error signatures are the same across families */
 	if (TLB_ERROR(ec)) {
 		if (TT(ec) == TT_DATA) {
@@ -391,6 +397,12 @@ static void decode_mc1_mce(struct mce *m)
 
 	pr_emerg(HW_ERR "MC1 Error: ");
 
+	if (!fam_ops) {
+		pr_err("fam_ops structure not alloc-ed."
+		       " Cannot provide detailed family/model"
+		       " specific error decoding.\n");
+		return;
+	}
 	if (TLB_ERROR(ec))
 		pr_cont("%s TLB %s.\n", LL_MSG(ec),
 			(xec ? "multimatch" : "parity error"));
@@ -522,6 +534,12 @@ static void decode_mc2_mce(struct mce *m)
 
 	pr_emerg(HW_ERR "MC2 Error: ");
 
+	if (!fam_ops) {
+		pr_err("fam_ops structure not alloc-ed."
+		       " Cannot provide detailed family/model"
+		       " specific error decoding.\n");
+		return;
+	}
 	if (!fam_ops->mc2_mce(ec, xec))
 		pr_cont(HW_ERR "Corrupted MC2 MCE info?\n");
 }
-- 
1.7.10.4


