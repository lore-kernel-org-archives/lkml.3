Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3J1DRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:17:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37072 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab3J1DRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:17:03 -0400
Date: Mon, 28 Oct 2013 03:16:42 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
Message-ID: <20131028031641.GA2782@kartoffel>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
 <20131027134607.E1782C4039D@trevor.secretlab.ca>
 <CAL_JsqLN9eOWTo5pZV1m0i2GmxEMJWOcJvci_w=rCO7_h+X1Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqLN9eOWTo5pZV1m0i2GmxEMJWOcJvci_w=rCO7_h+X1Nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:24:08PM +0000, Rob Herring wrote:
> On Sun, Oct 27, 2013 at 8:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
> > On Tue, 15 Oct 2013 21:39:23 +0100, Grant Likely <grant.likely@linaro.org> wrote:
> >> The standard interrupts property in device tree can only handle
> >> interrupts coming from a single interrupt parent. If a device is wired
> >> to multiple interrupt controllers, then it needs to be attached to a
> >> node with an interrupt-map property to demux the interrupt specifiers
> >> which is confusing. It would be a lot easier if there was a form of the
> >> interrupts property that allows for a separate interrupt phandle for
> >> each interrupt specifier.
> >>
> >> This patch does exactly that by creating a new interrupts-extended
> >> property which reuses the phandle+arguments pattern used by GPIOs and
> >> other core bindings.
> >>
> >> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> >> Cc: Rob Herring <rob.herring@calxeda.com>
> >
> > Alright, I want to merge this one. I've got an Ack from Tony, general
> > agreement from an in person converstaion from Ben (aside from wishing he
> > could think of a better property name), and various rumblings of
> > approval from anyone I talked to about it at ksummit. I'd like to have
> > something more that that to put into the commit text. Please take a look
> > and let me know if you agree/disagree with this binding.

The only comment I have is that I'm not keen on the name (it's a bit generic
and we might want to extend the interrupts binding in future), but I'm happy to
leave that as a matter of personal taste.

The best alternative I could come up with was parented-interrupts, but that
could be misinterpreted as describing the relationship backwards (i.e. this
device is the parent for those interrupts).

> 
> I think it looks fine, but I'll throw out an alternative proposal.
> Simply allow for interrupt-parent to be an array in equal size to
> interrupts property. Then it is a minimal change to the existing
> binding:
> 
> interrupt-parent = <&intc1>, <&intc2>;
> interrupts = <5 0>, <6 0>;

I'd prefer the interrupts-extended approach.

This might not matter, but if you have an existing driver with two interrupts,
and you attempt to describe the situation this way, e.g.

  intc1: interrupt_controller1 {
      compatible = "vendor,interrupt-controller";
      #interrupt-cells = <1>;
  };

  intc2: interrupt_controller2 {
      compatible = "vendor,another-interrupt-controller";
      #interrupt-cells = <2>;
  };

  dev {
      compatible = "vendor,some-device";
      interrupt-parent = <&intc1>, <&intc2>;
      interrupts = <5>, <65 73>;
  };

The existing driver may read interrupts as two interrupts for intc1, and
believe it's been successful when it has not, and one of those interrupts might
never fire. That would be very bad for a timer for example.

Additionally it makes the interrupts list difficult for a human to read, as you
need to match it with an entry in another list (this problem exists with other
parallel properties like interrupt-names too, but we can't do much better
there).

It's also easy to make a typo (e.g. an extra cell in an interrupt) that will
parse as valid when you don't expect it to. At least with the phandle in the
list it's less likely to happen.

> 
> Of course interrupts-extended is more inline with standard patterns
> for bindings.

I think for this reason alone it should be preferable. Unless I'm mistaken it
would be identical to the clock bindings pattern with a uniformly named
phandle+args property and a parallel -names property. I don't think the gpio
style ${NAME}-interrupts would easily fit here.

Thanks,
Mark.
