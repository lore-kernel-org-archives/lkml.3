Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaJGKzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:55:16 -0400
Received: from ozlabs.org ([103.22.144.67]:42093 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbaJGKzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:55:13 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Subject: [PATCH] ima: Fix build failure on powerpc when TCG_IBMVTPM dependencies are not met
Date: Tue,  7 Oct 2014 21:55:00 +1100
Message-Id: <1412679300-25695-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc we can end up with IMA=y and PPC_PSERIES=n which leads to:

  warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES)
  tpm_ibmvtpm.c:(.text+0x14f3e8): undefined reference to `.plpar_hcall_norets'

I'm not sure why IMA needs to select those user-visible symbols, but if
it must then the simplest fix is to just express the proper dependencies
on the select.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 security/integrity/ima/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 08758fbd496f..9fc41d2f0995 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -12,7 +12,7 @@ config IMA
 	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML
 	select TCG_TIS if TCG_TPM && X86
-	select TCG_IBMVTPM if TCG_TPM && PPC64
+	select TCG_IBMVTPM if TCG_TPM && PPC_PSERIES
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash
-- 
1.9.1

