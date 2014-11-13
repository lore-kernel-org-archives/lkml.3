Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbaKMX1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:27:35 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36037 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbaKMX1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:27:33 -0500
MIME-Version: 1.0
In-Reply-To: <1641362.yfrjtMOWge@diego>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
	<1415884826-7877-2-git-send-email-kever.yang@rock-chips.com>
	<1641362.yfrjtMOWge@diego>
Date: Thu, 13 Nov 2014 15:27:32 -0800
X-Google-Sender-Auth: PBj42ycoay5OPodgFnNmVHK6gOc
Message-ID: <CAD=FV=WSDtxjtGD3c22OqXsSqaphKcmup9rAfonbeC-bUWHmSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] clk: add property for force to update clock setting
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 13, 2014 at 6:53 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Donnerstag, 13. November 2014, 21:20:25 schrieb Kever Yang:
>> Usually we assigned a clock to a default rate in dts,
>> there is a situation that the clock already initialized to the rate
>> we intend to set before kernel(hardware default or init in uboot etc).
>> For the PLLs we can get a rate from different PLL parameter configure,
>> we can't change the PLL parameter if the rate is not changed by now.
>>
>> This patch adds a option property 'assigned-clock-force-rates'
>> to make sure we update all the setting even if we don't need to
>> update the clock rate.
>>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> ---
>>
>>  drivers/clk/clk-conf.c | 33 ++++++++++++++++++++++++++++++++-
>>  1 file changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
>> index aad4796..0c9df48 100644
>> --- a/drivers/clk/clk-conf.c
>> +++ b/drivers/clk/clk-conf.c
>> @@ -84,7 +84,7 @@ static int __set_clk_rates(struct device_node *node, bool
>> clk_supplier) struct clk *clk;
>>       u32 rate;
>>
>> -     of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
>> +     of_property_for_each_u32(node, "assigned-force-rates", prop, cur, rate) {
>>               if (rate) {
>>                       rc = of_parse_phandle_with_args(node, "assigned-clocks",
>>                                       "#clock-cells", index, &clkspec);
>> @@ -104,7 +104,38 @@ static int __set_clk_rates(struct device_node *node,
>> bool clk_supplier) index, node->full_name);
>>                               return PTR_ERR(clk);
>>                       }
>> +                     /* change the old rate to 0 to make sure we can get into
>> +                      * clk_change_rate */
>> +                     clk->rate = 0;
>> +                     rc = clk_set_rate(clk, rate);
>> +                     if (rc < 0)
>> +                             pr_err("clk: couldn't set %s clock rate: %d\n",
>> +                                    __clk_get_name(clk), rc);
>> +                     clk_put(clk);
>
> Forcing clocks to 0 at first will probably create issues on some platfoms.
> I think what Doug meant was something like [0], which would then enable
> the clk_conf part to force the rate change. I haven't tested this yet, but it
> seems the check in clk_set_rate is the only one checking for identical new
> and old rates.

Hrm, I was actually not thinking of adding a new device tree property.
I was thinking that we'd _always_ call "force" for
"assigned-clock-rates".  Really the check in clk_set_rate() is an
optimization (right?), not for correctness.  Thus it should be OK to
bypass it at bootup.

Actually, maybe even better: for all clocks you should always skip the
"clk_get_rate()" check the first time through.  Then you'd ensure that
you aren't using some default or firmware-assigned clock settings.
AKA, something like this untested patch:

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 59d853d..56db138 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1618,9 +1618,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
        /* prevent racing with updates to the clock topology */
        clk_prepare_lock();

-       /* bail early if nothing to do */
-       if (rate == clk_get_rate(clk))
+       /* bail early if nothing to do; linux should always set the rate once */
+       if (rate == clk_get_rate(clk) && clk->did_set_rate)
                goto out;
+       clk->did_set_rate = true;

        if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
                ret = -EBUSY;

I'm ducking now in case Mike decides to throw a tomato at me.

-Doug
