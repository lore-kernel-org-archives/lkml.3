Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaEHUhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:37:23 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38461 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaEHUhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140508120524.GF12548@pd.tnic>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
	<1399330337-16748-4-git-send-email-tthayer@altera.com>
	<20140508120524.GF12548@pd.tnic>
Date: Thu, 8 May 2014 15:37:19 -0500
Message-ID: <CAF03EBecxtMr1670ktQKTAZX_kHeZWz1SwuEk373B99BoVjbDw@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
From: Thor Thayer <tthayer.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 7:05 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, May 05, 2014 at 05:52:17PM -0500, tthayer@altera.com wrote:
>> From: Thor Thayer <tthayer@altera.com>
>
> Missing commit message.

Whoops. I don't know what happened there. I'll fix it.

>
>> ---
>> v2: Use the SDRAM controller registers to calculate memory size
>>     instead of the Device Tree. Update To & Cc list. Add maintainer
>>     information.
>>
>> v3: EDAC driver cleanup based on comments from Mailing list.
>>
>> Signed-off-by: Thor Thayer <tthayer@altera.com>
>> ---
>>  MAINTAINERS                |    5 +
>>  drivers/edac/Kconfig       |    9 +
>>  drivers/edac/Makefile      |    2 +
>>  drivers/edac/altera_edac.c |  411 ++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 427 insertions(+)
>>  create mode 100644 drivers/edac/altera_edac.c
>>

<snip>

>> --- /dev/null
>> +++ b/drivers/edac/altera_edac.c
>> @@ -0,0 +1,411 @@
>> +/*
>> + *  Copyright Altera Corporation (C) 2014. All rights reserved.
>> + *  Copyright 2011-2012 Calxeda, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file "COPYING" in the main directory of this archive
>> + * for more details.
>
> I'm guessing your lawyers want this boilerplate after all?
>

Yes. Their reasoning is that they want to retain the rights and
warranty language with the file (just in case the COPYING file
changes).

> ...
>
>> +static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
>> +{
>> +     struct mem_ctl_info *mci = dev_id;
>> +     struct altr_sdram_mc_data *drvdata = mci->pvt_info;
>> +     u32 status = 0, err_count = 0, err_addr = 0;
>> +
>> +     /* Error Address is shared by both SBE & DBE */
>> +     regmap_read(drvdata->mc_vbase, ERRADDR, &err_addr);
>> +
>> +     regmap_read(drvdata->mc_vbase, DRAMSTS, &status);
>> +
>> +     if (status & DRAMSTS_DBEERR) {
>> +             regmap_read(drvdata->mc_vbase, DBECOUNT, &err_count);
>> +             edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, err_count,
>> +                                  err_addr >> PAGE_SHIFT,
>> +                                  err_addr & ~PAGE_MASK, 0,
>> +                                  0, 0, -1, mci->ctl_name, "");
>
> So, are we setting edac_mc_panic_on_ue now or what are we planning to do
> for uncorrectable errors?

Yes. I tested using edac_core.edac_mc_panic_on_ue=1 from the command
line and it worked fine. I'll add a comment to clarify. BTW, thanks
for your help on that.

>
>> +     if (status & DRAMSTS_SBEERR) {
>> +             regmap_read(drvdata->mc_vbase, SBECOUNT, &err_count);

<snip>

>> +     if (count == 3) {
>> +             edac_printk(KERN_ALERT, EDAC_MC,
>> +                         "EDAC Inject Double bit error\n");
>> +             regmap_write(drvdata->mc_vbase, CTLCFG,
>> +                          (read_reg | CTLCFG_GEN_DB_ERR));
>> +     } else {
>> +             edac_printk(KERN_ALERT, EDAC_MC,
>> +                         "EDAC Inject Single bit error\n");
>> +             regmap_write(drvdata->mc_vbase, CTLCFG,
>> +                          (read_reg | CTLCFG_GEN_SB_ERR));
>
> You can remove the "EDAC " string from those printks above as
> edac_printk already adds the prefix.

Great. Will do.

>
>> +     }
>> +
>> +     ptemp[0] = 0x5A5A5A5A;
>> +     ptemp[1] = 0xA5A5A5A5;
>> +     regmap_write(drvdata->mc_vbase, CTLCFG, read_reg);
>> +     /* Ensure it has been written out */
>> +     wmb();
>> +
>> +     reg = ptemp[0];
>> +     read_reg = ptemp[1];
>> +     /* Force Read */
>> +     rmb();
>
> Have you checked whether those reads don't get optimized away by the
> compiler? I know, you need them for triggering the error condition.
>
> Also, you should add a comment here to explain why the reads are being
> done.

I considered using "volatile" variables, but decided against it after
I read Documentation/volatile-considered-harmful.txt and my situation
doesn't fit into the exemptions. Is there a better way to handle this?

I'll add the comment.

Thanks for reviewing and your comments.

Thor

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
