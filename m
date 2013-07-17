Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3GQHg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:36:29 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50324 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569Ab3GQHg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:36:26 -0400
Message-ID: <1374046584.26384.36.camel@x61.thuisdomein>
Subject: [PATCH v3] [SCSI] scsi_debug: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 09:36:24 +0200
In-Reply-To: <CAC5umyioeYDxFVs5J8fvPmXWOB8k9dp_qCp8Ntcq_d8cKhkS9g@mail.gmail.com>
References: <1373879920.2591.13.camel@x61.thuisdomein>
	 <1373914081.2591.40.camel@x61.thuisdomein>
	 <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
	 <1373988586.17662.4.camel@x61.thuisdomein>
	 <CAC5umyioeYDxFVs5J8fvPmXWOB8k9dp_qCp8Ntcq_d8cKhkS9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jul 2013 07:36:25.0044 (UTC) FILETIME=[574ED940:01CE82C0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building scsi_debug.o triggers a GCC warning:
    drivers/scsi/scsi_debug.c: In function ‘dif_verify’:
    drivers/scsi/scsi_debug.c:1755:3: warning: ‘csum’ may be used uninitialized in this function [-Wmaybe-uninitialized]

This warning was apparently introduced (in v3.11-rc1) by commit
beb40ea42b ("[SCSI] scsi_debug: reduce duplication between
prot_verify_read and prot_verify_write"). It is a false positive. But if
we transform the switch statement in dif_compute_csum() to a
straightforward if/else statement we supply GCC with enough information
to determine that csum will not be used uninitialized.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2: much simpler, and doesn't change any behavior;
   v3: mention commit bebe40ea42b, as Akinobu suggested.

1) Still only compile tested.

 drivers/scsi/scsi_debug.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..7565ec5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1735,14 +1735,11 @@ static u16 dif_compute_csum(const void *buf, int len)
 {
 	u16 csum;
 
-	switch (scsi_debug_guard) {
-	case 1:
+	if (scsi_debug_guard == 1)
 		csum = ip_compute_csum(buf, len);
-		break;
-	case 0:
+	else
 		csum = cpu_to_be16(crc_t10dif(buf, len));
-		break;
-	}
+
 	return csum;
 }
 
-- 
1.8.1.4

