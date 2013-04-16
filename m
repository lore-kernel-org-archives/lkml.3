Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab3DPUOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:14:11 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:3973
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936108Ab3DPUOJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:14:09 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh936eI1432I1447Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Tue, 16 Apr 2013 13:13:44 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Always notify whole subtree when reparenting
References: <afe397e3-c674-4dc3-9f3e-feea9275bb91@TX2EHSMHS023.ehs.local>
 <20130416195826.19887.78037@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130416195826.19887.78037@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ba2aafcd-94ad-442c-9366-77f34541334e@AM1EHSMHS009.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Apr 16, 2013 at 12:58:26PM -0700, Mike Turquette wrote:
> Quoting Soren Brinkmann (2013-04-16 10:06:50)
> > A clock's notifier count only reflects notifiers which are registered
> > directly for that clock. A reparent operation though affects the whole
> > subtree because of a potential rate change.
> > When issuing the pre rate change notifications only the notifier count
> > for the clock to be changed is considered and notifiers for subclocks
> > may never be called. Resulting in clocks in the subtree which have
> > registered notifiers, may receive a POST_- or ABORT_RATE_CHANGE
> > notification, without a PRE_RATE_CHANGE_NOTIFICATION.
> > Therefore always traverse the whole subtree when issueing pre rate
> > change notifications during a reparent operation.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > This should probably be considered an RFC. There may be smarter ways to
> > resolve this issue. E.g. forward notifier counts upstream the way it is done
> > with enable counts.
> > 
> 
> Hi Soren,
> 
> Thanks for the fix.  Some of the core code has changed enough lately
> that it is worth going through and consolidating/cleaning up.  For
> instance another nice optimization that is related might be something
> like:
> 
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 20ce67f..15e8b41 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1028,6 +1028,9 @@ static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
>  	else
>  		new_rate = parent_rate;
>  
> +	if (new_rate == clk->rate)
> +		return ret;
> +
>  	/* abort rate change if a driver returns NOTIFY_BAD or NOTIFY_STOP */
>  	if (clk->notifier_count)
>  		ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
> 
> 
> However it remains to be seen whether any drivers rely on
> PRE_RATE_CHANGE notifiers even if the clock rate stays the same.
Even if it changes the pre-rate change notifier is not issued.

> I don't think I'll take your patch for 3.10 since no one has reported a
> bug with it yet, but I'll roll it into a larger cleanup series after the
> merge window.
That's fine. I'm still revising Zynq's clock code and w/o this patch my
UART breaks since I don't receive a pre-rate-change notification when its
input frequency changes due to reparenting of clocks further up in the
hierarchy.

	Sören


