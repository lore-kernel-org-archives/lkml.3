Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab3L2Cua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:50:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab3L2CKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mikulas Patocka" <mpatocka@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.276648019@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 135/185] dm bufio: initialize read-only module parameters
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-bufio.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1611,6 +1611,11 @@ static int __init dm_bufio_init(void)
 {
 	__u64 mem;
 
+	dm_bufio_allocated_kmem_cache = 0;
+	dm_bufio_allocated_get_free_pages = 0;
+	dm_bufio_allocated_vmalloc = 0;
+	dm_bufio_current_allocated = 0;
+
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
 	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 

