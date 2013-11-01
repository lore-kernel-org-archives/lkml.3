Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3KAQGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:06:40 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33411 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3KAQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:06:39 -0400
Subject: [PATCH] cciss: return 0 from driver probe function on success, not 1
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Fri, 01 Nov 2013 11:06:38 -0500
Message-ID: <20131101160638.17867.37792.stgit@beardog.cce.hp.com>
In-Reply-To: <20131101160528.17867.59655.stgit@beardog.cce.hp.com>
References: <20131101160528.17867.59655.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

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
Cc: stable@vger.kernel.org
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index edfa251..0c004ac 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
 	rebuild_lun_table(h, 1, 0);
 	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
-	return 1;
+	return 0;
 
 clean4:
 	cciss_free_cmd_pool(h);

