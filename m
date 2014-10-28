Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbaJ1HGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:06:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbaJ1Dps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 097/127] sparc64: Do not disable interrupts in nmi_cpu_busy()
Date: Tue, 28 Oct 2014 11:35:32 +0800
Message-Id: <20141028033425.082827045@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 58556104e9cd0107a7a8d2692cf04ef31669f6e4 ]

nmi_cpu_busy() is a SMP function call that just makes sure that all of the
cpus are spinning using cpu cycles while the NMI test runs.

It does not need to disable IRQs because we just care about NMIs executing
which will even with 'normal' IRQs disabled.

It is not legal to enable hard IRQs in a SMP cross call, in fact this bug
triggers the BUG check in irq_work_run_list():

	BUG_ON(!irqs_disabled());

Because now irq_work_run() is invoked from the tail of
generic_smp_call_function_single_interrupt().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/nmi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -130,7 +130,6 @@ static inline unsigned int get_nmi_count
 
 static __init void nmi_cpu_busy(void *data)
 {
-	local_irq_enable_in_hardirq();
 	while (endflag == 0)
 		mb();
 }


