Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbbAOOho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:37:44 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34616 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbbAOOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <54B7B39C.7080204@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com> <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com> <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <20150112170644.GO4160@sirena.org.uk> <54B7B39C.7080204@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 15 Jan 2015 08:37:19 -0600
Message-ID: <CAL_JsqLqRn1QG6dG5Ea6231SNzrV=Q9K=uRqjziM9sDdA3+31g@mail.gmail.com>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mark Brown <broonie@kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 6:33 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 12/01/15 18:06, Mark Brown wrote:
>> On Mon, Jan 12, 2015 at 10:55:29AM -0600, Rob Herring wrote:
>>> > On Mon, Jan 12, 2015 at 10:10 AM, Jacek Anaszewski
>>>> > > There are however devices that don't fall into this category, i.e. they
>>>> > > have many outputs, that can be connected to a single LED or to many LEDs
>>>> > > and the driver has to know what is the actual arrangement.
>>> >
>>> > We may need to extend the regulator binding slightly and allow for
>>> > multiple phandles on a supply property, but wouldn't something like
>>> > this work:
>>> > led-supply = <&led-reg0>, <&led-reg1>, <&led-reg2>, <&led-reg3>;
>>> > The shared source is already supported by the regulator binding.
>>
>> What is the reasoning for this?  If a single supply is being supplied by
>> multiple regulators then in general those regulators will all know about
>> each other at a hardware level and so from a functional and software
>> point of view will effectively be one regulator.  If they don't/aren't
>> then they tend to interfere with each other.
>
> For LED current regulators like this one [1] we want to be able to
> communicate to the software the hardware wiring, e.g. if a single LED is
> connected to only one or both the current regulators.  The device needs
> to be programmed differently for each configuration, as shown on page 36
> of the datasheet [2].
>
> Now, the LED DT binding describes the LEDs (current consumers) as child
> nodes of the LED driver IC (current supplier), e.g. (from [3]):
>
> pca9632@62 {
>         compatible = "nxp,pca9632";
>         #address-cells = <1>;
>         #size-cells = <0>;
>         reg = <0x62>;
>
>         red@0 {
>                 label = "red";
>                 reg = <0>;

This only works if you don't have sub blocks or different functions to
describe. I suppose you could add yet another level of nodes. This
feels like abuse of the reg property even though to use the reg
property is a frequent review comment.

OTOH, we don't need 2 ways to describe this.

>                 linux,default-trigger = "none";
>         };
>         green@1 {
>                 label = "green";
>                 reg = <1>;
>                 linux,default-trigger = "none";
>         };
>         ...
> };
>
> What is missing in this binding is the ability to tell that a single LED
> is connected to more than one current source.
>
> We could, for example adopt the multiple phandle in the supply property
> scheme, but not use the kernel regulator API, e.g.
>
> flash-led {
>          compatible = "maxim,max77387";
>
>          current-reg1 { // FLED1
>                  led-output-id = <0>;
>          };
>
>          current-reg2 { // FLED2
>                  led-output-id = <1>;
>          };
>
>          red_led {
>                  led-supply = <&current-reg1>, <&current-reg2>;
>          };
> };
>
> However my feeling is that it is unnecessarily complicated that way.

This example is not so complicated, but I already agreed on not using
regulators on the basis there are other properties of the driver
unique to LEDs.

> Perhaps we could use the 'reg' property to describe actual connections,
> I'm not sure if it's better than a LED specific property, e.g.
>
> max77387@52 {
>         compatible = "nxp,max77387";
>         #address-cells = <2>;
>         #size-cells = <0>;
>         reg = <0x52>;
>
>         flash_led {
>                 reg = <1 1>;

Don't you mean <0 1> as the values are the "address" which in this
case are the LED driver output indexes.

Rob

>                 ...
>         };
> };
>
> [1] http://www.maximintegrated.com/en/products/power/led-drivers/MAX77387.html
> [2] http://datasheets.maximintegrated.com/en/ds/MAX77387.pdf
> [3] Documentation/devicetree/bindings/leds/pca963x.txt
