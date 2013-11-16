Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3KPNjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 08:39:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3KPNj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 08:39:29 -0500
From: Thomas Renninger <trenn@suse.de>
To: rjw@sisk.pl
Cc: trenn@suse.de, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tools cpupower: fix wrong err msg not supported vs not available
Date: Sat, 16 Nov 2013 14:39:22 +0100
Message-Id: <1384609162-77010-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1384609162-77010-1-git-send-email-trenn@suse.de>
References: <1384609162-77010-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idlestates in sysfs are counted from 0.

This fixes a wrong error message.
Current behavior on a machine with 4 sleep states is:

cpupower idle-set -e 4
Idlestate 4 enabled on CPU 0

-----Wrong---------------------
cpupower idle-set -e 5
Idlestate enabling not supported by kernel
-----Must and now will be -----
cpupower idle-set -e 5
Idlestate 6 not available on CPU 0
-------------------------------

cpupower idle-set -e 6
Idlestate 6 not available on CPU 0

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 tools/power/cpupower/utils/helpers/sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index 5cdc600..851c7a1 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -278,7 +278,7 @@ static char *sysfs_idlestate_get_one_string(unsigned int cpu,
 int sysfs_is_idlestate_disabled(unsigned int cpu,
 				unsigned int idlestate)
 {
-	if (sysfs_get_idlestate_count(cpu) < idlestate)
+	if (sysfs_get_idlestate_count(cpu) <= idlestate)
 		return -1;
 
 	if (!sysfs_idlestate_file_exists(cpu, idlestate,
@@ -303,7 +303,7 @@ int sysfs_idlestate_disable(unsigned int cpu,
 	char value[SYSFS_PATH_MAX];
 	int bytes_written;
 
-	if (sysfs_get_idlestate_count(cpu) < idlestate)
+	if (sysfs_get_idlestate_count(cpu) <= idlestate)
 		return -1;
 
 	if (!sysfs_idlestate_file_exists(cpu, idlestate,
-- 
1.7.6.1

