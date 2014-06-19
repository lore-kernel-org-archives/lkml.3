Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbaFSJdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:2300 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741AbaFSJd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,506,1400050800"; 
   d="scan'208";a="550277100"
From: "Cox, Alan" <alan.cox@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "aeb@cwi.nl" <aeb@cwi.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
Thread-Topic: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
Thread-Index: AQHPi6GF/pG+M92XHUW/Q1nLOafDgg==
Date: Thu, 19 Jun 2014 09:33:26 +0000
Message-ID: <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
References: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
In-Reply-To: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.120.243]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D882D0B92303B1449F57E68AA91D1689@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5J9XZRa024995

On Thu, 2014-06-19 at 10:30 +0100, Alan Cox wrote:
> The block code has 32bit cleanness problems with the iterator. This
> prevents things like partitioning a 32GB volume on a 32bit system.
> 
> I hit this with a volume of exactly 32GB in size (easy to duplicate with
> virtual machines). Tracing at step by step through the kernel I found
> the problem lines in blkdev_read_iter which truncates the size value
> into a 32bit value when setting up the iterator.
> 
> The hack below if applied "fixes" this and I think demonstrates that
> this is the problem spot.
> 
> What I'm less clear on is what the correct fix for this should be.

block: fix inability to partition large volumes

From: Alan <alan@linux.intel.com>

The block code has 32bit cleanness problems with the iterator. This
prevents things like partitioning a 32GB volume on a 32bit system.

This is a simple initial "fix" that clips the problem cases so get
behaviour that is at least sane and trivially backportable.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 fs/block_dev.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..bef2414 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1603,6 +1603,9 @@ static ssize_t blkdev_read_iter(struct kiocb
*iocb, struct iov_iter *to)
 
 	size -= pos;
 	iov_iter_truncate(to, size);
+	/* Fix up for 32bit boxes for now */
+	if (to->count < size)
+	        to->count = 0xFFFFFFFF;
 	return generic_file_read_iter(iocb, to);
 }
 

---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
