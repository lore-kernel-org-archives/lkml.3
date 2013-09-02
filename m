Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab3IBSlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:41:47 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44814 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab3IBSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <1378117829-9095-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1378117829-9095-1-git-send-email-tangchen@cn.fujitsu.com>
	<1378117829-9095-3-git-send-email-tangchen@cn.fujitsu.com>
Date: Mon, 2 Sep 2013 11:41:44 -0700
X-Google-Sender-Auth: rTglT38Zq0EzgopskT17QpyWqgk
Message-ID: <CAE9FiQXtWc6ud6BpsvUa5F4KKEX7cT5Phj4wvZfEr6zeWZVpZA@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/3] x86, mm: Update min_pfn_mapped in add_pfn_range_mapped().
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 3:30 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> In current kernel, we update min_pfn_mapped and max_pfn_mapped like this:
>
> init_mem_mapping()
> {
>         while ( a loop iterates all memory ranges ) {
>                 init_range_memory_mapping();
>                  |->init_memory_mapping()
>                      |->kernel_physical_mapping_init()
>                      |->add_pfn_range_mapped()
>                          |-> update max_pfn_mapped;
>
>                 update min_pfn_mapped;
>         }
> }
>
> max_pfn_mapped is updated in add_pfn_range_mapped() when a range of memory
> is mapped. But min_pfn_mapped is updated in init_mem_mapping(). We can also
> update min_pfn_mapped in add_pfn_range_mapped().
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/mm/init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 5b2eaca..a97749f 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -313,6 +313,7 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>         nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
>
>         max_pfn_mapped = max(max_pfn_mapped, end_pfn);
> +       min_pfn_mapped = min(min_pfn_mapped, start_pfn);
>  }
>
>  bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
> @@ -442,7 +443,6 @@ void __init init_mem_mapping(void)
>                 new_mapped_ram_size = init_range_memory_mapping(start,
>                                                         last_start);
>                 last_start = start;
> -               min_pfn_mapped = last_start >> PAGE_SHIFT;
>                 /* only increase step_size after big range get mapped */
>                 if (new_mapped_ram_size > mapped_ram_size)
>                         step_size <<= STEP_SIZE_SHIFT;


Nak, you can not move that.

min_pfn_mapped should not be updated before init_range_memory_mapping
is returned. as it need to refer old min_pfn_mapped.
and init_range_memory_mapping still init mapping from low to high locally.
min_pfn_mapped can not be updated too early.

Yinghai
