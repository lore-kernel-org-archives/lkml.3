Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaFWBcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:39 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39717 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaFWBci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:38 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 00/18] Lustre fixes
Date: Sun, 22 Jun 2014 21:32:04 -0400
Message-Id: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches here represent most of recent fixes we added recently
in our tree.
The first patch also unbreaks lustre from total breakage that was
introduced by commit 80db2734acbc78db12798cfb611d6acc7fe389e6

The changes seem to pass my testing.
checkpatch output is clean except for the last patch
#144: FILE: drivers/staging/lustre/lnet/lnet/lib-move.c:821:
+               CNETERR("Aborting message for %s: LNetM[DE]Unlink() already "
+                       "called on the MD/ME.\n",

This one cannot be helped I guess.

WARNING: return of an errno should typically be -ve (return -ECANCELED)
#150: FILE: drivers/staging/lustre/lnet/lnet/lib-move.c:827:
+               return ECANCELED;

This one would be addressed by two other patches I am working on right now.

Please consider for inclusion.

Alexander.Boyko (1):
  staging/lustre/ptlrpc: race at req processing

Alexey Lyashkov (1):
  staging/lustre/ptlrpc: unlink request buffer correctly

Andriy Skulysh (2):
  staging/lustre/mgc: mgc import reconnect race
  staging/lustre/osc: osc_extent_truncate()) ASSERTION( !ext->oe_urgent
    ) failed

Bob Glossman (1):
  staging/lustre/obdclass: runtime load lustre client when needed

Bobi Jam (1):
  staging/lustre/osc: get rid of old checksum initial value

Cheng Shao (1):
  staging/lustre/mgc: replace hard-coded MGC_ENQUEUE_LIMIT value

Christopher J. Morrone (1):
  staging/lustre/ptlrpc: Add schedule point to ptlrpc_check_set()

Dmitry Eremin (4):
  staging/lustre: fix frong ldlm flags type used
  staging/lustre/ptlrpc: fix NULL pointer dereference of {exp,imp}_obd
  staging/lustre/obdclass: Fix uninitialized variables
  staging/lustre/llite: Fix uninitialized variable

Isaac Huang (1):
  staging/lustre/lnet: abort messages whose MD has been unlinked

Li Xi (1):
  staging/lustre/llite: fix a flag bug of vvp_io_kernel_fault()

Nathaniel Clark (1):
  staging/lustre/llite: Only kill SGID/SUID bits

Oleg Drokin (2):
  staging/lustre/libcfs: revert changes to libcfs_sock_ioctl
  staging/lustre/ptlrpc: Protect request buffer changing

Patrick Farrell (1):
  staging/lustre/vvp: release mmap_sem in error case

 .../staging/lustre/include/linux/lnet/lib-types.h  |  1 +
 drivers/staging/lustre/lnet/lnet/lib-md.c          | 10 ++---
 drivers/staging/lustre/lnet/lnet/lib-me.c          | 11 ++---
 drivers/staging/lustre/lnet/lnet/lib-move.c        | 49 +++++++++++++++-------
 drivers/staging/lustre/lustre/include/lustre_dlm.h |  2 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |  6 ++-
 drivers/staging/lustre/lustre/include/obd_class.h  |  2 +-
 drivers/staging/lustre/lustre/include/obd_ost.h    |  4 ++
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |  2 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       | 21 ++++++++--
 drivers/staging/lustre/lustre/llite/file.c         |  6 +--
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  6 ++-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |  6 ++-
 drivers/staging/lustre/lustre/llite/xattr.c        |  1 +
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  2 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    | 10 ++---
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  5 ++-
 drivers/staging/lustre/lustre/obdclass/capa.c      |  5 +++
 drivers/staging/lustre/lustre/obdclass/obd_mount.c | 18 +++-----
 drivers/staging/lustre/lustre/osc/osc_cache.c      |  7 ++--
 drivers/staging/lustre/lustre/osc/osc_internal.h   |  2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |  2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    | 17 +++-----
 drivers/staging/lustre/lustre/ptlrpc/client.c      | 32 +++++++++++---
 drivers/staging/lustre/lustre/ptlrpc/events.c      | 11 +++--
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c | 29 +++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 41 ++++++++++++++----
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      | 14 ++++---
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |  5 +++
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    | 11 +++++
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   | 12 ++++++
 drivers/staging/lustre/lustre/ptlrpc/service.c     | 10 ++---
 33 files changed, 254 insertions(+), 108 deletions(-)

-- 
1.9.0

