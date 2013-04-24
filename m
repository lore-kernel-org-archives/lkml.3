Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3DXWas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:48 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34358 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3DXWab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:31 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 7/8] kconfig: allow specifying the seed for randconfig
Date: Thu, 25 Apr 2013 00:29:54 +0200
Message-Id: <0d8024c6ebadb68f1154377c2e1996b4e649e4c8.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

For reproducibility, it can be useful to be able to specify the
seed to use to seed the RNG.

Add a new KCONFIG_SEED environment variable which can be set to
the seed to use:
    $ make KCONFIG_SEED=42 randconfig
    $ sha1sum .config
    70a128c8dcc61303069e1be352cce64114dfcbca  .config
    $ make KCONFIG_SEED=42 randconfig
    $ sha1sum .config
    70a128c8dcc61303069e1be352cce64114dfcbca  .config

It's very usefull for eg. debugging the kconfig parser.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 Documentation/kbuild/kconfig.txt |    9 +++++++++
 scripts/kconfig/conf.c           |   12 +++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index b8b77bb..dbf746b 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -90,6 +90,15 @@ disable the options that are explicitly listed in the specified
 mini-config files.
 
 ______________________________________________________________________
+Environment variables for 'randconfig'
+
+KCONFIG_SEED
+--------------------------------------------------
+You can set this to the integer value used to seed the RNG, if you want
+to somehow debug the behaviour of the kconfig parser/frontends.
+If not set, the current time will be used.
+
+______________________________________________________________________
 Environment variables for 'silentoldconfig'
 
 KCONFIG_NOSILENTUPDATE
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index e39fcd8..bde5b95 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -13,6 +13,7 @@
 #include <getopt.h>
 #include <sys/stat.h>
 #include <sys/time.h>
+#include <errno.h>
 
 #include "lkc.h"
 
@@ -514,14 +515,23 @@ int main(int ac, char **av)
 		{
 			struct timeval now;
 			unsigned int seed;
+			char *seed_env;
 
 			/*
 			 * Use microseconds derived seed,
 			 * compensate for systems where it may be zero
 			 */
 			gettimeofday(&now, NULL);
-
 			seed = (unsigned int)((now.tv_sec + 1) * (now.tv_usec + 1));
+
+			seed_env = getenv("KCONFIG_SEED");
+			if( seed_env && *seed_env ) {
+				char *endp;
+				int tmp = (int)strtol(seed_env, &endp, 10);
+				if (*endp == '\0') {
+					seed = tmp;
+				}
+			}
 			srand(seed);
 			break;
 		}
-- 
1.7.10.4

