Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbbA2OFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:05:10 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:47658 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbbA2OFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:05:08 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA3E11.8000207@mev.co.uk>
Date: Thu, 29 Jan 2015 14:05:05 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: dt2815: Removed variables that
 is never used
References: <1422484469-8807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484469-8807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:34, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/dt2815.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
> index a98fb66..c5c0490 100644
> --- a/drivers/staging/comedi/drivers/dt2815.c
> +++ b/drivers/staging/comedi/drivers/dt2815.c
> @@ -98,12 +98,11 @@ static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
>   	struct dt2815_private *devpriv = dev->private;
>   	int i;
>   	int chan = CR_CHAN(insn->chanspec);
> -	unsigned int lo, hi;
> +	unsigned int lo;
>   	int ret;
>
>   	for (i = 0; i < insn->n; i++) {
>   		lo = ((data[i] & 0x0f) << 4) | (chan << 1) | 0x01;
> -		hi = (data[i] & 0xff0) >> 4;
>
>   		ret = comedi_timeout(dev, s, insn, dt2815_ao_status, 0x00);
>   		if (ret)
>

I think this highlights a bug in the driver.  It ought to write the hi 
byte to the DT2815_DATA register, but I can't find any register 
programming manuals for this board (only a Windows driver manual - and 
that's for Windows 3.1 and Windows 95).

My guess (based on kernel log messages that have since been removed from 
the driver) is that the sequence should be:

1. wait for the DT2815_STATUS register to read 0x00
2. write the lo byte to the DT2815_DATA register
3. wait for the DT2815_STATUS register to read 0x10
4. write the hi byte to the DT2815_DATA register

and that step 4 is missing from the driver.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
