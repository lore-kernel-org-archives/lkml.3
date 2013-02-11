Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3BKFqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:46:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53160 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3BKFqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:46:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20130211054632.11471.24295@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: add si5351 i2c common clock driver
Date: Sun, 10 Feb 2013 21:46:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-02-09 04:59:32)
> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
> i2c programmable clock generators. Currently, the driver supports
> DT kernels only and VXCO feature of si5351b is not implemented. DT
> bindings selectively allow to overwrite stored Si5351 configuration
> which is very helpful for clock generators with empty eeprom
> configuration. Corresponding device tree binding documentation is
> also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Notes:
> - During development I used a debugfs clock consumer that I can also
>   post if there is interest in it.

Please do.  I have a set of patches that implement a fake clock subtree
for testing the core framework.  I've been thinking of pushing this to
the list once it is more presentable and your work might fit into that
nicely.

> - With current (3.8-rc6) common clock framework there is two (minor)
>   issues:
>   * although clocks are registered with devm_clk_register they are not
>     removed from the clock tree on unloading. That makes reloading of
>     clk-si5351 as module impossible.

This is a known issue.  clk_unregister is a NOP and defining it has
always been deferred until the day that someone needed it.  Care to
take a crack at it?

>   * potentially there could be more than one different external si5351
>     generators but clocks are registered with names that do not refer
>     to e.g. the device name. Maybe common clock framework should
>     prepend the device name for each registered clock, i.e. 0-0060.clk0.
>     That would also avoid name collisions with same clock names from
>     different drivers (clk0 is likely to be used by others ;))

More unfinished work, just like clk_unregister above.  I'm sure you are
aware that clk_register takes struct device *dev as input, but does
nothing with it.  It wouldn't take much to concatenate the device name
and clock name if dev is present.  However a complication here is that
the registration code takes a parent string name to match parents up for
discrete subtrees; how could statically defined data know about the
device name ahead of time?

The above design decision took place before the big DT push we have
today and was short-sighted.  It would be better to change the framework
to rely less on string name lookups and DT is one way out of that.

3.8-rc7 is already out and I don't plan to take anything that hasn't
already been submitted for 3.9 now.  Can you resubmit this after 3.9-rc1
comes out?

Thanks,
Mike
