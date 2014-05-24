Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaEXCSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 22:18:25 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55989 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaEXCSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 22:18:23 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86/mce: Fix incorrect comment in do_machine_check()
Date: Sat, 24 May 2014 10:16:41 +0800
Message-Id: <1400897801-27370-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In do_machine_check function, we can find the following code segment:

*       ...
*        /* mce_clear_state will clear *final, save locally for use later */
*        m = *final;
*
*        if (!no_way_out)
*                mce_clear_state(toclear);
*       ...

But the reality is that mce_clear_state function will not clear *final. It is just
used to clear bank MSRs or the relative field of injectm used by MCE-Injection.
Meanwhile, mce_reign executed by monarch CPU will clear *final, therefore we need
to save it locally for use later.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..83159c1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1137,7 +1137,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
-	/* mce_clear_state will clear *final, save locally for use later */
+	/* mce_reign executed by monarch CPU will clear *final(mces_seen),
+	 * save locally for use later
+	 */
 	m = *final;
 
 	if (!no_way_out)
-- 
1.7.10.4

