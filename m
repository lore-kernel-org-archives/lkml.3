Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaDOL1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:27:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:54190 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOL1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:27:52 -0400
Subject: [PATCH 0/7] fuse: fix handling mtime and cmtime in writeback_cache
 mode
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:27:51 +0400
Message-ID: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch-set fixes a few issues introduced by writeback_cache feature:

 - fuse_iget() used inode->i_mode before its initialization
 - in course of truncate(2), inode->i_mtime was not updated at all
 - the same for open(O_TRUNC) in case of fc->atomic_o_trunc is set
 - we cannot trust ctime from server anymore because we doesn't 
   flush all data changes to the server immediately
 - to maintain ctime locally, we have to update it in proper places
   (fuse_update_time, fallocate, setxattr, etc.)
 - locally updated ctime must be flushed to the server eventually.

Maxim
---

Maxim Patlasov (7):
      fuse: do not use uninitialized i_mode
      fuse: update mtime on truncate(2)
      fuse: update mtime on open(O_TRUNC) in atomic_o_trunc mode
      fuse: introduce FUSE_I_CTIME_DIRTY flag
      fuse: trust kernel i_ctime only
      fuse: clear FUSE_I_CTIME_DIRTY flag on setattr
      fuse: flush ctime in FUSE_FORGET requests


 fs/fuse/dev.c             |   30 ++++++++++++---
 fs/fuse/dir.c             |   88 +++++++++++++++++++++++++++++++++++++++------
 fs/fuse/file.c            |   37 +++++++++++++------
 fs/fuse/fuse_i.h          |    6 ++-
 fs/fuse/inode.c           |   14 ++++++-
 include/uapi/linux/fuse.h |   29 +++++++++++++--
 6 files changed, 165 insertions(+), 39 deletions(-)

-- 
Signature
