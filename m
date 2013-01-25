Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3AYQpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:45:39 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.32]:34093
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab3AYQpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:45:35 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BLUPR03MB051;H:BLUPR03MB050.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@kernel.org" <stable@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Topic: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Index: AQHN+wFSTQzC7+pzaUi0ZNGfsVWqjphaPkYA
Date: Fri, 25 Jan 2013 16:43:17 +0000
Message-ID: <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BLUPR03MB051.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(199002)(189002)(51704002)(13464002)(79102001)(5343655001)(51856001)(31966008)(44976002)(63696002)(59766001)(4396001)(56816002)(46102001)(46406002)(33646001)(77982001)(56776001)(47776003)(23726001)(20776003)(5343635001)(50466001)(6806001)(74502001)(53806001)(54356001)(74662001)(76482001)(54316002)(16676001)(49866001)(50986001)(47446002)(47976001)(47736001)(57646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB022;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0737B96801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, January 25, 2013 8:37 AM
> To: linux-kernel@vger.kernel.org
> Cc: Olaf Hering; stable@kernel.org; KY Srinivasan; Greg KH
> Subject: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> 
> Enable hyperv_clocksource only if its advertised as a feature.
> XenServer 6 returns the signature which is checked in
> ms_hyperv_platform(), but it does not offer all features. Currently the
> clocksource is enabled unconditionally in ms_hyperv_init_platform(), and
> the result is a hanging guest.
> 
> Hyper-V spec Bit 1 indicates the availability of Partition Reference
> Counter.  Register the clocksource only if this bit is set.
> 
> The guest in question prints this in dmesg:
>  [    0.000000] Hypervisor detected: Microsoft HyperV
>  [    0.000000] HyperV: features 0x70, hints 0x0
> 
> This bug can be reproduced easily be setting 'viridian=1' in a HVM domU
> .cfg file. A workaround without this patch is to boot the HVM guest with
> 'clocksource=jiffies'.

I am curious why you are setting viridian=1 for a Linux HVM guest. Initially when
I did the Hyper-V emulation work on Xen, this configuration flag would be set only
for Windows guests since the idea was to run the "enlightened" Windows on Xen.
While the current Xen emulation code does not emulate "Partition Reference Counter"
there is no guarantee that Xen would not do this in the future. Perhaps dealing with this issue
by identifying the guest (via the viridian domain or not) may be a safer approach?

Regards,

K. Y 
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Cc: stable@kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 0a630dd..646d192 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -68,7 +68,8 @@ static void __init ms_hyperv_init_platform(void)
>  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
>  	       ms_hyperv.features, ms_hyperv.hints);
> 
> -	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> +	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
> +		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
>  }
> 
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> --
> 1.8.1.1
> 
> 


