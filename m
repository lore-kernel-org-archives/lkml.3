Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3EaVKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:10:24 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:3434
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab3EaVKT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:10:19 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z5105hz98dIc89bh936eI1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh906i192cn1155h)
Date: Fri, 31 May 2013 14:10:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, <paulmck@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <git@xilinx.com>
Subject: Re: [BUG] zynq | CCF | SRCU
References: <42b8bfd5-3012-4c49-b9ef-7a9beb5956f1@VA3EHSMHS041.ehs.local>
 <20130531195235.21525.64931@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130531195235.21525.64931@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <09ee3179-5100-4c7c-bf3d-0a659a3e7633@DB8EHSMHS026.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, May 31, 2013 at 12:52:35PM -0700, Mike Turquette wrote:
> Quoting Sören Brinkmann (2013-05-31 12:12:07)
> > Hi,
> > 
> > we recently encountered some kernel panics when we compiled one of our
> > drivers as module and tested inserting/removing the module.
> > Trying to debug this issue, I could reproduce it on the mainline kernel
> > with a dummy module.
> > 
> > What happens is, that when on driver remove clk_notifier_unregister() is
> > called and no other notifier for that clock is registered, the kernel
> > panics.
> > I'm not sure what is going wrong here. If there is a bug (and if where)
> > or I'm just using the infrastructure the wrong way,... So, any hint is
> > appreciated.
> > 
> > I attach the output from the crashing system. The stacktrace indicates a
> > crash in 'srcu_readers_seq_idx()'.
> > I also attach the module I used to trigger the issue and a patch on top
> > of mainline commit a93cb29acaa8f75618c3f202d1cf43c231984644 which has
> > the DT modifications I need to make the module find its clock and boot
> > with my initramfs.
> > 
> 
> Soren,
> 
> I only took a quick look at this so the following is a shot in the dark.
> notifier_block->next should be protected by an RCU lock, and the way you
> open-code the initialization struck me as a bit weird.  Can you change
> your code to the following and let me know if it makes any difference?
> 
> static struct notifier_block nb = {
>         .notifier_call = clk_notif_dbg_cb;
> };
> 
> static int clk_notif_dbg_cb(struct notifier_block *nb,
>                 unsigned long event, void *data)
> {
>         pr_info("clk_notif_dbg_cb\n");
> 
>         return NOTIFY_OK;
> }
> 
> static int clk_notif_dbg_probe(struct platform_device *pdev)
> {
>         ...
>         if (clk_notifier_register(clk, &nb))
>                 dev_warn(&pdev->dev, "clk_notifier_register failed\n");
>         ...
> 
> 
> That is a small difference, but that style of initializing the
> notifier_block has always worked for me when using clk rate-change
> notifiers.  However I'm sure the bug you mention is far more evil and
> nefarious than that ;-)
I changed the module like this (I hope this is what you suggested):
	8,9d7
	< static struct notifier_block nb;
	< 
	17a16,19
	> static struct notifier_block nb = {
	>       .notifier_call = clk_notif_dbg_cb
	> };
	> 
	20,22d21
	<       nb.next = NULL;
	<       nb.notifier_call = clk_notif_dbg_cb;
	<

The result is the same. It crashes in srcu_readers_seq_idx().

	Thanks,
	Sören


