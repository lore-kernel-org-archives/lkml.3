Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaK0Biq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:38:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48135 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbaK0Bip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:38:45 -0500
Message-ID: <5476809F.3090503@linux.vnet.ibm.com>
Date: Wed, 26 Nov 2014 20:38:39 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
CC: christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Arthur <will.c.arthur@intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v7 09/10] tpm: TPM 2.0 FIFO Interface
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1415713513-16524-10-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1415713513-16524-10-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112701-0033-0000-0000-00000128C4CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
> From: Will Arthur <will.c.arthur@intel.com>
>
> Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> instead of calling tpm_get_timeouts(), assign duration and timeout
> values defined in the TPM 2.0 PTP specification.


>
> Signed-off-by: Will Arthur <will.c.arthur@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>   drivers/char/tpm/tpm_tis.c | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 7a2c59b..0b3c089 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -1,5 +1,6 @@
>   /*
>    * Copyright (C) 2005, 2006 IBM Corporation
> + * Copyright (C) 2014 Intel Corporation
>    *
>    * Authors:
>    * Leendert van Doorn <leendert@watson.ibm.com>
> @@ -44,6 +45,10 @@ enum tis_status {
>   	TPM_STS_DATA_EXPECT = 0x08,
>   };
>
> +enum tis_status3 {
> +	TPM_STS3_TPM2_FAM = 0x04,
> +};
> +

I just looked at the specs: You have to define a mask for bits 2 and 3 
-> 0xc0.


> @@ -554,11 +567,28 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
>   	if (!chip->vendor.iobase)
>   		return -EIO;
>
> +	sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
> +	if (sts3 & TPM_STS3_TPM2_FAM)
> +		chip->flags = TPM_CHIP_FLAG_TPM2;

And use the mask here.

((sts3 & XYZ_MASK) == TPM_STS3_TPM2_FAM)
     chip->flags = TPM_CHIP_FLAG_TPM2;

Since the bits 00 indicate TPM 1.2, 01 TPM2 and 10 and 11 are reserved!


    Stefan

