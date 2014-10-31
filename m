Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbaJaTnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:43:09 -0400
Received: from skprod2.natinst.com ([130.164.80.23]:53423 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758026AbaJaTnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:43:08 -0400
From: Ben Shelton <ben.shelton@ni.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        Ben Shelton <ben.shelton@ni.com>
Subject: [PATCH 0/4] UBIFS: add xattr support for security / SELinux
Date: Fri, 31 Oct 2014 13:50:27 -0500
Message-Id: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
X-Mailer: git-send-email 2.1.1
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 10/31/2014 01:51:03 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 10/31/2014 01:51:03 PM,
	Serialize complete at 10/31/2014 01:51:03 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_08:2014-10-31,2014-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm reposting the patch series for security xattr / SELinux support on UBIFS
from Subodh Nijsure and Marc Kleine-Budde [1] in order to restart the process
of getting this support upstream.

Notes:

 - I removed 'UBIFS: xattr: protect ui_size and data_len by ui_mutex' because
   after looking through the comments before the definition of struct
   ubifs_inode, I'm not sure what this was intended to fix.  It looks like
   i_size and data_len are not intended to be protected by ui_mutex, and I'm
   unclear on why ui->ui_size needs to be protected here by host_ui's ui_mutex.
   CCing Marc -- could you comment on how this is supposed to work?

 - I made the suggested locking fixes in [2], with the exception of removing the
   i_mutex lock/unlock around the call to security_inode_init_security(), which 
   caused an assert.  With these fixes, I turned on lockdep and ran with SELinux
   enabled on an ARM-based embedded target using UBIFS, and I saw no lockdep
   warnings during filesystem labeling and normal operation.

[1] http://lists.infradead.org/pipermail/linux-mtd/2013-February/045794.html
[2] http://lists.infradead.org/pipermail/linux-mtd/2013-February/045871.html

Subodh Nijsure (4):
  UBIFS: fix a couple bugs in UBIFS xattr length calculation
  UBIFS: Add xattr support for symlinks
  UBIFS: Add security.* XATTR support for the UBIFS
  UBIFS: add ubifs_err() to print error reason

 fs/ubifs/dir.c     |  20 +++++++++
 fs/ubifs/file.c    |   4 ++
 fs/ubifs/journal.c |  11 ++++-
 fs/ubifs/super.c   |   1 +
 fs/ubifs/ubifs.h   |   4 ++
 fs/ubifs/xattr.c   | 116 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 145 insertions(+), 11 deletions(-)

-- 
2.1.1

