Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3IQXI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:08:29 -0400
Received: from nm22-vm6.access.bullet.mail.gq1.yahoo.com ([216.39.63.170]:22441
	"EHLO nm22-vm6.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210Ab3IQXI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:08:26 -0400
X-Yahoo-Newman-Id: 766222.3357.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 23:08:25 +0000 UTC
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2zvTiGMVM1lKdnQiZiCQtCSa4j.YSZogPPQlDoqLAmQmfOJ
 OXcLP8ZRrewFkbw8QtVahIj0olxPSf5qrmEoBrpN15FsOxCx5fkQjLPASWVp
 0zwIND2n4EHYJ8JjS8ockhCnFFHhWzxxEf8eh0Wz09gIgpT1b_DxKRwYs4EO
 yR7TfdzSFwq1Dt.NMRgc8JBV.egRyuGdG4Xjy68h3XbaS02qX7aQBFh.1q6N
 AVdNLTYGV51tdFX6Soojuc4WgSveSz4QWdOqS92UFhZTrzgFtniuzSg5s0Sa
 KYhWHBiTEJTZIkfr3DBmC9U4Dq3mvgSGWfHHDNKQADoudloCD.uWSArDfKNo
 yQ9Aujgz3OqG6emLntGaTgd1LUa3p20zpEqSIQCp_u31JCB21sGjGwEGLNAb
 t3BupXT6QUSktdVeZOsNmBbdddtcB90jUOl65CDIepVN19Y0Fjuk3WPBNjb1
 nD_1xxyNvarVD9_sKfWJwAOxEL_JoNAKV5QPde_IWjSLmdqo0U9TGWu1_gUx
 cu5q5Pi9g5QtCdYwUS.XeW8NPqFLJVvsF5gFEaGGgh1zN48HLvJxe0H6QquZ
 oadK_j8W0j1fHKYM-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 2/5] lib: Add .config options for error strings in printks
Date: Tue, 17 Sep 2013 18:08:34 -0500
Message-Id: <1379459317-13046-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds to lib/Kconfig.debug the options for printk messages to
display either error number only (the current behavior), number and
error name or number, name and description. These options in turn select
STRERROR_NAME and STRERROR as needed, so I'm not adding any direct
options to enable those, although it can be added later if somebody
needs strerror() or strerror_name() when not enabled in printks.

kconfg

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 lib/Kconfig.debug | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c9eef36..919f371 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -58,6 +58,7 @@ config DYNAMIC_DEBUG
 	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
 	  enlarges the kernel text size by about 2%.
 
+
 	  If a source file is compiled with DEBUG flag set, any
 	  pr_debug() calls in it are enabled by default, but can be
 	  disabled at runtime as below.  Note that DEBUG flag is
@@ -113,6 +114,58 @@ config DYNAMIC_DEBUG
 
 	  See Documentation/dynamic-debug-howto.txt for additional information.
 
+choice
+	prompt "Display errors in printk as"
+	default PRINTK_ERROR_CODES_ONLY
+	depends on PRINTK
+	help
+	  This option tells printk how to display error codes when
+	  formatted with the %de format code (a Linux printk extension).
+	  Error codes are most commonly passed to userspace when syscalls
+	  return where they are then translated into localized descrptions
+	  via libc's strerror(), perror(), etc.  However, many error
+	  conditions (for drivers and such) are only reported via printks
+	  where there is no such userspace mechanism to reliably translate
+	  error numbers into something a little more human.
+
+	  This option allows you to perform that translation in the kernel,
+	  at the cost of a slightly larger kernel. Note that no native
+	  language support is currently, or may ever be provided.
+
+	  If unsure, choose "Error codes only".
+
+config PRINTK_ERROR_CODES_ONLY
+	bool "Error codes only"
+	help
+	  Just display the error number.
+
+config PRINTK_ERROR_NAMES
+	bool "Error names"
+	select STRERROR_NAME
+	help
+	  This option causes printk messages containing an error code to
+	  print the name of the error in addition to the error number.
+	  Enabling this adds about 2k. Example: -22 (EINVAL)
+
+config PRINTK_ERROR_DESCS
+	bool "Full descrptions"
+	select STRERROR
+	select STRERROR_NAME
+	help
+	  This option causes printk messages containing an error code to
+	  print the description of errors (in addition to the name and
+	  number) and can be helpful for those with aversions to search
+	  engines. Enabling this adds about 6k over error codes alone.
+	  Example: -90 (EMSGSIZE: Message too long)
+
+endchoice
+
+config STRERROR
+	bool
+
+config STRERROR_NAME
+	bool
+
 endmenu # "printk and dmesg options"
 
 menu "Compile-time checks and compiler options"
-- 
1.8.1.5

