Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3L0TRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:17:11 -0500
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:36162 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754358Ab3L0TRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:17:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2892:2899:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3874:4250:4321:5007:6119:7652:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12114:12517:12519:12740:13069:13138:13146:13161:13229:13230:13231:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lead45_7850c710c3644
X-Filterd-Recvd-Size: 2441
Message-ID: <1388171825.30298.14.camel@joe-AO722>
Subject: Re: [PATCH] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>
Date: Fri, 27 Dec 2013 11:17:05 -0800
In-Reply-To: <1388171427.26981.77.camel@deadeye.wl.decadent.org.uk>
References: <1388164698.26981.73.camel@deadeye.wl.decadent.org.uk>
	 <20131227184740.GA5180@kroah.com>
	 <1388171427.26981.77.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-27 at 20:10 +0100, Ben Hutchings wrote:
> On Fri, 2013-12-27 at 10:47 -0800, Greg Kroah-Hartman wrote:
> > On Fri, Dec 27, 2013 at 06:18:18PM +0100, Ben Hutchings wrote:
> > > snprintf() returns the number of bytes that could have been written
> > > (excluding the null), not the actual number of bytes written.  Given a
> > > long enough subsystem or device name, these functions will advance
> > > beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
> > > in an information leak or stack corruption.  I don't know whether such
> > > a long name is currently possible.
> > > 
> > > In case snprintf() returns a value >= the buffer size, do not add
> > > structured logging information.  Also WARN the first time this
> > > happens, so we can fix the driver or increase the buffer size.
[]
> > > diff --git a/drivers/base/core.c b/drivers/base/core.c
[]
> > > +overflow:
> > > +	dev_WARN_ONCE(dev, 1, "device/subsystem name too long");
> > 
> > Why only warn once?  Any device/subsystem mix should be complained
> > about, if for only that we should be really annoying about it to get it
> > resolved.
> 
> This would expand the volume of logging for the problem device by a
> factor of ~50 so it doesn't seem like a good failure mode.

There are at least 6 bits on struct device unused.
Maybe add another bool bit field to struct device?

	bool			offline_disabled:1;
	bool			offline:1;


