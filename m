Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab3HNT3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:29:11 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59258 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799Ab3HNT3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:29:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com>
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org>
	<CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com>
Date: Wed, 14 Aug 2013 21:29:08 +0200
Message-ID: <CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Hanumant Singh <hanumant@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 1:39 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Wed, Jul 24, 2013 at 1:41 PM, Hanumant Singh <hanumant@codeaurora.org> wrote:

> As a general note on the patch, the pins and pin groups are defined by
> the soc, I'm therefore not convinced that these should be configured
> from the devicetree. It's at least not how it's done in other
> platforms.

Now we are three people sayin the same thing so it should
be a good hint to the implementer :-)

> After talking to Linus a little bit I concluded that the way the
> design idea behind pinmux is that you have pins and you have
> functions;
> * pins are your 117 gp-pins and with some imagination your sd pins, so
> that's fine.
> * the function is some functionality provided by the hard
> Then you can set up muxes between these two. Therefore I think your
> use of the word "function" in the patch is what normally is called a
> mux. It might be worth sorting this out, to make it easier to maintain
> this code down the road.
>
> @Linus, can you please confirm my understanding of the design?

Yes, we have pins in groups which are just group = pin [a, b, ... , n]
and we have functions which is e.g. "I2C block 1". To push a function
out on the pins we connect the function with a group of pins.

For a function such as a UART, we connect 2 or 4 pins ... those will
provide TX+RX or maybe TX+RX+CTS+RTS if we want to be fancy.

So the mapping table combines this group with this function and
that becomes a setting such as "default" ...

You only have to do it a few times and then you get the hang
of it :-)

I wish we could have come up with something simpler than
this but it appears the world is complex, this was the common
denominator of all the worlds pinmuxes: they enable a group
of pins for a certain function (an IP core).

>> +static int msm_tlmm_v3_sdc_cfg(uint pin_no, unsigned long *config,
>> +                                               void __iomem *reg_base,
>> +                                               bool write)
>
> I strongly recommend you split this function into a get_config and
> set_config. It took me plenty of time to get my head around what
> you're doing here.
>
> I would also suggest that you do:
>
> val = readl()
> switch () {
>   fix val in various ways
> }
> writel(val)
>
> Instead of maintaining mask and shift throughout the function.

Agree. And if you want to have performance as well:
readl_relaxed() ... writel() is preferred. (Not that it matters
much uless in a critical path.)

>> +       /* Get mask and shft values for this config type */
>> +       switch (id) {
>> +       case PIN_CONFIG_BIAS_DISABLE:
>> +               mask = TLMMV3_GP_PULL_MASK;
>> +               shft = TLMMV3_GP_PULL_SHFT;
>> +               data = TLMMV3_NO_PULL;
>> +               if (!write) {
>> +                       val >>= shft;
>> +                       val &= mask;
>> +                       data = rval_to_pull(val);
>
> I assume this should return a "boolean" whether or not this mode is
> selected; if so you should return 1 here iff (val & 0x3) == 3. I
> assume the same goes for the sdc config function?
>
> @Linus, could you please confirm this interpretation of the get_config
> for pull config.

On bias disable the argument is ignored so it doesn't matter, it
should just be set to zero.

Actually the data should be more carefully handled for each
config option I think.

Yours,
Linus Walleij
