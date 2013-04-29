Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3D2QSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:18:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:22830 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab3D2QSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:18:04 -0400
Date: Mon, 29 Apr 2013 18:17:27 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice CHOTARD <patrice.chotard@st.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
Message-ID: <20130429161725.GB30136@ab42.lan>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
 <516EEAA0.10906@wwwdotorg.org>
 <20130418090310.GA17636@ab42.lan>
 <CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Fri, Apr 26, 2013 at 09:47:16AM +0200, Linus Walleij wrote:
> On Thu, Apr 18, 2013 at 11:03 AM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> 
> > We would like to avoid the use of Linux pin numbers in the device tree.
> > Customers are used to physical pin numbers and exposing the logical
> > Linux-internal numbering scheme through the device tree would generate
> > quite some confusion. There are two reasons why we cannot align the two:
> >   - Not all products supported by these drivers have the same pin outs.
> >   - GPIO ranges must be consecutive in the Linux pin numbering space
> >     which is generally not the case in physical pin numbering.
> 
> If you are talking about the pin numbers really, i.e. the number we
> put into
> 
> struct pinctrl_pin_desc {
>         unsigned number; <- this
>         const char *name;
> };
> 
> Then are you aware that this is a sparse number space?
> 
> I.e. you can choose whatever number you want. You do not have
> to offset numbers from zero or anything like that. You just
> need to make sure the numbers do not overlap (no two pins
> have the same number).
> 
> So if this is what you want to achieve, just use the same number
> as in your datasheet in the pin number -> problem solved.

The problem is that we must support several products which are basically
different packaging options of the same chip (or simplified versions
thereof). Not all of those products will have the same number of pins
and as a consequence, data sheet pin numbering will also be different.
The port names are going to remain the same for all products, however.
Some of the ports are just not going to be physically available in some
or the products. Sorry if that wasn't clear from my previous mail.

> This may lead to some offsetting in your driver etc, and some
> struggle do to that. Inspect drivers/pinctrl/pinctrl-abx500.c
> for example. Here the datasheet offsets the pins from 1 rather
> than from zero, so Patrice had to struggle when cross-mapping
> these numbers, but it can surely be done.

This driver seems to avoid many of our problems by integrating both GPIO
and pinctrl driver in the same module. It would not be very difficult to
integrate our separate TB10x GPiO and pinctrl drivers in the same way:
The cross-calling would disappear and the GPIO-base specification could
also easily be removed from device tree. We would still use the named
pingroups scheme in device tree instead of Linux internal pin numbering,
however.
Is this the way to go? I was a bit reluctant from doing this since I'm
not a big fan of huge mega-drivers. Maybe in this particular case such a
driver may be justified?

>[...]
> > I am well aware of the problem but I haven't found any documentation,
> > core functions or examples which solve this. The most elegant way would
> > be some core functionality allowing to define GPIO ranges by directly
> > querying the pin data base (or to preregister GPIO ranges in the pin
> > controller to which GPIO drivers can then "attach"). Is there something
> > like this I have missed?
> 
> The current preferred pattern is to have the GPIO portions register
> the ranges referring to the pin controller pin numbers.
> 
> This is because it enables us to only use controller-local
> number spaces in both cases.

Agree. The only place in the TB10x drivers where non-local number space
is required is when preparing the GPIO range. I am wondering if some
generic interface in the framework could help us avoid the driver
cross-calls.

> > As a side note, the same argument does not apply to gpio-base, btw, for
> > two reasons:
> >   - Our customer documentation does not talk about a global GPIO
> >     numbering scheme. In our products, GPIOs are organised in banks and
> >     there is no risk of confusion.
> 
> This is the local numbering used when registering ranges from
> the GPIOlib side referred to above.
> 
> >   - The Linux-internal GPIO numbering is already exposed to customers
> >     through the /sys/class/gpio interface.
> 
> Yeah this sucks but we have to live with it forever.
> 
> > That said, if we solve the cross-calling issue I can still move it to
> > the pin data base in the next patch set since you are right that there
> > is no real reason to make it "user-configurable" through DT.
> 
> I don't understand this.

Actually, I am thinking of removing the need of specifying gpio-base in
the device tree and assigning a constant gpio-base to each functional
GPIO pin group in pinctrl-tb10x.c. This would also enforce some
coherence in the GPIO numbering between different product variants which
is probably a very good thing. Again, the issue here is that the pin
data base is in the pinctrl driver and the GPIO range is registered in
the GPIO driver but if I integrate the drivers into the same module with
a shared pin data base this issue will disappear.

> >> Perhaps this "abilis,simple-default" thing is intended to represent some
> >> specific default configuration? If so, I don't think that's the right
> >> way to go. Also, the DT binding should be as complete as possible from
> >> the start, rather than planning to define/implement part of it now and
> >> then keep adding to it later. This all implies that some extra
> >> properties really should be defined here.
> >
> > The abilis,simple-default thing is simply there because I missed commit
> > ab78029ecc347debbd737f06688d788bd9d60c1d and followed
> > Documentation/pinctrl.txt a bit too closely. ("So if possible, handle
> > the pin control in platform code or some other place where you have
> > access to all the affected struct device * pointers.") Currently, our
> > platform code iterates through nodes compatible with
> > abilis,simple-pinctrl and sets up the pin controller accordingly. I'll
> > happily remove this mechanism.

Thanks a lot for your guidance.

Best regards,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
