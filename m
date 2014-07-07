Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaGGKcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:32:17 -0400
Received: from odin2.bull.net ([129.184.85.11]:51907 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaGGKcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:32:14 -0400
Message-ID: <53BA772C.6040506@bull.net>
Date: Mon, 7 Jul 2014 12:32:12 +0200
From: Sebastien Buisson <sebastien.buisson@bull.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
References: <53B667F9.90306@bull.net> <87y4w6sbp7.fsf@tassilo.jf.intel.com>
In-Reply-To: <87y4w6sbp7.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.192.1.123]
Content-Transfer-Encoding: 8BIT
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
  fs/Kconfig  |    9 +++++++++
  fs/buffer.c |    3 +--
  2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..c08844c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -268,4 +268,13 @@ endif # NETWORK_FILESYSTEMS
  source "fs/nls/Kconfig"
  source "fs/dlm/Kconfig"

+config BH_LRU_SIZE
+      int
+      range 8 64
+      default "16"
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



Le 06/07/2014 18:18, Andi Kleen a écrit :
> Sebastien Buisson <sebastien.buisson@bull.net> writes:
>
>> Allow increasing the buffer-head per-CPU LRU size to allow efficient
>> filesystem operations that access many blocks for each transaction.
>> For example, creating a file in a large ext4 directory with quota
>> enabled will accesses multiple buffer heads and will overflow the LRU
>> at the default 8-block LRU size:
>
> I don't think that should be a user visible config. Most users wouldn't
> know how to set it. And Linux already has far too many obscure
> config options.
>
> Either make it set implicitely by the file system config.
> Or just increase it unconditionally?
>
> -Andi
>
>
