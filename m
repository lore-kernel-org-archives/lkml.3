Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaHVUcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:32:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:65106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaHVUcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:32:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,383,1406617200"; 
   d="scan'208";a="588688292"
Date: Fri, 22 Aug 2014 14:32:41 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Keith Busch <keith.busch@intel.com>
cc: Christoph Hellwig <hch@infradead.org>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, willy@linux.intel.com,
        nilesh.choudhury@oracle.com, indraneel.m@samsung.com,
        shiro.itou@outlook.com
Subject: Re: [PATCH] fs/block_dev.c: Use hd_part to find block inodes
In-Reply-To: <alpine.LRH.2.03.1408221341280.4696@AMR>
Message-ID: <alpine.LRH.2.03.1408221429020.4696@AMR>
References: <1408724896-3671-1-git-send-email-keith.busch@intel.com> <20140822174848.GA11819@infradead.org> <alpine.LRH.2.03.1408221341280.4696@AMR>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Keith Busch wrote:
> On Fri, 22 Aug 2014, Christoph Hellwig wrote:
>> On Fri, Aug 22, 2014 at 10:28:16AM -0600, Keith Busch wrote:
>>> When using the GENHD_FL_EXT_DEVT disk flags, a newly added device may
>>> be assigned the same major/minor as one that was previously removed but
>>> opened, and the pesky userspace refuses to close it!
>> 
>> Which means life time rules for those dev_t allocations are broken.
>> Please fix it to not release the dev_t until the device isn't referenced
>> at all.
>
> Okay, thanks. So a proper fix would not let extended devt minors get
> reused while still referenced, so we can't release it unconditionally
> from del_gendisk(). I think the following does that, but I had to add
> a reference counter to gendisk.

Sorry for the rapid churn; I hadn't followed the function pointers through
to discover the correct place to release the devt. This one's much simpler:
---
diff --git a/block/genhd.c b/block/genhd.c
index 791f419..321f1fd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -665,7 +665,6 @@ void del_gendisk(struct gendisk *disk)
  		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
  	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
  	device_del(disk_to_dev(disk));
-	blk_free_devt(disk_to_dev(disk)->devt);
  }
  EXPORT_SYMBOL(del_gendisk);

@@ -1098,6 +1097,7 @@ static void disk_release(struct device *dev)
  {
  	struct gendisk *disk = dev_to_disk(dev);

+	blk_free_devt(dev->devt);
  	disk_release_events(disk);
  	kfree(disk->random);
  	disk_replace_part_tbl(disk, NULL);
--
