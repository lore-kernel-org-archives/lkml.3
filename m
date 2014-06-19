Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbaFSJaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:30:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:49647 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868AbaFSJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="355862514"
Message-ID: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
Subject: Cannot partition 32GB disk on a 32bit machine
From: Alan Cox <alan@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, aeb@cwi.nl,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 10:30:01 +0100
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block code has 32bit cleanness problems with the iterator. This
prevents things like partitioning a 32GB volume on a 32bit system.

I hit this with a volume of exactly 32GB in size (easy to duplicate with
virtual machines). Tracing at step by step through the kernel I found
the problem lines in blkdev_read_iter which truncates the size value
into a 32bit value when setting up the iterator.

The hack below if applied "fixes" this and I think demonstrates that
this is the problem spot.

What I'm less clear on is what the correct fix for this should be.


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..3792406 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1603,6 +1603,9 @@ static ssize_t blkdev_read_iter(struct kiocb
*iocb, struct iov_iter *to)
 
 	size -= pos;
 	iov_iter_truncate(to, size);
+	/* Fix up for 32bit boxes for now */
+	if (to->count < size)
+	        to->count = size;
 	return generic_file_read_iter(iocb, to);
 }
 


