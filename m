Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaIAOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:25:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49890 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaIAOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:25:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, linux-samsung-soc@vger.kernel.org,
        broonie@kernel.org, thomas.ab@samsung.com, vikas.sajjan@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Mon, 01 Sep 2014 16:24:27 +0200
Message-ID: <12348292.z1qJl96tVA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140901112549.GM7374@lee--X1>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com> <4121644.3haxjiIdIo@wuerfel> <20140901112549.GM7374@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qERyDHGOp8/4GrWJDzhvLRl311yAKqtJ3Tk/E5r2Oyb
 xc/kwp3zGfYTU1YiunS3gjSs59gNFiB3IRPMdkfzfvX1qNr63d
 2pgCVl0xRSXoDlZcZzZ8qa0OeAwtdSGHxbPYiIrovkNICjYC9D
 UpRabNUxmgJ21Ylded73fEdTJ4H/aE6a1n6ndQmjQxJuLhXoRD
 75KRkWrXdDlRpukmeW+hqqn+UAz6mIoOiqahDgIM3mjkmjmaXq
 VTBSP2tlnvk/09zS0Gh4hKIM/tFnjLX6CtsyLQhCC0p41GKN7u
 WSHore0P8vF8FkCfWPfVS064hFzO6EVgY3zFRx/Sy0HNHErrgW
 euavMIbWEHhrnEmMg3bk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 12:25:49 Lee Jones wrote:
> On Mon, 01 Sep 2014, Arnd Bergmann wrote:
> > On Monday 01 September 2014 08:49:18 Lee Jones wrote:
> > > On Fri, 22 Aug 2014, Pankaj Dubey wrote:
> > > 
> > > > From: Tomasz Figa <t.figa@samsung.com>
> > > > 
> > > > Currently a syscon entity can be only registered directly through a
> > > > platform device that binds to a dedicated driver. However in certain use
> > > > cases it is desirable to make a device used with another driver a syscon
> > > > interface provider. For example, certain SoCs (e.g. Exynos) contain
> > > > system controller blocks which perform various functions such as power
> > > > domain control, CPU power management, low power mode control, but in
> > > > addition contain certain IP integration glue, such as various signal
> > > > masks, coprocessor power control, etc. In such case, there is a need to
> > > > have a dedicated driver for such system controller but also share
> > > > registers with other drivers. The latter is where the syscon interface
> > > > is helpful.
> > > > 
> > > > This patch decouples syscon object from syscon driver, so that it can be
> > > > registered from any driver in addition to the original "syscon" platform
> > > > driver.
> > > > 
> > > > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > > ---
> > > > 
> > > > RFC patch [1] was posted by Tomasz Figa. This patch addresses some of
> > > > comments given by Arnd to RFC patch, and further decouples syscon from
> > > > device model. It also gives flexibility of registering with syscon at
> > > > early stage using device_node object.
> > > 
> > > It would be helpful if Arnd gave this revision his blessing (Ack).
> > 
> > I never saw a reason why we don't take this all the way as discussed
> > a few times: Completely remove the dependency of syscon on having
> > a platform driver for it, and make it possible to just call
> > syscon_regmap_lookup_by_phandle() without having to register
> > it first.
> 
> I think this sounds like a good end-state.  Migrating over by
> supporting both methods in this way does sound like the correct thing
> to do though.  Doing so is likely to dramatically reduce the effect on
> current users.

Maybe I'm misreading the patch, but I don't see how it creates a
migration path. What I want to end up with is infrastructure that
lets anybody call syscon_regmap_lookup_by_pdevname or
syscon_regmap_lookup_by_compatible (if they really need to)
without needing the platform_driver for syscon. That should not
require any form of compatibility layer because to the driver
using it there is no API change.

In contrast, this patch introduces a new of_syscon_{un,}register()
interface that would get removed after the the above has
been implemented, causing extra churn for any driver that also
wants to provide a regmap-like interface.

	Arnd
