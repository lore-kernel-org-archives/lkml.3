Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBTUoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:44:38 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:47873 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBTUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:37 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET wq/for-3.15] workqueue: remove PREPARE_[DELAYED_]WORK()
Date: Thu, 20 Feb 2014 15:44:22 -0500
Message-Id: <1392929071-16555-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley noticed that since a2c1c57be8d9 ("workqueue: consider
work function when searching for busy work items"), a work item which
gets assigned a different work function would break out of the
non-reentrancy guarantee as workqueue would consider it a different
work item.

This is fragile and extremely subtle.  PREPARE_[DELAYED_]WORK() have
never been used widely and its semantics has always been somewhat
iffy.  If the work item is known not to be on queue when
PREPARE_WORK() is called, there's no difference from using
INIT_WORK().  If the work item may be queued at the time of
PREPARE_WORK(), we can't really tell whether the old or new function
will be executed the next time.

We really don't want this level of subtlety in workqueue interface for
such marginal use cases.  The previous patches converted all existing
users away from PREPARE_[DELAYED_]WORK().  Let's remove them.

This patchset contains the following nine patches.

 0001-wireless-rt2x00-don-t-use-PREPARE_WORK-in-rt2800usb..patch
 0002-ps3-vuart-don-t-use-PREPARE_WORK.patch
 0003-floppy-don-t-use-PREPARE_-DELAYED_-WORK.patch
 0004-firewire-don-t-use-PREPARE_DELAYED_WORK.patch
 0005-usb-don-t-use-PREPARE_DELAYED_WORK.patch
 0006-nvme-don-t-use-PREPARE_WORK.patch
 0007-afs-don-t-use-PREPARE_WORK.patch
 0008-staging-fwserial-don-t-use-PREPARE_WORK.patch
 0009-workqueue-remove-PREPARE_-DELAYED_-WORK.patch

0001-0008 convert existing users.

0009 removes them.

This patchset is on top of e95003c3f9ccb ("Merge tag 'nfs-for-3.14-4'
of git://git.linux-nfs.org/projects/trondmy/linux-nfs") and also
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-kill-PREPARE_WORK

diffstat follows.

 drivers/block/floppy.c                  |   42 +++++++++++++++++++++-----------
 drivers/block/nvme-core.c               |   18 +++++++++----
 drivers/firewire/core-device.c          |   22 +++++++++++-----
 drivers/firewire/sbp2.c                 |   17 +++++++++---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 -
 drivers/ps3/ps3-vuart.c                 |    4 ---
 drivers/staging/fwserial/fwserial.c     |   13 +++++++--
 drivers/staging/fwserial/fwserial.h     |    1 
 drivers/usb/core/hub.c                  |   13 +++++++--
 drivers/usb/core/hub.h                  |    1 
 fs/afs/internal.h                       |    1 
 fs/afs/rxrpc.c                          |   12 +++++++--
 include/linux/firewire.h                |    1 
 include/linux/nvme.h                    |    1 
 include/linux/workqueue.h               |   15 +----------
 15 files changed, 107 insertions(+), 56 deletions(-)

Thanks.

--
tejun

