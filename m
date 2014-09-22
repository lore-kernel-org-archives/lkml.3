Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaIVRvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:51:36 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39570 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaIVRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:51:35 -0400
From: Ashley Lai <ashley@ashleylai.com>
X-Google-Original-From: Ashley Lai <alai@ant>
Date: Mon, 22 Sep 2014 12:45:38 -0500 (CDT)
To: Anton Blanchard <anton@samba.org>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if
 driver_data is bad
In-Reply-To: <20140920072942.27c28768@kryten>
Message-ID: <alpine.DEB.2.10.1409221243390.4510@ant>
References: <20140920072942.27c28768@kryten>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Sep 2014, Anton Blanchard wrote:

> I'm looking at an oops in tpm_ibmvtpm_get_desired_dma:
>
>  28:	00 00 20 39 	li      r9,0
>  2c:	10 00 01 e8 	ld      r0,16(r1)
>  30:	28 00 69 80 	lwz     r3,40(r9)
>
> We set r9 to 0 then load r9+40. The problem is actually in
> ibmvtpm_get_data, it can return NULL but the rest of the driver
> never expects it.
>
> Add a BUG_ON in ibmvtpm_get_data. We still need to identify the root
> cause but at least this makes it obvious what went wrong.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index af74c57..0d1eeba 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -63,9 +63,9 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
> static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
> {
> 	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	if (chip)
> -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> -	return NULL;
> +
> +	BUG_ON(!chip);
> +	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> }
>
> /**
>

Acked-by: Ashley Lai <ashley@ashleylai.com>

