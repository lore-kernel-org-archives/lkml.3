Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161655AbaJaB02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:26:28 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33156 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161639AbaJaB00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:26:26 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, gong.chen@linux.intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] separate CMCI/Threshold Interrupt and POLL in mce-inject
Date: Fri, 31 Oct 2014 09:24:08 +0800
Message-Id: <1414718648-7766-4-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
References: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new flag MCJ_INTERRUPT that will be used
to separate CMCI/Threshold Interrupt and POLL in mce-inject.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 mce.h   |    5 +++--
 mce.lex |    1 +
 mce.y   |    6 +++++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/mce.h b/mce.h
index c0668ad..d0bd39a 100644
--- a/mce.h
+++ b/mce.h
@@ -38,8 +38,9 @@
 #define MCJ_CTX_PROCESS		1    /* inject context: process */
 #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
-#define MCJ_EXCEPTION		8    /* raise as exception */
-#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
+#define MCJ_IRQ_BRAODCAST	8    /* do IRQ broadcasting */
+#define MCJ_EXCEPTION		0x10 /* raise as exception */
+#define MCJ_INTERRUPT		0x20 /* raise as interrupt */
 
 #define MCJ_CTX_SET(flags, ctx)				\
 	do {						\
diff --git a/mce.lex b/mce.lex
index ce8a9ae..ce4ea69 100644
--- a/mce.lex
+++ b/mce.lex
@@ -83,6 +83,7 @@ static struct key {
 	KEY(IN_IRQ),
 	KEY(IN_PROC),
 	KEY(POLL),
+	KEY(INTERRUPT),
 	KEY(EXCP),
 	KEYVAL(CORRECTED, MCI_STATUS_VAL|MCI_STATUS_EN), 	// checkme
 	KEYVAL(UNCORRECTED, MCI_STATUS_VAL|MCI_STATUS_UC|MCI_STATUS_EN),
diff --git a/mce.y b/mce.y
index a9421ee..84095a1 100644
--- a/mce.y
+++ b/mce.y
@@ -43,7 +43,7 @@ static void init(void);
 %token STATUS RIP TSC ADDR MISC CPU BANK MCGSTATUS HOLD
 %token NOBROADCAST IRQBROADCAST NMIBROADCAST 
 %token IN_IRQ IN_PROC PROCESSOR TIME SOCKETID APICID MCGCAP
-%token POLL EXCP
+%token POLL INTERRUPT EXCP
 %token CORRECTED UNCORRECTED FATAL MCE
 %token NUMBER
 %token SYMBOL
@@ -94,7 +94,11 @@ mce_term:   STATUS status_list  { m.status = $2; }
      | IN_IRQ		   { MCJ_CTX_SET(m.inject_flags, MCJ_CTX_IRQ); }
      | IN_PROC		   { MCJ_CTX_SET(m.inject_flags, MCJ_CTX_PROCESS); }
      | POLL		   { mce_flags |= MCE_RAISE_MODE;
+			     m.inject_flags &= ~MCJ_INTERRUPT;
 			     m.inject_flags &= ~MCJ_EXCEPTION; }
+     | INTERRUPT	   { mce_flags |= MCE_RAISE_MODE;
+			     m.inject_flags &= ~MCJ_EXCEPTION;
+			     m.inject_flags |= MCJ_INTERRUPT; }
      | EXCP		   { mce_flags |= MCE_RAISE_MODE;
 			     m.inject_flags |= MCJ_EXCEPTION; }
      ;
-- 
1.7.10.4

