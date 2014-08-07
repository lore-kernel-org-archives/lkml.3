Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaHGS5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:57:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:12897 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaHGS5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:57:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,819,1400050800"; 
   d="scan'208";a="584927833"
Message-ID: <1407437449.2869.6.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 3/4] brd: Fix all partitions BUGs
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 07 Aug 2014 12:50:49 -0600
In-Reply-To: <53E342AD.2070303@gmail.com>
References: <53E21125.9080308@plexistor.com>
		 <53E2127B.1020805@plexistor.com>
	 <1407366387.2869.3.camel@rzwisler-mobl1.amr.corp.intel.com>
	 <53E342AD.2070303@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-07 at 12:11 +0300, Boaz Harrosh wrote:
> On 08/07/2014 02:06 AM, Ross Zwisler wrote:
> > Also, it looks like you can still create a new device with this patch, but you
> > can't create partitions on that device.  Not sure if this is just what you get
> > when you dynamically create a device on the fly, or if it's a symptom of
> > something larger.
> > 
> 
> What? I just tried again this all works fine for me, here with fdisk.
> $ modprobe brd      # will create ram0-7
> $ mknod /dev/ram8 b 1 8
> $ fdisk /dev/ram8
>   g, n, , , +2M, n, , , , , w 
> 
> I create 2 partitions 2M each and press w and it is all there.
> 
> What numbers did you use ? rd_nr, max_part, and the mknod numbers. Here it
> just works fine. What did you try?

Ah - it turns out the issue was that I wasn't following the naming scheme
"ramX" where X is your new device name.  Here's the sequence:

	# mknod /dev/ram_new b 1 6
	# fdisk /dev/ram_new 
		< create some partitions>

This ends up creating a "ram_new" and a "ram6", which have the same
major/minor.  The partitions do show up, but they live under ram6:

	brw-rw---- 1 root disk   1, 6 Aug  7 12:36 ram6
	brw-rw---- 1 root disk 259, 0 Aug  7 12:36 ram6p1
	brw-rw---- 1 root disk 259, 1 Aug  7 12:36 ram6p2
	brw-r--r-- 1 root root   1, 6 Aug  7 12:36 ram_new

You can run fdisk -l, etc, on ram_new, and it'll show you the partitions, they
just won't be surfaced in /dev.  ram6 and ram_new seem to be alaises:

	# fdisk -l /dev/ram_new

	Disk /dev/ram_new: 8589 MB, 8589934592 bytes
	64 heads, 32 sectors/track, 8192 cylinders
	Units = cylinders of 2048 * 512 = 1048576 bytes
	Sector size (logical/physical): 512 bytes / 4096 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x2812942c

	       Device Boot      Start         End      Blocks   Id  System
	/dev/ram_new1               1        2049     2098160   83  Linux
	/dev/ram_new2            2050        8192     6290432   83  Linux

This device aliasing happened with the old BRD code as well, so this isn't new
behavior.

- Ross


