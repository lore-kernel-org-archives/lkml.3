Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3BDQ5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:57:41 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45644 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3BDQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:57:38 -0500
Date: Mon, 4 Feb 2013 08:57:32 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH 12.5/62] firewire: add minor number range check to
 fw_device_init()
Message-ID: <20130204165732.GG27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_device_init() didn't check whether the allocated minor number isn't
too large.  Fail if it goes overflows MINORBITS.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@vger.kernel.org
---
 drivers/firewire/core-device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1020,6 +1020,10 @@ static void fw_device_init(struct work_s
 	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
 	      idr_get_new(&fw_device_idr, device, &minor) :
 	      -ENOMEM;
+	if (minor >= 1 << MINORBITS) {
+		idr_remove(&fw_device_idr, minor);
+		minor = -ENOSPC;
+	}
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)
