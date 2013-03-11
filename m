Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3CKUTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:19:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34562 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:19:16 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3] get_maintainer: use filename-only regex match for Tegra
Date: Mon, 11 Mar 2013 14:19:09 -0600
Message-Id: <1363033149-7839-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Create a new N: entry type in MAINTAINERS which performs a regex match
against filenames; either those extracted from patch +++ or --- lines,
or those specified on the command-line using the -f option.

This provides the same benefits as using a K: regex option to match a
set of filenames (see commit eb90d08 "get_maintainer: allow keywords to
match filenames"), but without the disadvantage that "random" file
content, such as comments, will ever match the regex. Hence, revert most
of that commit.

Switch the Tegra entry from using K: to N:

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Corrected typo in MAINTAINERS documentation
v3: Squash 3 patches into one.
---
 MAINTAINERS               |   14 ++++++++------
 scripts/get_maintainer.pl |    2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..e68a07a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -90,6 +90,9 @@ Descriptions of section entries:
 	   F:	drivers/net/*	all files in drivers/net, but not below
 	   F:	*/net/*		all files in "any top level directory"/net
 	   One pattern per line.  Multiple F: lines acceptable.
+	N: Files and directories with regex patterns.
+	   N:	[^a-z]tegra	all files whose patch contains the word tegra
+	   One pattern per line.  Multiple N: lines acceptable.
 	X: Files and directories that are NOT maintained, same rules as F:
 	   Files exclusions are tested before file matches.
 	   Can be useful for excluding a specific subdirectory, for instance:
@@ -97,13 +100,12 @@ Descriptions of section entries:
 	   X:	net/ipv6/
 	   matches all files in and below net excluding net/ipv6/
 	K: Keyword perl extended regex pattern to match content in a
-	   patch or file, or an affected filename.  For instance:
+	   patch or file.  For instance:
 	   K: of_get_profile
-	      matches patch or file content, or filenames, that contain
-	      "of_get_profile"
+	      matches patches or files that contain "of_get_profile"
 	   K: \b(printk|pr_(info|err))\b
-	      matches patch or file content, or filenames, that contain one or
-	      more of the words printk, pr_info or pr_err
+	      matches patches or files that contain one or more of the words
+	      printk, pr_info or pr_err
 	   One regex pattern per line.  Multiple K: lines acceptable.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
@@ -7848,7 +7850,7 @@ L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
-K:	(?i)[^a-z]tegra
+N:	[^a-z]tegra
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index ce4cc83..5e4fb14 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -611,7 +611,7 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
-			} elsif ($type eq 'K') {
+			} elsif ($type eq 'N') {
 			    if ($file =~ m/$value/x) {
 				$hash{$tvi} = 0;
 			    }
-- 
1.7.10.4

