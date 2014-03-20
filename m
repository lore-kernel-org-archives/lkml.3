Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaCTNnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:43:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:8210 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbaCTNnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:43:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,694,1389772800"; 
   d="scan'208";a="502777402"
Message-ID: <1395322983.2721.12.camel@rzhang1-mobl4>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Zhang Rui <rui.zhang@intel.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Stephane Eranian <eranian@google.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 20 Mar 2014 21:43:03 +0800
In-Reply-To: <532AA3F6.9090402@intel.com>
References: <20140224162400.GE16457@pd.tnic>
		<4205942.Tp8ltEsv6e@vostro.rjw.lan>	<532A514C.5010106@intel.com>
		<744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
	 <CABPqkBTyti0owCA_cWf9GcvYnOSvbMQpRC29rgpicjW1iYBjYQ@mail.gmail.com>
	 <744357E9AAD1214791ACBA4B0B9092630121F3B7@SHSMSX101.ccr.corp.intel.com>
	 <532AA3F6.9090402@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 16:16 +0800, Yan, Zheng wrote:
> On 03/20/2014 03:53 PM, Zhang, Rui wrote:
> > The resource length is also hardcoded to 0x6000, right?
> > This is probably a problem, because
> > only if the resource length read from PCI config space is larger than 0x4000,
> > drivers/pnp/quirks.c will detect the conflict and disable the PNP0C02
> > resource 0xfed10000 - 0xfed13fff, and the PCI device can request this
> > resource successfully.
> > In order to check this, can you please attach the dmesg output after boot?
> 
> maybe the issue can be fixed by below untested patch
> 
> ---
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index fd5e883..2b3d834 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -1701,7 +1701,7 @@ static struct uncore_event_desc snb_uncore_imc_events[] = {
>  #define SNB_UNCORE_PCI_IMC_BAR_OFFSET		0x48
>  
>  /* page size multiple covering all config regs */
> -#define SNB_UNCORE_PCI_IMC_MAP_SIZE		0x6000
> +#define SNB_UNCORE_PCI_IMC_MAP_SIZE		0x8
>  
>  #define SNB_UNCORE_PCI_IMC_DATA_READS		0x1
>  #define SNB_UNCORE_PCI_IMC_DATA_READS_BASE	0x5050
> @@ -1736,7 +1736,8 @@ static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
>  
>  	addr &= ~(PAGE_SIZE - 1);
>  
> -	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
> +	box->io_addr = ioremap(addr + SNB_UNCORE_PCI_IMC_CTR_BASE,
> +			       SNB_UNCORE_PCI_IMC_MAP_SIZE);

you're remapping 0xfed15050 - 0xfed1b04f instead of 0xfed10000 -
0xfed15fff ?
I do not quite understand this, but apparently this is not a FIX.
If it works for this problem, it is because 0xfed15050 - 0xfed1b04f
happens to be not conflict with any resource reserved by PNP system
driver, on this machine.

thanks,
rui

>  	box->hrtimer_duration = UNCORE_SNB_IMC_HRTIMER_INTERVAL;
>  }
>  
> @@ -1832,7 +1833,7 @@ static int snb_uncore_imc_event_init(struct perf_event *event)
>  	}
>  
>  	/* must be done before validate_group */
> -	event->hw.event_base = base;
> +	event->hw.event_base = base - SNB_UNCORE_PCI_IMC_CTR_BASE;
>  	event->hw.config = cfg;
>  	event->hw.idx = idx;
>  


