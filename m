Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3EaTwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:52:50 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53519 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3EaTwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:52:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, <paulmck@linux.vnet.ibm.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <42b8bfd5-3012-4c49-b9ef-7a9beb5956f1@VA3EHSMHS041.ehs.local>
Cc: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <git@xilinx.com>
References: <42b8bfd5-3012-4c49-b9ef-7a9beb5956f1@VA3EHSMHS041.ehs.local>
Message-ID: <20130531195235.21525.64931@quantum>
User-Agent: alot/0.3.4
Subject: Re: [BUG] zynq | CCF | SRCU
Date: Fri, 31 May 2013 12:52:35 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sören Brinkmann (2013-05-31 12:12:07)
> Hi,
> 
> we recently encountered some kernel panics when we compiled one of our
> drivers as module and tested inserting/removing the module.
> Trying to debug this issue, I could reproduce it on the mainline kernel
> with a dummy module.
> 
> What happens is, that when on driver remove clk_notifier_unregister() is
> called and no other notifier for that clock is registered, the kernel
> panics.
> I'm not sure what is going wrong here. If there is a bug (and if where)
> or I'm just using the infrastructure the wrong way,... So, any hint is
> appreciated.
> 
> I attach the output from the crashing system. The stacktrace indicates a
> crash in 'srcu_readers_seq_idx()'.
> I also attach the module I used to trigger the issue and a patch on top
> of mainline commit a93cb29acaa8f75618c3f202d1cf43c231984644 which has
> the DT modifications I need to make the module find its clock and boot
> with my initramfs.
> 

Soren,

I only took a quick look at this so the following is a shot in the dark.
notifier_block->next should be protected by an RCU lock, and the way you
open-code the initialization struck me as a bit weird.  Can you change
your code to the following and let me know if it makes any difference?

static struct notifier_block nb = {
        .notifier_call = clk_notif_dbg_cb;
};

static int clk_notif_dbg_cb(struct notifier_block *nb,
                unsigned long event, void *data)
{
        pr_info("clk_notif_dbg_cb\n");

        return NOTIFY_OK;
}

static int clk_notif_dbg_probe(struct platform_device *pdev)
{
        ...
        if (clk_notifier_register(clk, &nb))
                dev_warn(&pdev->dev, "clk_notifier_register failed\n");
        ...


That is a small difference, but that style of initializing the
notifier_block has always worked for me when using clk rate-change
notifiers.  However I'm sure the bug you mention is far more evil and
nefarious than that ;-)

Regards,
Mike

> 
>         Thanks,
>         Sören
