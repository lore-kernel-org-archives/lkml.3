Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaECPDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 11:03:18 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56394 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaECPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 11:03:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, t.figa@samsung.com,
        kgene.kim@samsung.com, linux@arm.linux.org.uk
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
Date: Sat, 03 May 2014 17:02:37 +0200
Message-ID: <13946837.RfnRDPQdge@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yNIcMQdjf1IUSSApkGvk6X9kZiZROjdlRmZoubrmIyC
 CDFesYMRHWvHEcXTbgXyIh6JbarkIhHWNR5ixft0gZ+AaOgCNw
 8b03nFgqQsB+eChiN/UDfZK1C1gFhgjYaFX2glnNuoocJ6NwhP
 e4HBpCRxrBpvGAusfMrAy54JVbmeMPenAWBXuCA0ZF9aYiLeuQ
 GireYvQuHO8A1dSWGyt4t4tqSJnHYr3HTxIVWAhxLKolniMl1N
 bvhJ4VWCozC1fvouTTvCqezg4hdExeUIK0z9UJCBbyNtEsaCHw
 jAhJfUrxHqTP39Itcl8OQLORBaye81ftnjbRDXo/QVviq7tALL
 +iwkGmy+cV0IhHUpU/K4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2014 15:11:36 Pankaj Dubey wrote:
> This patch series attempts to get rid of soc_is_exynosXXXX macros
> and eventually with the help of this series we can probably get
> rid of CONFIG_SOC_EXYNOSXXXX in near future.
> Each Exynos SoC has ChipID block which can give information about
> SoC's product Id and revision number. Currently we have single
> DT binding information for this as "samsung,exynos4210-chipid".
> But Exynos4 and Exynos5 SoC series have one small difference in
> chip Id, with resepect to product id bit-masks. So it means we
> should have separate compatible string for these different series
> of SoCs. So I have created new binding information for handling
> this difference. Also currently I can think of putting this driver
> code under "drivers/misc/" but suggestions are welcome.
> Also current form of driver is missing platfrom driver and needs
> init function to be called from machine file (either exynos.c or
> platsmp.c). I hope lot of suggestions and comments to improve this
> further.
> 
> This patch series is based on Kukjin Kim's for-next (3.14_rc1 tag)
> and prepared on top of following patch series and it's dependent
> patch series.

I think putting it into drivers/soc would be most appropriate.
We already have a few drivers lined up that we want in there,
although the directory currently doesn't exist.

However, I would ask that you use the infrastructure provided by
drivers/base/soc.c when you add this driver, to also make the
information available to user space using a standard API.

Ideally this should be done by slightly restructuring the DT
source to make all on-chip devices appear below the soc node.
We'd have to think a bit about how to best do this while
preserving compatibility with existing dts files.

Regarding patch 4, this is not what I meant when I asked for
removing the soc_is_exynos* macros. You basically do a 1:1 replacement
using a different interface, but you still have code that does
things differently based on a global identification.
The only user left in device drivers is now the cpufreq driver,
which is going to be replaced anyway, so that is ok. Having
a global variable that is accessible to random device drivers
is probably not a good idea though, it will just lead to
bad coding in drivers again.

To give an example of how I think it should really be restructured,
let's look at one function:

static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
        { 76, BIT(1) }, /* RTC alarm */
        { 77, BIT(2) }, /* RTC tick */
        { /* sentinel */ },
};

static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
        { 75, BIT(1) }, /* RTC alarm */
        { 76, BIT(2) }, /* RTC tick */
        { /* sentinel */ },
};

static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
{
        const struct exynos_wkup_irq *wkup_irq;

        if (soc_is_exynos5250())
                wkup_irq = exynos5250_wkup_irq;
        else
                wkup_irq = exynos4_wkup_irq;

	...
}

There are multiple problems with this code:

- As mentioned, you depend on a specific SoC identification for
  something that could be done completely generic.
- The knowledge about what is a wakeup source or not doesn't
  really belong here. We don't have a DT binding for wakeups
  as far as I'm aware of, but this should probably be handled
  locally in the RTC device node, possibly in the node that
  contains the S5P_WAKEUP_MASK register.

	Arnd
