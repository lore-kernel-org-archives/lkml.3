Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbbARKzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:55:10 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54986 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbARKzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:55:06 -0500
Message-ID: <54BB9100.7000506@samsung.com>
Date: Sun, 18 Jan 2015 11:54:56 +0100
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Paul Osmialowski <p.osmialowsk@samsung.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Michael Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC 1/3] i2c: Enhancement of i2c API to address circular lock
 dependency problem
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com> <CA+Ln22GrsCj0291dVccFPzPW8pmxyc8JHtPo5ijsAdDXw6RC1Q@mail.gmail.com>
In-Reply-To: <CA+Ln22GrsCj0291dVccFPzPW8pmxyc8JHtPo5ijsAdDXw6RC1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18.01.2015 o 07:30, Tomasz Figa pisze:
> Hi,
>
> [CCing more people]
>
> 2015-01-16 23:39 GMT+09:00 Paul Osmialowski <p.osmialowsk@samsung.com>:
>> This enhancement of i2c API is designed to address following problem
>> caused by circular lock dependency:
>>
>> -> #1 (prepare_lock){+.+.+.}:
>> [    2.730502]        [<c0061e50>] __lock_acquire+0x3c0/0x8a4
>> [    2.735970]        [<c0062868>] lock_acquire+0x6c/0x8c
>> [    2.741090]        [<c04a2724>] mutex_lock_nested+0x68/0x464
>> [    2.746733]        [<c0395e84>] clk_prepare_lock+0x40/0xe8
>> [    2.752201]        [<c0397698>] clk_unprepare+0x18/0x28
>> [    2.757409]        [<c034cbb0>] s3c24xx_i2c_xfer+0xc8/0x124
>> [    2.762964]        [<c03457e0>] __i2c_transfer+0x74/0x8c
>> [    2.768259]        [<c0347234>] i2c_transfer+0x78/0xec
>> [    2.773380]        [<c02a177c>] regmap_i2c_read+0x48/0x64
>> [    2.778761]        [<c029d5c0>] _regmap_raw_read+0xa8/0xfc
>> [    2.784230]        [<c029d920>] _regmap_bus_read+0x28/0x48
>> [    2.789699]        [<c029ce00>] _regmap_read+0x74/0xdc
>> [    2.794819]        [<c029d0ec>] _regmap_update_bits+0x24/0x70
>> [    2.800549]        [<c029e348>] regmap_update_bits+0x40/0x5c
>> [    2.806190]        [<c024c3c4>] _regulator_do_disable+0x68/0x7c
>> [    2.812093]        [<c024f4d8>] _regulator_disable+0x90/0x12c
>> [    2.817822]        [<c024f5a8>] regulator_disable+0x34/0x60
>> [    2.823377]        [<c0363070>] mmc_regulator_set_ocr+0x74/0xdc
>> [    2.829279]        [<c03783e8>] sdhci_set_power+0x38/0x20c
>> [    2.834748]        [<c0379c10>] sdhci_do_set_ios+0x180/0x450
>> [    2.840389]        [<c0379f00>] sdhci_set_ios+0x20/0x2c
>> [    2.845597]        [<c0364978>] mmc_set_initial_state+0x5c/0xbc
>> [    2.851500]        [<c0364f48>] mmc_power_off+0x2c/0x60
>> [    2.856708]        [<c0365c00>] mmc_rescan+0x268/0x27c
>> [    2.861829]        [<c003a128>] process_one_work+0x18c/0x3f8
>> [    2.867471]        [<c003a400>] worker_thread+0x38/0x2f8
>> [    2.872766]        [<c003f66c>] kthread+0xe4/0x104
>> [    2.877540]        [<c000f0a8>] ret_from_fork+0x14/0x2c
>> [    2.882749]
>> -> #0 (&map->mutex){+.+...}:
>> [    2.886828]        [<c0061224>] validate_chain.isra.25+0x3bc/0x548
>> [    2.892990]        [<c0061e50>] __lock_acquire+0x3c0/0x8a4
>> [    2.898459]        [<c0062868>] lock_acquire+0x6c/0x8c
>> [    2.903580]        [<c04a2724>] mutex_lock_nested+0x68/0x464
>> [    2.909222]        [<c029ce9c>] regmap_read+0x34/0x5c
>> [    2.914257]        [<c039a994>] max_gen_clk_is_prepared+0x1c/0x38
>> [    2.920333]        [<c0396ec4>] clk_unprepare_unused_subtree+0x64/0x98
>> [    2.926842]        [<c0396f78>] clk_disable_unused+0x80/0xd8
>> [    2.932484]        [<c00089d0>] do_one_initcall+0xac/0x1f0
>> [    2.937953]        [<c068bd44>] do_basic_setup+0x90/0xc8
>> [    2.943248]        [<c068be00>] kernel_init_freeable+0x84/0x120
>> [    2.949150]        [<c0491248>] kernel_init+0x8/0xec
>> [    2.954097]        [<c000f0a8>] ret_from_fork+0x14/0x2c
>> [    2.959307]
>> [    2.959307] other info that might help us debug this:
>> [    2.959307]
>> [    2.967293]  Possible unsafe locking scenario:
>> [    2.967293]
>> [    2.973194]        CPU0                    CPU1
>> [    2.977708]        ----                    ----
>> [    2.982221]   lock(prepare_lock);
>> [    2.985520]                                lock(&map->mutex);
>> [    2.991248]                                lock(prepare_lock);
>> [    2.997063]   lock(&map->mutex);
>> [    3.000276]
>> [    3.000276]  *** DEADLOCK ***
>>
>> Apparently regulator and clock try to acquire lock which is protecting the
>> same regmap. Communication over i2c requires clock to be started. Both things
>> require access to the same regmap in order to complete.
>
> I stumbled upon this issue (and reported it) quite long time ago
> already, but apparently nobody cared too much (including myself,
> unfortunately). Please see [1] for details.
>
> [1] https://lkml.org/lkml/2014/7/2/171
>
> We have here a typical ABBA deadlock scenario, between I2C clock
> providers and other (logical) devices on the same (physical) I2C
> device, for which a regmap is used to share the registers between
> drivers. Remaining factor here is I2C controller driver, which must
> perform clock gating in I2C ops to trigger this deadlock.
>
> The problem is that any operation on such I2C clock will first try to
> acquire clk_prepare_mutex and then, through driver's callback, access
> the regmap, acquiring its mutex (then an I2C transfer will happen, but
> it irrelevant in this context). On opposite side we have drivers for
> other functionality exposed by this I2C device, which will access the
> regmap, acquiring its mutex and causing I2C transfers to happen.
>
> The key here is that I2C transfers might require some clocks to be
> prepared, so clk_prepare() might get called from this context and
> cause a deadlock, because clk_prepare_mutex might have been already
> acquired by another context, waiting for regmap mutex, which has been
> already acquired by this context.
>
> Now, for the solution, the approach proposed by Paul, as far as I
> could understand it by reading the code (it's definitely lacking a
> cover letter with detailed explanation), should solve the issue by
> enforcing correct locking order at regmap level. However I wonder if
> we really need a heavy solution like this or we could just make I2C
> drivers not require clock preparation in I2C transfers, as suggested
> by Peter De Schrijver in [1], which should fix the issue as well.
>
> So, the question is, do we actually have hardware that _really_
> requires _actual_ preparation or all the clk_prepare_enable()s in I2C
> drivers (at least in i2c-s3c2410) are just to simplify the code?


Hi Tomasz,

I completely forgot that you already thought about this deadlock in 2014. I 
think we can try the no-prepare way for i2c-s3c2410. However this would be 
only workaround for specific chip. Other buses (like SPI) would require 
similar changes.

I wondered why this was not observed (at least not observed by me with 
lockdep) on Gear 2 (Rinato) board. This is quite similar case: the S2MPS14 
PMIC provides regulators and 32kHz clocks. I think it is exactly the same 
pattern as for max77686... but somehow lockdep never reported that deadlock 
there.

Anyway thanks for pointing out old discussion.

Best regards,
Krzysztof

>
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

