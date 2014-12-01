Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaLAIny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:43:54 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:32880 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbaLAInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:43:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,492,1413237600"; 
   d="scan'208";a="110399131"
Date: Mon, 1 Dec 2014 09:43:50 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Julia Lawall <julia.lawall@lip6.fr>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after
 error detection
In-Reply-To: <20141201065221.GA4994@mwanda>
Message-ID: <alpine.DEB.2.02.1412010942270.2036@localhost6.localdomain6>
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5467B12C.4010602@users.sourceforge.net>
 <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6> <54796B5E.5040707@users.sourceforge.net> <87sih22sn8.fsf@devron.myhome.or.jp> <alpine.DEB.2.10.1411291338530.2378@hadrien> <87lhmu2jl8.fsf@devron.myhome.or.jp> <20141201065221.GA4994@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Dec 2014, Dan Carpenter wrote:

> On Sat, Nov 29, 2014 at 10:59:47PM +0900, OGAWA Hirofumi wrote:
> > Julia Lawall <julia.lawall@lip6.fr> writes:
> > 
> > >> iput() checks NULL of inode. What is wrong just remove NULL check,
> > >> instead of adding new jump labels?
> > >
> > > Personally, I prefer that code that can be statically determined not to
> > > need to be executed not to be executed.  It can make the code easier to
> > > understand, because each function is only called when doing so is useful,
> > > and it can be helpful to static analysis.
> > 
> > Hm, first of all, we want to prevent the bugs. More labels are more
> > chances of bug (and we don't care micro optimize on this error path),
> > isn't it?  Increasing the chance of bugs and bothers developers for
> > analyzer sounds like strange.
> 
> Oh wow!  Absolutely not.  "One Err Bugs" are one of the most common
> kinds of bugs we have in the kernel.  This is where you have just one
> error label and the bugs look like this:
> 
> err:
> 	kfree(foo->bar);
> 	kfree(foo);
> 
> but foo is NULL.  Mixing the error paths together it always creates
> confusion.  I fix so many of these bugs...  We get a few new ones every
> week.

Just for concreteness, from drivers/clk/st/clkgen-mux.c (- indicates 
lines of interest, not lines to remove):

@@ -722,7 +722,6 @@ void __init st_of_clkgen_vcc_setup(struc
                return;

        clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
-       if (!clk_data)
                goto err;

        clk_data->clk_num = VCC_MAX_CHANNELS;
@@ -808,7 +807,6 @@ void __init st_of_clkgen_vcc_setup(struc
        return;

 err:
-       for (i = 0; i < clk_data->clk_num; i++) {
                struct clk_composite *composite;

                if (!clk_data->clks[i])

julia
