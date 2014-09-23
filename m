Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaIWRMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:12:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48247 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaIWRMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:12:34 -0400
Message-ID: <5421A9F8.9070301@linux.vnet.ibm.com>
Date: Tue, 23 Sep 2014 13:12:24 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scot Doyle <lkml14@scotdoyle.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Michael Mullin <masmullin@gmail.com>, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v9] tpm_tis: verify interrupt during init
References: <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain> <20140828165348.GE11183@obsidianresearch.com> <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain> <20140830174920.GA26218@obsidianresearch.com> <alpine.LNX.2.11.1408302229001.579@localhost.localdomain> <20140902172015.GD13956@obsidianresearch.com> <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain> <20140908220238.GB6204@obsidianresearch.com> <alpine.LNX.2.11.1409110010290.700@localhost.localdomain> <20140922171338.GB28082@obsidianresearch.com> <alpine.DEB.2.11.1409230232080.3995@localhost.localdomain> <alpine.DEB.2.11.1409230247010.4292@localhost.localdomain> <alpine.DEB.2.11.1409231136410.2947@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.11.1409231136410.2947@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092317-9332-0000-0000-0000021BDDFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 07:55 AM, Scot Doyle wrote:
> On Tue, 23 Sep 2014, Scot Doyle wrote:
> ---
> drivers/char/tpm/tpm_tis.c | 76 +++++++++++++++++++++++++++++++++++++---------
> 1 file changed, 62 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 2c46734..bfe1f1a 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -75,6 +75,10 @@ enum tis_defaults {
> #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
> #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
>
> +struct priv_data {
> +	bool irq_tested;
> +};
> +
> static LIST_HEAD(tis_chips);
> static DEFINE_MUTEX(tis_lock);
>
> @@ -338,12 +342,27 @@ out_err:
> 	return rc;
> }
>
> +static void disable_interrupts(struct tpm_chip *chip)
> +{
> +	u32 intmask;
> +	intmask =
> +	    ioread32(chip->vendor.iobase +
> +		     TPM_INT_ENABLE(chip->vendor.locality));
> +	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
> +		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;

You want to disable interrupts but you set all the flags? Maybe you meant:

intmask &= ~(FOO|BAR)

?

    Stefan

