Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3BRBEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:04:21 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48881 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3BRBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:04:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Sun, 17 Feb 2013 17:04:08 -0800
Message-ID: <87txpaph4n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19EwzCKAHp2fuyyIcEADSnxeAX/451iRK8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 00/16] userns: Completion of kuid/kgid/kprojid pushdown.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have spent some more time with the xfs code and finally figured out
what needed to be done to safely add kuid/kgid support without
significant logic changes.

My first two xfs changes make the small logical adjustments required of
xfs to get the primary inode uid, gid, and projid fields that xfs uses
not live in struct xfs_icdinode.  After that the patches are pretty much
what I have posted before just split up and cleaned up so it is much
easier to understand the patches and see that they are doing reasonable
things.

xfs being the last of the filesystems to need the userns compatibility
code I my patches to remove that compatibility code are at the end of
this patchset.

Eric W. Biederman (16):
      xfs: Convert uids and gids in xfs acls to/from kuids and kgids
      xfs: Store projectid as a single variable.
      xfs: Always read uids and gids from the vfs inode
      xfs: Update inode uids, gids, and projids to be kuids, kgids, and kprojids
      xfs: Update xfs_ioctl_setattr to handle projids in any user namespace
      xfs: Use kuids and kgids in xfs_setattr_nonsize
      xfs: Update ioctl(XFS_IOC_FREE_EOFBLOCKS) to handle callers in any userspace
      xfs: Use kprojids when allocating inodes.
      xfs: Modify xfs_qm_vop_dqalloc to take kuids, kgids, and kprojids.
      xfs: Push struct kqid into xfs_qm_scall_qmlim and xfs_qm_scall_getquota
      xfs: Modify xfs_qm_dqget to take a struct kqid.
      xfs: Remember the kqid for a quota
      xfs: Use q_id instead of q_core.d_id.
      xfs: Enable building with user namespaces enabled.
      userns: Now that everything has been converted remove the unnecessary infrastructure
      userns: Remove the EXPERMINTAL kconfig tag

 fs/xfs/xfs_acl.c          |   23 ++++++++++--
 fs/xfs/xfs_dquot.c        |   39 ++++++++++++++-------
 fs/xfs/xfs_dquot.h        |   13 +++++--
 fs/xfs/xfs_icache.c       |   12 +++---
 fs/xfs/xfs_icache.h       |   11 +++++-
 fs/xfs/xfs_inode.c        |   25 +++++++++----
 fs/xfs/xfs_inode.h        |   24 +++++++++----
 fs/xfs/xfs_ioctl.c        |   54 ++++++++++++++++++++++------
 fs/xfs/xfs_iops.c         |   34 ++++++++----------
 fs/xfs/xfs_itable.c       |   10 +++--
 fs/xfs/xfs_qm.c           |   85 ++++++++++++++++++++++-----------------------
 fs/xfs/xfs_qm.h           |    4 +-
 fs/xfs/xfs_qm_bhv.c       |    2 +-
 fs/xfs/xfs_qm_syscalls.c  |   24 +++++++------
 fs/xfs/xfs_quota.h        |    4 +-
 fs/xfs/xfs_quotaops.c     |   20 +---------
 fs/xfs/xfs_rename.c       |    2 +-
 fs/xfs/xfs_trace.h        |    2 +-
 fs/xfs/xfs_trans_dquot.c  |    8 +---
 fs/xfs/xfs_utils.c        |    2 +-
 fs/xfs/xfs_utils.h        |    2 +-
 fs/xfs/xfs_vnodeops.c     |   14 ++++----
 include/linux/posix_acl.h |    3 --
 include/linux/projid.h    |   15 --------
 include/linux/uidgid.h    |   22 ------------
 init/Kconfig              |   27 +--------------
 26 files changed, 244 insertions(+), 237 deletions(-)
