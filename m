Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbaE3Q2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:28:31 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:36453 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaE3Q2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <53881102.1080406@gmail.com>
References: <1401398496-4624-1-git-send-email-dianders@chromium.org>
	<20140529222904.10062.22764@quantum>
	<53881102.1080406@gmail.com>
Date: Fri, 30 May 2014 09:28:29 -0700
X-Google-Sender-Auth: iGWaQ0DvKg49wa6TeJhpOz2R6J8
Message-ID: <CAD=FV=Xsdaze6mDG=ZeCBZ9deYMjarftTK7YDtoN3fo5jzFbTg@mail.gmail.com>
Subject: Re: [PATCH] clk: exynos5420: Keep aclk66_peric enabled during boot
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, May 29, 2014 at 10:02 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi,
>
> On 30.05.2014 00:29, Mike Turquette wrote:
>> Quoting Doug Anderson (2014-05-29 14:21:36)
>>> Right now if you've got earlyprintk enabled on exynos5420-peach-pit
>>> then you'll get a hang on boot.  Here's why:
>>>
>>> 1. The i2c-s3c2410 driver will probe at subsys_initcall.  It will
>>>    enable its clock and disable it.  This is the clock "i2c2".
>>> 2. The act of disabling "i2c2" will disable its parents.  In this case
>>>    the parent is "aclk66_peric".  There are no other children of
>>>    "aclk66_peric" officially enabled, so "aclk66_peric" will be turned
>>>    off (despite being CLK_IGNORE_UNUSED, but that's by design).
>>> 3. The next time you try to earlyprintk you'll do so without the UART
>>>    clock enabled.  That's because the UART clocks are also children of
>>>    "aclk66_peric".  You'll hang.
>>>
>>> There's no good place to put a clock enable for earlyprintk, which is
>>> handled by a bunch of assembly code.  The best we can do is to handle
>>> this in the clock driver.
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> ---
>>>  drivers/clk/samsung/clk-exynos5420.c | 24 ++++++++++++++++++++++++
>>>  1 file changed, 24 insertions(+)
>>>
>>> diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
>>> index 9d7d7ee..1e586be 100644
>>> --- a/drivers/clk/samsung/clk-exynos5420.c
>>> +++ b/drivers/clk/samsung/clk-exynos5420.c
>>> @@ -1172,11 +1172,17 @@ static struct of_device_id ext_clk_match[] __initdata = {
>>>         { },
>>>  };
>>>
>>> +/* Keep these clocks on until late_initcall */
>>> +static const char *boot_clocks[] __initconst = {
>>> +       "aclk66_peric",
>>> +};
>>> +
>>>  /* register exynos5420 clocks */
>>>  static void __init exynos5x_clk_init(struct device_node *np,
>>>                 enum exynos5x_soc soc)
>>>  {
>>>         struct samsung_clk_provider *ctx;
>>> +       int i;
>>>
>>>         if (np) {
>>>                 reg_base = of_iomap(np, 0);
>>> @@ -1226,6 +1232,12 @@ static void __init exynos5x_clk_init(struct device_node *np,
>>>         }
>>>
>>>         exynos5420_clk_sleep_init();
>>> +
>>> +       for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
>>> +               struct clk *to_enable = __clk_lookup(boot_clocks[i]);
>>
>> How about replacing __clk_lookup with clk_get? You can keep the struct
>> clk object hanging around for later...
>>
>
> Mike, correct me if I'm wrong, but I thought you need clkdev look-up
> entry for clk_get() to find a clock. Here, this clock apparently don't
> have one and you don't even have a struct device * to pass to clk_get(),
> so even if you had a look-up entry, it would need to be a wildcard entry
> (with NULL device), which wouldn't be too elegant.

I'll send up the next patch changing this clock to "GATE_A" which will
allow global lookups.  ...then I'll use clk_get() as Mike requests.
We can see if we like it better and can always move back to
__clk_lookup().


> Doug, isn't a similar thing needed for PM debug as well? Maybe having
> this clock always ungated whenever DEBUG_LL is enabled would be enough?

There may be a possible case where this is needed for PM debug, but I
don't _think_ it's needed in all the common cases.  It's also not
sufficient, I think.

Specifically:

1. This patch only gets "aclk66_peric", not the UART clock itself.  It
makes the assumption (required for earlyprink) that the bootloader
left enough clocks on to use the UART.  That is roughly documented in
Documentation/arm/Booting.  Mostly this patch is making sure that we
don't screw up the nice environment that the bootloader left for us.
This solution has the nice side effect that we don't need to try to
figure out which actual UART is active / grab the right clock.

2. Without grabbing the real UART clock then PM debug would start
failing anyway when the system disables all unused clocks in
late_init.

3. I would assume that if there was a problem here it would have
surfaced in 5250.  5250 doesn't have the problem we're addressing here
since there's no gate clock for "aclk66_peric" (or if there is one,
it's not described in our clock tree).

4. Assuming that you've got the serial port specified as a console=
port, I think the core will use s3c24xx_serial_pm to enable the clock
and leave it on.


...I haven't got myself setup for PM debug upstream right now (would
be good to get it configured / working locally eventually), but I
think if we have problems to solve there then we should solve it in
code related to PM debug.  How does that sound?

Also note that on ChromeOS we always have DEBUG_LL enabled (though we
usually don't have earlyprintk on the command line).
