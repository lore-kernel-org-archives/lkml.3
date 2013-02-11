Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3BKPlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:41:06 -0500
Received: from linux-sh.org ([111.68.239.195]:60032 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3BKPlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:41:04 -0500
Date: Tue, 12 Feb 2013 00:40:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
Message-ID: <20130211154028.GB6088@linux-sh.org>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
 <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com>
 <CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com>
 <20130209091729.978C73E1A18@localhost>
 <CACRpkdagLssOG3FW8Qr1zqFabGMgdupADwg1=c0eQ7e76_XM5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdagLssOG3FW8Qr1zqFabGMgdupADwg1=c0eQ7e76_XM5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 03:09:21PM +0100, Linus Walleij wrote:
> On Sat, Feb 9, 2013 at 10:17 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > The ERR_PTR()/IS_ERR() is a horrible pattern for code
> > readability because it breaks the expectations that programmers have for
> > what is and is not a bad pointer. There are decades of history where the
> > test for a bad pointer is 'if (!ptr)'. Not only does ERR_PTR make make
> > that test not work, but the compiler won't tell you when you get it
> > wrong.
> >
> > There are places where ERR_PTR makes sense. Particularly when
> > communicating with userspace where error codes have very specific
> > meanings, but I don't want it in the GPIO subsystem.
> 
> OK I disagree but you get to decide.
> 
> However if you take this all the way to the descriptor API
> it will make the consumer (driver) API for GPIO descriptors deviate
> from what is today used for clocks, regulators and pins.
> 
> With all the resulting confusion for users.
> I've seen worse subsystem deviations though.
> 
I've always considered it to be more of a complexity issue. If an
interface can fail for half a dozen different reasons, it's useful to be
able to encapsulate this and pass it down the line to the consumer
(particularly in cases where no useful debug output is provided, and the
first thing someone is going to do is go and instrument the registration
path with printks to figure out where things went wrong). In the case
where the work to do is relatively straightforward and there's not much
complexity, NULL is clearly the way to go.

There are already quite a few cases today converting NULLs over to
arbitrary ERR_PTR values or IS_ERR cases wrapping back to NULL, so it's
clear that both have to be supported interacting with one another
regardless. Then there's that whole IS_ERR_OR_NULL case which everyone
seems to get wrong, but that's another issue entirely.
