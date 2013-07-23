Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452Ab3GWW1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426Ab3GWW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:26:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 003/103] powerpc/hw_brk: Fix off by one error when validating DAWR region end
Date: Tue, 23 Jul 2013 15:25:14 -0700
Message-Id: <20130723220418.949823505@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit e2a800beaca1f580945773e57d1a0e7cd37b1056 upstream.

The Data Address Watchpoint Register (DAWR) on POWER8 can take a 512
byte range but this range must not cross a 512 byte boundary.

Unfortunately we were off by one when calculating the end of the region,
hence we were not allowing some breakpoint regions which were actually
valid.  This fixes this error.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/hw_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -176,7 +176,7 @@ int arch_validate_hwbkpt_settings(struct
 		length_max = 512 ; /* 64 doublewords */
 		/* DAWR region can't cross 512 boundary */
 		if ((bp->attr.bp_addr >> 10) != 
-		    ((bp->attr.bp_addr + bp->attr.bp_len) >> 10))
+		    ((bp->attr.bp_addr + bp->attr.bp_len - 1) >> 10))
 			return -EINVAL;
 	}
 	if (info->len >


