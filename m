Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaHKUsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:48:22 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42235 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaHKUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:48:21 -0400
Date: Mon, 11 Aug 2014 13:48:20 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.17-rc1
Message-ID: <alpine.DEB.2.00.1408111342470.8075@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a lot of refactoring and hardening of the libceph and rbd code 
here from Ilya that fix various smaller bugs, and a few more important 
fixes with clone overlap.  The main fix is a critical change to the 
request_fn handling to not sleep that was exposed by the recent mutex 
changes (which will also go to teh 3.16 stable series).

Yan Zheng has several fixes in here for CephFS fixing ACL handling, time 
stamps, and request resends when the MDS restarts.

Finally, there are a few cleanups from Himangi Saraogi based on 
Coccinelle.

Thanks!
sage


----------------------------------------------------------------
Himangi Saraogi (2):
      rbd: use rbd_segment_name_free() instead of kfree()
      ceph: replace comma with a semicolon

Ilya Dryomov (29):
      libceph: rename ceph_osd_request::r_linger_osd to r_linger_osd_item
      libceph: add maybe_move_osd_to_lru() and switch to it
      libceph: move and add dout()s to ceph_msg_{get,put}()
      libceph: move and add dout()s to ceph_osdc_request_{get,put}()
      libceph: harden ceph_osdc_request_release() a bit
      libceph: assert both regular and lingering lists in __remove_osd()
      libceph: unregister only registered linger requests
      libceph: fix linger request check in __unregister_request()
      libceph: introduce ceph_osdc_cancel_request()
      rbd: rbd_obj_request_wait() should cancel the request if interrupted
      rbd: add rbd_obj_watch_request_helper() helper
      rbd: use rbd_obj_watch_request_helper() helper
      libceph: nuke ceph_osdc_unregister_linger_request()
      libceph: drop osd ref when canceling con work
      rbd: do not leak image_id in rbd_dev_v2_parent_info()
      rbd: show the entire chain of parent images
      rbd: introduce rbd_dev_header_info()
      rbd: remove unnecessary asserts in rbd_dev_image_probe()
      rbd: split rbd_dev_spec_update() into two functions
      rbd: harden rbd_dev_refresh() and callers a bit
      rbd: update mapping size only on refresh
      rbd: do not read in parent info before snap context
      rbd: take snap_id into account when reading in parent info
      ceph: remove redundant memset(0)
      ceph: fix sizeof(struct tYpO *) typo
      rbd: rework rbd_request_fn()
      rbd: allocate img_request with GFP_NOIO instead GFP_ATOMIC
      rbd: remove extra newlines from rbd_warn() messages
      libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly

Yan, Zheng (8):
      ceph: check unsupported fallocate mode
      ceph: include time stamp in replayed MDS requests
      ceph: pass proper page offset to copy_page_to_iter()
      ceph: properly apply umask when ACL is enabled
      ceph: reset r_resend_mds after receiving -ESTALE
      ceph: check zero length in ceph_sync_read()
      ceph: fix append mode write
      ceph: fix kick_requests()

 Documentation/ABI/testing/sysfs-bus-rbd |    4 +-
 drivers/block/rbd.c                     |  689 ++++++++++++++++---------------
 fs/ceph/acl.c                           |   14 +-
 fs/ceph/caps.c                          |    2 +-
 fs/ceph/file.c                          |   24 +-
 fs/ceph/mds_client.c                    |   16 +-
 fs/ceph/xattr.c                         |    4 +-
 include/linux/ceph/messenger.h          |   14 +-
 include/linux/ceph/osd_client.h         |   18 +-
 net/ceph/messenger.c                    |   47 ++-
 net/ceph/osd_client.c                   |  129 ++++--
 11 files changed, 538 insertions(+), 423 deletions(-)
