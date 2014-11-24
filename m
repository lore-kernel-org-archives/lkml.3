Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKXLvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:51:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:37620 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaKXLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:51:37 -0500
Date: Mon, 24 Nov 2014 12:51:16 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        richardcochran@gmail.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Touchscreen performance related fixes
Message-ID: <20141124115116.GA14997@linutronix.de>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vignesh R | 2014-11-14 10:37:25 [+0530]:

>This series of patches fix TSC defects related to lag in touchscreen
>performance and cursor jump at touch release. The lag was result of
>udelay in TSC interrupt handler. Cursor jump due to false pen-up event.
>The patches implement Advisory 1.0.31 in silicon errata of am335x-evm
am335x not -evm. The am335x-evm is a board (with its own advisory
document) built around the SoC.

Just testing the v4. I can use now IIO and touchscren at the same time.
back at v1 I reported that it does not work, this has been fixed now.
I had it running for a few minutes, now I see one of WARN_ON() beeing
triggered (I've cut a few numbers so don't wonder about PID 2 and so on):

|dmesg |grep WARNING | wc -l
|10
| dmesg |grep WARNING
|[306.257995] WARNING: CPU: 0 PID: 97 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[365.469591] WARNING: CPU: 0 PID: 58 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[379.255904] WARNING: CPU: 0 PID: 24 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[426.230505] WARNING: CPU: 0 PID: 35 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[435.654091] WARNING: CPU: 0 PID: 28 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[438.897519] WARNING: CPU: 0 PID: 91 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[525.720193] WARNING: CPU: 0 PID: 88 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[527.644770] WARNING: CPU: 0 PID: 38 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[557.218349] WARNING: CPU: 0 PID: 56 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104
|[610.077274] WARNING: CPU: 0 PID: 2 at mfd/ti_am335x_tscadc.c:94 am335x_tsc_se_set_once+0xf8/0x104

The complete trace:

|[610.110692] CPU: 0 PID: 4422 Comm: cat Tainted: G        W      3.18.0-rc6+ #1745
|[610.118577] [<c00138ec>] (unwind_backtrace) from [<c0011544>] (show_stack+0x10/0x14)
|[610.126772] [<c0011544>] (show_stack) from [<c003c9b0>] (warn_slowpath_common+0x68/0x88)
|[610.135313] [<c003c9b0>] (warn_slowpath_common) from [<c003c9ec>] (warn_slowpath_null+0x1c/0x24)
|[610.144586] [<c003c9ec>] (warn_slowpath_null) from [<bf00569c>] (am335x_tsc_se_set_once+0xf8/0x104 [ti_am335x_tscadc])
|[610.155886] [<bf00569c>] (am335x_tsc_se_set_once [ti_am335x_tscadc]) from [<bf067494>] (tiadc_read_raw+0xbc/0x190 [ti_am335x_adc])
|[610.168326] [<bf067494>] (tiadc_read_raw [ti_am335x_adc]) from [<bf02dccc>] (iio_read_channel_info+0x9c/0xa4 [industrialio])
|[610.180191] [<bf02dccc>] (iio_read_channel_info [industrialio]) from [<c02a42d4>] (dev_attr_show+0x1c/0x48)
|[610.190477] [<c02a42d4>] (dev_attr_show) from [<c013d544>] (sysfs_kf_seq_show+0x8c/0x110)
|[610.199108] [<c013d544>] (sysfs_kf_seq_show) from [<c013c1c8>] (kernfs_seq_show+0x24/0x28)
|[610.207833] [<c013c1c8>] (kernfs_seq_show) from [<c0102658>] (seq_read+0x1b4/0x47c)
|[610.215922] [<c0102658>] (seq_read) from [<c00e6700>] (vfs_read+0x8c/0x148)
|[610.223269] [<c00e6700>] (vfs_read) from [<c00e67fc>] (SyS_read+0x40/0x8c)
|[610.230525] [<c00e67fc>] (SyS_read) from [<c000e640>] (ret_fast_syscall+0x0/0x30)

Could you please look at that one? (I tested it on am335x-evm btw).

Sebastian
