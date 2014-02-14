Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaBNLyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:54:39 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:32914 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaBNLyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:54:37 -0500
Message-ID: <52FE03F4.70908@mev.co.uk>
Date: Fri, 14 Feb 2014 11:54:28 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: comedi: clean up conditional statement in
 addi_apci_3xxx.c
References: <1392262167-4073-1-git-send-email-chase.southwood@yahoo.com> <1392339746-3901-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392339746-3901-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-14 01:02, Chase Southwood wrote:
> In this conditional statement, if (chan < 16), but the instruction passed
> in data[0] is INSN_CONFIG_DIO_QUERY, the function does not return early,
> but the else-branch does not get executed either.  As a result, mask
> would be used uninitialized in the next line.  We want
> comedi_dio_insn_config() to use a chan_mask based on the chanspec for the
> INSN_CONFIG_DIO_QUERY instruction, so mask should be initialized to 0.
> Then, if instead the instruction is INSN_CONFIG_DIO_{INPUT,OUTPUT}, we
> return an error if (chan < 16) as these are invalid instructions for
> ports 0 and 1, or update the mask otherwise, so all the io_bits are
> modified for port 2.  This ensures that mask is always initialized by the
> time it is used.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> 2: Addressed all of the comments provided by Hartley regarding correct
> structure of this patch.
>
> Hopefully everything looks better!
>
>   drivers/staging/comedi/drivers/addi_apci_3xxx.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
> index ceadf8e..1f3b668 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
> @@ -680,7 +680,7 @@ static int apci3xxx_dio_insn_config(struct comedi_device *dev,
>   				    unsigned int *data)
>   {
>   	unsigned int chan = CR_CHAN(insn->chanspec);
> -	unsigned int mask;
> +	unsigned int mask = 0;
>   	int ret;
>
>   	/*
> @@ -688,12 +688,13 @@ static int apci3xxx_dio_insn_config(struct comedi_device *dev,
>   	 * Port 1 (channels 8-15) are always outputs
>   	 * Port 2 (channels 16-23) are programmable i/o
>   	 */
> -	if (chan < 16) {
> -		if (data[0] != INSN_CONFIG_DIO_QUERY)
> +	if (data[0] != INSN_CONFIG_DIO_QUERY) {
> +		/* ignore all other instructions for ports 0 and 1 */
> +		if (chan < 16)
>   			return -EINVAL;
> -	} else {
> -		/* changing any channel in port 2 changes the entire port */
> -		mask = 0xff0000;
> +		else
> +			/* changing any channel in port 2 changes the entire port */
> +			mask = 0xff0000;
>   	}
>
>   	ret = comedi_dio_insn_config(dev, s, insn, data, mask);
>

Looks okay this time. :)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
