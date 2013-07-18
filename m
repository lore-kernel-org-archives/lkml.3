Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3GRIYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:24:51 -0400
Received: from smtp.multi.fi ([85.134.37.151]:37767 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab3GRIYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:24:47 -0400
X-Greylist: delayed 1175 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jul 2013 04:24:47 EDT
Message-ID: <51E7A0F8.9000308@mageia.org>
Date: Thu, 18 Jul 2013 11:02:00 +0300
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kamal Mostafa <kamal@canonical.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Neil Horman <nhorman@tuxdriver.com>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH 089/145] iommu/vt-d: add quirk for broken interrupt remapping
 on 55XX chipsets
References: <1374101277-7915-1-git-send-email-kamal@canonical.com> <1374101277-7915-90-git-send-email-kamal@canonical.com>
In-Reply-To: <1374101277-7915-90-git-send-email-kamal@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

18.07.2013 01:47, Kamal Mostafa skrev:
> 3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Neil Horman <nhorman@tuxdriver.com>
>
> commit 03bbcb2e7e292838bb0244f5a7816d194c911d62 upstream.
>
> A few years back intel published a spec update:
> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
>
> For the 5520 and 5500 chipsets which contained an errata (specificially errata
> 53), which noted that these chipsets can't properly do interrupt remapping, and
> as a result the recommend that interrupt remapping be disabled in bios.  While
> many vendors have a bios update to do exactly that, not all do, and of course
> not all users update their bios to a level that corrects the problem.  As a
> result, occasionally interrupts can arrive at a cpu even after affinity for that
> interrupt has be moved, leading to lost or spurrious interrupts (usually
> characterized by the message:
> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
>
> There have been several incidents recently of people seeing this error, and
> investigation has shown that they have system for which their BIOS level is such
> that this feature was not properly turned off.  As such, it would be good to
> give them a reminder that their systems are vulnurable to this problem.  For
> details of those that reported the problem, please see:
> https://bugzilla.redhat.com/show_bug.cgi?id=887006
>
> [ Joerg: Removed CONFIG_IRQ_REMAP ifdef from early-quirks.c ]
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Don Dutile <ddutile@redhat.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Asit Mallick <asit.k.mallick@intel.com>
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: linux-pci@vger.kernel.org
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: Arkadiusz Miśkiewicz <arekm@maven.pl>
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>   arch/x86/include/asm/irq_remapping.h |  2 ++
>   arch/x86/kernel/early-quirks.c       | 20 ++++++++++++++++++++
>   drivers/iommu/intel_irq_remapping.c  | 10 ++++++++++
>   drivers/iommu/irq_remapping.c        |  6 ++++++
>   drivers/iommu/irq_remapping.h        |  2 ++
>   5 files changed, 40 insertions(+)
>

This patch introduces this warning on 3.8 series kernels:

In file included from arch/x86/kernel/early-quirks.c:21:0:
/kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:46:10: 
varning: ”struct irq_data” deklarerad inuti parameterlista [aktiverat 
som standard]
/kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:46:10: 
varning: dess scope-område är endast denna definition eller deklaration, 
vilket troligen inte är vad du vill. [aktiverat som standard]
/kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:50:17: 
varning: ”struct msi_msg” deklarerad inuti parameterlista [aktiverat som 
standard]


You need to add this upstream fix too:

commit 35d3d814cbd46a85bed97cd74ba97fbbb51e0ccd
Author: Joerg Roedel <joro@8bytes.org>
Date:   Fri Apr 19 20:34:55 2013 +0200

     iommu: Fix compile warnings with forward declarations


--

Thomas

