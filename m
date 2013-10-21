Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3JUJCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:02:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39804 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab3JUIwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Miller" <davem@davemloft.net>,
        "Kirill Tkhai" <tkhai@yandex.ru>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.938159896@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 115/149] sparc64: Fix ITLB handler of null page
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 1c2696cdaad84580545a2e9c0879ff597880b1a9 ]

1)Use kvmap_itlb_longpath instead of kvmap_dtlb_longpath.

2)Handle page #0 only, don't handle page #1: bleu -> blu

 (KERNBASE is 0x400000, so #1 does not exist too. But everything
  is possible in the future. Fix to not to have problems later.)

3)Remove unused kvmap_itlb_nonlinear.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/ktlb.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 79f3103..7c00735 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -25,11 +25,10 @@ kvmap_itlb:
 	 */
 kvmap_itlb_4v:
 
-kvmap_itlb_nonlinear:
 	/* Catch kernel NULL pointer calls.  */
 	sethi		%hi(PAGE_SIZE), %g5
 	cmp		%g4, %g5
-	bleu,pn		%xcc, kvmap_dtlb_longpath
+	blu,pn		%xcc, kvmap_itlb_longpath
 	 nop
 
 	KERN_TSB_LOOKUP_TL1(%g4, %g6, %g5, %g1, %g2, %g3, kvmap_itlb_load)

