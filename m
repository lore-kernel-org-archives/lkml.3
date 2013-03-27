Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3C0NST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:18:19 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64427 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3C0NSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:18:17 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: [PATCH v1 0/6] idr: add idr_alloc_cyclic and convert existing cyclic users
Date: Wed, 27 Mar 2013 09:18:02 -0400
Message-Id: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Andrew, I think this is probably best routed via -mm since it touches
several different places)

As Tejun points out, there are several users of the IDR facility that
attempt to use it in a cyclic fashion. These users are likely to see
-ENOSPC errors after the counter wraps one or more times however.

This patchset adds a new idr_alloc_cyclic routine and converts several
of these users to it. Many of these users are in obscure parts of the
kernel, and I don't have a good way to test some of them. The change is
pretty straightforward though, so hopefully it won't be an issue.

There is one other cyclic user of idr_alloc that I didn't touch in
ipc/util.c. That one is doing some strange stuff that I didn't quite
understand, but it looks like it should probably be converted later
somehow.

Jeff Layton (6):
  idr: introduce idr_alloc_cyclic
  amso1100: convert to using idr_alloc_cyclic
  mlx4: convert to using idr_alloc_cyclic
  nfsd: convert nfs4_alloc_stid to use idr_alloc_cyclic
  inotify: convert inotify_add_to_idr to use idr_alloc_cyclic
  sctp: convert sctp_assoc_set_id to use idr_alloc_cyclic

 drivers/infiniband/hw/amso1100/c2.h    |  1 -
 drivers/infiniband/hw/amso1100/c2_qp.c |  5 ++--
 drivers/infiniband/hw/mlx4/cm.c        |  6 ++---
 fs/nfsd/nfs4state.c                    |  9 ++-----
 fs/notify/inotify/inotify_user.c       | 10 +++-----
 include/linux/fsnotify_backend.h       |  1 -
 include/linux/idr.h                    | 10 +++++++-
 lib/idr.c                              | 47 +++++++++++++++++++++++++++++++---
 net/sctp/associola.c                   | 15 +----------
 net/sctp/protocol.c                    |  2 +-
 10 files changed, 63 insertions(+), 43 deletions(-)

-- 
1.7.11.7

