Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3FEPyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:54:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26711 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3FEPyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fix kmemleak complaining about memory leaks when offlining/onlining vCPUS (v1).
Date: Wed,  5 Jun 2013 11:54:29 -0400
Message-Id: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I fixed the online/offline vCPU mechanism to work again under
PVHVM guests, I saw this:


[  665.026885] kmemleak: 7 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

but due to not having enough time did not fix it. This patchset
fixes it by stashing the 'char *' of said interrupts line during their
creation. When they are torn down when a VCPU is offline we use said
per-cpu pointer to free it.

As part of it I also added some error checking and some default values.
Please look.

 arch/x86/xen/smp.c      | 91 ++++++++++++++++++++++++++++++++-----------------
 arch/x86/xen/spinlock.c |  5 +++
 arch/x86/xen/time.c     | 41 +++++++++++++++-------
 3 files changed, 92 insertions(+), 45 deletions(-)

Konrad Rzeszutek Wilk (9):
      xen/smp: Coalesce the free_irq calls in one function.
      xen/smp: Introduce a common structure to contain the IRQ name and interrupt line.
      xen/smp: Set the per-cpu IRQ number to a valid default.
      xen/smp: Don't leak interrupt name when offlining.
      xen/spinlock: Don't leak interrupt name when offlining.
      xen/time: Encapsulate the struct clock_event_device in another structure.
      xen/time: Don't leak interrupt name when offlining.
      xen/time: Check that the per_cpu data structure has data before freeing.
      xen/time: Free onlined per-cpu data structure if we want to online it again.

