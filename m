Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3H1IcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:32:10 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47082 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3H1IcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <520D4805.8070007@codeaurora.org>
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org>
	<CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com>
	<CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com>
	<520D1363.3090708@codeaurora.org>
	<CACRpkdYVQ-Yk_b0cW0-sB6eGkpkgfFsnd3NXQmCYCuiLmm5qww@mail.gmail.com>
	<520D4805.8070007@codeaurora.org>
Date: Wed, 28 Aug 2013 10:32:05 +0200
Message-ID: <CACRpkdaNCoE1Hn_KGNWVVWTXWQjLmEtWwg=KhzO8JhPZkV6w3w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanumant Singh <hanumant@codeaurora.org>
Cc: Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:28 PM, Hanumant Singh
<hanumant@codeaurora.org> wrote:
> On 8/15/2013 1:47 PM, Linus Walleij wrote:

>> What pin groups and functions that exist on a SoC is what you put into
>> a SoC driver. Because this is a hardware characteristic.
>>
>> How these are combined on a board into different states is what you put
>> into the device tree. (Or platform data.)
>
> For example lets say for a given SOC A it goes into boards 1, 2, and 3.
> Each of the boards has a display panel. The display panel uses two pins
> 1) a reset pin 2) an interrupt pin.

That sounds very close to two GPIO pins actually but I guess they
are not configured as "GPIO" in the data sheet sense when you do
this?

> In the combination of SOC A + board 1
>  - Display panel reset = pin no 5.
>  - Display panel interrupt = pin no 9.
>
> In combination of SOC A + board 2
>  - Display panel reset = pin no 4.
>  - Display panel interrupt = pin no 9.
>
> In combination of SOC A + board 3
>  - Display panel reset = pin no 7.
>  - Display panel interrupt = pin no 2.
>
> The pin groupings to be used by the display panel can be {5,9}, {4,9}, or
> {7,2}
> These different pin groups and their function setting will be present in
> soc-pinctrl.c. The function setting is the same on all 3 cases.

The last part is correct, the function setting is the same on all
three cases :-)

Define one group per pin in this case, example something
like this (using the examples in Documentation/pinctrl.txt
as a base):

static const unsigned pan_res_pos_a[] = { 4 };
static const unsigned pan_res_pos_b[] = { 5 };
static const unsigned pan_res_pos_c[] = { 7 };
static const unsigned pan_irq_pos_a[] = { 2 };
static const unsigned pan_irq_pos_b[] = { 9 };

Next define the function and applicable groups:

static const struct foo_group foo_groups[] = {
        {
                .name = "pan_res_pos_a_grp",
                .pins = pan_res_pos_a_pins,
                .num_pins = ARRAY_SIZE(pan_res_pos_a_pins),
        },
        {
                .name = "pan_res_pos_b_grp",
                .pins = pan_res_pos_b_pins,
                .num_pins = ARRAY_SIZE(pan_res_pos_b_pins),
        },
        {
                .name = "pan_res_pos_c_grp",
                .pins = pan_res_pos_c_pins,
                .num_pins = ARRAY_SIZE(pan_res_pos_c_pins),
        },
        {
                .name = "pan_irq_pos_a_grp",
                .pins = pan_irq_pos_a_pins,
                .num_pins = ARRAY_SIZE(pan_irq_pos_a_pins),
        },
        {
                .name = "pan_irq_pos_b_grp",
                .pins = pan_irq_pos_b_pins,
                .num_pins = ARRAY_SIZE(pan_irq_pos_b_pins),
        },
};

static const char * const panel_groups[] = { "pan_res_pos_a_grp",
  "pan_res_pos_b_grp", "pan_res_pos_c_grp",
  "pan_irq_pos_a_grp", "pan_irq_pos_b_grp"
};

static const struct foo_pmx_func foo_functions[] = {
        {
                .name = "panel",
                .groups = panel_groups,
                .num_groups = ARRAY_SIZE(panel_groups),
        },
....
};


Then in your DTS you combine the function "panel" with
the two groups you want, i.e. for your examples:

1: "panel" + "pan_res_pos_b_grp" + "pan_irq_pos_b_grp"
2: "panel" + "pan_res_pos_a_grp" + "pan_irq_pos_b_grp"
3: "panel" + "pan_res_pos_c_grp" + "pan_irq_pos_a_grp"

So in each case the function "panel" is combined with two
groups enabling the correct pins for a certain state, e.g.
the "default" state. Each line above corresponds to a
state.

> The DT entry will correspond to the different states of these pins for the
> different boards.
>
> Is this understanding correct?

See above.

>> Bring 'em on. But is that really different groups you are talking about,
>> and not just combinations of groups with functions for a certain board
>> as I describe above?
>>
>> If you have many SoC subdrivers, consider creating a subdir as some
>> drivers already have.
>
> Actually the SOC files, as I see it, will only contain the different pin
> groupings and the function setting for a given soc.

No settings. The SoC files will contain the available groups and
functions. How these are combined is defined by the device tree
(or even platform data). The pinctrl SoC files define what is
*possible* and the configuration from DTS or platform data
define what to do with the possibilities.

> 3). I will currently refrain from creating a special msm directory.
> Maybe that can be a step 2) once we start adding more SOC's?
> I will be starting the patch with msm8974 SOC only.

Sure any order you prefer, let's get a base support in that
looks fine and then we can start refining it.

Yours,
Linus Walleij
