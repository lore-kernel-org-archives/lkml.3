Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910AbaBDVNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:13:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934773AbaBDVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 140/140] powerpc: Make sure "cache" directory is removed when offlining cpu
Date: Tue,  4 Feb 2014 13:12:07 -0800
Message-Id: <20140204211040.971993709@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/cacheinfo.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -794,6 +794,9 @@ static void remove_cache_dir(struct cach
 {
 	remove_index_dirs(cache_dir);
 
+	/* Remove cache dir from sysfs */
+	kobject_del(cache_dir->kobj);
+
 	kobject_put(cache_dir->kobj);
 
 	kfree(cache_dir);


