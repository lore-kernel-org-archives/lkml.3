Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765900Ab3DJDxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:53:20 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47857 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3DJDxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
Date: Tue, 9 Apr 2013 20:53:18 -0700
X-Google-Sender-Auth: 1PGrR7sq6Ab4JpSYdZMOVQRNKgQ
Message-ID: <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
From: Colin Cross <ccross@android.com>
To: Rob Herring <robherring2@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 8:08 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Atomic operations are undefined behavior on ARM for device or strongly
> ordered memory types. So use write-combine variants for mappings. This
> corresponds to normal, non-cacheable memory on ARM. For many other
> architectures, this change should not change the mapping type.

This is going to make ramconsole less reliable.  A debugging printk
followed by a __raw_writel that causes an immediate hard crash is
likely to lose the last updates, including the most useful message, in
the write buffers.

Also, isn't this patch unnecessary after patch 3 in this set?

> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/pstore/ram_core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index 0306303..e126d9f 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -337,7 +337,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
>         page_start = start - offset_in_page(start);
>         page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
>
> -       prot = pgprot_noncached(PAGE_KERNEL);
> +       prot = pgprot_writecombine(PAGE_KERNEL);
Is this necessary?  Won't pgprot_noncached already be normal memory?

>         pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
>         if (!pages) {
> @@ -364,7 +364,7 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
>                 return NULL;
>         }
>
> -       return ioremap(start, size);
> +       return ioremap_wc(start, size);

ioremap_wc corresponds to MT_DEVICE_WC, which is still device memory,
so I don't see how this helps solve the problem in the commit message.

>  }
>
>  static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
> --
> 1.7.10.4
>
