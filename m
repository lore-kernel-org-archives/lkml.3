Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3FZLmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:42:38 -0400
Received: from mail.abilis.ch ([195.70.19.74]:14968 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3FZLmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:42:36 -0400
Date: Wed, 26 Jun 2013 13:42:01 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH 1/4] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20130626114159.GA7095@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-1-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdbhTsRAGSkxQURd01_yd5arw7=ktVXAmeEo22gFg4U38Q@mail.gmail.com>
 <51C1F531.3050205@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51C1F531.3050205@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 12:15:13PM -0600, Stephen Warren wrote:
> On 06/19/2013 06:03 AM, Linus Walleij wrote:
> > On Tue, Jun 18, 2013 at 11:29 AM, Christian Ruppert
> > <christian.ruppert@abilis.com> wrote:
> > 
> >> This patch adds the infrastructure required to register non-linear gpio
> >> ranges through gpiolib and the standard GPIO device tree bindings.
> >>
> >> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > 
> > I'm basically fine with this, but would like Stephen's ACK if possible.
> > 
> >> +In addition, named groups of pins can be mapped to pin groups of a given
> >> +pin controller:
> >> +
> >> +       gpio_pio_g: gpio-controller@1480 {
> >> +               #gpio-cells = <2>;
> >> +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> >> +               reg = <0x1480 0x18>;
> >> +               gpio-controller;
> >> +               gpio-ranges = <&pinctrl1 0 0 0>, <&pinctrl2 3 0 0>;
> >> +               gpio-ranges-group-names = "foo", "bar";
> >> +       };
> >> +
> >> +where,
> >> +   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
> >> +
> >> +   The following value specifies the base GPIO offset of the pin range with
> >> +   respect to the GPIO controller's base. The remaining two values must be
> >> +   0 to indicate that a named pin group should be used for the respective
> >> +   range. The number of pins in the range is the number of pins in the pin
> >> +   group.
> > 
> > So while this works, these zeroes seem a bit awkward, but maybe
> > it's the only way?
> > 
> > I'm not good enough on device tree conventions, but isn't this possible:
> > 
> >               gpio-ranges = <&pinctrl1 0>, <&pinctrl2 3>;
> >               gpio-ranges-group-names = "foo", "bar";
> > 
> > Since we don't have any #gpio-ranges-cells or anything like that I
> > guess we can define this to have a flexible number of cells
> > depending on use case?
> 
> If we're willing to have gpio-ranges be either *all* group names, or
> *all* IDs, we can define the format of gpio-ranges to have two cells
> (phandle and GPIO number) if the property gpio-ranges-group-names
> exists, but four cells (phandle, GPIO number, pin number, count)
> otherwise. However, that's a little restrictive, since then what if one
> GPIO controller is hooked to two different pinmux controllers, and you
> want to use different formats for the references to each. A
> #gpio-ranges-cells in the target of the phandle would allow this, but I
> don't think this is something the pinctrl node should dictate to those
> who reference it; it's quite legitimate for a GPIO node to use the pure
> numeric mapping even if the pin controller happens to expose some pin
> groups that allow you to do the mapping by name.

I actually had a version of the patch with #gpio-range-cells specifying
the format (one argument for named ranges, three for classical ranges)
before deciding to use a separate property and sending that version. As
I said in a previous mail, I don't have a preference which of the
following three possibilities to use and would be grateful for some
guidance (if it matters at all).

1.) separate property:
	gpio {
		gpio-ranges = <&pinctrl1 0 0 5>;
		gpio-range-groups = <&pinctrl2 5>;
		gpio-range-group-names = "gpios";
	};

2.) fixed number of three arguments:
	gpio {
		gpio-ranges = <&pinctrl1 0 0 5>, <&pinctrl2 5 0 0>;
		gpio-range-names = "", "gpios";
	};

3.) pinctrl-defined format.
	pinctrl1: pctl1 {
		#gpio-range-cells = <3>;
	};
	pinctrl2: pctl2 {
		#gpio-range-cells = <1>;
	};
	gpio {
		gpio-ranges = <&pinctrl1 0 0 5>, <&pinctrl2 5>;
		gpio-range-names = "", "gpios";
	};

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
