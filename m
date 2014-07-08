Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaGHV7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:59:17 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37141 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGHV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:59:15 -0400
MIME-Version: 1.0
In-Reply-To: <53BC4DD7.20906@codeaurora.org>
References: <53BC4DD7.20906@codeaurora.org>
Date: Tue, 8 Jul 2014 14:59:15 -0700
Message-ID: <CAJAp7OhUE4LmLtu5AMui_0ws-K_H__07VN=g2Frr0JCMn+Q5Gg@mail.gmail.com>
Subject: Re: a case for a common efuse API?
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 1:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Hi,
>
> On MSM chips we have some efuses (called qfprom) where we store things
> like calibration data, speed bins, etc. We need to read out data from
> the efuses in various drivers like the cpufreq, thermal, etc. This
> essentially boils down to a bunch of readls on the efuse from a handful
> of different drivers. In devicetree this looks a little odd because
> these drivers end up having an extra reg property (or two) that points
> to a register in the efuse and some length, i.e you see this:

Not only does it look odd, but it limits the possible use to devices on the
mmio bus.

[...]
> It's been suggested that we use syscon for this, but I wonder if that is
> the right thing to do. With a syscon you're usually writing some
> registers that got lumped together with other registers that aren't
> directly related to your driver. It doesn't seem like syscon is made for
> reading fuses or other things like eeproms. Maybe I'm wrong though.
>

I've been thinking further about this since we discussed it; and I agree with
you that this probably wasn't in the original plans for syscon.

But looking at the qfprom hardware, we have a span of 32 bit registers that's
supposed to be accessed from various drivers. All these registers are the same
size, so abstracting them with a mmio-regmap makes sense. All we need is a way
for drivers to get a handle to this regmap.

This was exactly what I implemented and then I realized that I had only created
a copy of syscon (although readonly) and given it a different name.


A potential addition to this would be to expose a (preferrably separate) api to
fuse things, for factory use. But looking at the qfprom this is done by writing
to different parts of the register space, so we could simply add a factory fuse
driver on the side - once one is desired.

> Using syscon would probably work if we could add a way to point to
> offsets within the syscon node (the 0x18 part in the example). In my
> specific use-case the calibration data may have different offsets
> depending on which SoC the hardware is instantiated in so we could also
> make syscon work if the compatible field for the sensor node indicates
> which SoC it is.
>

I'm not sure if other users of syscon would find a use for an xlate, if not
then we could just have that as a separate property that lists the reg offsets
within the syscon.

Maybe there's some benefits of common naming of said property so we could put
some common accessor functions somewhere?

Regards,
Bjorn
