Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaA0Raz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:30:55 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55853 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaA0Rap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:30:45 -0500
Message-ID: <52E697C0.6000202@gmail.com>
Date: Mon, 27 Jan 2014 19:30:40 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: tomi.valkeinen@ti.com
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz
Subject: [BISECTED] OMAP: DSS: clk rate mismatch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

linux-next-20140124 DSS is broken on N900  - display stays black (there 
is some noise though). I booted the kernel with qemu and it gives the 
following warning:

[    0.623779] DSS: set fck to 172800000
[    0.624237] ------------[ cut here ]------------
[    0.624298] WARNING: CPU: 0 PID: 1 at 
drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
[    0.624359] clk rate mismatch: 288000000 != 172800000
[    0.624389] Modules linked in:
[    0.624481] CPU: 0 PID: 1 Comm: swapper Tainted: G        W 
3.13.0-next-20140124+ #35
[    0.624572] [<c00126dc>] (unwind_backtrace) from [<c0010c30>] 
(show_stack+0x10/0x14)
[    0.624633] [<c0010c30>] (show_stack) from [<c0032d8c>] 
(warn_slowpath_common+0x64/0x84)
[    0.624694] [<c0032d8c>] (warn_slowpath_common) from [<c0032e2c>] 
(warn_slowpath_fmt+0x2c/0x3c)
[    0.624755] [<c0032e2c>] (warn_slowpath_fmt) from [<c01edb88>] 
(dss_set_fck_rate+0x68/0x8c)
[    0.624816] [<c01edb88>] (dss_set_fck_rate) from [<c056f300>] 
(omap_dsshw_probe+0x1e4/0x2f8)
[    0.624877] [<c056f300>] (omap_dsshw_probe) from [<c023e5f8>] 
(platform_drv_probe+0x18/0x48)
[    0.624938] [<c023e5f8>] (platform_drv_probe) from [<c023d1f0>] 
(driver_probe_device+0xb0/0x200)
[    0.624999] [<c023d1f0>] (driver_probe_device) from [<c023d3a8>] 
(__driver_attach+0x68/0x8c)
[    0.625061] [<c023d3a8>] (__driver_attach) from [<c023bac0>] 
(bus_for_each_dev+0x50/0x88)
[    0.625122] [<c023bac0>] (bus_for_each_dev) from [<c023ca28>] 
(bus_add_driver+0xcc/0x1c8)
[    0.625183] [<c023ca28>] (bus_add_driver) from [<c023da24>] 
(driver_register+0x9c/0xe0)
[    0.625244] [<c023da24>] (driver_register) from [<c023e540>] 
(platform_driver_probe+0x20/0xc0)
[    0.625305] [<c023e540>] (platform_driver_probe) from [<c056f088>] 
(omap_dss_init+0x1c/0xb0)
[    0.625366] [<c056f088>] (omap_dss_init) from [<c0008758>] 
(do_one_initcall+0x94/0x138)
[    0.625427] [<c0008758>] (do_one_initcall) from [<c054db64>] 
(kernel_init_freeable+0xe4/0x1ac)
[    0.625488] [<c054db64>] (kernel_init_freeable) from [<c03a0108>] 
(kernel_init+0x8/0x100)
[    0.625549] [<c03a0108>] (kernel_init) from [<c000ded8>] 
(ret_from_fork+0x14/0x3c)
[    0.625610] ---[ end trace 9f1065fe5ada0e27 ]---


According to git bisect, this 
http://permalink.gmane.org/gmane.linux.ports.arm.omap/107355 is the 
commit that broke it. Unfortunately that commit cannot be reverted, so I 
did a quick'n'dirty hack(just for the sake of it):

diff --git a/drivers/video/omap2/dss/dss.c b/drivers/video/omap2/dss/dss.c
index 9a145da..10e2fab 100644
--- a/drivers/video/omap2/dss/dss.c
+++ b/drivers/video/omap2/dss/dss.c
@@ -482,7 +482,8 @@ bool dss_div_calc(unsigned long pck, unsigned long 
fck_min,

  int dss_set_fck_rate(unsigned long rate)
  {
-	int r;
+	int  r, mul, div;
+	unsigned long prate;

  	DSSDBG("set fck to %lu\n", rate);

@@ -490,8 +491,22 @@ int dss_set_fck_rate(unsigned long rate)
  	if (r)
  		return r;

-	dss.dss_clk_rate = clk_get_rate(dss.dss_clk);
+	prate = clk_get_rate(dss.dss_clk);
+
+	for (mul = 1; mul < 16; mul++)
+		for(div = 1; div< 16; div++)
+			if(((prate*mul)/div) == rate)
+				goto found;
+
+found:

+	if(mul != 16)
+		r = clk_set_rate(dss.dss_clk, (rate*mul)/div);
+
+	if (r)
+		return r;
+
+	dss.dss_clk_rate = clk_get_rate(dss.dss_clk);
  	WARN_ONCE(dss.dss_clk_rate != rate,
  			"clk rate mismatch: %lu != %lu", dss.dss_clk_rate,
  			rate);


and it solves the problem. I hope the above will give you a better idea 
on what is really broken (and how to fix it :) ).

Regards,
Ivo
