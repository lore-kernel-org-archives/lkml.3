Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3AZBbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:34 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52893 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3AZBbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:18 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCHSET] idr: deprecate idr_remove_all()
Date: Fri, 25 Jan 2013 17:30:58 -0800
Message-Id: <1359163872-1949-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(Andrew, I think this one is best routed through -mm.  Please read on)

idr is one of the areas with much higher concentration of bad
interface and implementation decisions.  This patchset removes one of
those oddities - idr_remove_all().  idr needs two steps for
destruction - idr_remove_all() followed by idr_destroy().
idr_remove_all() releases all IDs in use but doesn't release buffered
idr_layers.  idr_destroy() frees buffered idr_layers() but doesn't
bother with in-use idr_layers.

For added fun, calling idr_remove() on all allocated IDs doesn't
necessarily free all in-use idr_layers, so idr_for_each_entry()
idr_remove(); followed by idr_destroy() may still leak memory.

This confuses people.  Some correctly use both.  Many forget to call
idr_remove_all() and others forget idr_destroy() and they all leak
memory.  Even ida - something tightly coupled w/ idr - forgets to do
idr_remove_all() (although it's my fault).

This is just a bad interface.  While remove_all in itself might not be
that bad, there is only one legitimate user of idr_remove_all() which
can be converted to idr_remove() relatively easily, so I think it'd be
better to deprecate and later unexport it than keeping it around.

This patchset contains the following 14 patches.

 0001-idr-make-idr_destroy-imply-idr_remove_all.patch
 0002-atm-nicstar-don-t-use-idr_remove_all.patch
 0003-block-loop-don-t-use-idr_remove_all.patch
 0004-firewire-don-t-use-idr_remove_all.patch
 0005-drm-don-t-use-idr_remove_all.patch
 0006-dm-don-t-use-idr_remove_all.patch
 0007-remoteproc-don-t-use-idr_remove_all.patch
 0008-rpmsg-don-t-use-idr_remove_all.patch
 0009-dlm-use-idr_for_each_entry-in-recover_idr_clear-erro.patch
 0010-dlm-don-t-use-idr_remove_all.patch
 0011-nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
 0012-inotify-don-t-use-idr_remove_all.patch
 0013-cgroup-don-t-use-idr_remove_all.patch
 0014-idr-deprecate-idr_remove_all.patch

0001 makes idr_destroy() imply idr_remove_all().  0002-0013 remove
uses of idr_remove_all().  0014 marks idr_remove_all() deprecated.
The patches are on top of the current linus#master 66e2d3e8c2 and also
applies on top of the current -mm.  It's available in the following
git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git deprecate-idr_remove_all

As changes to most are trivial and have dependency on the first patch,
I think it would be best to route these together.  The only
non-trivial change is 0009 and 0010 which converts idr_for_each() to
idr_for_each_entry() and then replaces idr_remove_all() with
idr_remove() inside the for_each_entry loop.  Defintely wanna get acks
from dlm people.

Andrew, once people agree with the series, can you please route these
through -mm?

diffstat follows.  Thanks.

 drivers/atm/nicstar.c                   |    1 -
 drivers/block/loop.c                    |    1 -
 drivers/firewire/core-cdev.c            |    1 -
 drivers/gpu/drm/drm_context.c           |    2 +-
 drivers/gpu/drm/drm_crtc.c              |    1 -
 drivers/gpu/drm/drm_drv.c               |    1 -
 drivers/gpu/drm/drm_gem.c               |    2 --
 drivers/gpu/drm/exynos/exynos_drm_ipp.c |    4 ----
 drivers/gpu/drm/sis/sis_drv.c           |    1 -
 drivers/gpu/drm/via/via_map.c           |    1 -
 drivers/md/dm.c                         |    1 -
 drivers/remoteproc/remoteproc_core.c    |    1 -
 drivers/rpmsg/virtio_rpmsg_bus.c        |    1 -
 fs/dlm/lockspace.c                      |    1 -
 fs/dlm/recover.c                        |   25 +++++++++++--------------
 fs/nfs/client.c                         |    1 -
 fs/notify/inotify/inotify_fsnotify.c    |    1 -
 include/linux/idr.h                     |   14 +++++++++++++-
 kernel/cgroup.c                         |    4 +---
 lib/idr.c                               |   28 +++++++++++++---------------
 20 files changed, 39 insertions(+), 53 deletions(-)

--
tejun
