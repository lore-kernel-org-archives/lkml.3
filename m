Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaJ2KHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:07:06 -0400
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:63488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932250AbaJ2KHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:07:00 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "riel@redhat.com" <riel@redhat.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] x86, pageattr: fix slow_virt_to_phys() for X86_PAE
Thread-Topic: [PATCH] x86, pageattr: fix slow_virt_to_phys() for X86_PAE
Thread-Index: AQHP811FQgYUPFGQEUOEF8ZD8E6TNpxG1ELg
Date: Wed, 29 Oct 2014 09:50:23 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C6105705CD@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1414580033-27484-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1414580033-27484-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(189002)(164054003)(377454003)(13464003)(51704005)(106116001)(84676001)(19580395003)(44976005)(19580405001)(68736004)(95666004)(76482002)(46102003)(80022003)(97736003)(2501002)(6806004)(120916001)(99396003)(69596002)(66066001)(23726002)(86146001)(2656002)(55846006)(106466001)(77096002)(97756001)(50986999)(92566001)(64706001)(76176999)(31966008)(85852003)(54356999)(26826002)(4396001)(85306004)(33656002)(16796002)(46406003)(47776003)(2201001)(21056001)(20776003)(107046002)(87936001)(81156004)(86612001)(92726001)(50466002)(86362001)(1121002)(921003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1210;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> Behalf Of Dexuan Cui
> Sent: Wednesday, October 29, 2014 18:54 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; x86@kernel.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; mingo@redhat.com;
> hpa@zytor.com; dave.hansen@intel.com; riel@redhat.com
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] x86, pageattr: fix slow_virt_to_phys() for X86_PAE
> 
> pte_pfn() returns a PFN of long (32 bits in 32-PAE), then
> "long << PAGE_SHIFT" will overflow for PFNs above 4GB.
> 
> Due to this issue, some Linux 32-PAE distros, running as guests on Hyper-V,
> with 5GB memory assigned, can't load the netvsc driver successfully and
> hence the synthetic network device can't work (we can use the kernel
> parameter
> mem=3000M to work around the issue).
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  arch/x86/mm/pageattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index ae242a7..36de293 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -409,7 +409,7 @@ phys_addr_t slow_virt_to_phys(void *__virt_addr)
>  	psize = page_level_size(level);
>  	pmask = page_level_mask(level);
>  	offset = virt_addr & ~pmask;
> -	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
> +	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
>  	return (phys_addr | offset);
>  }
>  EXPORT_SYMBOL_GPL(slow_virt_to_phys);

Sorry for sending the same patch twice due to my silly typing!

Thanks,
-- Dexuan
