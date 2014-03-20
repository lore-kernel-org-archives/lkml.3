Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbaCTQDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:03:40 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47043 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376AbaCTQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:03:36 -0400
MIME-Version: 1.0
In-Reply-To: <532AA3F6.9090402@intel.com>
References: <20140224162400.GE16457@pd.tnic>
	<4205942.Tp8ltEsv6e@vostro.rjw.lan>
	<532A514C.5010106@intel.com>
	<744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
	<CABPqkBTyti0owCA_cWf9GcvYnOSvbMQpRC29rgpicjW1iYBjYQ@mail.gmail.com>
	<744357E9AAD1214791ACBA4B0B9092630121F3B7@SHSMSX101.ccr.corp.intel.com>
	<532AA3F6.9090402@intel.com>
Date: Thu, 20 Mar 2014 17:03:34 +0100
Message-ID: <CABPqkBT4xmF-0Z_zk++KEtDzV7Z4zbisdG4uH7WKqw+kNF_nCA@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 9:16 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 03/20/2014 03:53 PM, Zhang, Rui wrote:
>> The resource length is also hardcoded to 0x6000, right?
>> This is probably a problem, because
>> only if the resource length read from PCI config space is larger than 0x4000,
>> drivers/pnp/quirks.c will detect the conflict and disable the PNP0C02
>> resource 0xfed10000 - 0xfed13fff, and the PCI device can request this
>> resource successfully.
>> In order to check this, can you please attach the dmesg output after boot?
>
> maybe the issue can be fixed by below untested patch
>
> ---
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index fd5e883..2b3d834 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -1701,7 +1701,7 @@ static struct uncore_event_desc snb_uncore_imc_events[] = {
>  #define SNB_UNCORE_PCI_IMC_BAR_OFFSET          0x48
>
>  /* page size multiple covering all config regs */
> -#define SNB_UNCORE_PCI_IMC_MAP_SIZE            0x6000
> +#define SNB_UNCORE_PCI_IMC_MAP_SIZE            0x8
>
I assume ioremap() works on page boundaries.
Eventually want to expose the other counters too, not just read and
writes ( 8 bytes total).

The size of 0x6000 comes from the counter offsets: BAR + 0x5040 to BAR + 0x5054.
May be a better way of doing this would be to remap just the one page
holding them
instead of the 6 covering the entire BAR + counters. That would need
changes in the
read_counter() but that is okay.

So that would something along the line of:

    addr = (addr + 0x5040) & (PAGE_SIZE - 1);
    ioremap(addr, 0x1000);


>  #define SNB_UNCORE_PCI_IMC_DATA_READS          0x1
>  #define SNB_UNCORE_PCI_IMC_DATA_READS_BASE     0x5050
> @@ -1736,7 +1736,8 @@ static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
>
>         addr &= ~(PAGE_SIZE - 1);
>
> -       box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
> +       box->io_addr = ioremap(addr + SNB_UNCORE_PCI_IMC_CTR_BASE,
> +                              SNB_UNCORE_PCI_IMC_MAP_SIZE);
>         box->hrtimer_duration = UNCORE_SNB_IMC_HRTIMER_INTERVAL;
>  }
>
> @@ -1832,7 +1833,7 @@ static int snb_uncore_imc_event_init(struct perf_event *event)
>         }
>
>         /* must be done before validate_group */
> -       event->hw.event_base = base;
> +       event->hw.event_base = base - SNB_UNCORE_PCI_IMC_CTR_BASE;
>         event->hw.config = cfg;
>         event->hw.idx = idx;
>
