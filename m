Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaKHVBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:01:42 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:33901 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaKHVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:01:41 -0500
X-ME-Helo: beldin
X-ME-Date: Sat, 08 Nov 2014 22:01:39 +0100
X-ME-IP: 109.222.82.103
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] Transition pxa25x clock to common clocks
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
	<CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
	<87lhnlwqm4.fsf@free.fr>
	<CALT56yNOXq-ssvsjafz=ae+uWv1GyscoQ3RQ_h--i740zm4trA@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 08 Nov 2014 22:01:37 +0100
In-Reply-To: <CALT56yNOXq-ssvsjafz=ae+uWv1GyscoQ3RQ_h--i740zm4trA@mail.gmail.com>
	(Dmitry Eremin-Solenikov's message of "Sat, 8 Nov 2014 23:55:49
	+0400")
Message-ID: <8761epwgni.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:

> 2014-11-08 20:26 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
>> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:
>>
>>> Hello,
>>> Tested in qemu (pxa25x target).
>>>
>>> 2) sa1100-rtc could not find a clock and thus failed to be probed.
>>> 4) Got an issue with IrDA driver - it gets -ENODEV for UARTCLK clock
>>
>> Hi Dmitry,
>>
>> Would you mind retesting with the patch in [1] applied to see if points 2 and 4
>> are fixed ? Alternatively you can refetch from the github tree, I included that
>> incremental patch there too.
>>
>> If it works correctly for you, could I have your Tested-by ? If not, tell me and
>> I'll try to figure out what's wrong.
>
> Tested in qemu, everything works fine. I will test on the real hardware
> tomorow.
Aha, the test.
Would you at that time do a "cat /sys/kernel/debug/clk/clk_summary" and send it
to me please ?

>
> BTW: It looks like pxa27x also shows the same behaviour wrt. sa1100-rtc and
> pxa2xx-ir (after reverting a revert).
Ah yes, you're very right about that.

Same as before, github updated and patch included in this mail.

Cheers.

-- 
Robert


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-clk-pxa-add-missing-clocks-for-Irda-and-sa1100-rtc.patch

>From c36803b312621c1a69d2d6aed000ae7ee11da588 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 8 Nov 2014 21:46:51 +0100
Subject: [PATCH] clk: pxa: add missing clocks for Irda and sa1100-rtc

Add 2 clocks which were erronously forgotten by the clock framework
port, namely :
 - sa1100-rtc
 - irda for pxa2xx-ir:UARTCLK

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/clk/pxa/clk-pxa27x.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/clk/pxa/clk-pxa27x.c b/drivers/clk/pxa/clk-pxa27x.c
index 2b8343a..611879b 100644
--- a/drivers/clk/pxa/clk-pxa27x.c
+++ b/drivers/clk/pxa/clk-pxa27x.c
@@ -353,6 +353,33 @@ static u8 clk_pxa27x_memory_get_parent(struct clk_hw *hw)
 PARENTS(clk_pxa27x_memory) = { "osc_13mhz", "system_bus", "run" };
 MUX_RO_RATE_RO_OPS(clk_pxa27x_memory, "memory");
 
+#define DUMMY_CLK(_con_id, _dev_id, _parent) \
+	{ .con_id = _con_id, .dev_id = _dev_id, .parent = _parent }
+struct dummy_clk {
+	const char *con_id;
+	const char *dev_id;
+	const char *parent;
+};
+static struct dummy_clk dummy_clks[] __initdata = {
+	DUMMY_CLK(NULL, "sa1100-rtc", "osc_32_768khz"),
+	DUMMY_CLK("UARTCLK", "pxa2xx-ir", "STUART"),
+};
+
+static void __init pxa27x_dummy_clocks_init(void)
+{
+	struct clk *clk;
+	struct dummy_clk *d;
+	const char *name;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dummy_clks); i++) {
+		d = &dummy_clks[i];
+		name = d->dev_id ? d->dev_id : d->con_id;
+		clk = clk_register_fixed_factor(NULL, name, d->parent, 0, 1, 1);
+		clk_register_clkdev(clk, d->con_id, d->dev_id);
+	}
+}
+
 static void __init pxa27x_base_clocks_init(void)
 {
 	pxa27x_register_plls();
@@ -365,6 +392,7 @@ static void __init pxa27x_base_clocks_init(void)
 int __init pxa27x_clocks_init(void)
 {
 	pxa27x_base_clocks_init();
+	pxa27x_dummy_clocks_init();
 	return clk_pxa_cken_init(pxa27x_clocks, ARRAY_SIZE(pxa27x_clocks));
 }
 
-- 
2.1.0


--=-=-=--
