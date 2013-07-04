Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3GDFlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:41:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:54357 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3GDFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:41:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] checkpatch: only allow COMPILE_TEST in Kconfig dependency lines
Date: Thu, 4 Jul 2013 01:39:13 -0400
Message-ID: <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The option CONFIG_COMPILE_TEST, added in commit 4bb1667255a
("build some drivers only when compile-testing") is meant to
give a middle ground[1] between those who want the widest compile
coverage possible (e.g. building sparc drivers for mips) and
those who want dependencies to represent real world systems
(e.g. don't allow me to see OMAP options when building x86).

As such, this addition is meant to be used in dependency lines,
properly or'd in with the real world hardware dependency.  Those
who select it, get wide compile coverage.  Those who do not, get
real world dependencies that match where the hardware is available
and/or where the driver is useful.

With that in mind, it is clear that this is _not_ to be used in
any C code with "#ifdef CONFIG_COMPILE_TEST" etc.  However there
will (and already has been) instances of people thinking this is
an OK practice[2].  So teach checkpatch to spot them as an error.

[1] https://lkml.org/lkml/2013/3/7/456
[2] https://lkml.org/lkml/2013/7/1/641

Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..c0871a3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1922,6 +1922,12 @@ sub process {
 			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
 		}
 
+# disallow the addition of CONFIG_COMPILE_TEST in #if(def).
+		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_COMPILE_TEST\b/) {
+			ERROR("CONFIG_COMPILE_TEST",
+			     "Use of COMPILE_TEST is only allowed in Kconfig dependency lines.\n");
+		}
+
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS_KEYWORD",
-- 
1.8.1.2

