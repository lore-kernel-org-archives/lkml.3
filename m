Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaFQPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:42:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57763 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbaFQPm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:42:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, mark.brown@linaro.org
Cc: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC] mfd: syscon: Decouple syscon interface from syscon devices
Date: Tue, 17 Jun 2014 17:42:14 +0200
Message-ID: <5027740.B7iVUcUX2T@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403019164-12514-1-git-send-email-t.figa@samsung.com>
References: <53A05E2D.6020702@samsung.com> <1403019164-12514-1-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ljmAai3pFpr/9shGRH0ABz96zjyRX9L2WhF6J+AwQjd
 gLc/thJfxI5GgeANECioTWf72wjMFG3mKzCTYOwj/xWMKGxIbk
 QbW3g4fA1ujAK+4REaTrhI+KlMAeT+fQrDRKESOvo4WJkmWPox
 8W8VzBKLR+Fq6nxj/i2T5DEygzw+YObBwZrRVvORoUpfBN/Xbl
 biQlDDznBS2NNL6K8MUnmlsUvOog9bZwTrOXh5m6+CH/KSaxVi
 QKYWL/vkKzwuwEW1v+0Ycg+D6t6RhEffnGrZtw8U7zZfWpvj2S
 ngTvx0IO+5KOrbjqhfTDp8zUNgVpW4bDd4P6B+porNb3GSYhTs
 SvYCrjdBbvgTVWdBv1WA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 17:32:44 Tomasz Figa wrote:
> Currently a syscon entity can be only registered directly through a
> platform device that binds to a dedicated driver. However in certain use
> cases it is desirable to make a device used with another driver a syscon
> interface provider. For example, certain SoCs (e.g. Exynos) contain
> system controller blocks which perform various functions such as power
> domain control, CPU power management, low power mode control, but in
> addition contain certain IP integration glue, such as various signal
> masks, coprocessor power control, etc. In such case, there is a need to
> have a dedicated driver for such system controller but also share
> registers with other drivers. The latter is where the syscon interface
> is helpful.
> 
> This patch decouples syscon object from syscon driver, so that it can be
> registered from any driver in addition to the original "syscon" platform
> driver.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>

Hi Tomasz,

This seems like a reasonable way of solving the problem, but I think
there is an even better one that we have about in the past: if we
promote syscon from a platform driver into a a drivers/base/ helper
that is independent of the platform device matching, we can use
call syscon_regmap_lookup_* for any device node, whether it's already
bound to a driver or not, which do what you need. It would also make
it easier to call the syscon code before the platform_device
infrastructure gets initialized, which is something a number of
people have asked for, e.g. for using regmap to do SMP bringup
or for clock registration.

	Arnd
