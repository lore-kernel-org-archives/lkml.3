Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3AKW7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:59:44 -0500
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:47404 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755100Ab3AKW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:59:43 -0500
Date: Fri, 11 Jan 2013 15:00:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org,
        =?UTF-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Subject: Re: [tip:x86/urgent] x86/Sandy Bridge:  reserve pages when
 integrated graphics is present
Message-ID: <20130111150030.1d39b8b8@jbarnes-desktop>
In-Reply-To: <tip-a9acc5365dbda29f7be2884efb63771dc24bd815@git.kernel.org>
References: <tip-a9acc5365dbda29f7be2884efb63771dc24bd815@git.kernel.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 14:39:04 -0800
tip-bot for Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Commit-ID:  a9acc5365dbda29f7be2884efb63771dc24bd815
> Gitweb:     http://git.kernel.org/tip/a9acc5365dbda29f7be2884efb63771dc24bd815
> Author:     Jesse Barnes <jbarnes@virtuousgeek.org>
> AuthorDate: Wed, 14 Nov 2012 20:43:31 +0000
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 11 Jan 2013 14:26:38 -0800
> 
> x86/Sandy Bridge: reserve pages when integrated graphics is present
> 
> SNB graphics devices have a bug that prevent them from accessing certain
> memory ranges, namely anything below 1M and in the pages listed in the
> table.  So reserve those at boot if set detect a SNB gfx device on the
> CPU to avoid GPU hangs.
> 
> Stephane Marchesin had a similar patch to the page allocator awhile
> back, but rather than reserving pages up front, it leaked them at
> allocation time.
> 
> [ hpa: made a number of stylistic changes, marked arrays as static
>   const, and made less verbose; use "memblock=debug" for full
>   verbosity. ]
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/setup.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 23ddd55..9dcb325 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -610,6 +610,81 @@ static __init void reserve_ibft_region(void)
>  
>  static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
>  
> +static bool __init snb_gfx_workaround_needed(void)
> +{
> +	int i;
> +	u16 vendor, devid;
> +	static const u16 snb_ids[] = {
> +		0x0102,
> +		0x0112,
> +		0x0122,
> +		0x0106,
> +		0x0116,
> +		0x0126,
> +		0x010a,
> +	};
> +
> +	/* Assume no if something weird is going on with PCI */
> +	if (!early_pci_allowed())
> +		return false;
> +
> +	vendor = read_pci_config_16(0, 2, 0, PCI_VENDOR_ID);
> +	if (vendor != 0x8086)
> +		return false;
> +
> +	devid = read_pci_config_16(0, 2, 0, PCI_DEVICE_ID);
> +	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
> +		if (devid == snb_ids[i])
> +			return true;
> +
> +	return false;
> +}
> +
> +/*
> + * Sandy Bridge graphics has trouble with certain ranges, exclude
> + * them from allocation.
> + */
> +static void __init trim_snb_memory(void)
> +{
> +	static const unsigned long bad_pages[] = {
> +		0x20050000,
> +		0x20110000,
> +		0x20130000,
> +		0x20138000,
> +		0x40004000,
> +	};
> +	int i;
> +
> +	if (!snb_gfx_workaround_needed())
> +		return;
> +
> +	printk(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");
> +
> +	/*
> +	 * Reserve all memory below the 1 MB mark that has not
> +	 * already been reserved.
> +	 */
> +	memblock_reserve(0, 1<<20);
> +	
> +	for (i = 0; i < ARRAY_SIZE(bad_pages); i++) {
> +		if (memblock_reserve(bad_pages[i], PAGE_SIZE))
> +			printk(KERN_WARNING "failed to reserve 0x%08lx\n",
> +			       bad_pages[i]);
> +	}
> +}
> +
> +/*
> + * Here we put platform-specific memory range workarounds, i.e.
> + * memory known to be corrupt or otherwise in need to be reserved on
> + * specific platforms.
> + *
> + * If this gets used more widely it could use a real dispatch mechanism.
> + */
> +static void __init trim_platform_memory_ranges(void)
> +{
> +	trim_snb_memory();
> +}
> +
>  static void __init trim_bios_range(void)
>  {
>  	/*
> @@ -630,6 +705,7 @@ static void __init trim_bios_range(void)
>  	 * take them out.
>  	 */
>  	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
> +
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>  }
>  
> @@ -908,6 +984,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	setup_real_mode();
>  
> +	trim_platform_memory_ranges();
> +
>  	init_gbpages();
>  
>  	/* max_pfn_mapped is updated here */
> 

Great, thanks Peter.

Stephane, care to try this out?

-- 
Jesse Barnes, Intel Open Source Technology Center
