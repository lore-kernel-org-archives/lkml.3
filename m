Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3IEWUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:20:33 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:37676 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3IEWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:20:30 -0400
Date: Thu, 5 Sep 2013 18:20:28 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] ceph: fscache support & upstream changes
Message-ID: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey gang I think this should be final revision of these changes. The changes 
are:

 * David rewrote the cookie validity check (that originally was written by
   Hongyi Jia). You might have seen some emails flying about doing it the
   right way.
 * I added crash fix when for Ceph filesystems mounted with nofsc (default)
   when fscache is compiled into Ceph. Previously it would crash trying to
   enqueue invalidate checks in the work queue because we didn't initialize
   if the mount had fscache disabled.

I've tested both changes on my cluster. You can get get these changes from my
branch in bitbucket. It contains the upstream wip-fscache branch rebased with
David's rewrite of Hongyi Jia's changes.

The branch is located at.

  https://bitbucket.org/adfin/linux-fs.git in the wip-fscahce branch

Finally, David requested that this patchset go through the Ceph tree. The tree
should have all the proper sign off from David. I also CC'ed him so he can give
his final okay.

Best,
 - Milosz

David Howells (2):
  FS-Cache: Add interface to check consistency of a cached object
  CacheFiles: Implement interface to check cache consistency

Milosz Tanski (6):
  fscache: Netfs function for cleanup post readpages
  ceph: use fscache as a local presisent cache
  ceph: clean PgPrivate2 on returning from readpages
  ceph: ceph_readpage_to_fscache didn't check if marked
  ceph: page still marked private_2
  ceph: Do not do invalidate if the filesystem is mounted nofsc

 Documentation/filesystems/caching/backend-api.txt |    9 +
 Documentation/filesystems/caching/netfs-api.txt   |   35 +-
 fs/cachefiles/interface.c                         |   26 ++
 fs/cachefiles/internal.h                          |    1 +
 fs/cachefiles/xattr.c                             |   36 ++
 fs/ceph/Kconfig                                   |    9 +
 fs/ceph/Makefile                                  |    1 +
 fs/ceph/addr.c                                    |   40 ++-
 fs/ceph/cache.c                                   |  400 +++++++++++++++++++++
 fs/ceph/cache.h                                   |  157 ++++++++
 fs/ceph/caps.c                                    |   19 +-
 fs/ceph/file.c                                    |   17 +
 fs/ceph/inode.c                                   |   14 +-
 fs/ceph/super.c                                   |   35 +-
 fs/ceph/super.h                                   |   16 +
 fs/fscache/cookie.c                               |   69 ++++
 fs/fscache/internal.h                             |    6 +
 fs/fscache/page.c                                 |   71 ++--
 include/linux/fscache-cache.h                     |    4 +
 include/linux/fscache.h                           |   42 +++
 20 files changed, 965 insertions(+), 42 deletions(-)
 create mode 100644 fs/ceph/cache.c
 create mode 100644 fs/ceph/cache.h

-- 
1.7.9.5

