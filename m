Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaBZMcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:32:08 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33964 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaBZMb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:31:58 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv8 6/6] zram: document max_comp_streams
Date: Wed, 26 Feb 2014 15:27:59 +0300
Message-Id: <1393417679-13657-7-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add max_comp_streams device attribute documentation.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 Documentation/ABI/testing/sysfs-block-zram |  9 ++++++++-
 Documentation/blockdev/zram.txt            | 31 +++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index 8aa0468..0da9ed6 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -50,7 +50,6 @@ Description:
 		The failed_reads file is read-only and specifies the number of
 		failed reads happened on this device.
 
-
 What:		/sys/block/zram<id>/failed_writes
 Date:		February 2014
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
@@ -58,6 +57,14 @@ Description:
 		The failed_writes file is read-only and specifies the number of
 		failed writes happened on this device.
 
+What:		/sys/block/zram<id>/max_comp_streams
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The max_comp_streams file is read-write and specifies the
+		number of backend's zcomp_strm compression streams (number of
+		concurrent compress operations).
+
 What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index b31ac5e..1f96abb 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -21,7 +21,28 @@ Following shows a typical sequence of steps for using zram.
 	This creates 4 devices: /dev/zram{0,1,2,3}
 	(num_devices parameter is optional. Default: 1)
 
-2) Set Disksize
+2) Set max number of compression streams
+	Compression backend may use up to max_comp_streams compression streams,
+	thus allowing up to max_comp_streams concurrent compression operations.
+	By default, compression backend uses single compression stream.
+
+	Examples:
+	#show max compression streams number
+	cat /sys/block/zram0/max_comp_streams
+
+	#set max compression streams number to 3
+	echo 3 > /sys/block/zram0/max_comp_streams
+
+Note:
+In order to enable compression backend's multi stream support max_comp_streams must
+be initially set to desired concurrency level before ZRAM device initialisation.
+Once the device initialised as a single stream compression backend (max_comp_streams
+equals to 0) changing the value of max_comp_streams will not take any effect, because
+single stream compression backend implemented as a special case and does not support
+dynamic max_comp_streams. Only multi stream backend supports dynamic max_comp_streams
+adjustment.
+
+3) Set Disksize
         Set disk size by writing the value to sysfs node 'disksize'.
         The value can be either in bytes or you can use mem suffixes.
         Examples:
@@ -38,14 +59,14 @@ There is little point creating a zram of greater than twice the size of memory
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-3) Activate:
+4) Activate:
 	mkswap /dev/zram0
 	swapon /dev/zram0
 
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-4) Stats:
+5) Stats:
 	Per-device statistics are exported as various nodes under
 	/sys/block/zram<id>/
 		disksize
@@ -60,11 +81,11 @@ size of the disk when not in use so a huge zram is wasteful.
 		compr_data_size
 		mem_used_total
 
-5) Deactivate:
+6) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-6) Reset:
+7) Reset:
 	Write any positive value to 'reset' sysfs node
 	echo 1 > /sys/block/zram0/reset
 	echo 1 > /sys/block/zram1/reset
-- 
1.9.0.291.g027825b

