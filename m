Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3E0Nue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:50:34 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56420 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab3E0Nuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:50:32 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, msnitzer@redhat.com, ksievers@redhat.com,
        jbottomley@parallels.com, axboe@kernel.dk
Subject: [RFC PATCH 0/4] SG_IO filtering via sysfs and minimal whitelist
Date: Mon, 27 May 2013 15:50:18 +0200
Message-Id: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012 09:05:41 +0100, James Bottomley wrote:
> This is why the whole filter thing was mutable via sysfs.  That way the
> admin could set this up per device.  It sounds like this is what you
> want to fix, rather than opening up more holes in an already leaky
> security apparatus.  The ideal is that we would be much more restrictive
> by default and give root the ability to override this both globally and
> per-device to conform to whatever policy it has for the virtual
> environments.
> 
> The patch which removed all of the sysfs pieces was:
> 
> commit 018e0446890661504783f92388ecce7138c1566d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Jun 26 16:27:10 2009 +0200
>
>     block: get rid of queue-private command filter
> 
> So that's probably the place to start for putting it back properly.

[https://lkml.org/lkml/2012/9/12/76]

We've been running in circles for nine months now.  Let's restart from
the maintainer's suggestion, which was probably dismissed too quickly.

This is still not a complete solution, because /dev/sgN does not have
access to its queue object.  Still, it can be a base for discussion.

If accepted (in a complete form with access to the queue object for
non-block devices), this series removes the need to fix the opcode
conflicts as far as I'm concerned.  We could just consider that a
feature of CONFIG_BLK_DEV_SG_FILTER_MMC.

Previously posted at https://lkml.org/lkml/2012/9/25/397 (short thread).
Rebased just fine, this one is compile-tested only.

Paolo

Paolo Bonzini (4):
  block: add back queue-private command filter
  scsi: create an all-zero filter for scanners
  block: add back command filter modification via sysfs
  scsi: lock out SG_IO by default to unprivileged users

 Documentation/block/queue-sysfs.txt |  16 +++++
 block/Kconfig                       |  22 ++++++
 block/blk-sysfs.c                   |  43 ++++++++++++
 block/bsg.c                         |   2 +-
 block/scsi_ioctl.c                  | 131 +++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_scan.c            |   8 ++-
 drivers/scsi/sg.c                   |   7 +-
 include/linux/blkdev.h              |  31 ++++++++-
 8 files changed, 238 insertions(+), 22 deletions(-)

-- 
1.8.1.4

