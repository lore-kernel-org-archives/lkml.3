Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3I0TYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:24:33 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61763 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3I0TYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <1380300815-1864-1-git-send-email-nhorman@tuxdriver.com>
References: <1380300815-1864-1-git-send-email-nhorman@tuxdriver.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Sep 2013 12:24:10 -0700
Message-ID: <CALCETrVB-rUds-u1sdXeUwgJtnTV0pFpaeZiDMKv96-uZ8uqSg@mail.gmail.com>
Subject: Re: [PATCH] iommu: Remove stack trace from broken irq remapping warning
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 9:53 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> The warning for the irq remapping broken check in intel_irq_remapping.c is
> pretty pointless.  We need the warning, but we know where its comming from, the
> stack trace will always be the same, and it needlessly triggers things like
> Abrt.  This changes the warning to just print a text warning about BIOS being
> broken, without the stack trace, then sets the appropriate taint bit.  Since we
> automatically disable irq remapping, theres no need to contiue making Abrt jump
> at this problem
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  drivers/iommu/intel_irq_remapping.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index f71673d..b97d70b 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -525,12 +525,13 @@ static int __init intel_irq_remapping_supported(void)
>         if (disable_irq_remap)
>                 return 0;
>         if (irq_remap_broken) {
> -               WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
> -                          "This system BIOS has enabled interrupt remapping\n"
> -                          "on a chipset that contains an erratum making that\n"
> -                          "feature unstable.  To maintain system stability\n"
> -                          "interrupt remapping is being disabled.  Please\n"
> -                          "contact your BIOS vendor for an update\n");
> +               printk(KERN_WARNING
> +                       "This system BIOS has enabled interrupt remapping\n"
> +                       "on a chipset that contains an erratum making that\n"
> +                       "feature unstable.  To maintain system stability\n"
> +                       "interrupt remapping is being disabled.  Please\n"
> +                       "contact your BIOS vendor for an update\n");
> +               add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);

Is the taint bit actually useful?  It seems like functionality will be
missing if this workaround happens, but everything should be stable.

--Andy
