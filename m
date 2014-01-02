Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaABMQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:16:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaABMII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH, RFC 03/30] DAC960: remove sleep_on usage
Date: Thu,  2 Jan 2014 13:07:27 +0100
Message-Id: <1388664474-1710039-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:OF8XSUQGD4aHkLspwWGjRhFASndHHFOzXVIBC2hRj9S
 RaNdgGjjpX+uveZFDiT73qjZgAG2p0coPxvMIKVUOZsY4qn5Xg
 lampeRBTZOqJfpHR64SaNnVveIBADS55OArT9F9ShnXZQ1lEH+
 wl+FY8yXQFA32zMTYjuCb0ShIyKrLAgRHSPZHp98oV6YWLh1Mq
 iuIHOLx2OGs+n6KtbqAkfU+pZ/zijFB8Rlab+KFXyZdNjC+9K8
 2FdLFUNTVWxO0CDoAloPFrt9h56iYWcWITmF0pUhBHoM6/zTU+
 hM0wtkwdg81U79zhK/fzFA/qkOjktsSdFXHfm4BBDoowoHT4Y7
 aoD9r7rUzDOo1psWaZ4RO1y4w4ak9+uIIQtmBTR+4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on and its variants are going away. The use of sleep_on() in
DAC960_V2_ExecuteUserCommand seems to be bogus because the command
by the time we get there, the command has completed already and
we just enter the timeout. Based on this interpretation, I concluded
that we can replace it with a simple msleep(1000) and rearrange the
code around it slightly.

The interruptible_sleep_on_timeout in DAC960_gam_ioctl seems equivalent
to the race-free version using wait_event_interruptible_timeout.
I left the driver to return -EINTR rather than -ERESTARTSYS to preserve
the timeout behavior.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/DAC960.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index eb39501..125d845 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6411,12 +6411,12 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 					.ScatterGatherSegments[0]
 					.SegmentByteCount =
 	    CommandMailbox->ControllerInfo.DataTransferSize;
-	  DAC960_ExecuteCommand(Command);
-	  while (Controller->V2.NewControllerInformation->PhysicalScanActive)
-	    {
-	      DAC960_ExecuteCommand(Command);
-	      sleep_on_timeout(&Controller->CommandWaitQueue, HZ);
-	    }
+	  while (1) {
+	    DAC960_ExecuteCommand(Command);
+	    if (!Controller->V2.NewControllerInformation->PhysicalScanActive)
+		break;
+	    msleep(1000);
+	  }
 	  DAC960_UserCritical("Discovery Completed\n", Controller);
  	}
     }
@@ -7035,18 +7035,16 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 		ErrorCode = -EFAULT;
 		break;
 	}
-	while (Controller->V2.HealthStatusBuffer->StatusChangeCounter
-	       == HealthStatusBuffer.StatusChangeCounter &&
-	       Controller->V2.HealthStatusBuffer->NextEventSequenceNumber
-	       == HealthStatusBuffer.NextEventSequenceNumber)
-	  {
-	    interruptible_sleep_on_timeout(&Controller->HealthStatusWaitQueue,
-					   DAC960_MonitoringTimerInterval);
-	    if (signal_pending(current)) {
-	    	ErrorCode = -EINTR;
-	    	break;
-	    }
-	  }
+	ErrorCode = wait_event_interruptible_timeout(Controller->HealthStatusWaitQueue,
+			!(Controller->V2.HealthStatusBuffer->StatusChangeCounter
+			    == HealthStatusBuffer.StatusChangeCounter &&
+			  Controller->V2.HealthStatusBuffer->NextEventSequenceNumber
+			    == HealthStatusBuffer.NextEventSequenceNumber),
+			DAC960_MonitoringTimerInterval);
+	if (ErrorCode == -ERESTARTSYS) {
+		ErrorCode = -EINTR;
+		break;
+	}
 	if (copy_to_user(GetHealthStatus.HealthStatusBuffer,
 			 Controller->V2.HealthStatusBuffer,
 			 sizeof(DAC960_V2_HealthStatusBuffer_T)))
-- 
1.8.3.2

