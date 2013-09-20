Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3ITWbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 18:31:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3ITWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 18:31:31 -0400
Date: Fri, 20 Sep 2013 15:31:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Olof Johansson <olof@lixom.net>, Jeff Moyer <jmoyer@redhat.com>,
        OS Engineering <osengineering@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
Message-Id: <20130920153128.63244ec2658b7ad3aee0e2e4@linux-foundation.org>
In-Reply-To: <5238B9A7.6040002@kernel.dk>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad>
	<x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
	<26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad>
	<x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
	<5228913A.50807@kernel.dk>
	<CAOesGMhF42=qQLyMyF4-tsTjCxwX0bb10rTQv9sLooyzrEOpHA@mail.gmail.com>
	<5238B9A7.6040002@kernel.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 14:20:55 -0600 Jens Axboe <axboe@kernel.dk> wrote:

> > So, it looks like this driver needs a bunch of work before it's ready
> > to go in. Or, maybe it's better to submit it with a TODO list for the
> > staging tree instead?
> 
> Not disagreeing with you, it definitely needs a bit of cleaning. And so
> far stec has not been very responsive in fixing those issues.

Geeze.  Here's what I came up with, mainly to make i386 compile:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/skd_main.c: fix a few things, disable on 32-bit

Fix these (i386 allmodconfig):

drivers/block/skd_main.c:4559: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/block/skd_main.c:4614: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/block/skd_main.c:4614: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'unsigned int'
drivers/block/skd_main.c:4626: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
drivers/block/skd_main.c:4626: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'unsigned int'
drivers/block/skd_main.c:4671: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/block/skd_main.c:4671: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'unsigned int'

And what remains is these:

drivers/block/skd_main.c: In function 'skd_reg_write64':
drivers/block/skd_main.c:439: error: implicit declaration of function 'writeq'
drivers/block/skd_main.c:441: error: implicit declaration of function 'readq'
drivers/block/skd_main.c: In function 'skd_cons_skmsg':
drivers/block/skd_main.c:4589: warning: cast from pointer to integer of different size
drivers/block/skd_main.c:4592: warning: cast from pointer to integer of different size
drivers/block/skd_main.c:4593: warning: cast to pointer from integer of different size

Which is more than I'm prepared to address, so just disable the driver on
32-bit builds.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig    |    1 +
 drivers/block/skd_main.c |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/block/skd_main.c~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit drivers/block/skd_main.c
--- a/drivers/block/skd_main.c~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit
+++ a/drivers/block/skd_main.c
@@ -4556,7 +4556,7 @@ static int skd_cons_skmsg(struct skd_dev
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
+	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
 		sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
 		(unsigned long) sizeof(struct skd_fitmsg_context) *
@@ -4611,7 +4611,7 @@ static int skd_cons_skreq(struct skd_dev
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
+	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
 		sizeof(struct skd_request_context),
 		skdev->num_req_context,
 		sizeof(struct skd_request_context) * skdev->num_req_context);
@@ -4623,7 +4623,7 @@ static int skd_cons_skreq(struct skd_dev
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
+	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
 		skdev->sgs_per_request, sizeof(struct scatterlist),
 		skdev->sgs_per_request * sizeof(struct scatterlist));
 
@@ -4668,7 +4668,7 @@ static int skd_cons_skspcl(struct skd_de
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
+	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
 		sizeof(struct skd_special_context),
 		skdev->n_special,
 		sizeof(struct skd_special_context) * skdev->n_special);
diff -puN drivers/block/Kconfig~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit drivers/block/Kconfig
--- a/drivers/block/Kconfig~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit
+++ a/drivers/block/Kconfig
@@ -319,6 +319,7 @@ config BLK_DEV_NVME
 config BLK_DEV_SKD
 	tristate "STEC S1120 Block Driver"
 	depends on PCI
+	depends on 64BIT
 	---help---
 	Saying Y or M here will enable support for the
 	STEC, Inc. S1120 PCIe SSD.
_

