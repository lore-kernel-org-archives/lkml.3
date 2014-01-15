Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaAOWMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:12:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaAOV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 042/166] dm bufio: initialize read-only module parameters
Date: Wed, 15 Jan 2014 13:50:56 -0800
Message-Id: <1389822780-4729-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 4cb57ab4a2e61978f3a9b7d4f53988f30d61c27f upstream.

Some module parameters in dm-bufio are read-only. These parameters
inform the user about memory consumption. They are not supposed to be
changed by the user.

However, despite being read-only, these parameters can be set on
modprobe or insmod command line, for example:
modprobe dm-bufio current_allocated_bytes=12345

The kernel doesn't expect that these variables can be non-zero at module
initialization and if the user sets them, it results in BUG.

This patch initializes the variables in the module init routine, so that
user-supplied values are ignored.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-bufio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5d2c26e..6ef007b 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1661,6 +1661,11 @@ static int __init dm_bufio_init(void)
 {
 	__u64 mem;
 
+	dm_bufio_allocated_kmem_cache = 0;
+	dm_bufio_allocated_get_free_pages = 0;
+	dm_bufio_allocated_vmalloc = 0;
+	dm_bufio_current_allocated = 0;
+
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
 	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 
-- 
1.8.3.2

