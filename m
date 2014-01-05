Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbaAEEqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 23:46:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:62288 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaAEEqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 23:46:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,605,1384329600"; 
   d="scan'208";a="453769844"
Date: Sun, 5 Jan 2014 12:46:48 +0800
From: fengguang.wu@intel.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lkp@linux.intel.com
Subject: [pipe] b8597fdc23: -8% regression of hackbench throughput
Message-ID: <20140105044648.GA28257@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dmitry,

We measured some 8% drop of hackbench throughput with your small commit
b8597fdc23 ("fs/pipe.c: skip file_update_time on frozen fs"). Comparing to its
parent commit, we also see increased context switches:

5b6e04beb19abc9  b8597fdc23f8f6e26a531e9a7  
---------------  -------------------------  
    231874 ~ 1%      -7.3%     214834 ~ 2%  lkp-snb01/micro/hackbench/1600%-process-pipe
     87774 ~ 3%     -10.7%      78419 ~ 4%  xps2/micro/hackbench/1600%-process-pipe
    319649           -8.3%     293253       TOTAL hackbench.throughput

5b6e04beb19abc9  b8597fdc23f8f6e26a531e9a7  
---------------  -------------------------  
   3673577 ~ 1%     +17.4%    4312376 ~ 2%  lkp-snb01/micro/hackbench/1600%-process-pipe
    195669 ~ 3%    +156.6%     502173 ~ 4%  xps2/micro/hackbench/1600%-process-pipe
   3869246          +24.4%    4814550       TOTAL vmstat.system.cs

5b6e04beb19abc9  b8597fdc23f8f6e26a531e9a7  
---------------  -------------------------  
 6.311e+08 ~ 2%     +33.7%  8.437e+08 ~ 1%  lkp-snb01/micro/hackbench/1600%-process-pipe
  21485632 ~ 3%    +411.9%    1.1e+08 ~ 8%  xps2/micro/hackbench/1600%-process-pipe
 6.526e+08          +46.1%  9.537e+08       TOTAL time.involuntary_context_switches

5b6e04beb19abc9  b8597fdc23f8f6e26a531e9a7  
---------------  -------------------------  
 1.563e+09 ~ 2%     +12.8%  1.763e+09 ~ 3%  lkp-snb01/micro/hackbench/1600%-process-pipe
  96703947 ~ 3%    +102.7%   1.96e+08 ~ 3%  xps2/micro/hackbench/1600%-process-pipe
  1.66e+09          +18.0%  1.959e+09       TOTAL time.voluntary_context_switches

The bisect looks stable:

                           time.involuntary_context_switches

     9e+08 ++---------------------------------------------------------------+
           |                                  O                             |
   8.5e+08 O+O O O O                   O    O     O O O                     |
           |         O O O O O O O   O   O      O                           |
     8e+08 ++                      O                                        |
           |                                                                |
   7.5e+08 ++                                                               |
           |                                                                |
     7e+08 ++                                                               |
           |.*   *.*.*.*.*   *.                  .*   *.                    |
   6.5e+08 *+ + +         + +  *.*.*.*       .*.*  + +  *.    *.   .*   *.  |
           |   *           *          + .*..*       *     *. +  *.*  + +  *.*
     6e+08 ++                          *                    *         *     |
           |                                                                |
   5.5e+08 ++---------------------------------------------------------------+

Thanks,
Fengguang

--a8Wt8u1KmwUX3Y2C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-fs-pipe.c-skip-file_update_time-on-frozen-fs.patch"

>From b8597fdc23f8f6e26a531e9a7da3c5fe7b99752c Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 17 Dec 2013 10:45:35 +1100
Subject: [PATCH] fs/pipe.c: skip file_update_time on frozen fs

Pipe has no data associated with fs so it is not good idea to block
pipe_write() if FS is frozen, but we can not update file's time on such
filesystem.  Let's use same idea as we use in touch_time().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=65701

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/pipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 0e0752e..78fd0d0 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -663,10 +663,11 @@ out:
 		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
-	if (ret > 0) {
+	if (ret > 0 && sb_start_write_trylock(file_inode(filp)->i_sb)) {
 		int err = file_update_time(filp);
 		if (err)
 			ret = err;
+		sb_end_write(file_inode(filp)->i_sb);
 	}
 	return ret;
 }
-- 
1.8.5.2


--a8Wt8u1KmwUX3Y2C--
