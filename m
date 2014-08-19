Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaHSBhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 21:37:38 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59792 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaHSBhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 21:37:37 -0400
Date: Mon, 18 Aug 2014 18:37:29 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20140819013729.GP18411@ld-irv-0074>
References: <1408357919-19793-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408357919-19793-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:31:51AM +0100, Lee Jones wrote:
> I believe all of your queries have either been answered or addressed
> and I am hoping this will be the last submission. :)

Sorry, no. I can't review code that doesn't compile, so I'm only now
getting to some of the review.

> This is v2 of the squashed submission.  v1 had a small typo which
> prevented the BBT code from being truly configurable.  This has now
> been rectified and build tested with and without MTD_NAND_STM_BCH_BBT
> support.

>From smatch:

  drivers/mtd/nand/stm_nand_bch.c:1556 stm_nand_bch_probe() error: we previously assumed 'bank' could be null (see line 1482) [smatch]

>From GCC (extra warnings):

  drivers/mtd/nand/stm_nand_dt.c:39:21: warning: no previous prototype for 'stm_of_get_partitions_node' [-Wmissing-prototypes]
  drivers/mtd/nand/stm_nand_dt.c:68:5: warning: no previous prototype for 'stm_of_get_nand_banks' [-Wmissing-prototypes]

Looks like you forgot to include <linux/mtd/stm_nand_bbt.h>.

And your code is not bisectable. I think patch 7 and 8 should be
reordered (with some tweaks, perhaps):

Bisectability test results for configuration "arm-multi_v7_defconfig,arm,arm-unknown-linux-gnueabi-"

Failed to build patch #7: 5936df30f5e1 mtd: nand: stm_nand_bch: add support for ST's BCH NAND controller
Configuration: "arm-multi_v7_defconfig, architecture arm".


In file included from include/linux/ftrace.h:20:0,
                 from include/linux/perf_event.h:47,
                 from kernel/sys.c:16:
arch/arm/include/asm/ftrace.h:48:21: warning: no previous prototype for 'return_address' [-Wmissing-prototypes]
In file included from include/linux/ftrace.h:20:0,
                 from include/linux/perf_event.h:47,
                 from include/linux/ftrace_event.h:9,
                 from kernel/module.c:21:
arch/arm/include/asm/ftrace.h:48:21: warning: no previous prototype for 'return_address' [-Wmissing-prototypes]
kernel/module.c: In function 'add_usage_links':
kernel/module.c:1512:6: warning: variable 'nowarn' set but not used [-Wunused-but-set-variable]
drivers/mtd/nand/stm_nand_bch.c:26:36: fatal error: linux/mtd/stm_nand_bbt.h: No such file or directory
compilation terminated.
make[4]: *** [drivers/mtd/nand/stm_nand_bch.o] Error 1

Brian
