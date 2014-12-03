Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaLCQSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:18:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44160 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaLCQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:18:36 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/3] genirq: Saving/restoring the irqchip state of an irq line
Date: Wed,  3 Dec 2014 16:18:20 +0000
Message-Id: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
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
- Some GPIO controllers seem to require peeking into the interrupt
  controller they are connected to to report their internal state.

Instead of letting people facing this situation doing horrible
(controller specific) hacks in their code, let's offer a couple of new
entry points that allow a few attributes to be read and set.

Of course, this is a very dangerous thing to do if you don't know what
you doing, and I wouldn't expect most drivers to use this. But this
can also be a life saver at times.

This patch series implement said API, and adds support for this to the
two main ARM interrupt controllers (GIC and GICv3). Available at:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/irqchip_state

>From v1 [1]:
- Rebased on top of 3.18-rc7 + tip/irq/irqdomain-arm
- Now deals with stacked domains
- Changed the API to be less ambiguous (after review by tglx)
- Added IRQCHIP_STATE_LINE_LEVEL (as requested by Bjorn Anderson)

[1] https://lkml.org/lkml/2014/10/25/134

Marc Zyngier (3):
  genirq: Allow the irqchip state of an IRQ to be save/restored
  irqchip: GIC: Add support for irq_{get,set}_irqchip_state
  irqchip: GICv3: Add support for irq_{get,set}_irqchip_state

 drivers/irqchip/irq-gic-v3.c | 83 +++++++++++++++++++++++++++++++++-------
 drivers/irqchip/irq-gic.c    | 69 ++++++++++++++++++++++++++++++---
 include/linux/interrupt.h    | 14 +++++++
 include/linux/irq.h          |  6 +++
 kernel/irq/manage.c          | 91 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 245 insertions(+), 18 deletions(-)

-- 
2.1.3

