Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3CATqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3CATqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 20/46] firewire: add minor number range check to fw_device_init()
Date: Fri,  1 Mar 2013 11:45:08 -0800
Message-Id: <20130301194434.373943638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 3bec60d511179853138836ae6e1b61fe34d9235f upstream.

fw_device_init() didn't check whether the allocated minor number isn't
too large.  Fail if it goes overflows MINORBITS.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/core-device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -999,6 +999,10 @@ static void fw_device_init(struct work_s
 	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
 	      idr_get_new(&fw_device_idr, device, &minor) :
 	      -ENOMEM;
+	if (minor >= 1 << MINORBITS) {
+		idr_remove(&fw_device_idr, minor);
+		minor = -ENOSPC;
+	}
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)


