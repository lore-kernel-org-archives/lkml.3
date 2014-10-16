Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaJPR4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:56:04 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:59090 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751433AbaJPR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:56:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2903:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:3874:4250:4321:5007:6261:6742:7903:8526:9010:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quilt03_1706fdc6ae238
X-Filterd-Recvd-Size: 3201
Message-ID: <1413482157.8915.3.camel@perches.com>
Subject: Re: [PATCH 3v] char: hw_random: core.c:  Changed from using strncat
 to strlcat
From: Joe Perches <joe@perches.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Torsten Duwe <duwe@lst.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 10:55:57 -0700
In-Reply-To: <20141016174823.GM17447@titan.lakedaemon.net>
References: <1413479722-29247-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1413480303.6702.7.camel@perches.com>
	 <20141016174823.GM17447@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 13:48 -0400, Jason Cooper wrote:
> On Thu, Oct 16, 2014 at 10:25:03AM -0700, Joe Perches wrote:
> > On Thu, 2014-10-16 at 19:15 +0200, Rickard Strandqvist wrote:
> > > The buf is used to hold the list of hwrng devices registered.
> > > The old code ensures we don't walk off the end of buf as we
> > > fill it, but it's unnecessarily complicated and thus difficult
> > > to maintain. Simplify it by using strlcat.
> > > We also ensure the string within buf is NULL terminated
> > > so the final strlen is ok.
> > []
> > > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > []
> > > @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> > >  		return -ERESTARTSYS;
> > >  	buf[0] = '\0';
> > >  	list_for_each_entry(rng, &rng_list, list) {
> > > -		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> > > -		ret += strlen(rng->name);
> > > -		strncat(buf, " ", PAGE_SIZE - ret - 1);
> > > -		ret++;
> > > +		strlcat(buf, rng->name, PAGE_SIZE);
> > > +		strlcat(buf, " ", PAGE_SIZE);
> > >  	}
> > > -	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> > > -	ret++;
> > > +	strlcat(buf, "\n", PAGE_SIZE);
> > >  	mutex_unlock(&rng_mutex);
> > >  
> > > -	return ret;
> > > +	return strlen(buf);
> > >  }
> > >  
> > >  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> > 
> > Rickard, can you please use some optimizations here
> > (and elsewhere) so that strlcat doesn't always have
> > to strlen the first string and the return doesn't
> > have to do the strlen too?
> 
> Joe, is further optimization worth the effort?  This function is only
> called when the end user reads the sysfs file rng_available...

It's unlikely that it matters much here.

I just don't like the repeated and unnecessary strlen.

I do imagine this pattern being repeated though where
it does matter.

