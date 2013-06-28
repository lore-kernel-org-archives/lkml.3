Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3F1Q4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:56:16 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:43601 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3F1Q4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <001401ce70b1$71c325e0$554971a0$%jun@samsung.com>
References: <1371772064-7505-1-git-send-email-dianders@chromium.org>
	<001401ce70b1$71c325e0$554971a0$%jun@samsung.com>
Date: Fri, 28 Jun 2013 09:56:09 -0700
X-Google-Sender-Auth: poPbcG9y4zpucbk9ma8QDMS_834
Message-ID: <CAD=FV=XNuphYrPSJqhuQrLvBJ7_EGvTSsCrVaOQLZGozDDDTBA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: don't queue up a card detect at slot startup
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

On Mon, Jun 24, 2013 at 1:04 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> This patch looks good to me. I agree above.
> Card detection procedure of mmc subsystem will be started by mmc_start_host during probe time.
> There is no need to do same in host driver.
> Could you describe the race point of this problem and why the duplication makes the problem?
> What is described below is not clear.
> If a actual detection of card is triggered during probe, similar problem may be occurred in spite of this patch.

OK, so I think the race is between the "mmc_rescan" thread and the
"dw_mci_work_routine_card" thread:

The "mmc_rescan" thread sets "host->state = STATE_SENDING_CMD" in
dw_mci_queue_request() with a stack crawl that looks like this (from
dump_stack):

[<803c5d10>] (dw_mci_request+0xb0/0x100) from [<803b1864>]
(__mmc_start_req+0x14c/0x164)
[<803b1864>] (__mmc_start_req+0x14c/0x164) from [<803b189c>]
(mmc_wait_for_req+0x20/0x30)
[<803b189c>] (mmc_wait_for_req+0x20/0x30) from [<803b1934>]
(mmc_wait_for_cmd+0x88/0xb4)
[<803b1934>] (mmc_wait_for_cmd+0x88/0xb4) from [<803bae34>]
(mmc_io_rw_direct_host+0xd0/0x160)
[<803bae34>] (mmc_io_rw_direct_host+0xd0/0x160) from [<803bb324>]
(sdio_reset+0x44/0x9c)
[<803bb324>] (sdio_reset+0x44/0x9c) from [<803b35d8>] (mmc_rescan+0x230/0x2c8)
[<803b35d8>] (mmc_rescan+0x230/0x2c8) from [<8004619c>]
(process_one_work+0x25c/0x418)
[<8004619c>] (process_one_work+0x25c/0x418) from [<8004680c>]
(worker_thread+0x280/0x3c4)
[<8004680c>] (worker_thread+0x280/0x3c4) from [<8004b4c0>] (kthread+0xc8/0xdc)
[<8004b4c0>] (kthread+0xc8/0xdc) from [<8000e758>] (ret_from_fork+0x14/0x20)


It's got the host->lock when it does that.  ...but then it releases
the lock at the end of dw_mci_request().  That allows
dw_mci_work_routine_card() to jump in.  You can see its stack crawl
(from kgdb):

#1  0x803c8008 in dw_mci_work_routine_card (work=0xee6f8ba0) at
/.../drivers/mmc/host/dw_mmc.c:1720
#2  0x8004619c in process_one_work (worker=worker@entry=0xeea74d00,
work=0xee6f8ba0) at /.../kernel/workqueue.c:2263
#3  0x8004680c in worker_thread (__worker=__worker@entry=0xeea74d00)
at /.../kernel/workqueue.c:2383
#4  0x8004b4c0 in kthread (_create=0xef209e38) at /.../kernel/kthread.c:168


I can reproduce the problem reliably by adding an "mdelay(100);" in
dw_mci_queue_request() right after "host->state = STATE_SENDING_CMD;".

When I do that and add a kgdb_breakpoint() in
dw_mci_work_routine_card() for the -ENOMEDIUM case, I can even see the
state of the "mmc_rescan" thread with kgdb:

#0  mmc_wait_for_req (host=host@entry=0xee702140,
mrq=mrq@entry=0xef1efdbc) at /.../drivers/mmc/core/core.c:474
#1  0x803b1934 in mmc_wait_for_cmd (host=host@entry=0xee702140,
cmd=cmd@entry=0xef1efe14, retries=0) at
/.../drivers/mmc/core/core.c:567
#2  0x803bae34 in mmc_io_rw_direct_host (host=host@entry=0xee702140,
write=write@entry=0, fn=fn@entry=0, addr=addr@entry=6, in=0 '\000',
out=out@entry=0xef1efe83 "\356\027\345\032'")
    at /.../drivers/mmc/core/sdio_ops.c:89
#3  0x803bb324 in sdio_reset (host=host@entry=0xee702140) at
/.../drivers/mmc/core/sdio_ops.c:214
#4  0x803b35d8 in mmc_rescan_try_freq (freq=<optimized out>,
host=0xee702140) at /.../drivers/mmc/core/core.c:2084
#5  mmc_rescan (work=0xee7023ac) at /.../drivers/mmc/core/core.c:2210
#6  0x8004619c in process_one_work (worker=worker@entry=0xef0af900,
work=0xee7023ac) at /.../kernel/workqueue.c:2263
#7  0x8004680c in worker_thread (__worker=__worker@entry=0xef0af900)
at /.../kernel/workqueue.c:2383
#8  0x8004b4c0 in kthread (_create=0xef18de40) at /.../kernel/kthread.c:168
#9  0x8000e758 in ret_from_fork () at /.../arch/arm/kernel/entry-common.S:92
#10 0x8000e758 in ret_from_fork () at /.../arch/arm/kernel/entry-common.S:92
Backtrace stopped: previous frame identical to this frame (corrupt stack?)


I'm not sure I have time to track down the whole race at the moment,
though I may be able to come back to it later.  However, we now have a
set of steps to reproduce (I think) and a full description of the
race.  Perhaps someone else who knows the code better would be able to
have a whack at it?

In any case, it seems reasonable to still merge my CL, since it makes
the race much less likely (and impossible in the case of non-removable
cards) removes some pointless code.  Would you be interested in acking
it?

-Doug
