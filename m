Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaIIM2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:28:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42073 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065AbaIIM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:28:31 -0400
Date: Tue, 9 Sep 2014 13:28:18 +0100
From: Will Deacon <will.deacon@arm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] asm-generic/io.h: Implement read[bwlq]_relaxed()
Message-ID: <20140909122818.GI1754@arm.com>
References: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Sep 09, 2014 at 01:12:40PM +0100, Daniel Thompson wrote:
> Currently the read[bwlq]_relaxed() family are implemented on every
> architecture except blackfin, m68k[1], metag, openrisc, s390[2] and
> score. Increasingly drivers are being optimized to exploit relaxed
> reads putting these architectures at risk of compilation failures for
> shared drivers.
> 
> This patch addresses this by providing implementations of
> read[bwlq]_relaxed() that are identical to the equivalent read[bwlq]().
> All the above architectures include asm-generic/io.h .
> 
> Note that currently only eight architectures (alpha, arm, arm64, avr32,
> hexagon, microblaze, mips and sh) implement write[bwlq]_relaxed() meaning
> these functions are deliberately not included in this patch.
> 
> [1] m68k includes the relaxed family only when configured *without* MMU.
> [2] s390 requires CONFIG_PCI to include the relaxed family.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> ---
>  include/asm-generic/io.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

I have a larger series adding these (and the write equivalents) to all
architectures that I periodically post and then fail to get on top of.

The key part you're missing is defining some generic semantics for these
accessors. Without those, I don't think it makes sense to put them into
asm-generic, because drivers can't safely infer any meaning from the relaxed
definition.

Ben and I agreed on something back in May:

  https://lkml.org/lkml/2014/5/22/468

but I need to send a new version including:

  - ioreadX_relaxed and iowriteX_relaxed
  - Strengthening non-relaxed I/O accessors on architectures with non-empty
    mmiowb()

I'll bump it up the list. In the meantime, you can have a look at my io
branch on kernel.org

Will
