Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaJPRx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:53:58 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:37590 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751309AbaJPRx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:53:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2903:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:3874:4250:4321:4605:5007:6261:6742:7903:9010:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12663:12740:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoes18_4322801a4138
X-Filterd-Recvd-Size: 3691
Message-ID: <1413482027.8915.1.camel@perches.com>
Subject: Re: [PATCH 3v] char: hw_random: core.c: Changed from using strncat
 to strlcat
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Jason Cooper <jason@lakedaemon.net>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Oct 2014 10:53:47 -0700
In-Reply-To: <CAFo99gbGrGXz+gYQn0hAPKxN73BLLWhaUPVN0DVq6-3PiFzOSw@mail.gmail.com>
References: <1413479722-29247-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1413480303.6702.7.camel@perches.com>
	 <CAFo99gbGrGXz+gYQn0hAPKxN73BLLWhaUPVN0DVq6-3PiFzOSw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 19:41 +0200, Rickard Strandqvist wrote:
> 2014-10-16 19:25 GMT+02:00 Joe Perches <joe@perches.com>:
> > On Thu, 2014-10-16 at 19:15 +0200, Rickard Strandqvist wrote:
> >> The buf is used to hold the list of hwrng devices registered.
> >> The old code ensures we don't walk off the end of buf as we
> >> fill it, but it's unnecessarily complicated and thus difficult
> >> to maintain. Simplify it by using strlcat.
> >> We also ensure the string within buf is NULL terminated
> >> so the final strlen is ok.
> > []
> >> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > []
> >> @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> >>               return -ERESTARTSYS;
> >>       buf[0] = '\0';
> >>       list_for_each_entry(rng, &rng_list, list) {
> >> -             strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> >> -             ret += strlen(rng->name);
> >> -             strncat(buf, " ", PAGE_SIZE - ret - 1);
> >> -             ret++;
> >> +             strlcat(buf, rng->name, PAGE_SIZE);
> >> +             strlcat(buf, " ", PAGE_SIZE);
> >>       }
> >> -     strncat(buf, "\n", PAGE_SIZE - ret - 1);
> >> -     ret++;
> >> +     strlcat(buf, "\n", PAGE_SIZE);
> >>       mutex_unlock(&rng_mutex);
> >>
> >> -     return ret;
> >> +     return strlen(buf);
> >>  }
> >>
> >>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> >
> > Rickard, can you please use some optimizations here
> > (and elsewhere) so that strlcat doesn't always have
> > to strlen the first string and the return doesn't
> > have to do the strlen too?
> >
> > You could use a temporary for the returned length
> > of the strlcat so that if it's shorter than
> > the buffer, the next strlcat can start at the
> > appropriate known position instead of having
> > to do the initial strlen again and again.
[]
> But the others, I am very hesitant about. Because strlcat like
> snprintf and strlcpy returns the length that would be copied rather
> than what is actually copied. Hence such a code to be even more
> complex than before.

None of the conversions you've done seem to use the
return value so maybe there should be yet another
function that doesn't return an overrun value.


