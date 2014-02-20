Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaBTQHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:07:43 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56438 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbaBTQHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:07:41 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ie0eah1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h93fhe5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1889i1155h)
X-WSS-ID: 0N1AY4M-08-MLF-02
X-M-MSG: 
Message-ID: <53062845.8010203@amd.com>
Date: Thu, 20 Feb 2014 10:07:33 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140217182729.GE4559@pd.tnic> <5302625C.4050700@amd.com> <20140217194153.GG4559@pd.tnic> <53028EE8.20106@amd.com> <20140218003654.GK4559@pd.tnic> <20140218084636.GA24465@pd.tnic> <5303A607.7090309@amd.com> <20140220093207.GB8876@pd.tnic>
In-Reply-To: <20140220093207.GB8876@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/2014 3:32 AM, Borislav Petkov wrote:
> Is that better (I also dropped the "Error Status: " prefix because it is
> not needed):
>
> - [   46.822828] [Hardware Error]: Error Status: Uncorrected, software containable error.
> + [   46.822828] [Hardware Error]: Uncorrected, software containable error.

Okay.

> --
> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
> index 30f7309446a6..528b0c4998d9 100644
> --- a/drivers/edac/mce_amd.c
> +++ b/drivers/edac/mce_amd.c
> @@ -741,6 +741,36 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
>   	if (amd_filter_mce(m))
>   		return NOTIFY_STOP;
>   
> +	pr_emerg(HW_ERR "%s\n", decode_error_status(m));
> +
> +	pr_emerg(HW_ERR "CPU:%d (%x:%x:%x) MC%d_STATUS[%s|%s|%s|%s|%s",
> +		m->extcpu,
> +		c->x86, c->x86_model, c->x86_mask,
> +		m->bank,
> +		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
> +		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
> +		((m->status & MCI_STATUS_MISCV)	? "MiscV" : "-"),
> +		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
> +		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
> +
> +	if (c->x86 == 0x15 || c->x86 == 0x16)
> +		pr_cont("|%s|%s",
> +			((m->status & MCI_STATUS_DEFERRED) ? "Deferred" : "-"),
> +			((m->status & MCI_STATUS_POISON)   ? "Poison"   : "-"));
> +
> +	/* do the two bits[14:13] together */
> +	ecc = (m->status >> 45) & 0x3;
> +	if (ecc)
> +		pr_cont("|%sECC", ((ecc == 2) ? "C" : "U"));
> +
> +	pr_cont("]: 0x%016llx\n", m->status);
> +
> +	if (m->status & MCI_STATUS_ADDRV)
> +		pr_emerg(HW_ERR "MC%d_ADDR: 0x%016llx\n", m->bank, m->addr);
> +
> +	if (!fam_ops)
> +		goto err_code;
> +
>   	switch (m->bank) {
>   	case 0:
>   		decode_mc0_mce(m);
> @@ -774,33 +804,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
>   		break;
>   	}
>   
> -	pr_emerg(HW_ERR "Error Status: %s\n", decode_error_status(m));
> -
> -	pr_emerg(HW_ERR "CPU:%d (%x:%x:%x) MC%d_STATUS[%s|%s|%s|%s|%s",
> -		m->extcpu,
> -		c->x86, c->x86_model, c->x86_mask,
> -		m->bank,
> -		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
> -		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
> -		((m->status & MCI_STATUS_MISCV)	? "MiscV" : "-"),
> -		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
> -		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
> -
> -	if (c->x86 == 0x15 || c->x86 == 0x16)
> -		pr_cont("|%s|%s",
> -			((m->status & MCI_STATUS_DEFERRED) ? "Deferred" : "-"),
> -			((m->status & MCI_STATUS_POISON)   ? "Poison"   : "-"));
> -
> -	/* do the two bits[14:13] together */
> -	ecc = (m->status >> 45) & 0x3;
> -	if (ecc)
> -		pr_cont("|%sECC", ((ecc == 2) ? "C" : "U"));
> -
> -	pr_cont("]: 0x%016llx\n", m->status);
> -
> -	if (m->status & MCI_STATUS_ADDRV)
> -		pr_emerg(HW_ERR "MC%d_ADDR: 0x%016llx\n", m->bank, m->addr);
> -
> + err_code:
>   	amd_decode_err_code(m->status & 0xffff);
>   
>   	return NOTIFY_STOP;
> @@ -816,10 +820,10 @@ static int __init mce_amd_init(void)
>   	struct cpuinfo_x86 *c = &boot_cpu_data;
>   
>   	if (c->x86_vendor != X86_VENDOR_AMD)
> -		return 0;
> +		return -ENODEV;
>   
>   	if (c->x86 < 0xf || c->x86 > 0x16)
> -		return 0;
> +		return -ENODEV;
>   
>   	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
>   	if (!fam_ops)
> @@ -874,6 +878,7 @@ static int __init mce_amd_init(void)
>   	default:
>   		printk(KERN_WARNING "Huh? What family is it: 0x%x?!\n", c->x86);
>   		kfree(fam_ops);
> +		fam_ops = NULL;
>   		return -EINVAL;
>   	}
> --
>

Tested the above a final time on local machine and it works fine..

Thanks,
-Aravind.

