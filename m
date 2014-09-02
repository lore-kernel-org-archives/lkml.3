Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaIBIPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:15:32 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58363 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaIBIPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:15:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com,
        linux-samsung-soc@vger.kernel.org, broonie@kernel.org,
        thomas.ab@samsung.com, chow.kim@samsung.com
Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Tue, 02 Sep 2014 10:14:57 +0200
Message-ID: <3109076.4UMHArqVbl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140902080516.GE17117@lee--X1>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com> <3343901.7HpqcTBEp1@wuerfel> <20140902080516.GE17117@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YDDK1hE9oo1vMl4YnWXobOS8l18Ciqk4OpUCQ3BKiAX
 guJYYoEsabN2KtWPxZM3wGMaiIcKR/lRms9Y/FMWypi/8aonTu
 Kr9qashgCzAPLI8kqTzthowEUH+UewHBonWparBjsWL/eUiex6
 R3gKpy7Q+NkzdAwqBRP7bm5HbIH1PjgjgZwaNoTRmJssbF2Z9a
 9srYTDZiVK9QEmoNLw6v0HEvGAVEI/wesLIam50H9aF9j/xgWk
 nTT345iHr6LaTUvgibEsC/B1+V3xwI5pUewAAJQnNF2q9Sc65N
 f011T91/OGEuuwtQE3zcG1PljQnAAmiCKqfdpUG//XB6ap+XVw
 oQbcookjrxo0svnVePsw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2014 09:05:16 Lee Jones wrote:
> On Mon, 01 Sep 2014, Arnd Bergmann wrote:
> 
> > On Monday 01 September 2014 17:04:26 Lee Jones wrote:
> > > On Mon, 01 Sep 2014, Arnd Bergmann wrote:
> > > > Maybe I'm misreading the patch, but I don't see how it creates a
> > > > migration path. What I want to end up with is infrastructure that
> > > > lets anybody call syscon_regmap_lookup_by_pdevname or
> > > > syscon_regmap_lookup_by_compatible (if they really need to)
> > > > without needing the platform_driver for syscon. That should not
> > > > require any form of compatibility layer because to the driver
> > > > using it there is no API change.
> > > 
> > > Somehow I think the likelyhood is that I am misreading the patch.
> > > 
> > > I thought that before this patch drivers we had to register a syscon
> > > device to bind to this driver, which was fine for the first use-cases
> > > of syscon as it wasn't required too early during boot.  However, now
> > > there are use-cases where systems require access to syscon registers
> > > eariler in boot we require a means to obtain access prior to device
> > > probing.  I thought this patch not only provides that possibilty, but
> > > also leaves in the ability to register direct from DT.
> > 
> > Right, it does provide the ability to have syscon before devices
> > are registered, I missed that part.
> > 
> > > > In contrast, this patch introduces a new of_syscon_{un,}register()
> > > > interface that would get removed after the the above has
> > > > been implemented, causing extra churn for any driver that also
> > > > wants to provide a regmap-like interface.
> > > 
> > > When will we ever not have to register syscon?
> > 
> > The idea is that we implicitly register the syscon block when someone
> > calls syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> > and then return a reference to that new syscon. When another driver
> > looks up the same device node, we just pass a reference to the existing
> > syscon.
> 
> Doesn't sound too unreasonable.  So how about instead of exporting
> these new of_syscon_{un,}register() calls, we make them static and
> call them from syscon_regmap_lookup_by_{phandle,compatible}?

Yes, that would be a good start. We should think about whether we want
to remove the existing DT probing at the same time, since it becomes
unused, and we might want to move the code to drivers/base/regmap_*.c
at some point.

	Arnd
