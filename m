Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaGXJ0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:26:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32218 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaGXJ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:26:49 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-fd-53d0d15613a3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] cpuidle: coupled: Enable interrupts when early returning on
 invalid driver
Date: Thu, 24 Jul 2014 11:26:39 +0200
Message-id: <1406193999-20300-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t/xy7phFy8EG6xtE7TYOGM9q8X2jd9Y
	LeZ9lrV4/cLQ4mzTG3aLy7vmsFl87j3CaLH2yF12izOnL7FaLNj4iNGBy2Pb7m2sHneu7WHz
	2HK1ncWjb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4Mi4f+sBWcEao4k7XEqYGxhv8XYycHBIC
	JhJP3p5mg7DFJC7cWw9kc3EICSxllPix5DczhNPHJPF6WgsLSBWbgLHE5uVLwKpEBCYzSlyY
	N5sdxGEWaGSSmPq+AaiFg0NYIFZi3kdRkAYWAVWJI0tAajg5eAXcJdZO+sgKsU5O4uSxyawT
	GLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJoS87GBcfszrEKMDBqMTDy/DwVLAQ
	a2JZcWXuIUYJDmYlEd6Vmy4EC/GmJFZWpRblxxeV5qQWH2Jk4uCUamAsVwvfqSirFWU5/eqk
	ECa9jsmfVte852ZifqsTaaPdYX3A+eWU0t33Q1a+1bY5tjN+iWH3U86js7etunA0tPHWtR0c
	9mF/85YKTNvh9qzJNr+hY7uIQLXxkfWGH/IZGzVX8sm3W83+xbmL+/zNn2GTbi6IjDZcIjHp
	xS32Y7ltB+MYNl0unP5GiaU4I9FQi7moOBEAnxRDqf8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle_enter_state is expected to return with interrupts enabled.
However cpuidle_enter_state_coupled returned with interrupts disabled if
the cpuidle driver was registered without mask of coupled cpus.

This could be observed as a warning:
[    1.613132] ------------[ cut here ]------------
[    1.613244] WARNING: CPU: 0 PID: 0 at kernel/sched/idle.c:175 cpu_idle_loop+0x2dc/0x6d0()
[    1.620268] Modules linked in:
[    1.623311] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc4-00102-g7669ccdbf8af-dirty #81
[    1.623619] dwmmc_exynos 12510000.mshc: 1 slots initialized
[    1.624890] logger: created 256K log 'log_main'
[    1.625483] logger: created 256K log 'log_events'
[    1.626084] logger: created 256K log 'log_radio'
[    1.626699] logger: created 256K log 'log_system'
[    1.655960] [<c00167cc>] (unwind_backtrace) from [<c0012c28>] (show_stack+0x10/0x14)
[    1.663679] [<c0012c28>] (show_stack) from [<c050ab00>] (dump_stack+0x70/0xbc)
[    1.670883] [<c050ab00>] (dump_stack) from [<c0023ac8>] (warn_slowpath_common+0x68/0x8c)
[    1.678954] [<c0023ac8>] (warn_slowpath_common) from [<c0023b08>] (warn_slowpath_null+0x1c/0x24)
[    1.687720] [<c0023b08>] (warn_slowpath_null) from [<c006ddd4>] (cpu_idle_loop+0x2dc/0x6d0)
[    1.696052] [<c006ddd4>] (cpu_idle_loop) from [<c006e1d4>] (cpupri_find+0x0/0xd4)
[    1.703518] [<c006e1d4>] (cpupri_find) from [<c07cdd14>] (processor_id+0x0/0x2c)
[    1.710917] ---[ end trace a85327313857296e ]---

Enable the interrupts also when early returning from
cpuidle_enter_state_coupled due to invalid coupled configuration.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 4126c0197bc8 ("cpuidle: add support for states that affect multiple cpus")
Cc: <stable@vger.kernel.org>
---
 drivers/cpuidle/coupled.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 73fe2f8d7f96..2b57c267e855 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -463,8 +463,10 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 	struct cpuidle_coupled *coupled = dev->coupled;
 	int w;
 
-	if (!coupled)
+	if (!coupled) {
+		local_irq_enable();
 		return -EINVAL;
+	}
 
 	while (coupled->prevent) {
 		cpuidle_coupled_clear_pokes(dev->cpu);
-- 
1.9.1

