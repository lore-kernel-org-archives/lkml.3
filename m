Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3FNTYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:24:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48886 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab3FNTYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:24:16 -0400
From: Richard Yao <ryao@gentoo.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@gentoo.org
Subject: [PATCH 0/2] llseek fixes
Date: Fri, 14 Jun 2013 15:23:32 -0400
Message-Id: <1371237814-59365-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs_file_llseek() and ocfs2_file_llseek() are extremely similar and
consequently, contain many of the same flaws. Li Dongyang filed a pull request
with ZFSOnLinux for SEEK_HOLE/SEEK_DATA support that included a custom llseek
function that appears to have been modelled after the one in ocfs2. The
similarity was strong enough that it suffered from many of the same flaws,
which I caught during review.  I addressed the issues with his patch with one
that I wrote. Since a small percentage of Gentoo Linux users are affected by
these flaws, I decided to adapt that code that to btrfs and ocfs2.

The specific issues are:

1. Taking the inode->i_mutex lock before calling generic_file_llseek(), which
is unnecessary.

2. Failing to take the filp->f_lock spinlock before modifying filp->f_pos and
filp->f_version, which differs from generic_file_llseek().

3. Having an offset > inode->i_sb->s_maxbytes check that is dead code in btrfs
and active code in ocfs2. In ocfs2, this permits seeking up to the maximum file
size possible, even when it is past the end of the file. Seeking beyond that
(if possible), would return EINVAL instead of ENXIO.

4. Trying to cover all whence values when in reality such functions should only
care about SEEK_HOLE/SEEK_DATA. Any other cases should be passsed to
generic_file_llseek().

Richard Yao (2):
  ocfs2: Fix llseek() semantics and do some cleanup
  btrfs: Cleanup llseek()

 fs/btrfs/file.c | 49 ++++++++++++++++++-------------------------
 fs/ocfs2/file.c | 65 ++++++++++++++++++++++-----------------------------------
 2 files changed, 45 insertions(+), 69 deletions(-)

-- 
1.8.1.5

