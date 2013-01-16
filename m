Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3APBBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:01:51 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50953 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3APBBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:01:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Cong Ding <dinggnu@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <50F5C00B.10108@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1358183892-28928-1-git-send-email-dinggnu@gmail.com>
 <50F563EC.3030804@free-electrons.com> <20130115152307.GA25615@gmail.com>
 <20130115153716.GF13433@titan.lakedaemon.net>
 <50F584F5.6030007@free-electrons.com> <20130115182629.GB7211@gmail.com>
 <50F5A1A9.2030803@free-electrons.com> <20130115184423.GC7211@gmail.com>
 <50F5C00B.10108@free-electrons.com>
Message-ID: <20130116010143.8920.90024@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v3] clk: mvebu/clk-cpu.c: fix memory leakage
Date: Tue, 15 Jan 2013 17:01:43 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gregory CLEMENT (2013-01-15 12:46:03)
> On 01/15/2013 07:44 PM, Cong Ding wrote:
> > the variable cpuclk and clk_name should be properly freed when error happens.
> Dear Cong Ding,
> 
> Thanks for you efforts!
> I am happy with this patch and I tested it on the Armada XP DB board, so
> you can now add my:
> 
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 
> Mike,
> 
> could you take this patch for 3.8-rc fixes?
> 
> If you prefer, Jason agrees to take it, but you probably didn't notice it,
> because he uses your former(and no more valid) email when he wrote this.
> 

Acked-by: Mike Turquette <mturquette@linaro.org>

I don't have an existing clk-fixes branch.  This patch is the first fix
I've reviewed for this cycle.  I'm happy if you want to take it and
submit as part of any other mvebu fixes you have.  Otherwise I can take
it.

Let me know what you decide.

Thanks,
Mike

> Thanks,
> 
> Gregory
> 
> > 
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > Acked-by: Jason Cooper <jason@lakedaemon.net>
> > ---
> >  drivers/clk/mvebu/clk-cpu.c |    9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
> > index ff004578..9dd2551 100644
> > --- a/drivers/clk/mvebu/clk-cpu.c
> > +++ b/drivers/clk/mvebu/clk-cpu.c
> > @@ -124,7 +124,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
> >  
> >       clks = kzalloc(ncpus * sizeof(*clks), GFP_KERNEL);
> >       if (WARN_ON(!clks))
> > -             return;
> > +             goto clks_out;
> >  
> >       for_each_node_by_type(dn, "cpu") {
> >               struct clk_init_data init;
> > @@ -134,11 +134,11 @@ void __init of_cpu_clk_setup(struct device_node *node)
> >               int cpu, err;
> >  
> >               if (WARN_ON(!clk_name))
> > -                     return;
> > +                     goto bail_out;
> >  
> >               err = of_property_read_u32(dn, "reg", &cpu);
> >               if (WARN_ON(err))
> > -                     return;
> > +                     goto bail_out;
> >  
> >               sprintf(clk_name, "cpu%d", cpu);
> >               parent_clk = of_clk_get(node, 0);
> > @@ -167,6 +167,9 @@ void __init of_cpu_clk_setup(struct device_node *node)
> >       return;
> >  bail_out:
> >       kfree(clks);
> > +     while(ncpus--)
> > +             kfree(cpuclk[ncpus].clk_name);
> > +clks_out:
> >       kfree(cpuclk);
> >  }
> >  
> > 
> 
> 
> -- 
> Gregory Clement, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com
