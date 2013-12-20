Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3LTSsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:48:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19650 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3LTSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:18 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-c7-52b490f169f6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 6/9] intel_idle: do C1E promotion disable quirk for
 hotplugged CPUs
Date: Fri, 20 Dec 2013 19:47:28 +0100
Message-id: <1387565251-7051-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd2PE7YEGZyYYW6xccZ6Vot5n2Ut
	zja9YbfY+fAtm8XlXXPYLD73HmG0mHF+H5PF7+//WC3OnL7E6sDpsWlVJ5vHnWt72DzOz1jI
	6LHlajuLR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGUcuHCftaCHo+LjlbXsDYyf2boYOTkk
	BEwk+v//gLLFJC7cWw9kc3EICUxnlLhwcBKU08UksfPoBUaQKjYBK4mJ7avAbBEBUYnLuyew
	gBQxCzxmlJjdNIUZJCEsECHx5EkfK4jNIqAq0TLjP5jNK+AusX/LTah1ihLdzyaA2ZwCHhKz
	Xy1nArGFgGpOdP1mnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNA9k9rBuLLB
	4hCjAAejEg9vQfSWICHWxLLiytxDjBIczEoivDfbgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7RaBwoJpCeWpGanphakFsFkmTg4pRoYm5ryNmpcm5GXMk3+lXm5l+kX5ubv4etWCz+58Xmx
	0Qtxi8ssgfdF/XQUm1VCFx017YloEZBexDxDyyt6C4+Sx4TTJd+bpnz++FnP/wbb1R1q247x
	OHvzqMRuXXrJaquQSuORZffLbB6V3WjKj36Qc3hpSlHy2s/V3+xb3k/ac9dx3f5u7dYnSizF
	GYmGWsxFxYkANn60uTYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the system is booted with some CPUs offline C1E promotion disable quirk
won't be applied because on_each_cpu() in intel_idle_cpuidle_driver_init()
operates only on online CPUs. Fix it by adding the C1E promotion disable
handling to intel_idle_cpu_init() (which is also called during CPU_ONLINE
operation).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/idle/intel_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 92d1206..38da3fb 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -683,6 +683,9 @@ static int intel_idle_cpu_init(int cpu)
 	if (icpu->auto_demotion_disable_flags)
 		smp_call_function_single(cpu, auto_demotion_disable, NULL, 1);
 
+	if (icpu->disable_promotion_to_c1e)
+		smp_call_function_single(cpu, c1e_promotion_disable, NULL, 1);
+
 	return 0;
 }
 
-- 
1.8.2.3

