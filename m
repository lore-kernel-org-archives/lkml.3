Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3LQSfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:35:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3LQSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 042/103] [SCSI] hpsa: return 0 from driver probe function on success, not 1
Date: Tue, 17 Dec 2013 18:12:31 +0000
Message-Id: <1387304012-23805-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 88bf6d62db4393fa03a58bada9d746312d5b496f upstream.

A return value of 1 is interpreted as an error.  See pci_driver.
in local_pci_probe().  If you're wondering how this ever could
have worked, it's because it used to be the case that only return
values less than zero were interpreted as failure.  But even in
the current kernel if the driver registers its various entry
points with the kernel, and then returns a value which is
interpreted as failure, those registrations aren't undone, so
the driver still mostly works.  However, the driver's remove
function wouldn't be called on rmmod, and pci power management
functions wouldn't work.  In the case of Smart Array, since it
has a battery backed cache (or else no cache) even if the driver
is not shut down properly as long as there is no outstanding
i/o, nothing too bad happens, which is why it took so long to
notice.

Requesting backport to stable because the change to pci-driver.c
which requires driver probe functions to return 0 occurred between
2.6.35 and 2.6.36 (the pci power management breakage) and again
between 3.7 and 3.8 (pci_dev->driver getting set to NULL in
local_pci_probe() preventing driver remove function from being
called on rmmod.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ac56c29..c60f737 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4859,7 +4859,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);
-- 
1.8.3.2

