Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3KOOWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:22:48 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50388 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3KOOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:22:44 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Orion irqchip and Kirkwood SDIO
Date: Fri, 15 Nov 2013 15:22:31 +0100
Message-Id: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set tries to deal with a minor irq issue seen on Marvell
Kirkwood SoCs with irqchip/irq-orion and mvsdio drivers. In contrast
to non-DT irq handling, irqchip driver does handle irqs a little bit
different. First of all, it reads irq cause register once and works
through all bits set while non-DT irq handling read irq cause and
handled only one irq. Second, irqchip reverses irq priorities by
using ffs() instead of fls().

This now, seems to trigger a minor ip design issue in sdio peripheral
where sdio irq can occur upstream while sdio interrupts are all
disabled in the ip registers. This extra, unexpected irq does neither
harm correct function of HW nor SW driver but triggers a warning in
mvsdio irq handler.

I have tried to debug this and can say that the sequence of irq
related events is:
(a) sdio irq is set in upstream irq
(b) generic-chip handler masks sdio irq
(c) sdio irq handler deals with it,
    acks and disables all peripheral irq registers
(d) sdio irq cause is cleared
(e) generic-chip handler unmasks sdio irq
(f) sdio irq is set in upstream irq and cleared little later
(g) sdio irq handler is upset about being called with no irq to handle

This patch set is actually three independent patches in one as mvsdio
irq workaround just motivates irqchip handling changes. The third just
silences a noisy mvsdio dev_notice down to dev_dbg. I have chosen to
keep them together anyway. Below is a more detailed description of the
individual patches.

First patch reverses irq handling priority for irqchip driver to what
non-DT irq did before by using fls() instead of ffs(). The "read cause
once, work through all irqs" handling is maintained.

Second patch works around the spurious irq issue by bailing out of the
irq handler early, if peripheral irq registers indicate that none should
have been fired.

Third patch silences a card detect mechanism related dev_notice to
dev_dbg to not bother users with that.

All patches are based on v3.12. I suggest to take irqchip patch though
mvebu branch, while mmc related patches should go though mmc tree.

Sebastian Hesselbarth (3):
  irqchip: orion: reverse irq handling priority
  mmc: mvsdio: workaround for spurious irqs
  mmc: mvsdio: silence card detect notice

 drivers/irqchip/irq-orion.c |    4 ++--
 drivers/mmc/host/mvsdio.c   |   20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

