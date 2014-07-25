Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbaGYPlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:41:16 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:36091 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753240AbaGYPlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:41:11 -0400
Message-ID: <1406302856.17726.18.camel@hornet>
Subject: Re: [PATCH 4/5] [SCSI] Do not use platform_bus as a parent
From: Pawel Moll <pawel.moll@arm.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Fri, 25 Jul 2014 16:40:56 +0100
In-Reply-To: <1406299616.1789.13.camel@jarvis.lan>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
	 <1406299616.1789.13.camel@jarvis.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 15:46 +0100, James Bottomley wrote:
> On Fri, 2014-07-25 at 15:23 +0100, Pawel Moll wrote:
> > The host devices without a parent were "forcefully adopted"
> > by platform bus. This patch removes this assignment. In
> > effect the dev_dev may be NULL now, which means ISA.
> > 
> > Cc: James E.J. Bottomley <JBottomley@parallels.com>
> > Cc: linux-scsi@vger.kernel.org
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> > 
> > This patch is a part of effort to remove references to platform_bus
> > and make it static.
> > 
> > James, could you please have a look and advice if the change is
> > correct? Would you happen to know the "real reasons" behind
> > using the root platform_bus device a parent?
> 
> Yes, for DMA purposes, the parent cannot now be NULL; we'll get a panic
> in the DMA transfers if it is.  

That's what I though at the beginning as well, but then I crawled
through get_dma_ops(struct device *dev) and it seems that on most
architectures (all but two, if I remember correctly) it will return a
default set of DMA ops if the dev == NULL, eg.

static inline struct dma_map_ops *get_dma_ops(struct device *dev)
{
#ifndef CONFIG_X86_DEV_DMA_OPS
        return dma_ops;
#else
        if (unlikely(!dev) || !dev->archdata.dma_ops)
                return dma_ops;
        else
                return dev->archdata.dma_ops;
#endif 
}

in arch/x86/include/asm/dma-mapping.h. Now, there seem to be only a
handful of places where dev_dma is dereferenced: scsi_dma_map and
scsi_dma_unmap in drivers/scsi/scsi_lib_dma.c, where all the calls seem
to be "NULL resistant" and __scsi_alloc_queue in __scsi_alloc_queue
which will oops as you said.

Anyway, if you are saying that dev_dma must not be NULL at any
circumstances, I'll either have to find some kind of replacement for
platform_bus or convince Greg that platform_bus must not be made
static ;-)

> A lot of the legacy ISA device on x86
> and I thought some ARM SOC devices don't pass in the parent device, so
> we hang them off a known parent.

That's another thing I'm not sure - once assigned, is the dma_dev
related to the parent in any way? Even more - is the shost_gendev.parent
used at all? Doesn't seem to be. If it's only about a place in the
device model hierarchy, leaving parent as NULL will make such device a
virtual one, which it probably should be...

Paweł

