Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3A3KAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:00:42 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:37972 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3A3KAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:00:38 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [GIT PULL] drbd activity log improvements for the 3.9 merge window
Date: Wed, 30 Jan 2013 11:00:32 +0100
Message-ID: <1743669.WHLDGuSuul@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-36-lowlatency; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

this is our contribution to the next merge-window:

With this release we have three important improvements to the activity log:

  1 Starting with 8.4.3 the activity log has a variable size on disk
    (before it was fixed 32KiByte). 
    -> The limitation of 6433 on the al-extents option is no longer.

  2 The activity log can be organised as a stripe set in the meta-data.

  3 Never block a caller submitting a BIO, but hand off the writing
    of AL-updates to a dedicated worker thread.
    (In the past DRBD blocked the caller when a submitted BIO is not
     covered by the current active set, until the transaction was written
     into the AL.)

With these changed we see substantial improvement in overall IOPs,
on workloads that are bigger than the active set (al-extents * 4MiB)



The following changes since commit 478c030eecbec927d62561c5f48a4515ea0fa21a:

  drivers/block/mtip32xx/mtip32xx.c:1726:5: sparse: symbol 'mtip_send_trim' was not declared. Should it be static? (2013-01-12 09:15:19 +0100)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens-3.9-drivers

for you to fetch changes up to 99cb6a9f0230ed31b712c48983a2ce9ca20a30e1:

  drbd: adjust upper limit for activity log extents (2013-01-30 10:19:58 +0100)

----------------------------------------------------------------
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
      drbd: queue writes on submitter thread, unless they pass the activity log fastpath
      lru_cache: introduce lc_get_cumulative()
      drbd: consolidate as many updates as possible into one AL transaction
      drbd: move start io accounting before activity log transaction
      drbd: try hard to max out the updates per AL transaction
      drbd: adjust upper limit for activity log extents

Philipp Reisner (7):
      drbd: reset ap_in_flight counter for new connections
      drbd: abort start of resync early, if it raced with connection breakage
      drbd: move invalidating the whole bitmap out of after_state ch()
      drbd: fix effective error returned when refusing an invalidate
      drbd: drop now useless duplicate state request from invalidate
      drbd: fix spurious warning about bitmap being locked from detach
      drbd: Fix disconnect to keep the peer disk state if connection breaks during operation

 drivers/block/drbd/drbd_actlog.c   |  246 ++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_bitmap.c   |   13 +-
 drivers/block/drbd/drbd_int.h      |  179 +++++++++++++-------------
 drivers/block/drbd/drbd_main.c     |  249 ++++++++++++++++++++++++++++++------
 drivers/block/drbd/drbd_nl.c       |  194 +++++++++++++++++-----------
 drivers/block/drbd/drbd_receiver.c |    5 +-
 drivers/block/drbd/drbd_req.c      |  166 +++++++++++++++++++++---
 drivers/block/drbd/drbd_state.c    |   28 ++--
 drivers/block/drbd/drbd_strings.c  |    1 +
 drivers/block/drbd/drbd_worker.c   |    9 +-
 include/linux/drbd.h               |    5 +-
 include/linux/drbd_limits.h        |   11 +-
 include/linux/lru_cache.h          |    1 +
 lib/lru_cache.c                    |   55 ++++++--
 14 files changed, 842 insertions(+), 320 deletions(-)
