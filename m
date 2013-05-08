Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3EHFZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:25:09 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:13846
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719Ab3EHFZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:25:08 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: PS-6(zz98dI936eI1432I13e6Kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Topic: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Index: AQHOSvE+ysMfIHdI9EqG5gcExdaKwpj6wt+A
Date: Wed, 8 May 2013 05:24:58 +0000
Message-ID: <1367990697.2425.33.camel@x230>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-5-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1367938519-840-5-git-send-email-qiaowei.ren@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DE57C1201CE4B40993265B5198C519A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r485PHTo007219

On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
> These interfaces are located in /sys/devices/platform/intel_txt/parameter/,
> showing specific parameter information for SMX features supported by
> the processor.

Explain what SMX is here.

> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	The parameter/ directory exposes specific parameter
> +		information for SMX features supported by the processor.

Also here.

> +What:		/sys/devices/platform/intel_txt/parameter/acm_max_size
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	The "acm_max_size" property will show max size of
> +		authenticated code execution area.

What would userspace use this for?

> +What:		/sys/devices/platform/intel_txt/parameter/acm_mem_types
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	The "acm_max_types" property will show external memory
> +		types supported during AC mode.

Or this? And what's AC mode?

> +static void __getsec_parameters(uint32_t index, int *param_type,
> +				uint32_t *peax, uint32_t *pebx,
> +				uint32_t *pecx)
> +{
> +	uint32_t eax = 0, ebx = 0, ecx = 0;

These are all going to be overwritten by the getsec operation? Do they
really need to be initialised?

> +	__asm__ __volatile__ (IA32_GETSEC_OPCODE "\n"
> +			      : "=a"(eax), "=b"(ebx), "=c"(ecx)
> +			      : "a"(IA32_GETSEC_PARAMETERS), "b"(index));
> +
> +	*param_type = eax & 0x1f;
> +	*peax = eax;
> +	*pebx = ebx;
> +	*pecx = ecx;

Should there be a check for failure here? Is it possible for this
operation to fail?

> +	write_cr4(read_cr4() | CR4_SMXE);

Whoo. This needs at least a giant comment and probably some locking, but
if this is supposed to be set during runtime then it should be done in
core architecture code rather than just in this driver.

> +	sscanf(buf, "%d", &index);

What if this fails?

> +EXPORT_SYMBOL_GPL(sysfs_create_parameter);
> +
> +MODULE_LICENSE("GPL");

Not needed.

> +#define IA32_GETSEC_OPCODE	".byte 0x0f,0x37"

Nnf. Does the assembler really not know about this instruction?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
