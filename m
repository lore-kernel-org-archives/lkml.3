Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaDWS6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:58:31 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:43375 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbaDWS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:58:29 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: [PATCH] s390/ccwgroup: Fix memory corruption
Date: Wed, 23 Apr 2014 20:58:45 +0200
Message-Id: <1398279525-2837-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042318-0542-0000-0000-000008C0D51D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0b60f9ead5d4816e7e3d6e28f4a0d22d4a1b2513 (s390: use
device_remove_file_self() instead of device_schedule_callback())

caused random memory corruption on my s390 box. Turns out that the
last element of the ccwgroup structure is of dynamic size, so we
must move the newly introduced work structure _before_ the zero
length array.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Tejun Heo <tj@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Sebastian Ott <sebott@linux.vnet.ibm.com>
CC: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 arch/s390/include/asm/ccwgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index 6e670f8..ebc2913 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -22,8 +22,8 @@ struct ccwgroup_device {
 /* public: */
 	unsigned int count;
 	struct device	dev;
-	struct ccw_device *cdev[0];
 	struct work_struct ungroup_work;
+	struct ccw_device *cdev[0];
 };
 
 /**
-- 
1.8.4.2

