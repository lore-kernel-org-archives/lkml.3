Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab3B0AJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334Ab3B0AJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 60/86] ARM: 7643/1: sched: correct update_sched_clock()
Date: Tue, 26 Feb 2013 16:08:08 -0800
Message-Id: <20130226235919.142149593@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <js1304@gmail.com>

commit 7c4e9ced424be4d36df6a3e3825763e97ee97607 upstream.

If we want load epoch_cyc and epoch_ns atomically,
we should update epoch_cyc_copy first of all.
This notify reader that updating is in progress.

If we update epoch_cyc first like as current implementation,
there is subtle error case.
Look at the below example.

<Initial Condition>
cyc = 9
ns = 900
cyc_copy = 9

== CASE 1 ==
<CPU A = reader>           <CPU B = updater>
                           write cyc = 10
read cyc = 10
read ns = 900
                           write ns = 1000
                           write cyc_copy = 10
read cyc_copy = 10

output = (10, 900)

== CASE 2 ==
<CPU A = reader>           <CPU B = updater>
read cyc = 9
                           write cyc = 10
                           write ns = 1000
read ns = 1000
read cyc_copy = 9
                           write cyc_copy = 10
output = (9, 1000)

If atomic read is ensured, output should be (9, 900) or (10, 1000).
But, output in example case are not.

So, change updating sequence in order to correct this problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -84,11 +84,11 @@ static void notrace update_sched_clock(v
 	 * detectable in cyc_to_fixed_sched_clock().
 	 */
 	raw_local_irq_save(flags);
-	cd.epoch_cyc = cyc;
+	cd.epoch_cyc_copy = cyc;
 	smp_wmb();
 	cd.epoch_ns = ns;
 	smp_wmb();
-	cd.epoch_cyc_copy = cyc;
+	cd.epoch_cyc = cyc;
 	raw_local_irq_restore(flags);
 }
 


