Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaGMTRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:17:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaGMTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:17:32 -0400
Date: Sun, 13 Jul 2014 12:22:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Weinberger <richard@nod.at>, dmitry.torokhov@gmail.com,
        linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        thierry.reding@gmail.com, Lennox Wu <lennox.wu@gmail.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
Message-ID: <20140713192202.GA19090@kroah.com>
References: <53C1F7DE.3060102@gmail.com>
 <201407130545.23004.marex@denx.de>
 <CAF0htA60juBVkPo2HQKMDGcEr-wRzRVL_6JgHAa+7WVE_E8M0Q@mail.gmail.com>
 <53C25551.1050909@nod.at>
 <53C288F0.3070001@metafoo.de>
 <53C28C4A.70907@nod.at>
 <53C29015.5070607@metafoo.de>
 <53C291C8.6050303@nod.at>
 <53C296C2.30304@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C296C2.30304@metafoo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 04:25:06PM +0200, Lars-Peter Clausen wrote:
> On 07/13/2014 04:03 PM, Richard Weinberger wrote:
> >Am 13.07.2014 15:56, schrieb Lars-Peter Clausen:
> >>On 07/13/2014 03:40 PM, Richard Weinberger wrote:
> >>>Am 13.07.2014 15:26, schrieb Lars-Peter Clausen:
> >>>>On 07/13/2014 11:45 AM, Richard Weinberger wrote:
> >>>>>Am 13.07.2014 11:27, schrieb Lennox Wu:
> >>>>>>As I said before, some configurations don't make sense.
> >>>>>
> >>>>>If such a configuration can be achieved using allmod/yesconfig it has to be fixed.
> >>>>>Chen's fixes seem reasonable as not all architectures support iomem.
> >>>>
> >>>>Maybe we should stub out ioremap() and friends when COMPILE_TEST is enabled to avoid these linker errors. That's in my opinion better than turning most of the 'depends on
> >>>>COMPILE_TEST' into 'depends on COMPILE_TEST && HAS_IOMEM'. The issue comes up quite a lot and it is often overlooked when adding a driver that can be build when COMPILE_TEST is
> >>>>enabled.
> >>>
> >>>And what should this stub do?
> >>>Except calling BUG()...
> >>
> >>return NULL;
> >>
> >>It's for compile testing, it's not meant to work at runtime.
> >
> >Hm, I really don't like the idea of having a non-working kernel.
> >IMHO either it should build _and_ run and nothing else.
> >Greg, what do you think?
> 
> The kernel will still be working fine and you can run it on a system. The
> drivers which use ioremap() or similar are probably not instantiated on a
> system that does not provide HAS_IOMEM. But even if it was the driver should
> handle ioremap() returning NULL gracefully and abort the driver probe. That
> said you'll probably not run a kernel that was built with COMPILE_TEST on
> your real hardware since it contains so many drivers that are completely
> useless on your hardware. The idea of COMPILE_TEST is to have as much
> compile test exposure as possible to the code that is enabled by
> COMPILE_TEST. Stubbing out ioremap() and friends when HAS_IOMEM is not set
> and COMPILE_TEST is set makes it easier to get there.

I run my kernels with COMPILE_TEST enabled as I need to build test
things that I don't happen to use.

I like the 'return NULL' option for this, it hits us all the time, might
as well fix it properly like this so that we don't have to deal with
Kconfig changes everywhere.

Also put a big "This platform does not support IOMEM" error printk in
there, so that people have a chance to figure out what is going on if
they happen to run such a driver on a platform that can't support it.

thanks,

greg k-h
