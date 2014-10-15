Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaJOKal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:30:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaJOKaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:30:39 -0400
Date: Wed, 15 Oct 2014 12:30:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/8] power_supply: Add API for safe access of power
 supply function attrs
Message-ID: <20141015103036.GA14266@amd>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
 <1413289246-31650-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413289246-31650-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-10-14 14:20:39, Krzysztof Kozlowski wrote:
> Add simple wrappers for accessing power supply's function attributes:
>  - get_property -> power_supply_get_property
>  - set_property -> power_supply_set_property
>  - property_is_writeable -> power_supply_property_is_writeable
>  - external_power_changed -> power_supply_external_power_changed
>  - set_charged -> power_supply_set_charged
> 
> This API adds a safe way of accessing a power supply from another
> driver. Particularly it solves invalid memory references (and lockup) in
> following race condition scenario:
> 
> Thread 1: charger manager
> Thread 2: power supply driver, used by charger manager
> 
> THREAD 1 (charger manager)         THREAD 2 (power supply driver)
> ==========================         ==============================
> psy = power_supply_get_by_name()
>                                    Driver unbind, .remove
>                                      power_supply_unregister
>                                      Device fully removed
> psy->get_property()
> 
> The 'get_property' callback is still valid and leads to actual calling of
> Thread2->get_property() but now in invalid context because the driver was
> unbound.
> 
> This could be observed easily with charger manager driver (here compiled
> with max17042 fuel gauge):
> $ echo "12-0036" > /sys/bus/i2c/drivers/max17042/unbind
> $ cat /sys/devices/virtual/power_supply/battery/temp
> [  240.505998] INFO: task cat:1394 blocked for more than 120 seconds.
> [  240.510762]       Not tainted 3.17.0-next-20141007-00028-ge60b6dd79570-dirty #183
> [  240.518208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.526025] cat             D c0469548     0  1394      1 0x00000000
> [  240.532384] [<c0469548>] (__schedule) from [<c0469d54>] (schedule_preempt_disabled+0x14/0x20)
> [  240.540885] [<c0469d54>] (schedule_preempt_disabled) from [<c046af20>] (mutex_lock_nested+0x1bc/0x458)
> [  240.550171] [<c046af20>] (mutex_lock_nested) from [<c0287a98>] (regmap_read+0x30/0x60)
> [  240.558079] [<c0287a98>] (regmap_read) from [<c032238c>] (max17042_get_property+0x2e8/0x350)
> [  240.566490] [<c032238c>] (max17042_get_property) from [<c0324b60>] (charger_get_property+0x238/0x31c)
> [  240.575688] [<c0324b60>] (charger_get_property) from [<c0320764>] (power_supply_show_property+0x48/0x1e0)
> [  240.585241] [<c0320764>] (power_supply_show_property) from [<c027308c>] (dev_attr_show+0x1c/0x48)
> [  240.594100] [<c027308c>] (dev_attr_show) from [<c0141fb0>] (sysfs_kf_seq_show+0x84/0x104)
> [  240.602251] [<c0141fb0>] (sysfs_kf_seq_show) from [<c0140b18>] (kernfs_seq_show+0x24/0x28)
> [  240.610497] [<c0140b18>] (kernfs_seq_show) from [<c0104574>] (seq_read+0x1b0/0x484)
> [  240.618138] [<c0104574>] (seq_read) from [<c00e1e24>] (vfs_read+0x88/0x144)
> [  240.625127] [<c00e1e24>] (vfs_read) from [<c00e1f20>] (SyS_read+0x40/0x8c)
> [  240.631941] [<c00e1f20>] (SyS_read) from [<c000e760>] (ret_fast_syscall+0x0/0x48)
> 
> Or:
> [   17.277605] Division by zero in kernel.
> [   17.280043] CPU: 2 PID: 1384 Comm: cat Not tainted 3.17.0-next-20141007-00028-ge60b6dd79570-dirty #181
> [   17.289348] [<c00140f0>] (unwind_backtrace) from [<c0011228>] (show_stack+0x10/0x14)
> [   17.297055] [<c0011228>] (show_stack) from [<c04680d0>] (dump_stack+0x70/0xbc)
> [   17.304264] [<c04680d0>] (dump_stack) from [<c01f7a28>] (Ldiv0+0x8/0x10)
> [   17.310933] [<c01f7a28>] (Ldiv0) from [<c01f79f8>] (__aeabi_uidivmod+0x8/0x18)
> [   17.318132] [<c01f79f8>] (__aeabi_uidivmod) from [<c0287a84>] (regmap_read+0x1c/0x60)
> [   17.325956] [<c0287a84>] (regmap_read) from [<c0322260>] (max17042_get_property+0x1bc/0x350)
> [   17.334361] [<c0322260>] (max17042_get_property) from [<c0324734>] (charger_get_property+0x198/0x328)
> [   17.343560] [<c0324734>] (charger_get_property) from [<c0320764>] (power_supply_show_property+0x48/0x1e0)
> [   17.353108] [<c0320764>] (power_supply_show_property) from [<c03209d4>] (power_supply_uevent+0x9c/0x1c4)
> [   17.362575] [<c03209d4>] (power_supply_uevent) from [<c02745d0>] (dev_uevent+0xb8/0x1c8)
> [   17.370639] [<c02745d0>] (dev_uevent) from [<c0272c4c>] (uevent_show+0xa8/0x104)
> [   17.378015] [<c0272c4c>] (uevent_show) from [<c027308c>] (dev_attr_show+0x1c/0x48)
> [   17.385579] [<c027308c>] (dev_attr_show) from [<c0141fb0>] (sysfs_kf_seq_show+0x84/0x104)
> [   17.393731] [<c0141fb0>] (sysfs_kf_seq_show) from [<c0140b18>] (kernfs_seq_show+0x24/0x28)
> [   17.401979] [<c0140b18>] (kernfs_seq_show) from [<c0104574>] (seq_read+0x1b0/0x484)
> [   17.409619] [<c0104574>] (seq_read) from [<c00e1e24>] (vfs_read+0x88/0x144)
> [   17.416557] [<c00e1e24>] (vfs_read) from [<c00e1f20>] (SyS_read+0x40/0x8c)
> [   17.423416] [<c00e1f20>] (SyS_read) from [<c000e760>] (ret_fast_syscall+0x0/0x48)
> [   17.430880] power_supply battery: driver failed to report `voltage_now' property: -22
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
