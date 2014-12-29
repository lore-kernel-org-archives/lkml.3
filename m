Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaL2OfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:35:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38668 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaL2OfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:35:20 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e1-54a166a7e8d8
From: Zbigniew Jasinski <z.jasinski@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] smack: Fix a bidirectional UDS connect check typo
Date: Mon, 29 Dec 2014 15:34:58 +0100
Message-id: <1419863698-29558-1-git-send-email-z.jasinski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xK7rL0xaGGDw4zGhxb9svNou+x0EW
	l3fNYbP40POIzeL8hXPsDqwe13ZHenx8eovF4+j+RWwenzfJBbBEcdmkpOZklqUW6dslcGU8
	vSJZ0M5V8WjeLpYGxnkcXYycHBICJhJLHl5mhLDFJC7cW8/WxcjFISSwlFHi795bLBBOH5PE
	5jmXWEGq2AQMJHoXNLCD2CICOhL79jxnByliFpjNKPHo5DWgIg4OYQEnibZVsiA1LAKqEmt+
	NbGB2LwCbhL/Fj1hBymREFCQmDPJZgIj9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsY
	IQHwdQfj0mNWhxgFOBiVeHgTTiwIEWJNLCuuzD3EKMHBrCTCK225MESINyWxsiq1KD++qDQn
	tfgQIxMHp1QDY7RojPI1M837MqaXFLd+vmQl9HmxJM/y/sP3fjfMTalc8Fv7zQrHUIHIVUvq
	Piy4x/pE2J871flnVFXTlPMfjHa/v+Agfsg485Xd/Wr3OMmWsPDFTt92zHPJqOr+ZCgqIu3C
	eFxw655GTqWHM0Mq+vJ3PL2pK7h5ZrzYXhHppy3d61mdfsR+VWIpzkg01GIuKk4EAGeK7uXe	AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 54e70ec5eb090193b03e69d551fa6771a5a217c4 commit introduced a
bidirectional check that should have checked for mutual WRITE access
between two labels. Due to a typo subject's OUT label is checked with
object's OUT. Should be OUT to IN.

Signed-off-by: Zbigniew Jasinski <z.jasinski@samsung.com>
---
 security/smack/smack_lsm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b774029..30f61f8 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3313,7 +3313,7 @@ static int smack_unix_stream_connect(struct sock *sock,
 
 	if (!smack_privileged(CAP_MAC_OVERRIDE)) {
 		skp = ssp->smk_out;
-		okp = osp->smk_out;
+		okp = osp->smk_in;
 #ifdef CONFIG_AUDIT
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		smk_ad_setfield_u_net_sk(&ad, other);
@@ -3321,6 +3321,8 @@ static int smack_unix_stream_connect(struct sock *sock,
 		rc = smk_access(skp, okp, MAY_WRITE, &ad);
 		rc = smk_bu_note("UDS connect", skp, okp, MAY_WRITE, rc);
 		if (rc == 0) {
+			okp = osp->smk_out;
+			skp = ssp->smk_in;
 			rc = smk_access(okp, skp, MAY_WRITE, NULL);
 			rc = smk_bu_note("UDS connect", okp, skp,
 						MAY_WRITE, rc);
-- 
1.7.9.5

