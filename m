Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3A3OgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:36:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3A3OgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:36:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, benh@kernel.crashing.org
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Wed, 30 Jan 2013 15:36:10 +0100
Message-ID: <1781360.cmQWHCW5SC@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-1-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <CAHTX3d+B4_u4zG+iGnGMuRj4Zt8WCUS32apwhFVJen0JtzcRfA@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <51090DB5.7050203@synopsys.com> <CAHTX3d+B4_u4zG+iGnGMuRj4Zt8WCUS32apwhFVJen0JtzcRfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PCFFsJnqO/uzhfBVem4qIdCG4AN/4iZtOhue7WcTa4o
 La5k7jJd+XzRdUyEjKyt1yRmTKnMkMxb+4AIZrSEUc0pwiYSPa
 SOLrpVTYgNz+xVYB6NmI2Gg8h1p+GbEmGcxa5JVzJh0oA0zN1S
 ju2uGV7IZEJm5O5hW/ba6azHsGMAQCJOu4JVsfBgNK85SeKTx3
 NbiT9IJeSz0WKAWtO0wjFLEXAniB3S7tbuC0v3tEbXeTAwBEkW
 2Mu8Zn12oYewx04MB9JhCYRC/SRjn6o4agB0hU8rlWAJROeU/3
 KCvsBYd2VuNJxOldOHL0VAlmhew/qV7DgFD2IJ56D5U1i/BAcX
 38x/AL8Y95V394pJ8Hps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 13:31:58 Michal Simek wrote:
> Also from my understanding of arm we should use readl/b/w functions because
> they have memory barriers which should be probably performed.
> 
> And I haven't found any IO function which will behave on arm as LE and
> on PPC as BE.

There are none, except for the __raw_ versions that are generally
not recommended for other reasons.

There really is no easy solution, because most of the hardware IP
blocks have fixed endianess, e.g. an OHCI USB controller will normally
have little-endian registers on all architectures, but in very rare
cases it may be big-endian, because some hardware designer tried to
be helpful and put a byte swapping logic in front of it.

There are a few devices that tend to have the same endianess as the
CPU, again because some hardware designer tried to make things easy
for software by making the hardware confiurable. Again, what normally
happens is that the next hardware designer takes this block and 
hardwires it to some endianess that he sees as "correct" but puts
it on a system with a variable-endian CPU. Note that there are both
little-endian PowerPC systems and big-endian ARM systems, they just
happen to be the minority on an architecture where 99% of the users
prefer the opposite.

The outcome is basically you're screwed for every driver that is
not fixed endianess. The normal workaround is to do something like

#if defined(CONFIG_FOO_BIG_ENDIAN) && !defined(CONFIG_FOO_LITTLE_ENDIAN)
/* always big-endian
#define foo_readl(dev, reg) ioread32_be(dev->regs + reg)
#define foo_writel(dev, reg, val) iowrite32_be(val, dev->regs + reg)
#elif !defined(CONFIG_FOO_BIG_ENDIAN) && defined(CONFIG_FOO_LITTLE_ENDIAN)
/* always little-endian
#define foo_readl(dev, reg) ioread32(dev->regs + reg)
#define foo_writel(dev, reg, val) iowrite32e(val, dev->regs + reg)
#else
/* run-time configured */
#define foo_readl(dev, reg) dev->readl(dev->regs + reg)
#define foo_writel(dev, reg, val) dev->writel(val, dev->regs + reg)
#endif

and select the CONFIG_FOO_BIG_ENDIAN and CONFIG_FOO_LITTLE_ENDIAN
symbols in Kconfig based on the system you are building for.

This of course gets further complicated if you require different
accessors per architecture, like ARM wanting readl or ioread32
and PowerPC wanting in_le32 for a little-endian SoC component.

	Arnd
