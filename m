Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbbASVoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:44:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53417 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbbASVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:43:51 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/3] sysfs: Only accept read/write permissions for file attributes
Date: Mon, 19 Jan 2015 13:43:25 -0800
Message-Id: <1421703806-29791-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421703806-29791-1-git-send-email-linux@roeck-us.net>
References: <1421703806-29791-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54BD7A96.0265,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sysfs file attributes, only read and write permisssions make sense.
Mask provided attribute permissions accordingly and send a warning
to the console if invalid permission bits are set.

Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 fs/sysfs/group.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 305eccb..0de6473 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -55,6 +55,12 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 				if (!mode)
 					continue;
 			}
+
+			WARN(mode & ~(S_IRUGO | S_IWUGO | SYSFS_PREALLOC),
+			     "Attribute %s: Invalid permission 0x%x\n",
+			     (*attr)->name, mode);
+
+			mode &= S_IRUGO | S_IWUGO | SYSFS_PREALLOC;
 			error = sysfs_add_file_mode_ns(parent, *attr, false,
 						       mode, NULL);
 			if (unlikely(error))
-- 
2.1.0

