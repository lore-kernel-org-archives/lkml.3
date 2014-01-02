Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaABLM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:12:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaABLM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:12:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Xiubo Li <Li.Xiubo@freescale.com>, thierry.reding@gmail.com,
        shawn.guo@linaro.org, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, Alison Wang <b18965@freescale.com>,
        linux-kernel@vger.kernel.org, Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv8 1/4] pwm: Add Freescale FTM PWM driver support
Date: Thu, 02 Jan 2014 12:12:50 +0100
Message-ID: <3716216.GQHQhxMFvx@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1388656624-26570-2-git-send-email-Li.Xiubo@freescale.com>
References: <1388656624-26570-1-git-send-email-Li.Xiubo@freescale.com> <1388656624-26570-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1YRYQ4En3go5DimOZZ/HCWKb8Rr1Pm0h8rNTpU9Tov4
 S5vpWqpc7Rp0mV7usBWPrMQKnkXS6Jnqqkj+NJNmlmOvXFLGyn
 2ErQ8t1Y8QmU6KIQntmK7gFrwGPfdUzZdEiY+LHazNk0lLfMPQ
 8glaIbI3dcm5Q7SISMWRT+UIbo9qU64j6yYtal/nsblLRRyNC2
 vVtHSQdnhUwRtnKE9HU9DQC+r1+OJ/sYS2lFOC1Ea5h2yrCmy9
 3fJuPtQS3RjRFn6hyImUThaXi+vIioTcOvFd4ic7kxruLb8ZhM
 CyDejiOLxanjLraDOaT3DaCNNhvNlZl0lYn9p3t7drCXfFCuhG
 HaZwVxOTmtq8DA5aV38s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014 17:57:01 Xiubo Li wrote:
> +static inline u32 ftm_readl(bool big_endian, const void __iomem *addr)
> +{
> +       u32 val;
> +
> +       val = __raw_readl(addr);
> +
> +       if (likely(big_endian))
> +               val = be32_to_cpu((__force __be32)val);
> +       else
> +               val = le32_to_cpu((__force __le32)val);
> +       rmb();
> +
> +       return val;
> +}
> +
> +static inline void ftm_writel(bool big_endian, u32 val, void __iomem *addr)
> +{
> +       wmb();
> +       if (likely(big_endian))
> +               val = (__force u32)cpu_to_be32(val);
> +       else
> +               val = (__force u32)cpu_to_le32(val);
> +
> +       __raw_writel(val, addr);

These functions definitely need some comments regarding why this is necessary.
I assume that after 8 rounds of review (that I did not read) this has been
discussed already, so please explain above the functions why you don't just
use ioread32be/ioread32 and iowrite32be/iowrite32 here.

Also all callers seem to be of the style

       val = ftm_readl(fpc->big_endian, fpc->base + FTM_SC);

so I wonder why you don't just pass the fpc pointer to the function
and make it

static inline void ftm_readl(struct fsl_pwm_chip *fpc, unsigned long reg, u32 val)
{
	if (fpc->big_endian)
		iowrite32be(val, fpc->base + reg);
	else
		iowrite32(val, fpc->base + reg);
}

	Arnd
