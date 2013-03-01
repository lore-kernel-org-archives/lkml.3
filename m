Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3CAPuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:50:51 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:60170 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3CAPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:50:48 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Justin Lecher <jlec@gentoo.org>
Subject: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
Date: Fri,  1 Mar 2013 16:50:44 +0100
Message-Id: <1362153044-23611-3-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362153044-23611-1-git-send-email-jlec@gentoo.org>
References: <jlec@gentoo.org>
 <1362153044-23611-1-git-send-email-jlec@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Lecher <jlec@gentoo.org>

When building ncurses with --with-termlib several symbols get moved from
libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
additionally needs to link with libtinfo.so. Ncurses provides a config script
(ncurses5-config) or in very recent version even a pkg-config module to assist
finding ncurses.

This patch makes use of it to detect the necessary libs for linking of the
ncurses nconfig dialog

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 scripts/kconfig/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 231b475..cc81db5 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -219,7 +219,11 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
 
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
-HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
+HOSTLOADLIBES_nconf	= -lmenu -lpanel
+HOSTLOADLIBES_nconf	+= $(shell \
+				pkg-config --libs ncurses 2>/dev/null \
+				|| ncurses5-config --libs 2>/dev/null \
+				|| ncurses6-config --libs 2>/dev/null  )
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
 
 ifeq ($(qconf-target),1)
-- 
1.8.1.4

