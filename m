Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbbASVnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:43:53 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53411 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbASVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:43:50 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/3] sysfs: Use only return value from is_visible for the file mode
Date: Mon, 19 Jan 2015 13:43:24 -0800
Message-Id: <1421703806-29791-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421703806-29791-1-git-send-email-linux@roeck-us.net>
References: <1421703806-29791-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54BD7A95.011F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
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

Up to now, is_visible can only be used to either remove visibility
of a file entirely or to add permissions, but not to reduce permissions.
This makes it impossible, for example, to use DEVICE_ATTR_RW to define
file attributes and reduce permissions to read-only.

This behavior is undesirable and unnecessarily complicates code which
needs to reduce permissions; instead of just returning the desired
permissions, it has to ensure that the permissions in the attribute
variable declaration only reflect the minimal permissions ever needed.

Change semantics of is_visible to only use the permissions returned
from it instead of oring the returned value with the hard-coded
permissions.

Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 fs/sysfs/group.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 7d2a860..305eccb 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -41,7 +41,7 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 
 	if (grp->attrs) {
 		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
-			umode_t mode = 0;
+			umode_t mode = (*attr)->mode;
 
 			/*
 			 * In update mode, we're changing the permissions or
@@ -56,8 +56,7 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 					continue;
 			}
 			error = sysfs_add_file_mode_ns(parent, *attr, false,
-						       (*attr)->mode | mode,
-						       NULL);
+						       mode, NULL);
 			if (unlikely(error))
 				break;
 		}
-- 
2.1.0

