Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaJNTNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:13:46 -0400
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:60225 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754241AbaJNTNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:13:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3873:4250:4321:4605:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13018:13019:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass98_32c4e051f803
X-Filterd-Recvd-Size: 2769
Message-ID: <1413314020.26864.7.camel@joe-AO725>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Joe Perches <joe@perches.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 14 Oct 2014 12:13:40 -0700
In-Reply-To: <20141014184702.GA12662@arch.hh.imgtec.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <20141014143902.GA9768@arch.hh.imgtec.org>
	 <1413299343.7906.103.camel@sauron.fi.intel.com>
	 <20141014184702.GA12662@arch.hh.imgtec.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 15:47 -0300, Ezequiel Garcia wrote:
> On 14 Oct 06:09 PM, Artem Bityutskiy wrote:
> > On Tue, 2014-10-14 at 11:39 -0300, Ezequiel Garcia wrote:
> > > Please use some pr_fmt for this. Something like this before the headers
> > > should be enough:
> > > 
> > > #define pr_fmt(fmt) "UBI: block:" fmt
> > 
> > Sinc ubiblock is a device, there should be a 'struct device' somewhere,
> > so probably dev_printk() and other dev_*() printing functions would be a
> > better choice?
> > 
> 
> A quick code dig shows you should get the struct device associated
> to the struct gendisk, with the disk_to_dev() macro.
> 
> In other words, something like this should work, provided 'dev' is defined
> in the scope as a struct ubiblock:
> 
>   #define ubiblock_err(x) dev_err(disk_to_dev(dev->gd), x)
> 
> When the gendisk is not available, a simple pr_{} would work.

Or maybe combine these in the ubi_<level> calls passing
NULL when there is no struct ubi_device *

void ubi_err(const struct ubi_device *ubi, fmt. ...)
{
	struct va_format vaf;
	va_list args;

	va_start(args, fmt);

	vaf.fmt = fmt;
	vaf.va = &args;

	if (ubi && ubi->gd)
		dev_err(disk_to_dev(dev->gd), "UBI-%d error: %pF %pV",
			ubi->ubi_num, __builtin_return_address(0), &vaf);
	else if (ubi)
		printk(KERN_ERR "UBI-%d error: %pf: %pV",
		       ubi->ubi_num, __builtin_return_address(0), &vaf);
	else
		printk(KERN_ERR "UBI: error: %pf: %pV",
		       __builtin_return_address(0), &vaf);

	va_end(args);
}




