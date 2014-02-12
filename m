Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaBLIOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbaBLIN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Myers" <bpm@sgi.com>,
        "Christoph Hellwig" <hch@lst.de>, "Dave Chinner" <dchinner@redhat.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.13742722@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/79] xfs: Account log unmount transaction correctly
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 3948659e30808fbaa7673bbe89de2ae9769e20a7 upstream.

There have been a few reports of this warning appearing recently:

XFS (dm-4): xlog_space_left: head behind tail
 tail_cycle = 129, tail_bytes = 20163072
 GH   cycle = 129, GH   bytes = 20162880

The common cause appears to be lots of freeze and unfreeze cycles,
and the output from the warnings indicates that we are leaking
around 8 bytes of log space per freeze/unfreeze cycle.

When we freeze the filesystem, we write an unmount record and that
uses xlog_write directly - a special type of transaction,
effectively. What it doesn't do, however, is correctly account for
the log space it uses. The unmount record writes an 8 byte structure
with a special magic number into the log, and the space this
consumes is not accounted for in the log ticket tracking the
operation. Hence we leak 8 bytes every unmount record that is
written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/xfs/xfs_log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -653,8 +653,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 				.lv_iovecp = &reg,
 			};
 
-			/* remove inited flag */
+			/* remove inited flag, and account for space used */
 			tic->t_flags = 0;
+			tic->t_curr_res -= sizeof(magic);
 			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*

