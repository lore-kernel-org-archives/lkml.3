Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaESWc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:32:27 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:46429 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751576AbaESWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:32:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2892:2903:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mass88_6c2c469f48624
X-Filterd-Recvd-Size: 2429
Message-ID: <1400538742.14238.51.camel@joe-AO725>
Subject: Re: [PATCH driver-core-linus] sysfs: make sure read buffer is zeroed
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, Ron <ron@debian.org>,
        Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 19 May 2014 15:32:22 -0700
In-Reply-To: <20140519222500.GA14616@kroah.com>
References: <20140519172334.GK20439@audi.shelbyville.oz>
	 <20140519195210.GA27506@mtj.dyndns.org> <20140519222500.GA14616@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 15:25 -0700, Greg Kroah-Hartman wrote:
> On Mon, May 19, 2014 at 03:52:10PM -0400, Tejun Heo wrote:
> > 13c589d5b0ac ("sysfs: use seq_file when reading regular files")
> > switched sysfs from custom read implementation to seq_file to enable
> > later transition to kernfs.  After the change, the buffer passed to
> > ->show() is acquired through seq_get_buf(); unfortunately, this
> > introduces a subtle behavior change.  Before the commit, the buffer
> > passed to ->show() was always zero as it was allocated using
> > get_zeroed_page().  Because seq_file doesn't clear buffers on
> > allocation and neither does seq_get_buf(), after the commit, depending
> > on the behavior of ->show(), we may end up exposing uninitialized data
> > to userland thus possibly altering userland visible behavior and
> > leaking information.
> > 
> > Fix it by explicitly clearing the buffer.
[]
> > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
[]
> > @@ -47,12 +47,13 @@ static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
> >  	ssize_t count;
> >  	char *buf;
> >  
> > -	/* acquire buffer and ensure that it's >= PAGE_SIZE */
> > +	/* acquire buffer and ensure that it's >= PAGE_SIZE and clear */
> >  	count = seq_get_buf(sf, &buf);
> >  	if (count < PAGE_SIZE) {
> >  		seq_commit(sf, -1);
> >  		return 0;
> >  	}
> > +	memset(buf, 0, PAGE_SIZE);

	memset(buf, 0, count)?

> Thanks, I'll go queue this up.


