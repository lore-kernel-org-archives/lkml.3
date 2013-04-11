Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145Ab3DKUvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:51:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935925Ab3DKUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:36 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hbz-8L9Mu38A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EmLvEcgK89wA:10 a=7CQSdrXTAAAA:8 a=JfrnYn6hAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=azCPoUKV1MNu8TPkOAQA:9 a=ESTKKtUg-DoA:10 a=WwgC8nHKvroA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202556.227197057@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 061/171 ] clockevents: Dont allow dummy broadcast timers
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0061-clockevents-Don-t-allow-dummy-broadcast-timers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit a7dc19b8652c862d5b7c4d2339bd3c428bd29c4a ]

Currently tick_check_broadcast_device doesn't reject clock_event_devices
with CLOCK_EVT_FEAT_DUMMY, and may select them in preference to real
hardware if they have a higher rating value. In this situation, the
dummy timer is responsible for broadcasting to itself, and the core
clockevents code may attempt to call non-existent callbacks for
programming the dummy, eventually leading to a panic.

This patch makes tick_check_broadcast_device always reject dummy timers,
preventing this problem.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/tick-broadcast.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..a13987a 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,7 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
-	if ((tick_broadcast_device.evtdev &&
+	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
-- 
1.7.10.4


