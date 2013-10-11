Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3JKVHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:07:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3JKTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>
Subject: [ 24/39] sparc64: Fix ITLB handler of null page
Date: Fri, 11 Oct 2013 12:35:08 -0700
Message-Id: <20131011193213.521068145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/ktlb.S |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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


