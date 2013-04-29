Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3D2QNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:13:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab3D2QM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:12:59 -0400
To: Florian Westphal <fw@strlen.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, axboe@kernel.dk,
        adam radford <aradford@gmail.com>
Subject: Re: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20130429152639.GG32324@breakpoint.cc>
Date: Mon, 29 Apr 2013 12:13:01 -0400
In-Reply-To: <20130429152639.GG32324@breakpoint.cc> (Florian Westphal's
	message of "Mon, 29 Apr 2013 17:26:39 +0200")
Message-ID: <yq1obcxpb76.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Florian" == Florian Westphal <fw@strlen.de> writes:

Florian> After update to 3.8 dmesg is spammed with: kernel: [
Florian> 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41 kernel: [
Florian> 280.272107] sd 8:0:0:0: [sda] Unhandled error code kernel: 

Interesting. It looks like the 3ware handles this at the driver level
instead of passing the command through to the disk and letting it
fail. That in turn means that the logic we have in place to disable WS
when the disk does not support it does not get triggered.

The driver should really fill out the sense buffer in that case.

Could you please test the patch below?


Florian> This goes on and on.

The second question is what it is that's issuing these zeroouts at boot?
Which filesystem are you using? What's your DM/MD config?

-- 
Martin K. Petersen	Oracle Linux Engineering


3w-xxxx: Create sense buffer for unsupported commands

Make the driver return appropriate sense data when an unsupported
operation is queued. This will cause the SCSI layer to stop issuing the
offending command.

Reported-by: Florian Westphal <fw@strlen.de>
CC: adam radford <aradford@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 56662ae..b9276d1 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -216,6 +216,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
 #include "3w-xxxx.h"
 
 /* Globals */
@@ -2009,7 +2010,8 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 			printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			tw_state_request_finish(tw_dev, request_id);
-			SCpnt->result = (DID_BAD_TARGET << 16);
+			SCpnt->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense_buffer(1, SCpnt->sense_buffer, ILLEGAL_REQUEST, 0x20, 0);
 			done(SCpnt);
 			retval = 0;
 	}
