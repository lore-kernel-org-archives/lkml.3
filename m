Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaIKX5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:57:32 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:51465 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaIKX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:57:29 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com, avanzini.arianna@gmail.com
Subject: [PATCH RFC v2 0/5] Multi-queue support for xen-blkfront and xen-blkback
Date: Fri, 12 Sep 2014 01:57:19 +0200
Message-Id: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patchset adds to the Xen PV block driver support to exploit the multi-
queue block layer API by sharing and using multiple I/O rings in the frontend
and backend. It is the result of my internship for GNOME's Outreach Program
for Women ([1]), in which I was mentored by Konrad Rzeszutek Wilk.

The patchset implements in the backend driver the retrieval of information
about the currently-in-use block layer API for a certain device and about
the number of available submission queues, if the API turns out to be the
multi-queue one. The information is then advertised to the frontend driver
via XenStore.
The frontend device can exploit such an information to allocate and grant
multiple I/O rings and advertise the final number to the backend so that
it will be able to map them.
The patchset has been tested with fio's IOmeter emulation on a four-cores
machine with a null_blk device (some results are available here: [2]).

With respect to the first version of this RFC patchset ([3]), the patchset has
undergone the following changes (as the structure of the patchset itself
has changed, I'm summarizing them here).

. Now the use of the multi-queue API replaces that of the request queue API,
  as indicated by Christoph Hellwig.
. Patch 0003 from the previous patchset has been split into two patches, the
  first introducing in the frontend actual support for multiple block rings,
  the second adding support to negotiate the number of I/O rings with the
  backend, as suggested by David Vrabel.
. Patch 0004 from the previous patchset has been split into two patches, the
  first introducing in the backend support for multiple block rings, the second
  adding support to negotiate the number of I/O rings, as suggested by David
  Vrabel.
. Added the BLK_MQ_F_SG_MERGE and BLK_MQ_F_SHOULD_SORT flags to the frontend
  driver's initialization as suggested by Christoph Hellwig.
. Removed empty/useless definition of the init_hctx and complete hooks, as
  pointed out by Christoph Hellwig.
. Removed useless debug printk()s from code added in xen-blkfront, as indicated
  by David Vrabel.
. Added return of an actual error code in the blk_mq_init_queue() failure path
  in xlvbd_init_blk_queue(), as suggested by Christoph Hellwig.
. Fixed coding style issue in blkfront_queue_rq() as suggested by Christoph
  Hellwig.

. Added support for the migration of a multi-queue-capable domU to a host with
  non-multi-queue-capable devices.
. Fixed locking issues in the interrupt path, avoiding to grab the io_lock
  twice when calling blk_mq_start_stopped_hw_queues().
. Fixed wrong use of the return value of blk_mq_init_queue().
. Dropped the use of ternary operator in the macros that compute the number
  of per-ring requests and grants: now they use the max() macro.

Any comments or suggestions are more than welcome.
Thank you,
Arianna

[1] http://goo.gl/bcvHMh
[2] http://goo.gl/O8RlLL
[3] http://lkml.org/lkml/2014/8/22/158

Arianna Avanzini (5):
  xen, blkfront: port to the the multi-queue block layer API
  xen, blkfront: introduce support for multiple block rings
  xen, blkfront: negotiate the number of block rings with the backend
  xen, blkback: introduce support for multiple block rings
  xen, blkback: negotiate of the number of block rings with the frontend

 drivers/block/xen-blkback/blkback.c | 377 ++++++++-------
 drivers/block/xen-blkback/common.h  | 110 +++--
 drivers/block/xen-blkback/xenbus.c  | 472 +++++++++++++------
 drivers/block/xen-blkfront.c        | 894 +++++++++++++++++++++---------------
 4 files changed, 1122 insertions(+), 731 deletions(-)

-- 
2.1.0

