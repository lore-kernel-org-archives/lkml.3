Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaJNTUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:20:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56430 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754524AbaJNTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:20:19 -0400
Date: Tue, 14 Oct 2014 16:18:15 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Joe Perches <joe@perches.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
Message-ID: <20141014191815.GB12662@arch.hh.imgtec.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
 <20141014143902.GA9768@arch.hh.imgtec.org>
 <1413299343.7906.103.camel@sauron.fi.intel.com>
 <20141014184702.GA12662@arch.hh.imgtec.org>
 <1413314020.26864.7.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413314020.26864.7.camel@joe-AO725>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Oct 12:13 PM, Joe Perches wrote:
> On Tue, 2014-10-14 at 15:47 -0300, Ezequiel Garcia wrote:
> > On 14 Oct 06:09 PM, Artem Bityutskiy wrote:
> > > On Tue, 2014-10-14 at 11:39 -0300, Ezequiel Garcia wrote:
> > > > Please use some pr_fmt for this. Something like this before the headers
> > > > should be enough:
> > > > 
> > > > #define pr_fmt(fmt) "UBI: block:" fmt
> > > 
> > > Sinc ubiblock is a device, there should be a 'struct device' somewhere,
> > > so probably dev_printk() and other dev_*() printing functions would be a
> > > better choice?
> > > 
> > 
> > A quick code dig shows you should get the struct device associated
> > to the struct gendisk, with the disk_to_dev() macro.
> > 
> > In other words, something like this should work, provided 'dev' is defined
> > in the scope as a struct ubiblock:
> > 
> >   #define ubiblock_err(x) dev_err(disk_to_dev(dev->gd), x)
> > 
> > When the gendisk is not available, a simple pr_{} would work.
> 
> Or maybe combine these in the ubi_<level> calls passing
> NULL when there is no struct ubi_device *
> 
> void ubi_err(const struct ubi_device *ubi, fmt. ...)
> {
> 	struct va_format vaf;
> 	va_list args;
> 
> 	va_start(args, fmt);
> 
> 	vaf.fmt = fmt;
> 	vaf.va = &args;
> 
> 	if (ubi && ubi->gd)
> 		dev_err(disk_to_dev(dev->gd), "UBI-%d error: %pF %pV",
> 			ubi->ubi_num, __builtin_return_address(0), &vaf);
> 	else if (ubi)
> 		printk(KERN_ERR "UBI-%d error: %pf: %pV",
> 		       ubi->ubi_num, __builtin_return_address(0), &vaf);
> 	else
> 		printk(KERN_ERR "UBI: error: %pf: %pV",
> 		       __builtin_return_address(0), &vaf);
> 
> 	va_end(args);
> }
> 

Isn't this excessive obfuscation? What's the benefit of it?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
