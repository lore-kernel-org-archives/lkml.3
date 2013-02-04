Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3BDRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:24:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab3BDRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:24:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Mon, 4 Feb 2013 17:24:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        benh@kernel.crashing.org, alan@lxorguk.ukuu.org.uk,
        geert@linux-m68k.org, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
In-Reply-To: <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302041724.47331.arnd@arndb.de>
X-Provags-ID: V02:K0:e1AeGQapTYcy4iPaZsKdJDeV4WhOvS3NKvoxdPivHNL
 vu8iS02AlZsC1ecE4lolMIcvRV0/gTQj5CAGjGI0E44GYXP1kc
 C+Um5D6mK0CRSYpQYvcA0FuNOXulTn4HyaeamnA1HTrvgmYuRy
 wwpxxPjkqnEbtqkgK4OyIzH1OcloooB2edzvEfWn6lq1YJzOWQ
 S/YqKyE80e20mf8BUYGBmR6jLtefLRAIgHZMVX+LtgmO1oOPS+
 ovNZhyym4rTk79c9rl3o5W+CtOGXzqzfYGhoZdn5mlAAqvzPCx
 2VNZSMqv/T6HX5l8JEEiN8YIWmub+EM0tYSYgWaGeNpwiMKp5n
 xLYnfwKO/nlpdXAHlkoc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013, Michal Simek wrote:
> >
> > and select the CONFIG_FOO_BIG_ENDIAN and CONFIG_FOO_LITTLE_ENDIAN
> > symbols in Kconfig based on the system you are building for.
> 
> Using CONFIG_FOO_BIG/LITTLE is not good because it is just another
> Kconfig option.
> You can easily detect it at runtime and for dedicated hw with fixed
> endians you can just
> handle it in the driver and don't care about global setting.

The configuration option should not be visible, so it's
not something a user would have to worry about. It's just
sometimes nicer to express the configuration of the platform
in terms of Kconfig syntax than it is in C code if you have
complex platform dependencies.

> > This of course gets further complicated if you require different
> > accessors per architecture, like ARM wanting readl or ioread32
> > and PowerPC wanting in_le32 for a little-endian SoC component.
> 
> FYI: I have got two responses on linux-arch from Alan
> "Set the pointers up and pass them as data with your platform device, that
> way the function definitions are buried in your platform code where they
> depend."
> 
> and Geert:
> "Or embed a struct io_ops * in struct device, to be set up by the bus driver?
> 
> Wasn't David Hinds working on something like this in the context of PCMCIA
> a few decades ago?"
> 
> Based on their suggestions one way can be to pass it through void *platform_data
> which is probably not the best and then which make more sense to me is to extend
> struct dev_archdata archdata to add there native read/write functions.
> 
> What do you think?

I worry a little about code size if we have a lot of drivers that go
from one instruction to an indirect function call for each readl/writel.
Using platform_data ss also something that does not work too well with
device tree based platform configuration, which tries hard to leave
all run-time configuration inside of the driver.

	Arnd
