Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3JCTVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:21:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51913 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3JCTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <20131003172142.GA20660@hmsreliant.think-freely.org>
References: <1380300815-1864-1-git-send-email-nhorman@tuxdriver.com> <20131003172142.GA20660@hmsreliant.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Oct 2013 13:21:22 -0600
Message-ID: <CAErSpo7fzSNGShWocpLQf6LwQZ84u+9zRX0oMJyNrRfe+87mxg@mail.gmail.com>
Subject: Re: [PATCH] iommu: Remove stack trace from broken irq remapping warning
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 11:21 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, Sep 27, 2013 at 12:53:35PM -0400, Neil Horman wrote:
>> The warning for the irq remapping broken check in intel_irq_remapping.c is
>> pretty pointless.  We need the warning, but we know where its comming from, the
>> stack trace will always be the same, and it needlessly triggers things like
>> Abrt.  This changes the warning to just print a text warning about BIOS being
>> broken, without the stack trace, then sets the appropriate taint bit.  Since we
>> automatically disable irq remapping, theres no need to contiue making Abrt jump
>> at this problem
>>
>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>> CC: Joerg Roedel <joro@8bytes.org>
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>> ---
>>  drivers/iommu/intel_irq_remapping.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
>> index f71673d..b97d70b 100644
>> --- a/drivers/iommu/intel_irq_remapping.c
>> +++ b/drivers/iommu/intel_irq_remapping.c
>> @@ -525,12 +525,13 @@ static int __init intel_irq_remapping_supported(void)
>>       if (disable_irq_remap)
>>               return 0;
>>       if (irq_remap_broken) {
>> -             WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
>> -                        "This system BIOS has enabled interrupt remapping\n"
>> -                        "on a chipset that contains an erratum making that\n"
>> -                        "feature unstable.  To maintain system stability\n"
>> -                        "interrupt remapping is being disabled.  Please\n"
>> -                        "contact your BIOS vendor for an update\n");
>> +             printk(KERN_WARNING
>> +                     "This system BIOS has enabled interrupt remapping\n"
>> +                     "on a chipset that contains an erratum making that\n"
>> +                     "feature unstable.  To maintain system stability\n"
>> +                     "interrupt remapping is being disabled.  Please\n"
>> +                     "contact your BIOS vendor for an update\n");
>> +             add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
>>               disable_irq_remap = 1;
>>               return 0;
>>       }
>> --
>> 1.8.3.1
>>
>>
>
> Ping Bjorn, Jeorg, any thoughts here?

This is in drivers/iommu, so I'd prefer that Joerg handle this.

My opinion is that this patch does the right thing in dropping the
backtrace and keeping the taint.

I tend to agree with Andy that we should also consider a second patch
that drops the taint, because this is basically just a quirk that
avoids broken chipset functionality, but as far as I can tell, there's
no reason to fear an undebuggable problem related to disabling
interrupt remapping.  We don't taint the kernel for other similar
quirks, so I don't see why we should here.

Bjorn
