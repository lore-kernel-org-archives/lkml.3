Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaLOTbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:31:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaLOTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:31:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Haklai <nadavh@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 65/96] ARM: 8222/1: mvebu: enable strex backoff delay
Date: Mon, 15 Dec 2014 11:26:25 -0800
Message-Id: <1418671616-25482-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 995ab5189d1d7264e79e665dfa032a19b3ac646e upstream.

Under extremely rare conditions, in an MPCore node consisting of at
least 3 CPUs, two CPUs trying to perform a STREX to data on the same
shared cache line can enter a livelock situation.

This patch enables the HW mechanism that overcomes the bug. This fixes
the incorrect setup of the STREX backoff delay bit due to a wrong
description in the specification.

Note that enabling the STREX backoff delay mechanism is done by
leaving the bit *cleared*, while the bit was currently being set by
the proc-v7.S code.

[Thomas: adapt to latest mainline, slightly reword the commit log, add
stable markers.]

Fixes: de4901933f6d ("arm: mm: Add support for PJ4B cpu and init routines")

Signed-off-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mm/proc-v7.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 74f6033..fdedc31 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -211,7 +211,6 @@ __v7_pj4b_setup:
 /* Auxiliary Debug Modes Control 1 Register */
 #define PJ4B_STATIC_BP (1 << 2) /* Enable Static BP */
 #define PJ4B_INTER_PARITY (1 << 8) /* Disable Internal Parity Handling */
-#define PJ4B_BCK_OFF_STREX (1 << 5) /* Enable the back off of STREX instr */
 #define PJ4B_CLEAN_LINE (1 << 16) /* Disable data transfer for clean line */
 
 /* Auxiliary Debug Modes Control 2 Register */
@@ -234,7 +233,6 @@ __v7_pj4b_setup:
 	/* Auxiliary Debug Modes Control 1 Register */
 	mrc	p15, 1,	r0, c15, c1, 1
 	orr     r0, r0, #PJ4B_CLEAN_LINE
-	orr     r0, r0, #PJ4B_BCK_OFF_STREX
 	orr     r0, r0, #PJ4B_INTER_PARITY
 	bic	r0, r0, #PJ4B_STATIC_BP
 	mcr	p15, 1,	r0, c15, c1, 1
-- 
1.9.1

