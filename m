Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaJYCEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 22:04:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50893 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaJYCEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 22:04:04 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: fsl_asrc: Add reg_defaults for regmap to fix kernel dump
Date: Fri, 24 Oct 2014 19:03:57 -0700
Message-Id: <1414202637-18929-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel dump (WARN_ON) ocurred during system boot-up inside regmap_write():

------------[ cut here ]------------
WARNING: CPU: 0 PID: 47 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xe8/0x108()
DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
Modules linked in:
CPU: 0 PID: 47 Comm: kworker/u2:2 Not tainted 3.18.0-rc1-10245-gb75d289-dirty #56
Workqueue: deferwq deferred_probe_work_func
Backtrace:
[<80012294>] (dump_backtrace) from [<80012578>] (show_stack+0x18/0x1c)
 r6:8097c73c r5:8097c73c r4:00000000 r3:be33ba80
[<80012560>] (show_stack) from [<806aac48>] (dump_stack+0x8c/0xa4)
[<806aabbc>] (dump_stack) from [<8002a694>] (warn_slowpath_common+0x70/0x94)
 r6:80062838 r5:00000009 r4:bd827b30 r3:be33ba80
[<8002a624>] (warn_slowpath_common) from [<8002a6f0>] (warn_slowpath_fmt+0x38/0x40)
 r8:00000004 r7:00000001 r6:000080d0 r5:60000193 r4:bd826010
[<8002a6bc>] (warn_slowpath_fmt) from [<80062838>] (lockdep_trace_alloc+0xe8/0x108)
 r3:80831590 r2:8082e160
[<80062750>] (lockdep_trace_alloc) from [<800ea5dc>] (kmem_cache_alloc+0x28/0x134)
 r5:000080d0 r4:be001f00
[<800ea5b4>] (kmem_cache_alloc) from [<8038d72c>] (regcache_rbtree_write+0x15c/0x648)
 r10:00000000 r9:0000001c r8:00000004 r7:00000001 r6:00000000 r5:bd819a00
 r4:00000000 r3:811aea88
[<8038d5d0>] (regcache_rbtree_write) from [<8038c4d8>] (regcache_write+0x5c/0x64)
 r10:be3f9f88 r9:00000000 r8:00000004 r7:00000001 r6:00000000 r5:00000001
 r4:bd819a00
[<8038c47c>] (regcache_write) from [<8038b0dc>] (_regmap_raw_write+0x134/0x5f4)
 r6:be3f9f84 r5:00000001 r4:bd819a00 r3:00000001
[<8038afa8>] (_regmap_raw_write) from [<8038b610>] (_regmap_bus_raw_write+0x74/0x94)
 r10:00000000 r9:00000001 r8:be3fb080 r7:bd819a00 r6:00000001 r5:00000000
 r4:bd819a00
[<8038b59c>] (_regmap_bus_raw_write) from [<8038a8b4>] (_regmap_write+0x60/0x9c)
 r6:00000001 r5:00000000 r4:bd819a00 r3:8038b59c
[<8038a854>] (_regmap_write) from [<8038ba24>] (regmap_write+0x48/0x68)
 r7:bd81ad80 r6:00000001 r5:00000000 r4:bd819a00
[<8038b9dc>] (regmap_write) from [<80528f30>] (fsl_asrc_dai_probe+0x34/0x104)
 r6:bd888628 r5:be3fb080 r4:be3b4410 r3:be3b442c
------------[ dump end ]------------

=============================================================================
2741         /*
2742          * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
2743          */
2744         if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
2745                 return;
=============================================================================

By looking at 2744 line, we can get that it's because regcache_rbtree_write()
would call kmalloc() with GFP flag if it couldn't find an existing block to
insert nodes while this kmalloc() call is inside a spin_lock_irq_save pair,
i.e. IRQs disabled.

Even though this may be a bug that should be fixed, I still try to send this
patch as a quick fix (work around) since it does no harm to assign default
values of every registers when using regcache.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_asrc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index f2d8652..817d304 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -684,12 +684,38 @@ static bool fsl_asrc_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
+static struct reg_default fsl_asrc_reg[] = {
+	{ REG_ASRCTR, 0x0000 }, { REG_ASRIER, 0x0000 },
+	{ REG_ASRCNCR, 0x0000 }, { REG_ASRCFG, 0x0000 },
+	{ REG_ASRCSR, 0x0000 }, { REG_ASRCDR1, 0x0000 },
+	{ REG_ASRCDR2, 0x0000 }, { REG_ASRSTR, 0x0000 },
+	{ REG_ASRRA, 0x0000 }, { REG_ASRRB, 0x0000 },
+	{ REG_ASRRC, 0x0000 }, { REG_ASRPM1, 0x0000 },
+	{ REG_ASRPM2, 0x0000 }, { REG_ASRPM3, 0x0000 },
+	{ REG_ASRPM4, 0x0000 }, { REG_ASRPM5, 0x0000 },
+	{ REG_ASRTFR1, 0x0000 }, { REG_ASRCCR, 0x0000 },
+	{ REG_ASRDIA, 0x0000 }, { REG_ASRDOA, 0x0000 },
+	{ REG_ASRDIB, 0x0000 }, { REG_ASRDOB, 0x0000 },
+	{ REG_ASRDIC, 0x0000 }, { REG_ASRDOC, 0x0000 },
+	{ REG_ASRIDRHA, 0x0000 }, { REG_ASRIDRLA, 0x0000 },
+	{ REG_ASRIDRHB, 0x0000 }, { REG_ASRIDRLB, 0x0000 },
+	{ REG_ASRIDRHC, 0x0000 }, { REG_ASRIDRLC, 0x0000 },
+	{ REG_ASR76K, 0x0A47 }, { REG_ASR56K, 0x0DF3 },
+	{ REG_ASRMCRA, 0x0000 }, { REG_ASRFSTA, 0x0000 },
+	{ REG_ASRMCRB, 0x0000 }, { REG_ASRFSTB, 0x0000 },
+	{ REG_ASRMCRC, 0x0000 }, { REG_ASRFSTC, 0x0000 },
+	{ REG_ASRMCR1A, 0x0000 }, { REG_ASRMCR1B, 0x0000 },
+	{ REG_ASRMCR1C, 0x0000 },
+};
+
 static const struct regmap_config fsl_asrc_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
 
 	.max_register = REG_ASRMCR1C,
+	.reg_defaults = fsl_asrc_reg,
+	.num_reg_defaults = ARRAY_SIZE(fsl_asrc_reg),
 	.readable_reg = fsl_asrc_readable_reg,
 	.volatile_reg = fsl_asrc_volatile_reg,
 	.writeable_reg = fsl_asrc_writeable_reg,
-- 
1.9.1

