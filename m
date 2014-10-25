Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaJYVvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:51:07 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:40262 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbaJYVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:51:04 -0400
X-Greylist: delayed 12601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2014 17:51:04 EDT
From: Marc Zyngier <marc.zyngier@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] genirq: Saving/restoring the irqchip state of an irq line
Date: Sat, 25 Oct 2014 11:14:54 +0100
Message-Id: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: adharmap@codeaurora.org, pvo@apm.com, linus.walleij@linaro.org, tnhuynh@apm.com, yvo@apm.com, tglx@linutronix.de, toanle@apm.com, bjorn@kryo.se, arnd@arndb.de, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite Linux offering a rather fine grained control over the life
cycle of an interrupt, there is a few cases where it would be very
useful to snapshot (or even set) the internal state of the interrupt
controller for a given interrupt line:

- With KVM, a device shared between VMs must have its whole context
  switched, and that includes the interrupt line state. KVM/arm is
  moving to using this.
- Some GPIO controllers seem to require peeking into the interrupt controller
  they are connected to to report their internal state.

Instead of letting people facing this situation doing horrible
(controller specific) hacks in their code, let's offer a couple of new
entry points that allow a few attributes to be read and set.

Of course, this is a very dangerous thing to do if you don't know what
you doing, and I wouldn't expect most drivers to use this. But this
can also be a life saver at times.

This patch series implement said API, and adds support for this to the
two main ARM interrupt controllers (GIC and GICv3).

Based on 3.18-rc1, tested on arm/arm64, and also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/irqchip_state

Marc Zyngier (3):
  genirq: Allow the irqchip state of an IRQ to be save/restored
  irqchip: GIC: Add support for irq_{get,set}_irqchip_state
  irqchip: GICv3: Add support for irq_{get,set}_irqchip_state

 drivers/irqchip/irq-gic-v3.c | 78 ++++++++++++++++++++++++++++++++++++--------
 drivers/irqchip/irq-gic.c    | 70 ++++++++++++++++++++++++++++++++++++---
 include/linux/interrupt.h    |  2 ++
 include/linux/irq.h          | 18 ++++++++++
 kernel/irq/manage.c          | 71 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 221 insertions(+), 18 deletions(-)

-- 
2.1.0

