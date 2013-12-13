Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3LMU0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3LMU0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:26:03 -0500
Date: Fri, 13 Dec 2013 15:25:54 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Vincent Pelletier <plr.vincent@gmail.com>
Subject: [git pull] device mapper fixes for 3.13
Message-ID: <20131213202554.GA1736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7b6b2bc98c0303b7f043ad5b35906f833e56308d:

  dm cache: resolve small nits and improve Documentation (2013-11-12 13:11:09 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.13-fixes

for you to fetch changes up to ed9571f0cf1fe09d3506302610f3ccdfa1d22c4a:

  dm array: fix a reference counting bug in shadow_ablock (2013-12-13 14:22:10 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
A set of device-mapper fixes for 3.13.

A fix for possible memory corruption during DM table load, fix a
possible leak of snapshot space in case of a crash, fix a possible
deadlock due to a shared workqueue in the delay target, fix to
initialize read-only module parameters that are used to export metrics
for dm stats and dm bufio.

Quite a few stable fixes were identified for both the thin-provisioning
and caching targets as a result of increased regression testing using
the device-mapper-test-suite (dmts).  The most notable of these are the
reference counting fixes for the space map btree that is used by the
dm-array interface -- without these the dm-cache metadata will leak,
resulting in dm-cache devices running out of metadata blocks.  Also,
some important fixes related to the thin-provisioning target's
transition to read-only mode on error.

----------------------------------------------------------------
Joe Thornber (7):
      dm thin: switch to read only mode if a mapping insert fails
      dm thin: always fallback the pool mode if commit fails
      dm thin: re-establish read-only state when switching to fail mode
      dm thin: allow pool in read-only mode to transition to read-write mode
      dm cache policy mq: fix promotions to occur as expected
      dm space map: disallow decrementing a reference count below zero
      dm array: fix a reference counting bug in shadow_ablock

Mike Snitzer (3):
      dm space map metadata: return on failure in sm_metadata_new_block
      dm thin: switch to read-only mode if metadata space is exhausted
      dm cache: update Documentation for invalidate_cblocks's range syntax

Mikulas Patocka (5):
      dm delay: fix a possible deadlock due to shared workqueue
      dm snapshot: avoid snapshot space leak on crash
      dm table: fail dm_table_create on dm_round_up overflow
      dm bufio: initialize read-only module parameters
      dm stats: initialize read-only module parameter

Vincent Pelletier (1):
      dm cache: actually resize cache

 Documentation/device-mapper/cache.txt              | 10 +--
 drivers/md/dm-bufio.c                              |  5 ++
 drivers/md/dm-cache-policy-mq.c                    | 13 ++--
 drivers/md/dm-cache-target.c                       |  2 +-
 drivers/md/dm-delay.c                              | 23 ++++---
 drivers/md/dm-snap.c                               | 71 +++++++++++++++++++---
 drivers/md/dm-stats.c                              |  1 +
 drivers/md/dm-table.c                              |  5 ++
 drivers/md/dm-thin-metadata.c                      |  8 +++
 drivers/md/dm-thin-metadata.h                      |  1 +
 drivers/md/dm-thin.c                               | 66 ++++++++++++--------
 drivers/md/persistent-data/dm-array.c              | 10 ++-
 drivers/md/persistent-data/dm-block-manager.c      |  6 ++
 drivers/md/persistent-data/dm-block-manager.h      |  7 ++-
 drivers/md/persistent-data/dm-space-map-common.c   | 32 +++++++---
 drivers/md/persistent-data/dm-space-map-metadata.c |  8 ++-
 16 files changed, 197 insertions(+), 71 deletions(-)
