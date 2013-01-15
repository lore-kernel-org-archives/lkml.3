Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3AOOlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:41:49 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52443 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab3AOOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:41:48 -0500
Date: Tue, 15 Jan 2013 14:41:41 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: mvebu/clk-cpu.c: fix memory leakage
Message-ID: <20130115144140.GA1160@gmail.com>
References: <1358183892-28928-1-git-send-email-dinggnu@gmail.com>
 <50F563EC.3030804@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F563EC.3030804@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 03:13:00PM +0100, Gregory CLEMENT wrote:
> Dear Cong Ding,
> 
> On 01/14/2013 06:18 PM, Cong Ding wrote:
> > the variable cpuclk and clk_name should be properly freed.
> > 
> 
> Thanks for reporting this memory leak and for your patch but I think
> we could do even better, see below:
> 
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > ---
> >  drivers/clk/mvebu/clk-cpu.c |    9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
> > index ff004578..1a0d84f 100644
> > --- a/drivers/clk/mvebu/clk-cpu.c
> > +++ b/drivers/clk/mvebu/clk-cpu.c
> > @@ -124,7 +124,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
> >  
> >  	clks = kzalloc(ncpus * sizeof(*clks), GFP_KERNEL);
> >  	if (WARN_ON(!clks))
> > -		return;
> > +		goto clks_out;
> >  
> >  	for_each_node_by_type(dn, "cpu") {
> >  		struct clk_init_data init;
> > @@ -134,11 +134,11 @@ void __init of_cpu_clk_setup(struct device_node *node)
> >  		int cpu, err;
> >  
> >  		if (WARN_ON(!clk_name))
> > -			return;
> > +			goto clk_name_out;
> 
> I agree
> 
> >  
> >  		err = of_property_read_u32(dn, "reg", &cpu);
> >  		if (WARN_ON(err))
> > -			return;
> > +			goto bail_out;
> 
> I agree
> 
> >  
> >  		sprintf(clk_name, "cpu%d", cpu);
> >  		parent_clk = of_clk_get(node, 0);
> > @@ -166,7 +166,10 @@ void __init of_cpu_clk_setup(struct device_node *node)
> >  
> >  	return;
> >  bail_out:
> > +	kfree(clk_name);
> 
> Here you free only one clk_name whereas we could have previous clk_name which have
> been already allocated during the for_each_node_by_type loop.
> 
> A more annoying thing is that you use clk_name whereas it is only valid in the
> for_each_node_by_type statement and then this patch breaks the compilation:
> 
> drivers/clk/mvebu/clk-cpu.c: In function ‘of_cpu_clk_setup’:
> drivers/clk/mvebu/clk-cpu.c:169:8: error: ‘clk_name’ undeclared (first use in this function)
> drivers/clk/mvebu/clk-cpu.c:169:8: note: each undeclared identifier is reported only once for each function it appears in
sorry for the mistake, I am sending version 2.

thanks,
- cong

