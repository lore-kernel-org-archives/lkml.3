Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaFLTeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:34:09 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36533 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaFLTeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:34:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] timer: Fix missing dynticks kick
Date: Thu, 12 Jun 2014 21:33:59 +0200
Message-Id: <1402601641-28462-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Viresh has spotted and fixed an interesting issue. When a timer list
is enqueued or updated on a (idle or full) dynticks target, we kick it
with an IPI.

At least that's what we do on add_timer_on() but the mod_timer*() family
doesn't handle that. I think that's because we had assumptions that
mod_timer() never enqueues to remote idle targets. But that's subject
to subtle races where a CPU can become dynticks-idle between a call to
get_nohz_timer_target() and the time we actually lock the new target.

Moreover we forgot to handle full dynticks targets selected by __mod_timer().

That patchset should fixes all those issues.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/missing-kick

Thanks,
	Frederic
---

Viresh Kumar (2):
      timer: Store cpu-number in 'struct tvec_base'
      timer: Kick dynticks targets on mod_timer*() calls


 kernel/timer.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)
