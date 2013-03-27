Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3C0T3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:29:46 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:48558 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3C0T3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:29:43 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: [PATCH v2 0/6] idr: add idr_alloc_cyclic and convert existing cyclic users
Date: Wed, 27 Mar 2013 15:29:32 -0400
Message-Id: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Andrew, I think this is probably best routed via -mm since it touches
several different places)

This is the second version of this patchset. The main changes are:

- removed an incorrect comment on the new allocator function that
  stemmed from a misunderstanding of the IDR code. Also fixed up
  the kerneldoc comment.

- the idr_init_cyclic function has been removed, since it doesn't add
  any benefit over a "normal" idr_init.

- minor change to the caller in inotify code to make it not allocate
  an ID of 0. The existing code starts at 1, so this seems like a
  reasonable precaution.

Original cover letter follows:

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
 drivers/infiniband/hw/amso1100/c2_qp.c |  3 +--
 drivers/infiniband/hw/mlx4/cm.c        |  4 +---
 fs/nfsd/nfs4state.c                    |  7 +------
 fs/notify/inotify/inotify_user.c       |  8 ++------
 include/linux/fsnotify_backend.h       |  1 -
 include/linux/idr.h                    |  2 ++
 lib/idr.c                              | 27 +++++++++++++++++++++++++++
 net/sctp/associola.c                   | 16 ++--------------
 9 files changed, 36 insertions(+), 33 deletions(-)

-- 
1.7.11.7

