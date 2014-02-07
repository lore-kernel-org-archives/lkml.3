Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaBGLwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbaBGLwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 187/233] powerpc: Make sure "cache" directory is removed when offlining cpu
Date: Fri,  7 Feb 2014 11:46:46 +0000
Message-Id: <1391773652-25214-188-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 91b973f90c1220d71923e7efe1e61f5329806380 upstream.

The code in remove_cache_dir() is supposed to remove the "cache"
subdirectory from the sysfs directory for a CPU when that CPU is
being offlined.  It tries to do this by calling kobject_put() on
the kobject for the subdirectory.  However, the subdirectory only
gets removed once the last reference goes away, and the reference
being put here may well not be the last reference.  That means
that the "cache" subdirectory may still exist when the offlining
operation has finished.  If the same CPU subsequently gets onlined,
the code tries to add a new "cache" subdirectory.  If the old
subdirectory has not yet been removed, we get a WARN_ON in the
sysfs code, with stack trace, and an error message printed on the
console.  Further, we ultimately end up with an online cpu with no
"cache" subdirectory.

This fixes it by doing an explicit kobject_del() at the point where
we want the subdirectory to go away.  kobject_del() removes the sysfs
directory even though the object still exists in memory.  The object
will get freed at some point in the future.  A subsequent onlining
operation can create a new sysfs directory, even if the old object
still exists in memory, without causing any problems.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/cacheinfo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index 9262cf2..2eab23c 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -794,6 +794,9 @@ static void remove_cache_dir(struct cache_dir *cache_dir)
 {
 	remove_index_dirs(cache_dir);
 
+	/* Remove cache dir from sysfs */
+	kobject_del(cache_dir->kobj);
+
 	kobject_put(cache_dir->kobj);
 
 	kfree(cache_dir);
-- 
1.8.3.2

