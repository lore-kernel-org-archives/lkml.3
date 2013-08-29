Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3H2L7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:59:49 -0400
Received: from mx2.parallels.com ([199.115.105.18]:45403 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3H2L7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:59:48 -0400
From: James Bottomley <jbottomley@parallels.com>
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
CC: Tomas Henzl <thenzl@redhat.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/1 v1.1] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284 (Resend renew)
Thread-Topic: [PATCH 1/1 v1.1] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284 (Resend renew)
Thread-Index: AQHOpK8/bNlw3pJofEi9LdcMUns6mw==
Date: Thu, 29 Aug 2013 11:59:43 +0000
Message-ID: <1377777581.2223.93.camel@dabdike>
References: <CAKiknE_FJN7gRLMFHCfNOtjg73fLLCQ45yacHb+w1B46C5dJQA@mail.gmail.com>
In-Reply-To: <CAKiknE_FJN7gRLMFHCfNOtjg73fLLCQ45yacHb+w1B46C5dJQA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [195.214.232.10]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B0720BB82FD9A478C89833A5BB1B6F8@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7TBxtp3014369

On Thu, 2013-08-29 at 12:55 +0800, é»ƒæ¸…éš† wrote:
> Update the patch code.
> 
> From: Ching<ching2048@areca.com.tw>
> 
> Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284.
> Modify maximum outstanding command number.
> Notify command complete with auto request sense.
> Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface.
> Fix coding style warning.
> Fix compiling warning.
> Fix ARC1880 hardware reset.
> Fix coding style - indent

This patch is too big for the SCSI mailing list.  We have a 400k limit.
Your patch is 292k, which would ordinarily be OK, but you attached it
twice (once inline and once as an attachment), which is why it's not
going through.

> -	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
> -	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},

Why are you removing these adapters from the driver?

I agree with Dan, all these whitespace changes make the patch very hard
to read for the significant pieces; can't they be done separately?

Some of them, like this


> -static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
> +static void
> +arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
>  {
>  	uint32_t outbound_doorbell;
> -	struct MessageUnit_A __iomem *reg = acb->pmuA;
> +	struct MessageUnit_A __iomem *reg  = acb->pmuA;

Aren't even correct (last one introduces an extra spurious space).

Others, like this:

> +		kfree((const void *)ver_addr);
[...]
> -		kfree(ver_addr);

Are stylistically wrong: ver_addr is an unsigned char *; there's no
reason to cast it to anything before calling kfree (any pointer can be
passed without cast to a function taking a void *)

> -		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
> +		memcpy((void *)ptmpuserbuffer,
> +			(const void *)pcmdmessagefld->messagedatabuffer, user_len);

You do a lot of this spurious casting to void *; please don't:

> -		} while (((readl(&pmuC->host_diagnostic) & ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
> -		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
> +		} while ((((temp = readl(&pmuC->host_diagnostic)) &
> +			ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) &&
> +			(count < 5));

Why assign to temp?  You never refer to it again.

I'm sure there are other issues, but the massive code reformat changes
mean I probably missed them.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
