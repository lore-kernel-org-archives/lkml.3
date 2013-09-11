Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3IKE3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3IKE3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:00 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=CG8f9SzwHFsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=nnwHGGW9uisA:10 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042854.773188302@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
Subject: [016/251] md/raid10: fix two bugs affecting RAID10 reshape.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0016-md-raid10-fix-two-bugs-affecting-RAID10-reshape.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 78eaa0d4cbcdb345992fa3dd22b3bcbb473cc064 ]

1/ If a RAID10 is being reshaped to a fewer number of devices
 and is stopped while this is ongoing, then when the array is
 reassembled the 'mirrors' array will be allocated too small.
 This will lead to an access error or memory corruption.

2/ A sanity test for a reshaping RAID10 array is restarted
 is slightly incorrect.

Due to the first bug, this is suitable for any -stable
kernel since 3.5 where this code was introduced.

Cc: stable@vger.kernel.org (v3.5+)
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/raid10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cd7394b..e2d5778 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3434,7 +3434,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	/* FIXME calc properly */
 	conf->mirrors = kzalloc(sizeof(struct raid10_info)*(mddev->raid_disks +
-							    max(0,mddev->delta_disks)),
+							    max(0,-mddev->delta_disks)),
 				GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out;
@@ -3578,7 +3578,7 @@ static int run(struct mddev *mddev)
 		    conf->geo.far_offset == 0)
 			goto out_free_conf;
 		if (conf->prev.far_copies != 1 &&
-		    conf->geo.far_offset == 0)
+		    conf->prev.far_offset == 0)
 			goto out_free_conf;
 	}
 
-- 
1.7.10.4


