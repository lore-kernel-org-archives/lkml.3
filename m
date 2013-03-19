Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab3CSRRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:17:08 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44512 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab3CSRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 00/18] RFC: Non blocking submit for activity log misses
Date: Tue, 19 Mar 2013 18:16:41 +0100
Message-Id: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Issues

Since the beginning DRBD was written with the assumption that the write
pattern has spacial locality. (This assumption was driven from the fact,
that rotating media performs better if you do not send the head too far too
often)

Backed by this assumption a caller that submits a request that is outside of
the current active set, was blocked until the active set was changed.
(Changing the active set is a synchronous write operation to the meta-data
area on the backing storage = "an AL-update" in DRBD-speak)

A second effect was that DRBD's meta-data was located in a very narrow
area. When DRBD is used on top of a RAID0 stripe set, this causes all
AL-updates to got to the same disk.


The Proposed Solution

This patch series improves DRBD's behavior. A submitter is no longer blocked
in the case of a AL-miss. For this a dedicated submitter worker is introduced
(patch 13).

In order to better distribute the AL-updates to more disks in a stripe set
this patch series also introduces an optional striped layout of the part
of the meta-data that holds the AL-updates (patch 4).


The Results

This of course drastically improves DRBD's performance if the write pattern
does not have any spacial locality. E.g. random writes spread out over the
whole device.

In the test systems we have SSDs with are able to do up to 50000 writes per
second. The test does random distributed writes over a work set size of
128GiB with IO depths from 1 to 1024.

At an IO depth of 64:
without this patch we observed ~100 IOPs.
With this patches we observed about 20000 IOPs.

Please find charts of the results here:
http://blogs.linbit.com/p/469/843-random-writes-faster/


Lars Ellenberg (18):
  drbd: cleanup bogus assert message
  drbd: cleanup ondisk meta data layout calculations and defines
  drbd: prepare for new striped layout of activity log
  drbd: use the cached meta_dev_idx
  drbd: mechanically rename la_size to la_size_sect
  drbd: read meta data early, base on-disk offsets on super block
  drbd: Clarify when activity log I/O is delegated to the worker thread
  drbd: drbd_al_being_io: short circuit to reduce latency
  drbd: split __drbd_make_request in before and after drbd_al_begin_io
  drbd: prepare to queue write requests on a submit worker
  drbd: split drbd_al_begin_io into fastpath, prepare, and commit
  drbd: split out some helper functions to drbd_al_begin_io
  drbd: queue writes on submitter thread, unless they pass the activity
    log fastpath
  lru_cache: introduce lc_get_cumulative()
  drbd: consolidate as many updates as possible into one AL transaction
  drbd: move start io accounting before activity log transaction
  drbd: try hard to max out the updates per AL transaction
  drbd: adjust upper limit for activity log extents

 drivers/block/drbd/drbd_actlog.c   |  246 +++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_bitmap.c   |   13 +-
 drivers/block/drbd/drbd_int.h      |  179 +++++++++++++-------------
 drivers/block/drbd/drbd_main.c     |  243 +++++++++++++++++++++++++++++------
 drivers/block/drbd/drbd_nl.c       |  129 ++++++++++++-------
 drivers/block/drbd/drbd_receiver.c |    4 +-
 drivers/block/drbd/drbd_req.c      |  166 +++++++++++++++++++++---
 drivers/block/drbd/drbd_worker.c   |    5 +-
 include/linux/drbd_limits.h        |   11 +-
 include/linux/lru_cache.h          |    1 +
 lib/lru_cache.c                    |   55 ++++++--
 11 files changed, 782 insertions(+), 270 deletions(-)

-- 
1.7.9.5

