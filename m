Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbaGCVIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaGCVIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 5/9] pefile: Parse the presumed PKCS#7 content of the certificate blob
Date: Thu,  3 Jul 2014 17:07:17 -0400
Message-Id: <1404421641-12691-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the content of the certificate blob, presuming it to be PKCS#7 format.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/pefile_parser.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pefile_parser.c b/arch/x86/kernel/pefile_parser.c
index 088779e..e4d3410 100644
--- a/arch/x86/kernel/pefile_parser.c
+++ b/arch/x86/kernel/pefile_parser.c
@@ -199,6 +199,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
  */
 int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 {
+	void *pkcs7;
 	struct pefile_context ctx;
 	int ret;
 
@@ -213,6 +214,15 @@ int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 	if (ret < 0)
 		return ret;
 
+	pkcs7 = pkcs7_parse_message(pebuf + ctx.sig_offset, ctx.sig_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+	ctx.pkcs7 = pkcs7;
+
 	/* Not yet complete */
-	return -ENOANO;
+	ret = -ENOANO;
+
+error:
+	pkcs7_free_message(ctx.pkcs7);
+	return ret;
 }
-- 
1.9.0

