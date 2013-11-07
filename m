Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3KGUZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:25:05 -0500
Received: from mdfmta010.mxout.tbr.inty.net ([91.221.168.51]:52354 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753180Ab3KGUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:24:58 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org
Cc: minchan@kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/6] Squashfs performance improvements
Date: Thu,  7 Nov 2013 20:24:19 +0000
Message-Id: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch-set is mainly a compilation of the various Squashfs
performance improvement patches sent to the mailing list over the
last month or so.  These patches do the following:

	* Add support for different decompressor implementations
	* Add support for parallel decompression, with or without
	  percpu variables
	* Add support for direct decompression into the page cache,
	  rather than using an intermediate buffer.

Patches 1, 4 and 6 are revised V2 versions following review.

Patch 2 is Minchan Kim's multi-threading patch unmodified, it is
included here for completeness.

Patch 3 is new, it is a multi-threaded implementation which uses
percpu variables to do load-balancing across multiple cores, providing
one decompressor per core.  This implementation is intended to be
complementary to Minchan Kim's patch.

Each parallelisation implementation exhibits trade-offs between
decompression performance and CPU and memory usage.  The
multi-threading implementation without percpu variables offers
the ability to do two simultaneous decompressions per core, which
offers maximum performance but at the expense of very high CPU usage
and memory overhead.  For many multi-core embedded systems with
weak CPUs such resource use may be prohibitive.

The percpu implementation inherently limits CPU usage to one decompression
per core, and because of the use of percpu variables it ensures
decompression is load balanced too.

----------------------------------------------------------------
Minchan Kim (1):
      Squashfs: enhance parallel I/O

Phillip Lougher (5):
      Squashfs: Refactor decompressor interface and code (V2)
      Squashfs: add multi-threaded decompression using percpu variables
      Squashfs: Generalise paging handling in the decompressors (V2)
      Squashfs: restructure squashfs_readpage()
      Squashfs: Directly decompress into the page cache for file data (V2)

 fs/squashfs/Kconfig                     |   72 +++++++++++
 fs/squashfs/Makefile                    |    5 +
 fs/squashfs/block.c                     |   36 +++---
 fs/squashfs/cache.c                     |   28 ++++-
 fs/squashfs/decompressor.c              |   59 ++++++---
 fs/squashfs/decompressor.h              |   24 ++--
 fs/squashfs/decompressor_multi.c        |  199 +++++++++++++++++++++++++++++++
 fs/squashfs/decompressor_multi_percpu.c |  104 ++++++++++++++++
 fs/squashfs/decompressor_single.c       |   85 +++++++++++++
 fs/squashfs/file.c                      |  142 +++++++++++-----------
 fs/squashfs/file_cache.c                |   38 ++++++
 fs/squashfs/file_direct.c               |  178 +++++++++++++++++++++++++++
 fs/squashfs/lzo_wrapper.c               |   47 ++++----
 fs/squashfs/page_actor.c                |  104 ++++++++++++++++
 fs/squashfs/page_actor.h                |   86 +++++++++++++
 fs/squashfs/squashfs.h                  |   20 +++-
 fs/squashfs/squashfs_fs_sb.h            |    4 +-
 fs/squashfs/super.c                     |   10 +-
 fs/squashfs/xz_wrapper.c                |  105 +++++++++-------
 fs/squashfs/zlib_wrapper.c              |   64 ++++------
 20 files changed, 1167 insertions(+), 243 deletions(-)
 create mode 100644 fs/squashfs/decompressor_multi.c
 create mode 100644 fs/squashfs/decompressor_multi_percpu.c
 create mode 100644 fs/squashfs/decompressor_single.c
 create mode 100644 fs/squashfs/file_cache.c
 create mode 100644 fs/squashfs/file_direct.c
 create mode 100644 fs/squashfs/page_actor.c
 create mode 100644 fs/squashfs/page_actor.h

Phillip
