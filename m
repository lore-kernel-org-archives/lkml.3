Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJOO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:57:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61280 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaJOO5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:57:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9BQuaDw6612c8Bqf4n7O8qjKelY1tuqA=
X-DKIM: OpenDKIM Filter v2.0.1 titan D7D7B5FF604
Date: Wed, 15 Oct 2014 10:57:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] char: hw_random: core.c: Changed from using strncat
 to strlcat
Message-ID: <20141015145709.GC17447@titan.lakedaemon.net>
References: <1413110971-17392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141012192209.GC14147@titan.lakedaemon.net>
 <CAFo99gamwyykRnV0nwQpjp41fJSETKik1e2CVwnHX0DXzOdhzA@mail.gmail.com>
 <20141014153606.GA17447@titan.lakedaemon.net>
 <CAFo99gZNGi-P6Uisgba1EA38xrQoRcr2RV5xkvvoC_dbyHVxjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gZNGi-P6Uisgba1EA38xrQoRcr2RV5xkvvoC_dbyHVxjw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 11:11:28PM +0200, Rickard Strandqvist wrote:
> 2014-10-14 17:36 GMT+02:00 Jason Cooper <jason@lakedaemon.net>:
> > On Mon, Oct 13, 2014 at 11:20:35PM +0200, Rickard Strandqvist wrote:
> >> 2014-10-12 21:22 GMT+02:00 Jason Cooper <jason@lakedaemon.net>:
> >> > Rickard,
> >> >
> >> > On Sun, Oct 12, 2014 at 12:49:31PM +0200, Rickard Strandqvist wrote:
> >> >> Changed from using strncat to strlcat to simplify the code
> >> >
> >> > I'd like to see a little more explicit discussion here.  As Guenter got
> >> > caught up in the mis-understanding, I doubt he'd be the only one.  I
> >> > think it's worth spelling out that the old code prevents overflowing the
> >> > buffer 'buf' of size PAGE_SIZE.  And that strlcat() does that internally
> >> > allowing this code to be more readable.
> >> >
> >> > It should also be mentioned that the final strlen(buf) is safe because
> >> > every operation on buf will insert a NULL terminator within the
> >> > buffers limit.
> >> >
> >> > thx,
> >> >
> >> > Jason.
> >> >
> >> >> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> >> >> ---
> >
> > [1]
> >
> >> >>  drivers/char/hw_random/core.c |   12 ++++--------
> >> >>  1 file changed, 4 insertions(+), 8 deletions(-)
> >> >>
> >> >> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> >> >> index aa30a25..1500cfd 100644
> >> >> --- a/drivers/char/hw_random/core.c
> >> >> +++ b/drivers/char/hw_random/core.c
> >> >> @@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> >> >>                                        char *buf)
> >> >>  {
> >> >>       int err;
> >> >> -     ssize_t ret = 0;
> >> >>       struct hwrng *rng;
> >> >>
> >> >>       err = mutex_lock_interruptible(&rng_mutex);
> >> >> @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> >> >>               return -ERESTARTSYS;
> >> >>       buf[0] = '\0';
> >> >>       list_for_each_entry(rng, &rng_list, list) {
> >> >> -             strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> >> >> -             ret += strlen(rng->name);
> >> >> -             strncat(buf, " ", PAGE_SIZE - ret - 1);
> >> >> -             ret++;
> >> >> +             strlcat(buf, rng->name, PAGE_SIZE);
> >> >> +             strlcat(buf, " ", PAGE_SIZE);
> >> >>       }
> >> >> -     strncat(buf, "\n", PAGE_SIZE - ret - 1);
> >> >> -     ret++;
> >> >> +     strlcat(buf, "\n", PAGE_SIZE);
> >> >>       mutex_unlock(&rng_mutex);
> >> >>
> >> >> -     return ret;
> >> >> +     return strlen(buf);
> >> >>  }
> >> >>
> >> >>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> >> >> --
> >> >> 1.7.10.4
> >>
> >>
> >> Hi
> >>
> >> Do not know if I understand this right, you want to explain strlcat
> >> function better then ..?
> >
> > I want to see that the submitter of the patch has thought this through
> > and isn't just blindly doing s/strn/strl/g and some cleanup.
> >
> > Please keep in mind that the kernel community is *huge* and no one
> > person can see everything going on.  The type of fixes and cleanup
> > you're doing crosses many sub-systems.  As a result, you haven't popped
> > up on anyones radar as a regular contributor within a sub-system yet.
> >
> > iow, I didn't have the thought in my head "Rickard, yeah, he's the guy
> > doing the cppcheck and strn/l cleanup properly" because none of your
> > patches have crossed my inbox until now.
> >
> >> But while I think this is something you have to learn, rather than
> >> typing it in git comment.
> >
> > Wether it's appropriate for the git comment or not is debatable, I'll
> > agree.  The point I'm trying to make is that reviewers aren't
> > super-human.  All I saw at first is a patch from someone I don't know
> > changing buffer handling in crypto/rng code.  I had no indication in the
> > email as to how carefully this had been done.  I'll call that out every
> > time. :)
> >
> > A short explanation, here [1], would have let first-time reviewers of
> > your patches know that you had taken the time to grok the code and
> > wasn't blindly fulfilling a eudyptula challenge or similar.
> 
> 
> Hi Jason!
> 
> Thanks for your response.
> Yes, I've done patches all over in Kernel. And the response is
> different everywhere, and this was the first time I got this response
> :-)
> 
> But sure! You mean I should put this in git comment, or just that it
> should have been included as a cover letter?

If it's a series, the cover letter is fine.  For single patches, after
the '---' works.  For more complicated patches, it's best to put it in
the commit message.

> How about adding this line.
> "By using strlcat it is much easier to ensure that you do not write
> past the maximum string length, which could simplify this code a bit."

That defines strlcat, which as you said previously, is obvious.  I was
more looking for:

"buf is used to hold the list of hwrng devices registered.  The old code
ensures we don't walk off the end of buf as we fill it, but it's
unnecessarily complicated and thus difficult to maintain.  Simplify it
by using strlcat.  We also ensure the string within buf is NULL
terminated so the final strlen is ok."

thx,

Jason.
