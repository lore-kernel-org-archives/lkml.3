Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3BKPHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:07:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40261 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3BKPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:07:21 -0500
Date: Mon, 11 Feb 2013 15:07:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
Message-ID: <20130211150709.GL17833@n2100.arm.linux.org.uk>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de> <CAOh2x=ne_Oe7V=BzjQJtuPv20syorLTq-C89aKQDo4JK78Y8YA@mail.gmail.com> <20130209135202.C8EA73E30EC@localhost> <CACRpkdaxxn9nWKjFF=XD5F2kus69-8uxqPWA1vt1RJ0aGJ-Mvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaxxn9nWKjFF=XD5F2kus69-8uxqPWA1vt1RJ0aGJ-Mvw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 02:53:47PM +0100, Linus Walleij wrote:
> NB: among the error codes people want to propagate from
> consumer interfaces such as say, clk_get(), regulator_get()
> and pinctrl_get() is -EPROBE_DEFER. So just "something
> failed" (return NULL) isn't enough.
> 
> We then obviously need to return an int as error code instead
> and pass the pointer as argument, so do you mean we should
> refactor all the *_get() things from e.g.:
> 
> struct clk *clk_get(struct device *dev, const char *id);
> 
> into something like:
> 
> int clk_get(struct clk **clk, struct device *dev, const char *id);
> 
> across the entire kernel?

I really don't want to do that.  What we have today I think is far
better than having to munge things like that - you just get a different
set of problems through doing that, such as what happens if people
ignore the returned error code, etc.

We _should_ really be able to get Sparse to deal with this.  Sparse
really should be taught about a pointer attribute that says "this is
fine to dereference, but it should also have the magic IS_ERR() check
done on it too."  As IS_ERR() is a function, we can surely mark the
passed pointer in some way to tell sparse "this has been appropraitely
checked".

Practically, we don't end up with that many problems though with people
failing to check the returned pointer (I've seen relatively few of these
in the bigger scheme of things).  What I have seen through is repeated
confusion between IS_ERR() and IS_ERR_OR_NULL() since the second one was
introduced - which then leads people into coding their error paths such
that they return zero should NULL be returned.

I've said before - almost every usage of IS_ERR_OR_NULL() appears to be
a bug... and I've been mooting its removal.  I have acks against a patch
which deprecates it - but we can't deprecate it until we've removed most
of the existing users of it (otherwise akpm will hunt down those who
added the deprecated marker.)
