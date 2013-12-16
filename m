Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3LPRbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:31:37 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48898 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3LPRbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:31:34 -0500
X-Spam-Check-By: orbis-terrarum.net
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, "Robin H. Johnson" <robbat2@gentoo.org>
Subject: [PATCH v2] libata: disable a disk via libata.force params
Date: Mon, 16 Dec 2013 09:31:19 -0800
Message-Id: <1387215079-29897-1-git-send-email-robbat2@gentoo.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386464187-6993-1-git-send-email-robbat2@gentoo.org>
References: <1386464187-6993-1-git-send-email-robbat2@gentoo.org>
X-Virus-Checked: Checked by ClamAV on orbis-terrarum.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A user on StackExchange had a failing SSD that's soldered directly onto
the motherboard of his system. The BIOS does not give any option to
disable it at all, so he can't just hide it from the OS via the BIOS.

The old IDE layer had hdX=noprobe override for situations like this, but
that was never ported to the libata layer.

This patch implements a disable flag for libata.force.
Example use:
libata.force=2.0:disable

[v2 of the patch, removed the nodisable flag per Tejun Heo]

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
X-URL: http://unix.stackexchange.com/questions/102648/how-to-tell-linux-kernel-3-0-to-completely-ignore-a-failing-disk
X-URL: http://askubuntu.com/questions/352836/how-can-i-tell-linux-kernel-to-completely-ignore-a-disk-as-if-it-was-not-even-co
X-URL: http://superuser.com/questions/599333/how-to-disable-kernel-probing-for-drive
---
 Documentation/kernel-parameters.txt | 2 ++
 drivers/ata/libata-core.c           | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..b9e9bd8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1529,6 +1529,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			* atapi_dmadir: Enable ATAPI DMADIR bridge support
 
+			* disable: Disable this device.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 75b9367..70529b8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6519,6 +6519,7 @@ static int __init ata_parse_force_one(char **cur,
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
 		{ "rstonce",	.lflags		= ATA_LFLAG_RST_ONCE },
 		{ "atapi_dmadir", .horkage_on	= ATA_HORKAGE_ATAPI_DMADIR },
+		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
-- 
1.8.4.3

