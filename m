Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaJPSFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:05:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15011 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaJPSFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:05:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19bHzd5zPK2eva3LS+/TbzPWsF0vA0QfAY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7A043600913
Date: Thu, 16 Oct 2014 14:05:17 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Joe Perches <joe@perches.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Torsten Duwe <duwe@lst.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3v] char: hw_random: core.c:  Changed from using
 strncat to strlcat
Message-ID: <20141016180517.GO17447@titan.lakedaemon.net>
References: <1413479722-29247-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1413480303.6702.7.camel@perches.com>
 <20141016174823.GM17447@titan.lakedaemon.net>
 <1413482157.8915.3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413482157.8915.3.camel@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:55:57AM -0700, Joe Perches wrote:
> On Thu, 2014-10-16 at 13:48 -0400, Jason Cooper wrote:
> > On Thu, Oct 16, 2014 at 10:25:03AM -0700, Joe Perches wrote:
> > > On Thu, 2014-10-16 at 19:15 +0200, Rickard Strandqvist wrote:
> > > > The buf is used to hold the list of hwrng devices registered.
> > > > The old code ensures we don't walk off the end of buf as we
> > > > fill it, but it's unnecessarily complicated and thus difficult
> > > > to maintain. Simplify it by using strlcat.
> > > > We also ensure the string within buf is NULL terminated
> > > > so the final strlen is ok.
> > > []
> > > > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > > []
> > > > @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> > > >  		return -ERESTARTSYS;
> > > >  	buf[0] = '\0';
> > > >  	list_for_each_entry(rng, &rng_list, list) {
> > > > -		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> > > > -		ret += strlen(rng->name);
> > > > -		strncat(buf, " ", PAGE_SIZE - ret - 1);
> > > > -		ret++;
> > > > +		strlcat(buf, rng->name, PAGE_SIZE);
> > > > +		strlcat(buf, " ", PAGE_SIZE);
> > > >  	}
> > > > -	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> > > > -	ret++;
> > > > +	strlcat(buf, "\n", PAGE_SIZE);
> > > >  	mutex_unlock(&rng_mutex);
> > > >  
> > > > -	return ret;
> > > > +	return strlen(buf);
> > > >  }
> > > >  
> > > >  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> > > 
> > > Rickard, can you please use some optimizations here
> > > (and elsewhere) so that strlcat doesn't always have
> > > to strlen the first string and the return doesn't
> > > have to do the strlen too?
> > 
> > Joe, is further optimization worth the effort?  This function is only
> > called when the end user reads the sysfs file rng_available...
> 
> It's unlikely that it matters much here.
> 
> I just don't like the repeated and unnecessary strlen.
> 
> I do imagine this pattern being repeated though where
> it does matter.

Agreed.  Back to why I like to see descriptions from the author
demonstrating they grok the code they are changing :)

thx,

Jason.
