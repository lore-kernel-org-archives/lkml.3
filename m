Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3FYP7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:59:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50204 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3FYP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:59:14 -0400
Message-ID: <51C9BE4F.80200@wwwdotorg.org>
Date: Tue, 25 Jun 2013 09:59:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com> <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com> <51BA3BC1.3090109@wwwdotorg.org> <20130614091241.GA23745@ab42.lan> <51C1F42E.5090107@wwwdotorg.org> <51C1F82C.4020502@wwwdotorg.org> <20130620115710.GB942@ab42.lan> <51C4C2ED.5090505@wwwdotorg.org> <20130625115950.GB30827@ab42.lan>
In-Reply-To: <20130625115950.GB30827@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 05:59 AM, Christian Ruppert wrote:
> On Fri, Jun 21, 2013 at 03:17:33PM -0600, Stephen Warren wrote:

...
> To define some terminology, let's call a set of pins affected by the
> same register / bit field a "port".

Well, the terminology "group" already exists for this really, but I
suppose we can call it a port instead...

...
>> 4) Depending on HW design, all register fields might be of type
>> described at (2) above, or all of the type described at (3) above, or a
>> mixture of both. Tegra is a mixture.
> 
> TB10x is all (3).
> 
>> 5) I expect the concept of a pin group to solely represent the various
>> groups of pins affected by each register field; in (2) above one pin per
>> group, in (3) above many pins per group.
> 
> In our example above, TB10x would have two ports, i.e. two bit fields in
> its pinctrl register. Each of those bit fields would allow selecting one
> of the configurations for grp1 and grp2 respectively.
>
> Do I understand your explanation correctly: You would implement the TB10x
> pinctrl exactly like the example above, two pin groups with three and
> five configurations?

Assuming there's a register field for grp1 that takes one of 3 values,
and a register field for grp2 that takes one of 5 values, then yes.

...
>> Consider a pin group in HW that encompasses 10 pins, but you've selected
>> a function onto it that only actually uses 6 pins for that logical
>> function. The other 4 pins aren't used, and can be GPIO. However, all
>> pins in the group are "claimed" because some mux function has been
>> selected onto the group that includes those 10 pins. In order to allow
>> some of those pins to be claimed as a GPIO, the pinctrl core simply
>> allows GPIO usage and mux function usage to be claimed on each
>> individual pin without regard for each-other.
> 
> This might be the main source of confusion. I admit that I hadn't
> understood (and still think it is at least unorthogonal if not
> semantically wrong) that an entire port must be claimed if just one
> interface inside the port is required. Probably many other driver
> authors (those you mention above) didn't understand this either.

It's not that the "entire port /must/ be claimed", it's that there's
choice in the matter; no concept of claiming anything (other than GPIO)
at a level less than a port. The port (group in pinctrl terminology)
*is* the level of granularity at which pinctrl claims pins.

>> Now, it would indeed be possible for each combination of (pin group, mux
>> function) to be associated with a list of pins from the group that could
>> be used as GPIO, and then for the pinctrl core to additionally enforce
>> that only those pins be claimed for GPIO usage. However, the pinctrl
>> core does not do this at present.
> 
> This is why it is implemented inside the TB10x driver.

OK.

If that concept ends up being more generally applicable, then it might
make sense to move the validation into the pinctrl core. I don't know if
this level of detail makes sense there or not though.

>>> When writing our pinctrl driver, my understanding was slightly
>>> different: I define seven pin groups:
>>> spi1 = {A5, A6, A7, A8};
>>> i2c = {A5, B5};
>>> mmc2 = {A1, B1};
>>> mmc4 = {A1, B1, C1, D1};
>>> mmc8 = {A1, B1, C1, D1, E1, F1, G1, H1};
>>> spi2 = {G1, G2, G3, G4};
>>> gpios = {A1, A5, A6, A7, A8, B1, B5, C1, D1, E1, F1, G1, G2, G3, G4, H1};
> 
> Do I understand your explanation on the very top correctly that this is
> actually the strategy you said was wrongly employed in several other
> drivers?

It looks like it on the surface. I'd have to look at the HW register
specs to say for sure.

...
>> In that case, the pinctrl driver or DT binding really shouldn't define
>> pin groups to help define that mapping, since the mapping is something
>> that exists outside the realm of the pinctrl HW block itself.
> 
> I agree. This is why the proposed pinctrl driver defines mux-side pin
> controller interfaces as pingroups (these are actual hardware interfaces
> of the pinctrl RTL module). GPIOs (and any other interfaces) are
> connected at the top level to those interfaces.

Pingroup definitions for "actual HW interfaces of the RTL module" make
sense to me.
