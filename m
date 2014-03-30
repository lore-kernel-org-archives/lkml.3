Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaC3Xqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:46:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbaC3Xn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Mackerras" <paulus@samba.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.894206448@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 059/200] powerpc: Make sure "cache" directory is
 removed when offlining cpu
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/cacheinfo.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -788,6 +788,9 @@ static void remove_cache_dir(struct cach
 {
 	remove_index_dirs(cache_dir);
 
+	/* Remove cache dir from sysfs */
+	kobject_del(cache_dir->kobj);
+
 	kobject_put(cache_dir->kobj);
 
 	kfree(cache_dir);

