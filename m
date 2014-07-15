Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaGONs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:48:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21730 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaGONsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:48:55 -0400
X-IronPort-AV: E=Sophos;i="5.01,665,1400025600"; 
   d="scan'208";a="152988517"
Message-ID: <1405432129.1749.5.camel@hamster.uk.xensource.com>
Subject: xen: Fix possible page fault in fifo events
From: Frediano Ziglio <frediano.ziglio@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: xen-devel <xen-devel@lists.xenproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 14:48:49 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_test_bit function require a long* read access to pointer.
This is a problem if the you are using last entry in the page causing
an access to next page. If this page is not readable you get a memory
access failure (page fault).
All other x64 bit functions access memory using 32 bit operations.
For processors different than x64 long aligned operations are used.

Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
---
 drivers/xen/events/events_fifo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index d302639..af4672d 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -168,6 +168,11 @@ static int evtchn_fifo_setup(struct irq_info *info)
 	return ret;
 }
 
+static __always_inline int test_fifo_bit(int nr, event_word_t *word)
+{
+	return (ACCESS_ONCE(*word) & (((event_word_t) 1) << nr)) != 0;
+}
+
 static void evtchn_fifo_bind_to_cpu(struct irq_info *info, unsigned cpu)
 {
 	/* no-op */
@@ -188,7 +193,7 @@ static void evtchn_fifo_set_pending(unsigned port)
 static bool evtchn_fifo_is_pending(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	return sync_test_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
+	return test_fifo_bit(EVTCHN_FIFO_PENDING, word);
 }
 
 static bool evtchn_fifo_test_and_set_mask(unsigned port)
@@ -206,7 +211,7 @@ static void evtchn_fifo_mask(unsigned port)
 static bool evtchn_fifo_is_masked(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	return sync_test_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
+	return test_fifo_bit(EVTCHN_FIFO_MASKED, word);
 }
 /*
  * Clear MASKED, spinning if BUSY is set.
-- 
1.9.1


