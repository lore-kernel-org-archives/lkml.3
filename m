Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3AQN2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:28:50 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49394 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3AQN2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:28:48 -0500
Date: Thu, 17 Jan 2013 13:28:43 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Richard Mortimer <richm@oldelvet.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] sparc: kernel/sbus.c: fix memory leakage
Message-ID: <20130117132843.GD25615@gmail.com>
References: <1358199372-11976-1-git-send-email-dinggnu@gmail.com>
 <20130116211309.GA13993@merkur.ravnborg.org>
 <20130116211725.GC18593@gmail.com>
 <20130116220018.GA14063@merkur.ravnborg.org>
 <20130116220153.GD18593@gmail.com>
 <50F7D577.8010506@oldelvet.org.uk>
 <20130117115637.GB25615@gmail.com>
 <50F7EED3.1050309@oldelvet.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F7EED3.1050309@oldelvet.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable iommu and strbuf are not freed properly if it goes to error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/sparc/kernel/sbus.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
index 1271b3a..be5bdf9 100644
--- a/arch/sparc/kernel/sbus.c
+++ b/arch/sparc/kernel/sbus.c
@@ -554,10 +554,8 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	regs = pr->phys_addr;
 
 	iommu = kzalloc(sizeof(*iommu), GFP_ATOMIC);
-	if (!iommu)
-		goto fatal_memory_error;
 	strbuf = kzalloc(sizeof(*strbuf), GFP_ATOMIC);
-	if (!strbuf)
+	if (!iommu || !strbuf)
 		goto fatal_memory_error;
 
 	op->dev.archdata.iommu = iommu;
@@ -656,6 +654,8 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	return;
 
 fatal_memory_error:
+	kfree(iommu);
+	kfree(strbuf);
 	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
 }
 
-- 
1.7.4.5

