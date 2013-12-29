Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3L2Cjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:39:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55297 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3L2CKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.772842211@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 113/185] [SCSI] hpsa: return 0 from driver probe
 function on success, not 1
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4465,7 +4465,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);

