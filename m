Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3FJRHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:07:45 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:56990 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FJRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:07:44 -0400
MIME-Version: 1.0
X-Originating-IP: [84.115.78.137]
In-Reply-To: <7927838.NMrLdRWptT@pcimr>
References: <CALG0vJu9-640D=Q-2RoSOnWtR=sERwj0fSCibK+ijprcf-T6Ag@mail.gmail.com>
	<7927838.NMrLdRWptT@pcimr>
Date: Mon, 10 Jun 2013 19:07:43 +0200
Message-ID: <CALG0vJtjS2wP_s=-iyG1ABKw_ct=B9OdNXY9YCrnkhAnpaN1Zw@mail.gmail.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
From: Michael Guntsche <michael.guntsche@it-loops.com>
To: Rojhalat Ibrahim <imr@rtschenk.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening,

On Mon, Jun 10, 2013 at 1:41 PM, Rojhalat Ibrahim <imr@rtschenk.de> wrote:
> Hi Mike,
>
> could you please try this patch:
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-May/106624.html
> http://patchwork.ozlabs.org/patch/244515/
>
>    Rojhalat
>
>
> On Saturday 08 June 2013 21:39:37 Michael Guntsche wrote:
>> After bisecting I found the responsible commit.
>>
>> 50d8f87d2b3: powerpc/fsl-pci Make PCIe hotplug work with Freescale
>> PCIe controllers
>>
>> Reverting this commit allowed my board to boot again.
>>
>> @Rojhalat: Please have a look at
>> http://marc.info/?l=linux-kernel&m=137071294204858&w=2
>> for my initial bugreport.
>>
>> What I do not understand at all is why this is affecting my platform.
>> AFAIK there is no PCIe hardware on it AND I completely disabled PCIe
>> support in config.
>>
>> Kind regards,
>> Mike

This patch does not fix the problem, during boot the kernel still
panics. I had a closer look at the commit and the following patch
fixes it for me....

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 028ac1f..21b687f 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -814,7 +814,7 @@ int __init mpc83xx_add_bridge(struct device_node *dev)
                if (ret)
                        goto err0;
        } else {
-               fsl_setup_indirect_pci(hose, rsrc_cfg.start,
+               setup_indirect_pci(hose, rsrc_cfg.start,
                                       rsrc_cfg.start + 4, 0);
        }

Apparently the mpc83xx platform code goes through great lengths to
guard the call to fsl_pcie_check_link on NON PCIe platforms, since
apparently this seems to cause the panic. Furthermore it also has its
own PCIe setup code. With this patch applied the system boots fine for
me.

The only problem I have with this patch is that the compiler fails
since -Werror is used and fsl_setup_indirect_pci now is never used.
For testing purposes I removed the function definition. Obviously the
proper fix would be to wrap it in an #ifdef but I did not know the
proper define to check against.

Kind regards,
Mike
