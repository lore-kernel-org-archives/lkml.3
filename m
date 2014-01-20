Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaATLkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:40:22 -0500
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:50764 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbaATLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:40:13 -0500
X-Yandex-Uniq: d0ce2d68-215c-4742-a4e7-f7681781478f
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf tools: bring back old behavior when NO_DEMAGLE doesn't link with libbfd
Date: Mon, 20 Jan 2014 15:39:40 +0400
Message-Id: <1390217980-22424-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
References: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
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
index d604e50fc167..4b76865c9bef 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -477,10 +477,6 @@ else
   endif
 endif
 
-ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd
-endif
-
 ifdef NO_DEMANGLE
   CFLAGS += -DNO_DEMANGLE
 else
@@ -488,7 +484,9 @@ else
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

