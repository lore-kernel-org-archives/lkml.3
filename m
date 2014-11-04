Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaKDAid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:38:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36445 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaKDAi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:38:29 -0500
Date: Mon, 3 Nov 2014 18:38:27 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141104003827.GA24005@ti.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <CACRpkdak3EACNpgEznN85d7gPHsMOBW+Ondwx23XhLaVEdjo8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdak3EACNpgEznN85d7gPHsMOBW+Ondwx23XhLaVEdjo8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Thanks for the feedback.

To summarize the hog feature should be local to gpiolib-of.c, correct?

I also also need some clarifications, see below.


Linus Walleij <linus.walleij@linaro.org> wrote on Mon [2014-Nov-03 10:59:53 +0100]:
> On Tue, Oct 21, 2014 at 10:09 PM, Benoit Parrot <bparrot@ti.com> wrote:
> 
> >         qe_pio_a: gpio-controller@1400 {
> > @@ -110,6 +130,19 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
> >                 reg = <0x1400 0x18>;
> >                 gpio-controller;
> >                 #gpio-cells = <2>;
> > +               gpio-hogs = <&line_b>;
> > +
> > +               /* line_a hog is defined but not enabled in this example*/
> > +               line_a: line_a {
> > +                       gpios = <5 0>;
> > +                       input;
> > +               };
> > +
> > +               line_b: line_b {
> > +                       gpios = <6 0>;
> > +                       output-low;
> > +                       line-name = "foo-bar-gpio";
> > +               };
> 
> 
> I don't see the point of having unused hogs and enabling them using
> phandles.
> 
> Just let the core walk over all children nodes of a GPIO controller
> and hog them. Put in a bool property saying it's a hog.
> 
> +               line_b: line_b {
> +                       gpio-hog;
> +                       gpios = <6 0>;
> +                       output-low;
> +                       line-name = "foo-bar-gpio";
> +               };
> 
> I don't quite see the point with input hogs that noone can use
> but whatever.
> 
> I am thinking that maybe the line name should be compulsory
> so as to improbe readability. I mean there is always a reason
> why you're hogging a pin and the name should say it.

Ok, so as an alternative I had presented something like this in my reply
to Alexandre Courbot's review comments:

  I did consider a "pinmux" flavored format (not sure how hard to parse it would be).
  It would allow grouping if nothing else.

  	/* Line syntax: line_name <gpio# flags> direction-value [export] */
	gpio-hogs = <&group_y>;

	group_y: group_y {
		gpio-hogs-group = <
			line_x <15 0> output-low
			line_y <16 0> output-high export
			line_z <17 0> input
		>;
	};

Now based on your comment would something like this work?

     qe_pio_a: gpio-controller@1400 {
	reg = <0x1400 0x18>;
	gpio-controller;
	#gpio-cells = <2>;

  	/* Line syntax: line_name <gpio# flags> direction-value [export] */
	gpio-hogs: {
		gpio-hogs-group = <
			foo-bar-gpio <15 0> output-low
			bar-foo-gpio <16 0> output-high export
		>;
	};
     };

This would group all hogs for one controller under a single child node.
Again I am not sure how feasible or easy to implement the DT parsing would be. 

I guess for completeness if you could also comment on my reply to Alexandre from Oct 29th,
that would be great, before I head in the wrong directions. 

Regards,
Benoit
