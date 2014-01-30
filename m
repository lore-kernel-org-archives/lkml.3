Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaA3MF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:05:29 -0500
Received: from relaygw2-8.mclink.it ([213.21.178.155]:43443 "EHLO
	relaygw2-8.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaA3MFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:05:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYFAG0/6lJNK3Ai/2dsb2JhbABZgwy/NhZ0giYBBScTPxABUFcZiAkBy2UXjx+EIgSYKIpPh1CDLjs
Date: Thu, 30 Jan 2014 13:05:20 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] FMC: show_sdb_tree: fix offset calculation
Message-ID: <e0339c856514a1df2744e9a133451516c746a2ed.1391083417.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <697e73820414734bd7f3a8023391652b9bd930a3.1391083417.git.rubini@gnudd.com>
In-Reply-To: <697e73820414734bd7f3a8023391652b9bd930a3.1391083417.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code reported wrong addresses in the sdb dumps.  All sdb addresses
are relative, but the code was adding the base address twice.  Bug
exposed by a gateware image with two bridge levels.

Thanks David for reporting the problem.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Reported-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Tested-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
---
 drivers/fmc/fmc-sdb.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/fmc/fmc-sdb.c b/drivers/fmc/fmc-sdb.c
index 79adc39..69f42d7 100644
--- a/drivers/fmc/fmc-sdb.c
+++ b/drivers/fmc/fmc-sdb.c
@@ -153,20 +153,17 @@ EXPORT_SYMBOL(fmc_reprogram);
 static void __fmc_show_sdb_tree(const struct fmc_device *fmc,
 				const struct sdb_array *arr)
 {
+	unsigned long base = arr->baseaddr;
 	int i, j, n = arr->len, level = arr->level;
-	const struct sdb_array *ap;
 
 	for (i = 0; i < n; i++) {
-		unsigned long base;
 		union  sdb_record *r;
 		struct sdb_product *p;
 		struct sdb_component *c;
 		r = &arr->record[i];
 		c = &r->dev.sdb_component;
 		p = &c->product;
-		base = 0;
-		for (ap = arr; ap; ap = ap->parent)
-			base += ap->baseaddr;
+
 		dev_info(&fmc->dev, "SDB: ");
 
 		for (j = 0; j < level; j++)
-- 
1.7.7.2
