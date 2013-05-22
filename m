Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3EVJuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:50:39 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27050 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab3EVJue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:50:34 -0400
Date: Wed, 22 May 2013 11:49:59 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
Message-ID: <20130522094958.GA4789@ab42.lan>
References: <CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
 <20130429161725.GB30136@ab42.lan>
 <5182B557.4040804@wwwdotorg.org>
 <CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
 <20130508164123.GA10248@ab42.lan>
 <518AAF31.8080502@wwwdotorg.org>
 <20130510082521.GA2125@ab42.lan>
 <CACRpkdbkqzyr0r0CostUx9RYa=pyPoyVvvW+VxEzyAYSESxp_g@mail.gmail.com>
 <20130515094146.GA19925@ab42.lan>
 <CACRpkdY2R9uf0s6LGVCSPZmdNTDQV4RT65SuxCR_+hQ2eK90Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdY2R9uf0s6LGVCSPZmdNTDQV4RT65SuxCR_+hQ2eK90Yg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:03:24AM +0200, Linus Walleij wrote:
> On Wed, May 15, 2013 at 11:41 AM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> > On Tue, May 14, 2013 at 02:29:46PM +0200, Linus Walleij wrote:
> 
> >> Look at for example
> >> drivers/pinctrl/pinctrl-abx500.c:
> >>
> >> static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
> >>                           unsigned gpio)
> >> {
> >> (...)
> >>         /* on ABx5xx, there is no GPIO0, so adjust the offset */
> >>         unsigned offset = gpio - 1;
> >>
> >> As you can see, this driver, which does not use device tree,
> >> is working around the same problem. Here the problem is that
> >> the pins are numbered starting at 1 instead of 0, a very trivial
> >> numberspace shuffleing.
> >
> > Let me see if I understand this right:
> > In ABx5xx, the pin numbering is offset by 1 wrt. GPIO numbering?
> 
> No, sorry that the code is strange... The variable is named "gpio"
> because that is the numbering used in the data sheet.
> 
> Think of "gpio" as "the number in the data sheet".
> 
> Then offset is calculated to start from 0.

OK, seems like I thoroughly misunderstood what you were saying and drew
some wrong conclusions from that. In order to avoid confusion I'll
delete everything related to this misunderstanding below.

> [...]
> If you mean that you try to map the global GPIO number space
> 1:1 on top of what your datasheet has, just *don't do that*.
> Because we want to get rid of this global GPIO numberspace.
> Alexandre is already working hard on this!

Thanks for the hint. Defining a global GPIO number space in the data
sheet was one of our ideas but I agree it would be preferable to do away
with this completely and rather deal with GPIOs on a bank level.

> >  - The custom logic inside many pinctrl drivers would be confined in one
> >    translation function the driver provides instead of being spread out
> >    all over the driver.
> >  - "Sparse GPIO ranges" are easy to implement if required by the
> >    platform/driver.
> 
> This looks good.

I think these advantages could be maintained through two alternative
methods:
1) Extend the GPIO ranges mechanism to allow for pin groups in addition
   to contiguous pin ranges. This would be my preferred method since no
   pin numbers are exposed to the user at all (neither kernel internal
   nor physical). All pin numbering remains inside the driver. This
   would be a clean version of what I did in the original patch.
2) Add a physical-to-Linux-internal pin number translation callback to
   the pinmux driver core interface. Map 1-to-1 if this callback is not
   defined to maintain backwards compatibility. I don't like this
   solution as much as 1) for the following reasons:
     . It adds yet another number space to confuse things even more.
     . Managing contiguous ranges becomes more difficult because ranges
       contiguous in one number space (physical pins, Linux pins, GPIOs)
       are not necessarily contiguous in the others, requiring more
       complex translation mechanisms.
     . Some chips have matrix like number schemes (A1, A2, ..., B1, B1,
       ...) etc. which cannot be directly addressed with this and would
       need to introduce yet another layer of indirection.
     . In cases where different package options need to be supported, a
       translation table is required for each inside the driver. For
       modern SOCs, each of these tables can easily be a few kB in size
       and I don't know if we want to add that amount of static data to
       the kernel, esp. because all but one of the tables are unused.

I don't know ACPI and one of the two solutions might not be applicable
there.

> [...]
> We need to iterate this discussion a few turns until I actually
> understand your problem I think.

I agree. Let me resume my high level constraints again:
- Align customer visible interfaces (such as device tree and
  sys/class/gpio) with our hardware documentation.
- Documentation can be augmented (e.g. a global GPIO number space
  _could_ be added) but fundamentals (such as physical pin numbering,
  our GPIO bank structure) must not be changed.
- Several distinct naming schemes for the same thing (such as pins) are
  only allowed if it is obvious to which naming scheme a given name
  belongs. E.g. pins may have both a name (string) and a number (and
  they actually have) but it is not allowed to have two different
  numbers designating the same pin.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
