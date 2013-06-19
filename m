Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab3FSPNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:13:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934521Ab3FSPNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:13:50 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-73-51c1caad2d33
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/4] security: smack: limit a length for a rule string in the
 long format
Date: Wed, 19 Jun 2013 17:13:32 +0200
Message-id: <1371654816-20772-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
References: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xoO7aUwcDDU6t1La4t+0Xm8XZpjfs
	Fpd3zWGz+NDziM1i7ZG77BZvJ61gtpjX/pLVgd2jb8sqRo+j+xexeXzeJBfAHMVlk5Kak1mW
	WqRvl8CV0fn6BFvBNN6KiTtb2BoY73N1MXJySAiYSDy5cIoFwhaTuHBvPVsXIxeHkMB0Roml
	nf3sEE4Xk8TxzplgVWxAHceWfGYEsUUENCWOTYfoYBbYxijR8WIqE0hCWCBaovXyXFYQm0VA
	VWLKnSdARRwcvAIeEpcvp0Bsk5d4er+PDcTmFPCUuH7+HdhMIaCSxVfXsU5g5F3AyLCKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIziEnknvYFzVYHGIUYCDUYmH12HuwUAh1sSy4srcQ4wS
	HMxKIrxLjwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1
	MKrvyVFQO7LAfraWpOmFvuZr2r07s9h+v2PcWl3c+uGWVeApn23H52tPbLv1bk7IVsV2T+Mg
	83aD1ZmqL3TmqjkkWSz/xlogZM7s/7grIrTW+9YBB4WmDC0BC/VlyyWkZ0+b/uPXmcpTbqbi
	Vy88Cw/8u7rj2tpGkfUp++bFTDtVatzBxbzYWImlOCPRUIu5qDgRACyzTBAdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximal length for a rule line for long format is introduced as
SMK_LOAD2LEN.  Limiting the length of a rule line helps to avoid allocations of
a very long contiguous buffer from a heap if user calls write() for a very long
chunk.  Such an allocation often causes a lot swapper/writeback havoc and it is
very likely to fail.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smackfs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 08aebc2..5dcd520 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -137,6 +137,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
  * SMK_ACCESS: Maximum possible combination of access permissions
  * SMK_ACCESSLEN: Maximum length for a rule access field
  * SMK_LOADLEN: Smack rule length
+ * SMK_LOAD2LEN: Smack maximal long rule length excluding \0
  */
 #define SMK_OACCESS	"rwxa"
 #define SMK_ACCESS	"rwxat"
@@ -144,6 +145,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 #define SMK_ACCESSLEN	(sizeof(SMK_ACCESS) - 1)
 #define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
 #define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
+#define SMK_LOAD2LEN   (2 * SMK_LONGLABEL + SMK_ACCESSLEN + 2)
 
 /*
  * Stricly for CIPSO level manipulation.
@@ -459,6 +461,9 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 	if (*ppos != 0)
 		return -EINVAL;
 
+	if (count > SMK_LOAD2LEN)
+		count = SMK_LOAD2LEN;
+
 	if (format == SMK_FIXED24_FMT) {
 		/*
 		 * Minor hack for backward compatibility
-- 
1.7.9.5

