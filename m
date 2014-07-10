Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaGJGvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:51:22 -0400
Received: from odin2.bull.net ([129.184.85.11]:60331 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGJGvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:51:20 -0400
Message-ID: <53BE37E5.4030407@bull.net>
Date: Thu, 10 Jul 2014 08:51:17 +0200
From: Sebastien Buisson <sebastien.buisson@bull.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Allow increasing the buffer-head per-CPU LRU size
References: <53B667F9.90306@bull.net> <87y4w6sbp7.fsf@tassilo.jf.intel.com> <53BA772C.6040506@bull.net> <20140707163003.GA18735@two.firstfloor.org> <20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org> <20140707224634.GE18735@two.firstfloor.org> <53BB8F7C.1060505@bull.net>
In-Reply-To: <53BB8F7C.1060505@bull.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.192.1.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow increasing the buffer-head per-CPU LRU size to allow efficient
filesystem operations that access many blocks for each transaction.
For example, creating a file in a large ext4 directory with quota
enabled will accesses multiple buffer heads and will overflow the LRU
at the default 8-block LRU size:

* parent directory inode table block (ctime, nlinks for subdirs)
* new inode bitmap
* inode table block
* 2 quota blocks
* directory leaf block (not reused, but pollutes one cache entry)
* 2 levels htree blocks (only one is reused, other pollutes cache)
* 2 levels indirect/index blocks (only one is reused)

The buffer-head per-CPU LRU size can be changed at config time, and its
default value is raised to 16.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
  fs/Kconfig  |   14 ++++++++++++++
  fs/buffer.c |    3 +--
  2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..afbb6fa 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -268,4 +268,18 @@ endif # NETWORK_FILESYSTEMS
  source "fs/nls/Kconfig"
  source "fs/dlm/Kconfig"

+config BH_LARGE_LRU
+      def_bool y
+      depends on (EXT4_FS && QUOTA)
+
+config BH_LRU_SIZE
+      int
+      range 8 64
+      default "16" if BH_LARGE_LRU
+      default "8" if !BH_LARGE_LRU
+      help
+        This sets the per-CPU LRU size for buffer heads in memory.
+        More complex filesystems may be modifying multiple blocks
+        within a single transaction, so keeping the buffer heads in
+        CPU-local cache speeds up modifications significantly.
  endmenu
diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..b83fa63 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1255,8 +1255,7 @@ static struct buffer_head *__bread_slow(struct 
buffer_head *bh)
   * The LRUs themselves only need locking against invalidate_bh_lrus. 
We use
   * a local interrupt disable for that.
   */
-
-#define BH_LRU_SIZE	8
+#define BH_LRU_SIZE	CONFIG_BH_LRU_SIZE

  struct bh_lru {
  	struct buffer_head *bhs[BH_LRU_SIZE];
-- 
1.7.1

