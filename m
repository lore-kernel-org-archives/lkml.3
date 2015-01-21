Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbbAUPm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:42:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40561 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbAUPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:42:47 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-c4-54bfc863307e
Content-transfer-encoding: 8BIT
Message-id: <1421854963.12894.1.camel@AMDC1943>
Subject: Re: [RFC PATCHv2 00/19] power_supply: Allow safe usage of power supply
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Date: Wed, 21 Jan 2015 16:42:43 +0100
In-reply-to: <20150121152216.GD13715@earth.universe>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
 <20150121152216.GD13715@earth.universe>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7rJJ/aHGPx4a2Ex6cl7ZouJKycz
	W+x8+JbNYvm+fkaLTY+vsVpc3jWHzeJz7xFGi7unjrJZnDl9idXi9O4SBy6PnbPusntsXqHl
	sWlVJ5vH5iX1HluutrN4rFj9nd3j8ya5APYoLpuU1JzMstQifbsEroxlSxQLZipUzP9xga2B
	8alEFyMnh4SAicSUlUeZIWwxiQv31rN1MXJxCAksZZTYcKKNESTBKyAo8WPyPZYuRg4OZgF5
	iSOXskHCzALqEpPmLWKGqP/MKHFyzU1WiHp9iTdflrOB2MIC/hK3X09nArHZBIwlNi9fAhYX
	EVCTeH/pKQtIM7PAPiaJ1Xu3s4MsYBFQlVg/C2wBJ9Bxt/v62EFsIYFCibMzdzGBlEgIKEs0
	9rtNYBSYheS6WQjXzUJy3QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIbHwZQfj4mNW
	hxgFOBiVeHgrQveHCLEmlhVX5h5ilOBgVhLh9TsIFOJNSaysSi3Kjy8qzUktPsTIxMEp1cA4
	73z43+c9TRvVlnp7XrxaZ1F3wMh9BYN3dv+tHM948QjjJTvzd/lu+ZuXNuWW5rKMiDnz2MM9
	v2ZH752akxCyTuroutdnxZtWP73RYvxrn4u17pYd3xZ+yJywca6B1foNqpxzX72NefeyMM3M
	OS05+LHHliVl7H4zrF8+0ObzYtdkOMmaIPhYiaU4I9FQi7moOBEAuNBf02MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2015-01-21 at 16:22 +0100, Sebastian Reichel wrote:
> Hi Krzysztof,
> 
> On Mon, Jan 05, 2015 at 04:47:43PM +0100, Krzysztof Kozlowski wrote:
> > This is RFC, please don't apply yet but let me know if this approach
> > is OK.
> 
> I just reviewed the patchset. It looks fine to me.

Great! Thanks for looking at patchset. I'll start working on next
version adjusting all drivers.

> 
> > TLDR
> > ====
> > Patchset tries to fix following race scenario:
> > 
> > Thread 1: charger manager, CONSUMER
> > Thread 2: power supply driver, PROVIDER
> > 
> > THREAD 1 (charger manager)         THREAD 2 (power supply driver)
> > ==========================         ==============================
> > psy = power_supply_get_by_name()
> >                                    Driver unbind, .remove
> >                                      power_supply_unregister()
> >                                      Device fully removed
> > psy->get_property()
> > 
> > To properly fix the race the patchset:
> > 1. Adds power_supply_get_property()-like API for safe access by consumer.
> > 2. Moves ownership of power_supply structure from driver (provider) to
> >    power supply core.
> > 3. Adds power_supply_put() which will reclaim memory.
> 
> Looks fine to me, thanks for doing this :)
> 
> > Description
> > =========== 
> > This is a little different than my previous approaches [1][2] for fixing
> > usage of power supply by some consumer, if driver implementing it is
> > unbound.
> > 
> > The patchset is quite big and touches power supply API so a lot of
> > changes in drivers are needed. These changes *are not finished yet*.
> > I've done them only for:
> >  - bq24190_charger.c
> >  - charger-manager.c
> >  - max14577_charger.c
> >  - max17040_battery.c
> >  - max17042_battery.c
> >  - sbs-battery.c
> >  - tps65090-charger.c
> > So allyesconfig won't build.
> >
> > If this approach is OK, I'll prepare full patchset changing all the
> > drivers.
> 
> Please do :)
> 
> > My previous approach [1][2] limited the race but did not close it.
> > Still the consumer of power supply by calling power_supply_get_propert(psy...)
> > may reference invalid memory because the producer freed it.
> > 
> > Actually, because struct power_supply is exposed to consumers, the
> > core should be the owner of it. This is accomplished in patch 11/19
> > ("power_supply: Change ownership from driver to core").
> > 
> > What the patchset does in steps
> > ===============================
> > 1. Some preparation steps are necessary - patch 1 and 2. The driver
> >    implementing power supply won't be able to fill structure before
> >    calling power_supply_register(). So 'power_supply_config'
> >    is introduced in patch 2 ("power_supply: Move run-time configuration
> >    to separate structure"). Unfortunately this touches all drivers.
> 
> $ grep -l power_supply_register **/*.c | grep -v mod.c | grep -v drivers/power
> drivers/acpi/ac.c
> drivers/acpi/battery.c
> drivers/acpi/sbs.c
> drivers/hid/hid-input.c
> drivers/hid/hid-sony.c
> drivers/hid/hid-wiimote-modules.c
> drivers/hid/wacom_sys.c
> drivers/platform/x86/compal-laptop.c
> drivers/staging/nvec/nvec_power.c
> 
> Please make sure to CC the respective maintainers for the patchset
> (e.g. current patch 14 and 15 should have CC'd x86 maintainers), so
> that they can Acknowledge the patchset.

Right. Probably maintainers should receive full patchset anyway. The
address list will be quite big.

> 
> > 2. Safe API wrappers (and usage counter) are added (power_supply_*()).
> > 3. Patch 11: ownership of 'struct power_supply' is moved from driver
> >    to the core.
> > 4. power_supply_put() is added which reclaims resources.
> 
> Looks fine to me.
> 
> > The patchset is rebased on next-20141226. It should be pulled at once.
> > Bisectability is preserved.
> 
> Fine with me, but I need acks from all involved maintainers. So for the
> patchset:
> 
> Reviewed-By: Sebastian Reichel <sre@kernel.org>

Thanks!

Best regards,
Krzysztof



