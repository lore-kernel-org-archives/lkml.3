Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3CUAyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:54:11 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46039 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3CUAyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:54:09 -0400
From: "Seymour, Shane M" <shane.seymour@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] Implementing tape statistics
Thread-Topic: [RFC] Implementing tape statistics
Thread-Index: Ac4lzhyOUPk3CXhFQP6t9k/6tZEAig==
Date: Thu, 21 Mar 2013 00:52:15 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3436A2CE@G9W0766.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before you start reading this I want to apologize in advance for the length of this email. The length is important though to make sure all of the arguments and counter-arguments are represented in asking for feedback about how tape statistics would be best implemented.

There is some demand for the provision of tape IO statistics by users of the enterprise distributions, in particular those possessing large scale tape libraries. The provision of interfaces for getting statistics about tape I/O for use by utilities such as sar is a feature present in most commercial UNIX distributions.

Several patches have been produced and presented to linux-scsi mailing list but it seems that there are differences of opinion that cannot be reconciled and hence currently no acceptance of the proposed solutions. I have therefore decided to post to the wider kernel list to see if we can come to some consensus on what one of these (or other) should be adopted.

No patches are presented in this email for the sake of brevity, it's only a summary of the implementation and consequences along with discussion points for each. Note that this is not an attempt to work around the feedback gained on the linux-scsi mailing list but an attempt to get a wider consensus on what would be an acceptable implementation of a tape statistics interface.


Option #1
=========

Provide device based stats vis sysfs:

/sys/class/scsi_tape/stNN/stats   (where NN is the tape device instance number)

The stat file provides the following in a one line entry suitable for a single fgets() and processing by sscanf():

+/* Tape stats */
+	u64 read_byte_cnt;	/* bytes read since tape open */
+	u64 write_byte_cnt;	/* bytes written since tape open */
+	u64 in_flight;		/* Number of I/Os in flight */
+	u64 read_cnt;		/* Count of read requests since tape open */
+	u64 write_cnt;		/* Count of write requests since tape open */
+	u64 other_cnt;		/* Count of other requests since tape open
+				   either implicit (from driver) or from
+				   user space via ioctl. */
+	u64 read_ticks;		/* Ticks spent completing read requests */
+	u64 write_ticks;	/* Ticks spent completing write requests */
+	u64 io_ticks;		/* Ticks spent doing any I/O */
+	u64 stamp;		/* holds time request was queued */

The file contents are almost the same as the stat file for disks except the merge statistics are always 0 (since tape drives are sequential merged I/Os don't make sense) and the inflight value is almost always either a 0 or 1 since the st module always only has either one read or write outstanding. An additional field is added to the end of the file - a count of other I/Os - this could be commands issued by the driver within the kernel (e.g. rewind) or via an ioctl from user space. For tape drives some commands involving actions like tape movement can take a long time, it's important to keep track of scsi requests sent to the tape drive other than reads and writes so when delays happen they can be explained.

With some future patches to iostat this data will be reported, an example set of data is (the extra other_cnt data allows an average wait for all (a_await) and other I/Os per second (oio/s)):

tape:   wr/s   KiB_write/s    rd/s  KiB_read/s  r_await  w_await  a_await  oio/s
st0   186.50         46.75    0.00        0.00    0.000    0.276    0.276   0.00
st1   186.00         93.00    0.00        0.00    0.000    0.180    0.180   0.00
st2     0.00          0.00  181.50       45.50    0.347    0.000    0.347   0.00
st3     0.00          0.00  183.00       45.75    0.224    0.000    0.224   0.00

## This is our preferred method of implementation since it is efficient for both kernel and user-space (also requires fewest code changes), it also matches that already presented for the disk block subsys, see for example:

# grep . /sys/block/sd*/stat
/sys/block/sda/stat:   27351     6890   609272   228129    36810   920727  7660304  1333950        0   556889  1562009
/sys/block/sdb/stat:    2369     6762    18890    39003        0        0        0        0        0     4059    39002

## SCSI maintainers counter-point: "I'm afraid we can't do it the way you're proposing.  files in sysfs must conform to the one value per file rule (so we avoid the ABI nastiness that plagues /proc).  You can create a stat directory with a bunch of files, but not a single file that gives all values.

## My counter:

I can only assume it (sysfs blk_subsys stat file) was implemented this way for the sake of efficiency, eg avoid a huge amount of file open/read/close calls in sar/iostat.  It's not unusual for us to see over a thousand block devices on enterprise servers, multiply that by the number of above entries and you would be talking about 9 x block-dev-count per iostat read iteration.  Okay for tapes we typically don't see anything like this number but the patch just follows the precedent set with the block device.


The sysfs.txt docs say:

Attributes
~~~~~~~~~~

Attributes can be exported for kobjects in the form of regular files in the filesystem. Sysfs forwards file I/O operations to methods defined for the attributes, providing a means to read and write kernel attributes.

Attributes should be ASCII text files, preferably with only one value per file. It is noted that it may not be efficient to contain only one value per file, so it is socially acceptable to express an array of values of the same type.
....


Option #2
=========

Nevertheless, to address the concerns of the 1 record per 1 sysfs file a prototype with the stats broken out as follows has also been tested:

# cd /sys/class/scsi_tape/st0/device/statistics
# ll
total 0
-r--r--r--. 1 root root 4096 Mar  1 09:33 in_flight
-r--r--r--. 1 root root 4096 Mar  1 09:33 io_ms 
-r--r--r--. 1 root root 4096 Mar  1 09:33 other_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 read_block_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 read_byte_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 read_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 read_ms 
-r--r--r--. 1 root root 4096 Mar  1 09:33 write_block_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 write_byte_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 write_cnt 
-r--r--r--. 1 root root 4096 Mar  1 09:33 write_ms

## I dislike this breakout because it adds complexity in both the kernel st.ko driver (300 odd extra lines of code) as well as making life more complicated and less efficient in user-space.  The st module maintainer is against this option being implemented as the one and only solution, they would prefer Option#1 or Option#3.

 
Option #3
=========

Provide Option#1  _and/or_ Option#2 via debugfs, where structure is less restricted.

## This is a compromise. It seems that almost anything is acceptable here (few constraints) so either options could be used.  However we dislike the notion of using debugfs for several reasons:

* we are not presenting internal, technical info for developers, this is primarily device based counters/statistics to be used by apps such as iostat/sar etc in the same way as /sys/block/sd*/stat can be now

* debugfs IS typically included in the enterprise distributions but not mounted as a matter of course (sysfs is), hence for the user-space apps to work users would have to take action to ensure that debugfs is mounted

* more code/complexity has to be added in to st.ko to support this implementation, in either form, more than for even Option#2


Additional Features:
====================

A. /sys/bus/scsi/drivers/st/drives

This file contains an integer count to indicate the maximum number of tape drives connected to the system since boot. The value is incremented for each device discovered in st_probe(). The purpose of this file is to just provide an upper level hint to assist user-space apps to iterate over the stNN devices (eg: for (stN=0; stN < drives; stN++)).  The value is not decremented when a drive is removed. It is left to user-space to detect missing devices (those removed), remembering that in SAN based tape libs devices can come/go and there could be many dozens of tape drives.  This should help with user-space coding efficiency.


B. /sys/bus/scsi/drivers/st/open_zero_stats

A system-wide boolean to control the behaviour of the individual tape stats, ie should they be reset to zero upon device open (by default they are not).

Again these could be presented under debugfs.


================

If the only way we can get agreement for acceptance is with Option#3 then we will concede and reimplement using debugfs but I would appreciate further comments on the above proposals.
