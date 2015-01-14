Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbbANOpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:45:53 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33917 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbANOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:45:36 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] genirq: Make irqchip flags work with stacked irq domains
Date: Wed, 14 Jan 2015 14:45:15 +0000
Message-Id: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the landing of stacked irq domains in 3.19, we have ended up in a
situation where we have a stack of IRQ controllers, each with their
set of flags, but the core code is only able to look at the top-most,
which is not very helpful. This small series is trying to fix this.

The first patch converts all access to desc->irq_data.chip->flags to
using an accessor, without changing anything else. The second patch
adds some logic to combine these flags as we allocate the interrupts,
ultimately storing the resulting set as part of the irq_desc
structure.

We end-up with a configuration where the flags can either be located
in the irq_chip structure (non stacked case), or in the irq_desc
(stacked case). While this isn't really ideal, this gives at least the
right level of information to the rest of the IRQ framework, and is
only computed at allocation time, instead of parsing the irqchip stack
at runtime.

Based on 3.19-rc3, and available at:
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/stacked-irqchip-flags

>From v1 [1]:
- fix one last occurence of desc->irq_data.chip->flags, spotted by Jiang

[1]: https://lkml.org/lkml/2015/1/8/387

Marc Zyngier (2):
  genirq: Abstract access to irq_chip flags
  genirq: Allow irq_desc to carry the union of stacked irq_chip flags

 include/linux/irq.h     |  4 ++++
 include/linux/irqdesc.h | 12 ++++++++++++
 kernel/irq/chip.c       | 10 +++++-----
 kernel/irq/irqdesc.c    |  3 +++
 kernel/irq/irqdomain.c  | 20 +++++++++++++++++++-
 kernel/irq/manage.c     |  8 ++++----
 kernel/irq/pm.c         |  2 +-
 7 files changed, 48 insertions(+), 11 deletions(-)

-- 
2.1.4

