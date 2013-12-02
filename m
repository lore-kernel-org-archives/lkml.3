Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3LBOhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:37:03 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:46619 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab3LBOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:36:49 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com
Subject: [PATCH] perf tools: bring back old behavior when NO_DEMAGLE doesn't link with libbfd
Date: Mon,  2 Dec 2013 18:36:39 +0400
Message-Id: <1385994999-19889-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit reverts part of the 3e6a147deef9 "perf tools: Separate lbfd
check out of NO_DEMANGLE condition" which always links perf with libbfd.
I'd like to preserve old behavior when NO_DEMAGLE does not link with
it, because some machines may contain different versions of binutils
(hence miss required libbfd version) and I still want an option to build perf
which works on any machine regardless of binutils version.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/config/Makefile | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 80ea6d823908..337cc786bafd 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -485,10 +485,6 @@ else
   endif
 endif
 
-ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd
-endif
-
 ifdef NO_DEMANGLE
   CFLAGS += -DNO_DEMANGLE
 else
@@ -496,7 +492,9 @@ else
     EXTLIBS += -liberty
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
-    ifneq ($(feature-libbfd), 1)
+    ifeq ($(feature-libbfd), 1)
+      EXTLIBS += -lbfd
+    else
       $(call feature_check,liberty)
       ifeq ($(feature-liberty), 1)
         EXTLIBS += -lbfd -liberty
-- 
1.8.3.2

