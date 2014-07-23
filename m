Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaGWUM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:12:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42818 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933322AbaGWULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:04 -0400
X-Sasl-enc: ddt+ZkRd/J5z6aZhi9nBE61dLN+wy+1WEyMQ/zImtBeR 1406146263
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 6/8] x86, microcode, intel: total_size is valid only when data_size != 0
Date: Wed, 23 Jul 2014 17:10:49 -0300
Message-Id: <1406146251-8540-7-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the Intel SDM vol 3A (order code 253668-051US, June 2014),
on section 9.11.1, page 9-28:

"For microcode updates with a data size field equal to 00000000H, the
size of the microcode update is 2048 bytes. The first 48 bytes contain
the microcode update header. The remaining 2000 bytes contain encrypted
data."

"For microcode updates with a data size not equal to 00000000H, the total
size field specifies the size of the microcode update"

We were incorrectly assuming that total_size is valid when it is
non-zero, instead of checking data_size to be non-zero.  IOW, we were
trusting a reserved field to be zero in a situation where it was, in
fact, undefined.

This is a very old bug, dating back to 2003.  It has been dormant ever
since, as Intel seems to set all reserved fields to zero on the
microcode updates they distribute: I could not find a public microcode
update that would trigger this bug.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/include/asm/microcode_intel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 2bdbc6b..62f91c1 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -43,7 +43,7 @@ struct extended_sigtable {
 #define DWSIZE			(sizeof(u32))
 
 #define get_totalsize(mc) \
-	(((struct microcode_intel *)mc)->hdr.totalsize ? \
+	(((struct microcode_intel *)mc)->hdr.datasize ? \
 	 ((struct microcode_intel *)mc)->hdr.totalsize : \
 	 DEFAULT_UCODE_TOTALSIZE)
 
-- 
1.7.10.4

