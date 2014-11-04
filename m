Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaKDKE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:04:57 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58746 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbaKDKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:04:50 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: gong.chen@linux.intel.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        " Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com, eric.paire@st.com
Subject: [PATCH v2] bitops: Fix shift overflow in GENMASK macros
Date: Tue,  4 Nov 2014 11:03:57 +0100
Message-Id: <1415095437-28723-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-04_05:2014-11-03,2014-11-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
instead of the expected ~0UL.

This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).

This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
1 << 64 for GENMASK_ULL.

Fixes: 10ef6b0dffe404bcc54e94cb2ca1a5b18445a66b
Cc: <stable@vger.kernel.org> #v3.13+
Reported-by: Eric Paire <eric.paire@st.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 include/linux/bitops.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index be5fd38..a49d7b7 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -18,8 +18,8 @@
  * position @h. For example
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
-#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
-#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
+#define GENMASK(h, l)     ((~0UL >> (BITS_PER_LONG - (h - l + 1))) << l)
+#define GENMASK_ULL(h, l) ((~0ULL >> (BITS_PER_LONG_LONG - (h - l + 1))) << l)
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
-- 
1.9.1

