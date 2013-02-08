Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab3BHEwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:52:18 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61937 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3BHEwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:52:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130208020659.GE5224@localhost>
References: <20130208020659.GE5224@localhost>
Date: Fri, 8 Feb 2013 12:52:16 +0800
Message-ID: <CAJd=RBBtzcjyzxMFUHQL+9srV-juvqc9gLFFMOx50kPv9tVtBQ@mail.gmail.com>
Subject: Re: [console_unlock] WARNING: at kernel/sched/clock.c:219 sched_clock_cpu()
From: Hillf Danton <dhillf@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fengguang

On Fri, Feb 8, 2013 at 10:06 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /c/kernel-tests/src/linux/kernel/sched/clock.c:219 sched_clock_cpu+0x65/0x140()
> [    0.000000] Hardware name: Bochs
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-rc6-mm1-00539-g83b324c #39
> [    0.000000] Call Trace:
> [    0.000000]  [<c102ba37>] warn_slowpath_common+0x87/0xb0
> [    0.000000]  [<c1063025>] ? sched_clock_cpu+0x65/0x140
> [    0.000000]  [<c1063025>] ? sched_clock_cpu+0x65/0x140
> [    0.000000]  [<c102ba82>] warn_slowpath_null+0x22/0x30
> [    0.000000]  [<c1063025>] sched_clock_cpu+0x65/0x140
> [    0.000000]  [<c102d8f9>] __console_unlock+0x39/0x490
> [    0.000000]  [<c12eeb23>] ? printk+0x3d/0x3f
> [    0.000000]  [<c102dd5d>] console_unlock+0xd/0x20
> [    0.000000]  [<c14bbbb0>] con_init+0x1fb/0x20e
> [    0.000000]  [<c14bb1b2>] console_init+0x12/0x20
> [    0.000000]  [<c149e969>] start_kernel+0x258/0x35f
> [    0.000000]  [<c149e4cc>] ? repair_env_string+0x51/0x51
> [    0.000000]  [<c149e376>] i386_start_kernel+0x12c/0x12f
> [    0.000000] ---[ end trace e006f8c3d589c9a1 ]---
>
Can you please try the following fix?

--- a/kernel/printk.c	Fri Feb  8 12:31:18 2013
+++ b/kernel/printk.c	Fri Feb  8 12:51:42 2013
@@ -2053,6 +2053,7 @@ static bool __console_unlock(void)
 		return false;
 	}

+	local_irq_save(flags);
 	console_may_schedule = 0;
 	cur_cpu = smp_processor_id();
 	/*
@@ -2062,6 +2063,7 @@ static bool __console_unlock(void)
 	end_time = sched_clock_cpu(cur_cpu) +
 				max_interrupt_disabled_duration() / 2;

+	local_irq_restore(flags);
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
 again:
--
