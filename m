Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3GEVDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:03:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3GEVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:03:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: MTD EEPROM support and driver integration
Date: Fri, 5 Jul 2013 23:02:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
References: <20130705201118.GM2959@lukather>
In-Reply-To: <20130705201118.GM2959@lukather>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307052302.40588.arnd@arndb.de>
X-Provags-ID: V02:K0:MbAkAIKjd5sPseaNtxRazoFb6n1ZCpkOKcVp6CqBp46
 qFYXlyGdeGE7RjFkOAOc/kaqqtN7aUSYFMuQsNbmrFnX/hhU5g
 OCwG41QBhO/vYKrGauUCbrwMiwgN9j8g7mzSp+mGWCYISohjJF
 kC2k7rJHGZT786/cKh5pLGtY9JZGBeeJmguGXGNpEwVNRgg0ST
 pNAVPuJjv/rTx3aQ3DDzSxq5jlQ3tSgHPnNScaCpXSCQGfa0YD
 +nE8Dzp++MKtvBm7ysh5WutgzIIOzIeifToqbF84XP+YVLXIeH
 A7c9vZzG59XMHLJMchQKtvoW93mp75rqF5PqIv3RVGdXsfzwLX
 q424a01iW6LsMA17O8F4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 July 2013, Maxime Ripard wrote:
> Hi everyone,
> 
> In the last weeks, we've drivers coming up both about mostly some very
> simple drivers that expose to the userspace a few bytes of memory-mapped
> IO. Both will probably live under drivers/misc/eeprom, where there's
> support already for other kind of what could be assimilated as eeproms
> (AT24, AT25, etc.).
> 
> Now, besides the code duplication every driver has to make to register
> the sysfs attributes, it wouldn't cause much of a problem.
> 
> Except that these EEPROMs could store values useful for other drivers in
> Linux. For example:
>   - imx28 OCOTP (the latest of the two EEPROM drivers recently submitted)
>     use it most of the time to store its MAC addresses
>   - Allwinner SoCs SID (the other latest driver submitted) use it
>     sometime to store a MAC address, and also the SoC ID, which could be
>     useful to implement a SoC bus driver.
>   - Some Allwinner boards (and presumably others) use an AT24 to store
>     the MAC address in it.
> 
> For now, everyone comes up with a different solution:
>   - imx28 has a hook in mach-mxs to patch the device tree at runtime and
>     add the values retrieved from the OCOTP to it.
>   - AT24 seem to have some function exported (at24_macc_(read|write)) so
>     that other part of the kernel can use them to retrieve values from
>     such an EEPROM.
>   - Allwinner SoCs have, well, basically nothing for now, which is why I
>     send this email.
> 
> The current way of working has several flaws imho:
>   - The code is heavily duplicated: the sysfs registering is common to
>     every driver, and at the end of the day, every driver should only
>     give a read/write callback, and that's it.
>   - The "consumer" drivers should not have to worry at all about the
>     EEPROM type it should retrieve the needed value from, let alone
>     dealing with the number of instances of such an EEPROM.
> 
> To solve this issues, I think I have some solution. Would merging this
> drivers into MTD make some sense? It seems like there is already some
> EEPROM drivers into drivers/mtd (such as an AT25 one, which also have a
> drivers under drivers/misc/eeprom), so I guess it does, but I'd like to
> have your opinion on this.

I always felt that we should eventually move the eeprom drivers out of
drivers/misc into their own subsystem. Moving them under drivers/mtd
also seems reasonable.

Having a common API sounds like a good idea, and we should probably
spend some time comparing the options.
 
> If so, would some kind of MTD in-kernel API to retrieve values from MTD
> devices would be acceptable to you? I mostly have DT in mind, so I'm
> thinking of having DT bindings to that API such as
> 
>   mac-storage = <&phandle 0xoffset 0xsize>
> 
> to describe which device to get a value from, and where in that device.
> 
> That would allow consumer drivers to only have to call a function like
> of_mtd_get_value and let the MTD subsystem do the hard work.
> 
> What's your feeling on this?

My first thought is that it should be more generic than that and not
have the mac address hardcoded as the purpose. We could possibly use
regmap as the in-kernel interface, and come up with a more generic
way of referring to registers in another device node.

	Arnd
