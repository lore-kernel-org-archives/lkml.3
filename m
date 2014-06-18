Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaFRTtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:49:50 -0400
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:44970 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755034AbaFRTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:49:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4385:5007:6120:7652:8603:8957:10004:10400:10848:11026:11232:11658:11914:12295:12296:12438:12517:12519:12679:12740:13019:13069:13095:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spy82_8f2447ab44854
X-Filterd-Recvd-Size: 2761
Message-ID: <1403120982.3839.25.camel@joe-AO725>
Subject: Re: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of
 memory' messages
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        benoit.taine@lip6.fr
Date: Wed, 18 Jun 2014 12:49:42 -0700
In-Reply-To: <20140618193345.GR4669@linux.vnet.ibm.com>
References: <1402419340.30479.18.camel@joe-AO725>
	 <20140611074704.GS5015@mwanda> <1402502500.6169.5.camel@joe-AO725>
	 <alpine.DEB.2.02.1406140937370.2003@localhost6.localdomain6>
	 <alpine.DEB.2.02.1406141151170.2045@localhost6.localdomain6>
	 <20140618193345.GR4669@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 12:33 -0700, Paul E. McKenney wrote:
> On Sat, Jun 14, 2014 at 11:51:41AM +0200, Julia Lawall wrote:
> > On Sat, 14 Jun 2014, Julia Lawall wrote:
> > > With a semantic patch that searches for the various calls and then a 
> > > string containing the letters "emory", I get removals of the messages 
> > > below.  Do any of these messages look useful?  For example, some are 
> > > generated with specific functions, such as IRDA_ERROR or BT_ERR.  If none 
> > > of the messages look useful, should just one big patch go to trivial, or 
> > > should the patches go to the individual maintainers?
> > 
> > Sorry, I left out all the strings...
> 
> I would like the rcu-torture message to stay:
> 
> > -		pr_err("rcu-torture: Out of memory, need: %d", size);
> 
> This is in a module that is not loaded into any reasonable production
> kernel, and has helped me to catch typos.

I believe the function doesn't work well.

static void
rcu_torture_stats_print(void)
{
	int size = nr_cpu_ids * 200 + 8192;
	char *buf;

	buf = kmalloc(size, GFP_KERNEL);
	if (!buf) {
		pr_err("rcu-torture: Out of memory, need: %d\n", size);
		return;
	}
	rcu_torture_printk(buf);
	pr_alert("%s", buf);
	kfree(buf);
}

rcu_torture_printk simply fills buf

btw: I believe the arguments should pass size and
     rcu_torture_printk should use snprintf/size

but all printks are limited to a maximum of 1024
bytes so the large allocation is senseless and
would even if it worked, would likely need to be
vmalloc/vfree



