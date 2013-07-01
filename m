Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3GAVcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:32:54 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:55840 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755057Ab3GAVcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:32:52 -0400
X-TM-IMSS-Message-ID: <1f5c36b4000781e9@nsa.gov>
Message-ID: <51D1F531.9000308@tycho.nsa.gov>
Date: Mon, 01 Jul 2013 17:31:29 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        leosilva@linux.vnet.ibm.com, shpedoikal@gmail.com,
        konrad.wilk@oracle.com, xen-devel@lists.xen.org, mail@srajiv.net,
        adlai@linux.vnet.ibm.com, tpmdd@sirrix.com
Subject: Re: [tpmdd-devel] [PATCH v3] drivers/tpm: add xen tpmfront interface
References: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov> <201306050014.29162.PeterHuewe@gmx.de>
In-Reply-To: <201306050014.29162.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 06:14 PM, Peter Hüwe wrote:
> Hi Daniel,
>
> thanks for this v3.
> It's really nice to see the progress and I really like that
> sparse/smatch/clang/coccicheck do not complain at all - nice job!
>
> Konrad already did an excellent job at reviewing the driver (thanks for that),
> and all previously pointed out issues are fixed.
>
> Unfortunately I haven't had the opportunity to test it yet, but
> the driver looks clean from the TPM perspective.
>
>
> However I do have some minor comments from a general perspective - see below.
>
>
>>From the TPM point of view I'd say it is fine.
> (I'm currently _not_ the (official) maintainer of the tpm subsystem but at least
> take care of the incoming stuff as an interim)
>
>
> So if the comments are addressed you can add:
> Acked-by: Peter Huewe <peterhuewe@gmx.de>
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

I believe I have addressed the comments in v4 (sorry for the delay, I was away
from this email for a few weeks).

>
> @Konrad: I can stage the driver and push it to James or you can take it.
> As it lives in drivers/tpm maybe it should go through the tpm (interim ;)
> maintainer and james' tree.
>
>
> So here are my comments:
>
> Am Dienstag, 28. Mai 2013, 17:40:32 schrieb Daniel De Graaf:
>> This is a complete rewrite of the Xen TPM frontend driver, taking
>> advantage of a simplified frontend/backend interface and adding support
>> for cancellation and timeouts.  The backend for this driver is provided
>> by a vTPM stub domain using the interface in Xen 4.3.
>>
>> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
>> Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
>
>> diff --git a/Documentation/xen-tpmfront.txt
>> b/Documentation/xen-tpmfront.txt new file mode 100644
>> index 0000000..8a61d6f
>> --- /dev/null
>> +++ b/Documentation/xen-tpmfront.txt
>> @@ -0,0 +1,116 @@
>> +Copyright (c) 2010-2012 United States Government, as represented by
>> +the Secretary of Defense.  All rights reserved.
>
> I'm not 100% sure if this can stay this way, as it doesn't permit any changes
> to the documentation itself.

This copyright statement has been removed; the portions of the text under copyright
have been released under the GPL, so the kernel's COPYING statement suffices.

>
>> + * Linux DomU: The Linux based guest that wants to use a vTPM. There many
>> be +	       more than one of these.
> -* Linux DomU: The Linux based guest that wants to use a vTPM. There many
> +* Linux DomU: The Linux based guest that wants to use a vTPM. There may
> Just a minor typo

Fixed, thanks.

>> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>> index dbfd564..205ed35 100644
>> --- a/drivers/char/tpm/Kconfig
>> +++ b/drivers/char/tpm/Kconfig
>> @@ -91,4 +91,15 @@ config TCG_ST33_I2C
>>           To compile this driver as a module, choose M here; the module will
>> be called tpm_stm_st33_i2c.
>>
>> +config TCG_XEN
> Maybe TCG_XEN_TPM would be better, but TCG_XEN is okay for me.
>

TCG_XEN seems to match the other Kconfig menu items better.
  
>> +static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>> +{
>> +	struct tpm_private *priv = TPM_VPRIV(chip);
>> +	struct vtpm_shared_page *shr = priv->shr;
>> +	unsigned int offset = shr_data_offset(shr);
>> +
>> +	u32 ordinal;
>> +	unsigned long duration;
>> +
>> +	if (offset > PAGE_SIZE)
>> +		return -EIO;
> Maybe -EINVAL?
>> +
>> +	if (offset + count > PAGE_SIZE)
>> +		return -EIO;
> Maybe -EINVAL?

Both changed.

>
>> +/*************************************************************************
>> ***** + * tpmif.h
>> + *
>> + * TPM I/O interface for Xen guest OSes, v2
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> copy + * of this software and associated documentation files (the
>> "Software"), to + * deal in the Software without restriction, including
>> without limitation the + * rights to use, copy, modify, merge, publish,
>> distribute, sublicense, and/or + * sell copies of the Software, and to
>> permit persons to whom the Software is + * furnished to do so, subject to
>> the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included
>> in + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
>> OR + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> MERCHANTABILITY, + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
>> IN NO EVENT SHALL THE + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
>> CLAIM, DAMAGES OR OTHER + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
>> TORT OR OTHERWISE, ARISING + * FROM, OUT OF OR IN CONNECTION WITH THE
>> SOFTWARE OR THE USE OR OTHER + * DEALINGS IN THE SOFTWARE.
>> + *
>> + */
>
> Also not sure if this license is correct/compliant with the kernel as it
> indicates no clear license to me.
>
> Peter

Since the portions of the header covered by copyright (the v1 interface) have been
removed from the Linux copy, the remainder is public domain and I have removed the
notice.


-- 
Daniel De Graaf
National Security Agency
