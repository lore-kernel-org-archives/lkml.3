Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaLFPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:16:27 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47777 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752283AbaLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 46/66] ARM: 8222/1: mvebu: enable strex backoff delay
Date: Sat,  6 Dec 2014 16:07:38 +0100
Message-Id: <72741f17d30ed08eb9eb64711bfd6c7e11ab7841.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mm/proc-v7.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index ced046d9f825..2e381582ffee 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -204,7 +204,6 @@ __v7_pj4b_setup:
 /* Auxiliary Debug Modes Control 1 Register */
 #define PJ4B_STATIC_BP (1 << 2) /* Enable Static BP */
 #define PJ4B_INTER_PARITY (1 << 8) /* Disable Internal Parity Handling */
-#define PJ4B_BCK_OFF_STREX (1 << 5) /* Enable the back off of STREX instr */
 #define PJ4B_CLEAN_LINE (1 << 16) /* Disable data transfer for clean line */
 
 /* Auxiliary Debug Modes Control 2 Register */
@@ -227,7 +226,6 @@ __v7_pj4b_setup:
 	/* Auxiliary Debug Modes Control 1 Register */
 	mrc	p15, 1,	r0, c15, c1, 1
 	orr     r0, r0, #PJ4B_CLEAN_LINE
-	orr     r0, r0, #PJ4B_BCK_OFF_STREX
 	orr     r0, r0, #PJ4B_INTER_PARITY
 	bic	r0, r0, #PJ4B_STATIC_BP
 	mcr	p15, 1,	r0, c15, c1, 1
-- 
2.1.3

