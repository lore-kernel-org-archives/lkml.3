Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3J3MU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:20:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:7874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab3J3MU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:20:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,600,1378882800"; 
   d="scan'208";a="425161903"
Subject: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
To: neilb@suse.de
From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, shli@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 13:20:22 +0100
Message-ID: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of reshape of raid0 through raid4 a value of discard_granularity
will be set to stripe size. MD driver should re-set this value to correct
one when migration will be finished. Otherwise array will be left with
wrong value and discard operations will not work properly.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: Shaohua Li <shli@kernel.org>
---
 drivers/md/raid0.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c4d420b..807ca3a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
+	mddev->queue->limits.discard_granularity =
+			queue_logical_block_size(mddev->queue);
 
 	/*
 	 * now since we have the hard sector sizes, we can make sure

