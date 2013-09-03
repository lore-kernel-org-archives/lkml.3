Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab3ICVFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:05:05 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47050 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168Ab3ICVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:04:58 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/3] kconfig: do not allow more than one symbol to have 'option modules'
Date: Tue,  3 Sep 2013 23:04:47 +0200
Message-Id: <1378242287-12759-3-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Previously, it was possible to have more than one symbol with the
'option modules' attached to them, although only the last one would
in fact controls tristates.

Since this does not make much sense, only allow at most one symbol to
control tristates.

Note: it is still possible to have more than one symbol that control
tristates, but indirectly:

    config MOD1
        bool "mod1"
        select MODULES
    config MOD2
        bool "mod2"
        select MODULES
    config MODULES
        bool
        option modules

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 Documentation/kbuild/kconfig-language.txt | 1 +
 scripts/kconfig/menu.c                    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index c858f84..c420676 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -147,6 +147,7 @@ applicable everywhere (see syntax).
   - "modules"
     This declares the symbol to be used as the MODULES symbol, which
     enables the third modular state for all config symbols.
+    At most one symbol may have the "modules" option set.
 
   - "env"=<value>
     This imports the environment variable into Kconfig. It behaves like
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 3a9c674..c1d5320 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -199,6 +199,12 @@ void menu_add_option(int token, char *arg)
 {
 	switch (token) {
 	case T_OPT_MODULES:
+		if (modules_sym)
+			zconf_error("symbol '%s' redefines option 'modules'"
+				    " already defined by symbol '%s'",
+				    current_entry->sym->name,
+				    modules_sym->name
+				    );
 		modules_sym = current_entry->sym;
 		break;
 	case T_OPT_DEFCONFIG_LIST:
-- 
1.8.1.2

