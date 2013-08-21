Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3HUIIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:08:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3HUIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:08:46 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Date: Wed, 21 Aug 2013 10:08:28 +0200
Message-Id: <1377072512-7986-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  This is the next iteration of my printk patchset. Since v5 I've made the
limit for printing configurable via sysfs.

Summary:

These patches avoid softlockups when a CPU gets caught in console_unlock() for
a long time during heavy printing from other CPU. As is discussed in patch 3/4
it isn't enough to just silence the watchdog because if CPU spends too long in
console_unlock() also RCU will complain, other CPUs can be blocked waiting for
printing CPU to process IPI, and even disk can be offlined because commands
couldn't be delivered to it for too long.

This patch series solves the problem by stopping printing in console_unlock()
after 1000 characters and the printing is postponed to irq work. To avoid
hogging a single CPU (irq work gets processed on the same CPU where it was
queued so it doesn't really help to reduce the printing load on that CPU) we
introduce a new type of lazy irq work - IRQ_WORK_UNBOUND - which can be
processed by any CPU.

The patch series has survived my testing without any softlockup reports.  I've
tested running sysrq-t (lots of printk output) while inserting modules (to
generate IPIs and also some printk traffic) and also running two delayed works
printing 10 KB of text each. All this was with simulated 9600 baud serial
console.

								Honza
