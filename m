Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbaFXQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:20:33 -0400
Received: from odin2.bull.net ([129.184.85.11]:38707 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363AbaFXQU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:20:29 -0400
X-Greylist: delayed 1705 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2014 12:20:28 EDT
Message-ID: <53A99EA0.3010800@bull.net>
Date: Tue, 24 Jun 2014 17:52:00 +0200
From: Sebastien Buisson <sebastien.buisson@bull.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <rob@landley.net>, <viro@zeniv.linux.org.uk>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.192.1.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Influence of buffer-head per-CPU LRU size on metadata performance has 
been studied with mdtest, on one ext4 formatted ramdisk device, 
creating, stating and removing 1000000 files in the same directory. 
Several test cases were evaluated, varying the 'size' of the directory 
in which files are created:
- target directory is empty
- target directory already contains 100000 files
- target directory already contains 500000 files
- target directory already contains 2000000 files
- target directory already contains 5000000 files
- target directory already contains 10000000 files

To compare the effect of the patch, the same series of tests was run with:
- a vanilla kernel
- a patched kernel with BH_LRU_SIZE set to 16

The tests launched were:
(a) mdtest on ramdisk device, single shared dir, with large ACL and SELinux
(b) mdtest on ramdisk device, single shared dir, with large ACL but NO 
SELinux

Below are the results showing performance gain (in percentage) when 
increasing BH_LRU_SIZE to 16 (vanilla default value is 8):
(a)
files   	tasks 	dir size 	Creation   Stat 	Removal
1000000  	1 	0        	-8,7 	   -2,7 	-0,5
1000000  	1 	100000 	        -5,2 	   -0,5 	-1,1
1000000  	1 	500000 	        -5,1 	   -3,7 	-1,5
1000000  	1 	2000000 	-5,1 	   -4,0 	-8,5
1000000  	1 	5000000 	-4,2 	   -5,3 	-10,2
1000000  	1 	10000000 	-3,5 	   -8,0 	-10,9
1000000 	8 	0 	        -0,3 	   -3,8 	-1,2
1000000  	8 	100000 	        -1,2 	   -3,7 	-1,5
1000000  	8 	500000 	         0,5 	   -3,2 	-5,3
1000000  	8 	2000000 	-1,7 	   -6,1 	-8,7
1000000 	8 	5000000 	-5,9 	   -7,7 	-11,9
1000000  	8 	10000000 	-4,1 	   -8,8 	-13,6

(b)
files 	        tasks 	dir size 	Creation   Stat 	Removal
1000000  	1 	0 	         0,0 	   -0,9 	-1,1
1000000 	1 	100000 	         1,0 	   -3,0 	-3,5
1000000  	1 	500000 	         3,7 	   -3,0 	-2,4
1000000  	1 	2000000 	 1,1 	    3,6 	-0,2
1000000 	1 	5000000 	 3,5 	    0,1 	 5,9
1000000 	1 	10000000 	 9,0 	    3,8 	 6,4
1000000 	8 	0 	         2,4 	   -1,2 	-4,3
1000000 	8 	100000 	        -0,2 	   -1,8 	-2,4
1000000 	8 	500000 	         1,1 	   -0,3 	 2,0
1000000 	8 	2000000 	-0,3 	   -2,8 	-3,3
1000000 	8 	5000000 	 0,3 	   -3,1 	-1,3
1000000 	8 	10000000 	 1,5 	    0,0 	 0,7


To sum up briefly, it is very difficult to show performance improvement 
with mdtest. The only positive case is on Create without SELinux when 
using 1 thread. Strangely the more threads we have, the poorer is the 
gain in performance.


Furthermore, metadata tests were run on Lustre with a specific benchmark 
called mds-survey. They used a ramdisk device, creating, stating and 
removing 1000000 files.

The tests launched were:
(c) mds-survey on ramdisk device, quota enabled, shared directory
(d) mds-survey on ramdisk device, quota enabled, directory per process

Below are the results showing performance gain (in percentage) when 
increasing BH_LRU_SIZE to 16 (vanilla default value is 8):
(c)
files 	        dir 	threads 	create 	lookup 	destroy
1000000 	1 	1 	         11,3 	 1,2 	 7,2
1000000 	1 	2 	          6,4 	 2,3 	 6,9
1000000 	1 	4 	          1,9 	 3,0 	 1,3
1000000 	1 	8 	         -0,6 	 4,3 	 0,7
1000000 	1 	16 	          0,5 	 4,4 	 0,6

(d)
files 	        dir 	threads 	create 	lookup 	destroy
1000000 	4 	4 	          3,2 	28,5 	 5,3
1000000 	8 	8 	          1,2 	33,9 	 2,0
1000000 	16 	16 	          0,6 	 7,9 	-0,2


Compared to pure ext4 tests, we can see more improvements thanks to 
mds-survey. In shared directory case, gain is between 0 and 10% for 
create, between 1 and 4% for lookup, and between 0 and 7% for destroy, 
depending on the number of threads.

All this test plan has been elaborated in collaboration with Intel, and 
results have been already shared with them.



[PATCH] Allow increasing the buffer-head per-CPU LRU size

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

Make this tuning be a kernel parameter 'bh_lru_size'.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
---
  Documentation/kernel-parameters.txt |    3 +++
  fs/buffer.c                         |   35 
+++++++++++++++++++++++++----------
  2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/Documentation/kernel-parameters.txt 
b/Documentation/kernel-parameters.txt
index 9ca3e74..f0b5b2f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -480,6 +480,9 @@ bytes respectively. Such letter suffixes can also be 
entirely omitted.
  			Format: <io>,<irq>,<mode>
  			See header of drivers/net/hamradio/baycom_ser_hdx.c.

+	bh_lru_size=  [KNL]
+			Set the buffer-head per-CPU LRU size.
+
  	blkdevparts=	Manual partition parsing of block device(s) for
  			embedded devices based on command line input.
  			See Documentation/block/cmdline-partition.txt
diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..8e987d6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1256,10 +1256,25 @@ static struct buffer_head *__bread_slow(struct 
buffer_head *bh)
   * a local interrupt disable for that.
   */

-#define BH_LRU_SIZE	8
+#define BH_LRU_SIZE_MAX	64
+
+static unsigned long bh_lru_size = 16;
+static int __init set_bh_lru_size(char *str)
+{
+	if (!str)
+		return 0;
+
+	if (kstrtoul(str, 0, &bh_lru_size))
+		return 0;
+	if (bh_lru_size > BH_LRU_SIZE_MAX)
+		bh_lru_size = BH_LRU_SIZE_MAX;
+
+	return 1;
+}
+__setup("bh_lru_size=", set_bh_lru_size);

  struct bh_lru {
-	struct buffer_head *bhs[BH_LRU_SIZE];
+	struct buffer_head *bhs[BH_LRU_SIZE_MAX];
  };

  static DEFINE_PER_CPU(struct bh_lru, bh_lrus) = {{ NULL }};
@@ -1289,20 +1304,20 @@ static void bh_lru_install(struct buffer_head *bh)
  	check_irqs_on();
  	bh_lru_lock();
  	if (__this_cpu_read(bh_lrus.bhs[0]) != bh) {
-		struct buffer_head *bhs[BH_LRU_SIZE];
+		struct buffer_head *bhs[BH_LRU_SIZE_MAX];
  		int in;
  		int out = 0;

  		get_bh(bh);
  		bhs[out++] = bh;
-		for (in = 0; in < BH_LRU_SIZE; in++) {
+		for (in = 0; in < bh_lru_size; in++) {
  			struct buffer_head *bh2 =
  				__this_cpu_read(bh_lrus.bhs[in]);

  			if (bh2 == bh) {
  				__brelse(bh2);
  			} else {
-				if (out >= BH_LRU_SIZE) {
+				if (out >= bh_lru_size) {
  					BUG_ON(evictee != NULL);
  					evictee = bh2;
  				} else {
@@ -1310,7 +1325,7 @@ static void bh_lru_install(struct buffer_head *bh)
  				}
  			}
  		}
-		while (out < BH_LRU_SIZE)
+		while (out < BH_LRU_SIZE_MAX)
  			bhs[out++] = NULL;
  		memcpy(__this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
  	}
@@ -1331,7 +1346,7 @@ lookup_bh_lru(struct block_device *bdev, sector_t 
block, unsigned size)

  	check_irqs_on();
  	bh_lru_lock();
-	for (i = 0; i < BH_LRU_SIZE; i++) {
+	for (i = 0; i < bh_lru_size; i++) {
  		struct buffer_head *bh = __this_cpu_read(bh_lrus.bhs[i]);

  		if (bh && bh->b_bdev == bdev &&
@@ -1437,7 +1452,7 @@ static void invalidate_bh_lru(void *arg)
  	struct bh_lru *b = &get_cpu_var(bh_lrus);
  	int i;

-	for (i = 0; i < BH_LRU_SIZE; i++) {
+	for (i = 0; i < BH_LRU_SIZE_MAX; i++) {
  		brelse(b->bhs[i]);
  		b->bhs[i] = NULL;
  	}
@@ -1449,7 +1464,7 @@ static bool has_bh_in_lru(int cpu, void *dummy)
  	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
  	int i;
  	
-	for (i = 0; i < BH_LRU_SIZE; i++) {
+	for (i = 0; i < bh_lru_size; i++) {
  		if (b->bhs[i])
  			return 1;
  	}
@@ -3359,7 +3374,7 @@ static void buffer_exit_cpu(int cpu)
  	int i;
  	struct bh_lru *b = &per_cpu(bh_lrus, cpu);

-	for (i = 0; i < BH_LRU_SIZE; i++) {
+	for (i = 0; i < BH_LRU_SIZE_MAX; i++) {
  		brelse(b->bhs[i]);
  		b->bhs[i] = NULL;
  	}
-- 
1.7.1

