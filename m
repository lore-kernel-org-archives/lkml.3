Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3AXO5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:57:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:48034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab3AXO5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:57:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,530,1355126400"; 
   d="scan'208";a="277925414"
Date: Thu, 24 Jan 2013 22:57:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: paul.szabo@sydney.edu.au
Cc: linux-mm@kvack.org, 695182@bugs.debian.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Negative (setpoint-dirty) in bdi_position_ratio()
Message-ID: <20130124145707.GB12745@localhost>
References: <201301200002.r0K02Atl031280@como.maths.usyd.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301200002.r0K02Atl031280@como.maths.usyd.edu.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> (This patch does not solve the PAE OOM issue.)

You may try the below debug patch. The only way the writeback patches
should trigger OOM, I think, is for the number of dirty/writeback
pages going out of control.

Or more simple, you may show us the OOM dmesg which will contain the
number of dirty pages. Or run this in a continuous loop during your
tests, and see how the dirty numbers change before OOM:

while :
do
        grep -E '(Dirty|Writeback)' /proc/meminfo
        sleep 1
done

Thanks,
Fengguang

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 50f0824..cf1165a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1147,6 +1147,16 @@ pause:
 		if (task_ratelimit)
 			break;
 
+		if (nr_dirty > dirty_thresh + dirty_thresh / 2) {
+			if (printk_ratelimit())
+				printk(KERN_WARNING "nr_dirty=%lu dirty_thresh=%lu task_ratelimit=%lu dirty_ratelimit=%lu pos_ratio=%lu\n",
+				       nr_dirty,
+				       dirty_thresh,
+				       task_ratelimit,
+				       dirty_ratelimit,
+				       pos_ratio);
+		}
+
 		/*
 		 * In the case of an unresponding NFS server and the NFS dirty
 		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
