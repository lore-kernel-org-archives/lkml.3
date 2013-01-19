Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3ASB1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:27:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:56902 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3ASBUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:20:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>, Dave Jones <davej@redhat.com>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/21] r8169: avoid NAPI scheduling delay.
Date: Fri, 18 Jan 2013 17:19:27 -0800
Message-Id: <20130119010712.946729733@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 7dbb491878a2c51d372a8890fa45a8ff80358af1 upstream.

While reworking the r8169 driver a few months ago to perform the
smallest amount of work in the irq handler, I took care of avoiding
any irq mask register operation in the slow work dedicated user
context thread. The slow work thread scheduled an extra round of NAPI
work which would ultimately set the irq mask register as required,
thus keeping such irq mask operations in the NAPI handler.
It would eventually race with the irq handler and delay NAPI execution
for - assuming no further irq - a whole ksoftirqd period. Mildly a
problem for rare link changes or corner case PCI events.

The race was always lost after the last bh disabling lock had been
removed from the work thread and people started wondering where those
pesky "NOHZ: local_softirq_pending 08" messages came from.

Actually the irq mask register _can_ be set up directly in the slow
work thread.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/ethernet/realtek/r8169.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5516,11 +5516,7 @@ static void rtl_slow_event_work(struct r
 	if (status & LinkChg)
 		__rtl8169_check_link_status(dev, tp, tp->mmio_addr, true);
 
-	napi_disable(&tp->napi);
-	rtl_irq_disable(tp);
-
-	napi_enable(&tp->napi);
-	napi_schedule(&tp->napi);
+	rtl_irq_enable_all(tp);
 }
 
 static void rtl_task(struct work_struct *work)


