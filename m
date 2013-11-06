Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3KFNsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:42 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54706 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805Ab3KFNsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:38 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 08/11] VFS hot tracking: Add documentation
Date: Wed,  6 Nov 2013 21:45:41 +0800
Message-Id: <1383745544-391-9-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-0320-0000-0000-000001A3EE37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add Documentation for VFS hot tracking feature

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 Documentation/filesystems/00-INDEX         |   2 +
 Documentation/filesystems/hot_tracking.txt | 207 +++++++++++++++++++++++++++++
 2 files changed, 209 insertions(+)
 create mode 100644 Documentation/filesystems/hot_tracking.txt

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 8042050..46b2f6f 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -122,3 +122,5 @@ xfs.txt
 	- info and mount options for the XFS filesystem.
 xip.txt
 	- info on execute-in-place for file mappings.
+hot_tracking.txt
+	- info on hot tracking in VFS layer
diff --git a/Documentation/filesystems/hot_tracking.txt b/Documentation/filesystems/hot_tracking.txt
new file mode 100644
index 0000000..df184b9
--- /dev/null
+++ b/Documentation/filesystems/hot_tracking.txt
@@ -0,0 +1,207 @@
+Hot Data Tracking
+
+April, 2013		Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+
+CONTENTS
+
+1. Introduction
+2. Motivation
+3. The Design
+4. How to Calc Frequency of Reads/Writes & Temperature
+5. Git Development Tree
+6. Usage Example
+
+
+1. Introduction
+
+  The feature adds the  support for tracking data temperature
+information in VFS layer.  Essentially, this means maintaining some key
+stats(like number of reads/writes, last read/write time, frequency of
+reads/writes), then distilling those numbers down to a single
+"temperature" value that reflects what data is "hot", and filesystem
+can use this information to move hot data from slow devices to fast
+devices.
+
+  The long-term goal of the feature is to allow some FSs,
+e.g. Btrfs to intelligently utilize SSDs in a heterogenous volume.
+Incidentally, this project has been motivated by
+the Project Ideas page on the Btrfs wiki.
+
+
+2. Motivation
+
+  This is essentially the traditional cache argument: SSD is fast and
+expensive; HDD is cheap but slow. ZFS, for example, can already take
+advantage of SSD caching. Btrfs should also be able to take advantage of
+hybrid storage without many broad, sweeping changes to existing code.
+
+  The overall goal of enabling hot data relocation to SSD has been
+motivated by the Project Ideas page on the Btrfs wiki at
+<https://btrfs.wiki.kernel.org/index.php/Project_ideas>.
+It will divide into two parts. VFS provide hot data tracking function
+while specific FS will provide hot data relocation function.
+So as the first step of this goal, this feature provides the first part
+of the functionality.
+
+
+3. The Design
+
+These include the following parts:
+
+    * Hooks in existing vfs functions to track data access frequency
+
+    * New rb-trees for tracking access frequency of inodes and sub-file
+ranges
+    The relationship between super_block and rb-trees is as below:
+hot_info.hot_inode_tree
+    Each FS instance can find hot tracking info s_hot_root.
+    hot_info has hot_inode_tree and it has inode's hot information,
+and it has hot_range_tree, which has range's hot information.
+
+    * A list of hot inodes and hot ranges by its temperature
+
+    * A work queue for updating inode heat info
+
+    * Mount options for enabling temperature tracking(-o hot_track,
+default mean disabled)
+    * An ioctl to retrieve the frequency information collected for a certain
+inode
+
+Let us see their relationship as below:
+
+    * hot_info.hot_inode_tree indexes hot_inode_items, one per inode
+
+    * hot_inode_item contains access frequency data for that inode
+
+    * hot_inode_item holds a track list node to link the access frequency
+data for that inode
+
+    * hot_inode_item.hot_range_tree indexes hot_range_items for that inode
+
+    * hot_range_item contains access frequency data for that range
+
+    * hot_range_item holds a track list node to link the access frequency
+data for that range
+
+    * hot_info.hot_map[TYPE_INODE] indexes per-inode track list nodes
+
+    * hot_info.hot_map[TYPE_RANGE] indexes per-range track list nodes
+
+  How about some ascii art? :) Just looking at the hot inode item case
+(the range item case is the same pattern, though), we have:
+
+                          super_block
+                              |
+                              V
+                           hot_info
+                              |
+    +-------------------------+----------------------------------------+
+    |                         |                                        |
+    |                         |                                        |
+    V                         V                                        V
+heat_inode_map           hot_inode_tree                         heat_range_map
+    |                         |                                        |
+    |                         V hot_inode_item                         |
+    |           +----------list_head---------+                         |
+    |           |       frequency data       |                         |
++---+           |                            |                         |
+|               V hot_inode_item             V hot_inode_item          |
+|....<-----list-head--->...      ...<----list_head---->...             |
+        frequency data                 frequency data                  |
+         hot_range_tree                hot_range_tree                  |
+                                             |                         |
+                                             V hot_range_item          |
+                               +---------list_head----------+          |
+                               |       frequency data       |          |
+                               |            ^               |          +---+
+                hot_range_item V            | |             Vhot_range_item|
+                        <--list_head-->...  | |  ...<--list_head-->....... |
+                        frequency data               frequency data
+
+
+4. How to Calc Frequency of Reads/Writes & Temperature
+
+1.) hot_freq_calc()
+
+  This function does the actual work of updating the frequency numbers.
+FREQ_POWER determines how many atime deltas we keep track of (as a power of 2).
+So, setting it to anything above 16ish is probably overkill. Also,
+the higher the power, the more bits get right shifted out of the timestamp,
+reducing precision, so take note of that as well.
+
+  FREQ_POWER, defined immediately below, determines how heavily to weight
+the current frequency numbers against the newest access. For example, a value
+of 4 means that the new access information will be weighted 1/16th (ie 2^-4)
+as heavily as the existing frequency info. In essence, this is a kludged-
+together version of a weighted average, since we can't afford to keep all of
+the information that it would take to get a _real_ weighted average.
+
+2.) hot_temp_calc()
+
+  The following comments explain what exactly comprises a unit of heat.
+Each of six values of heat are calculated and combined in order to form an
+overall temperature for the data:
+
+    * NRR - number of reads since mount
+    * NRW - number of writes since mount
+    * LTR - time elapsed since last read (ns)
+    * LTW - time elapsed since last write (ns)
+    * AVR - average delta between recent reads (ns)
+    * AVW - average delta between recent writes (ns)
+
+  These values are divided (right-shifted) according to the *_DIVIDER_POWER
+values defined below to bring the numbers into a reasonable range. You can
+modify these values to fit your needs. However, each heat unit is a u32 and
+thus maxes out at 2^32 - 1. Therefore, you must choose your dividers quite
+carefully or else they could max out or be stuck at zero quite easily.
+(E.g., if you chose AVR_DIVIDER_POWER = 0, nothing less than 4s of atime
+delta would bring the temperature above zero, ever.)
+
+  Finally, each value is added to the overall temperature between 0 and 8
+times, depending on its *_COEFF_POWER value. Note that the coefficients are
+also actually implemented with shifts, so take care to treat these values
+as powers of 2. (I.e., 0 means we'll add it to the temp once; 1 = 2x, etc.)
+
+    * AVR/AVW cold unit = 2^X ns of average delta
+    * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+
+  E.g., data with an average delta between 0 and 2^X ns will have a cold
+value of 0, which means a heat value equal to HEAT_MAX_VALUE.
+
+  This function is responsible for distilling the six heat
+criteria, which are described in detail in hot_tracking.h) down into a single
+temperature value for the data, which is an integer between 0
+and HEAT_MAX_VALUE.
+
+  To accomplish this, the raw values from the hot_freq_data structure
+are shifted in order to make the temperature calculation more
+or less sensitive to each value.
+
+  Once this calibration has happened, we do some additional normalization and
+make sure that everything fits nicely in a u32. From there, we take a very
+rudimentary kind of "average" of each of the values, where the *_COEFF_POWER
+values act as weights for the average.
+
+  Finally, we use the MAP_BITS value, which determines the size of the
+heat list array, to normalize the temperature to the proper granularity.
+
+
+5. Git Development Tree
+
+  This feature is still on development and review, so if you're interested,
+you can pull from the git repository at the following location:
+
+  https://github.com/wuzhy/kernel.git hot_tracking
+  git://github.com/wuzhy/kernel.git hot_tracking
+
+
+6. Usage Example
+
+1.) To use hot tracking, you should mount like this:
+
+$ mount -o hot_track /dev/sdb /mnt
+[ 1505.894078] device label test devid 1 transid 29 /dev/sdb
+[ 1505.952977] btrfs: disk space caching is enabled
+[ 1506.069678] VFS: Turning on hot tracking
+
+2.) Retrieve hot tracking info for some specific file by ioctl().
-- 
1.7.11.7

