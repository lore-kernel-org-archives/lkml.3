Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbaCUPuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:50:35 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34274 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632AbaCUPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140310112929.GY21483@n2100.arm.linux.org.uk>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk> <20140310105808.GE2815@lukather>
 <20140310112929.GY21483@n2100.arm.linux.org.uk>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Fri, 21 Mar 2014 11:49:59 -0400
X-Google-Sender-Auth: ET3CTVK4ol4ChGCuxvSXTE2yPLU
Message-ID: <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com>
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 7:29 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Mar 10, 2014 at 11:58:08AM +0100, Maxime Ripard wrote:
>> On Fri, Mar 07, 2014 at 04:08:36PM +0000, Russell King - ARM Linux wrote:
>> > On Fri, Mar 07, 2014 at 03:59:30PM +0100, Maxime Ripard wrote:
>> > > @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
>> > >  exit_free_irq:
>> > >   free_irq(drv_data->irq, drv_data);
>> > >  exit_reset:
>> > > - if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
>> > > + if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
>> > > +     !IS_ERR(drv_data->rstc))
>> > >           reset_control_assert(drv_data->rstc);
>> >
>> > Another question is... why do we need to check pd->dev.of_node here?
>> > If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
>> > controller node, so drv_data->rstc is either going to be a valid
>> > pointer, or it's going to be an error pointer - neither
>> > reset_control_get() nor devm_reset_control_get return NULL.
>>
>> Following back on this as I was doing the patch, actually,
>> drv_data->rstc will be NULL if we're not probed by DT, and hence never
>> call reset_control_get, that would set an error pointer.
>>
>> But then, we can use IS_ERR_OR_NULL on drv_data->rstc.
>
> I think you can also move the devm_reset_control_get() into the main
> probe function: you're only checking for -EPROBE_DEFER from it to fail,
> allowing other errors to continue with the driver init.  This means
> that on non-OF, devm_reset_control_get() will fail with -ENOENT.

Looping linux-next into the CC since this is the cause of the failure
in orion5x_defconfig there, and no point in anyone else re-doing the
same bisect.

Paul.
--

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[80c69915e5fbe6493119d87eee2a2a6a7115c74c] i2c: mv64xxx: fix circular
Kconfig dependency
running ./x
#
# configuration written to .config
#
drivers/built-in.o: In function `mv64xxx_i2c_remove':
/home/paul/git/linux-head/drivers/i2c/busses/i2c-mv64xxx.c:924:
undefined reference to `reset_control_assert'
drivers/built-in.o: In function `mv64xxx_i2c_probe':
/home/paul/git/linux-head/drivers/i2c/busses/i2c-mv64xxx.c:904:
undefined reference to `reset_control_assert'
drivers/built-in.o: In function `mv64xxx_of_config':
/home/paul/git/linux-head/drivers/i2c/busses/i2c-mv64xxx.c:771:
undefined reference to `devm_reset_control_get'
/home/paul/git/linux-head/drivers/i2c/busses/i2c-mv64xxx.c:778:
undefined reference to `reset_control_deassert'
make: *** [vmlinux] Error 1
80c69915e5fbe6493119d87eee2a2a6a7115c74c is the first bad commit
commit 80c69915e5fbe6493119d87eee2a2a6a7115c74c
Author: Wolfram Sang <wsa@the-dreams.de>
Date:   Thu Mar 6 10:08:50 2014 +0100

    i2c: mv64xxx: fix circular Kconfig dependency

    Commit 370136bc67c3 ("i2c: mv64xxx: Add reset deassert call")
    introduced:

    drivers/video/Kconfig:42:error: recursive dependency detected!

    ARCH_SUNXI selects RESET_CONTROLLER anyhow.

    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

:040000 040000 533a0ca6b40f2dd1d0b3bb434e6ed13ff4796953
cfd47b9ad19651148a2d0d4fa3a4df0b8cbbe1df M    drivers
bisect run success




>
> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
