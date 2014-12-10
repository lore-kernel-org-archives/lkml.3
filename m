Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaLJVyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:54:08 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:62967 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbaLJVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <1410546745-919-1-git-send-email-tony@atomide.com>
References: <1410546745-919-1-git-send-email-tony@atomide.com>
Date: Wed, 10 Dec 2014 13:54:04 -0800
X-Google-Sender-Auth: G0ScE7_zAVfrNt6D2h_4SjChZgo
Message-ID: <CAGXu5jLxXCRH+ffgW_CcA6NRFneQT4THQtvsBM0TytZtawvuGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pstore-ram: Fix hangs by using write-combine mappings
From: Kees Cook <keescook@chromium.org>
To: Tony Lindgren <tony@atomide.com>, Tony Luck <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:32 AM, Tony Lindgren <tony@atomide.com> wrote:
> From: Rob Herring <robherring2@gmail.com>
>
> Currently trying to use pstore on at least ARMs can hang as we're
> mapping the peristent RAM with pgprot_noncached().
>
> On ARMs, pgprot_noncached() will actually make the memory strongly
> ordered, and as the atomic operations pstore uses are implementation
> defined for strongly ordered memory, they may not work. So basically
> atomic operations have undefined behavior on ARM for device or strongly
> ordered memory types.
>
> Let's fix the issue by using write-combine variants for mappings. This
> corresponds to normal, non-cacheable memory on ARM. For many other
> architectures, this change does not change the mapping type as by
> default we have:
>
> #define pgprot_writecombine pgprot_noncached
>
> The reason why pgprot_noncached() was originaly used for pstore
> is because Colin Cross <ccross@android.com> had observed lost
> debug prints right before a device hanging write operation on some
> systems. For the platforms supporting pgprot_noncached(), we can
> add a an optional configuration option to support that. But let's
> get pstore working first before adding new features.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> [tony@atomide.com: updated description]
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Acked-by: Kees Cook <keescook@chromium.org>

Please Cc: stable@vger.kernel.org on this one too.

Thanks!

-Kees

> ---
>  fs/pstore/ram_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index 9d7b9a8..24f94b0 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -392,7 +392,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
>         page_start = start - offset_in_page(start);
>         page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
>
> -       prot = pgprot_noncached(PAGE_KERNEL);
> +       prot = pgprot_writecombine(PAGE_KERNEL);
>
>         pages = kmalloc_array(page_count, sizeof(struct page *), GFP_KERNEL);
>         if (!pages) {
> @@ -422,7 +422,7 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
>         buffer_start_add = buffer_start_add_locked;
>         buffer_size_add = buffer_size_add_locked;
>
> -       return ioremap(start, size);
> +       return ioremap_wc(start, size);
>  }
>
>  static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
> --
> 2.1.0
>



-- 
Kees Cook
Chrome OS Security
