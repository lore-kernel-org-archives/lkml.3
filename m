Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3FDPhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:37:36 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43336 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3FDPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <6466898.RnYOe3jpGG@wuerfel>
References: <1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com>
 <51A5BA86.3070609@free-electrons.com> <20130530.024201.1913984663902628192.davem@davemloft.net>
 <6466898.RnYOe3jpGG@wuerfel>
From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 4 Jun 2013 16:36:50 +0100
X-Google-Sender-Auth: ve36r1dYVxvWh_bnbd-bCIWIlac
Message-ID: <CAGVrzcbRS3x5fgD1BfOk4-oTUsAY9FA2V621OvZLJQNZ01brCg@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] net: phy: prevent linking breakage
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, alexandre.belloni@free-electrons.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, shawn.guo@linaro.org,
        kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/4 Arnd Bergmann <arnd@arndb.de>:
>> Or you properly segregate the networking bits of the platform code so
>> that it can be built only when the necessary networking portions are
>> enabled.
>>
>> Sometimes having dummy stubs makes sense, but not in this situation.
>
> Currently most users of this function are doing something like
>
> static int foo_phy_fixup(struct phy_device *phydev)
> {
>         ...
> }
>
> static int __init boo_board_init(void)
> {
>          if (IS_BUILTIN(CONFIG_PHYLIB))
>                 phy_register_fixup_for_uid(phy_id, foo_phy_fixup);
> }
>
> which is practically the same as having a dummy stub. It leads to
> the foo_phy_fixup() function always getting compiled and then discarded
> by gcc when CONFIG_PHYLIB is disabled.
>
> The method is currently broken when network drivers are enabled as
> modules, because we are missing the fixup then.
>
> I think we should use IS_ENABLED() here to force a build error
> in that case, and have something like
>
> config ARCH_FOO
>         bool "support for the foo platform"
>         select PHYLIB if NET
>
> in the platform Kconfig file, to ensure PHYLIB is always built-in.
>
> I still think the inline alternatives would be helpful, but using
> if (IS_ENABLED(CONFIG_PHYLIB)) in the platform code would also
> work.

It seems to me that what David proposes is to have say an
arch/arm/mach-foo/phy-fixups.c file which is only enabled when
CONFIG_PHYLIB is set (obj-$(CONFIG_PHYLIB) += phy-fixup.o), such that
it does not need to have any conditionnals when calling
phy_register_fixup. This sounds a little unusual, but why not.
--
Florian
