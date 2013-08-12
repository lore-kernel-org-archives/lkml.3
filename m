Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3HLXaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:30:07 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57069 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3HLXaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <1376348482-1357-1-git-send-email-linn@hp.com>
References: <52094ED2.1000308@zytor.com>
	<1376348482-1357-1-git-send-email-linn@hp.com>
Date: Mon, 12 Aug 2013 16:30:05 -0700
X-Google-Sender-Auth: LwwXiTGuA9w4Nm7mVwmqv-fs2Z8
Message-ID: <CAE9FiQXx1xYOxeWTiG0ZxXxC+7EApM8HShjYepnWNGL6-ahUtg@mail.gmail.com>
Subject: Re: [PATCH v2] x86: selective remapping in parse_setup_data()
From: Yinghai Lu <yinghai@kernel.org>
To: Linn Crosetto <linn@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 4:01 PM, Linn Crosetto <linn@hp.com> wrote:
> Type SETUP_PCI, added by setup_efi_pci(), may advertise a ROM size
> larger than early_memremap() is able to handle, which is currently
> limited to 256kB. If this occurs it leads to a NULL dereference in
> parse_setup_data().
>
> To avoid this, first remap the setup_data header, and remap the data
> only for types actually parsed in parse_setup_data(). Type SETUP_PCI is
> handled later by pcibios_add_device(), when ioremap() is available.
>
> Signed-off-by: Linn Crosetto <linn@hp.com>
> ---
> v2: add more detail to the explanation as requested by hpa
> ---
>  arch/x86/kernel/setup.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f8ec578..2063a49 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -423,6 +423,17 @@ static void __init reserve_initrd(void)
>  }
>  #endif /* CONFIG_BLK_DEV_INITRD */
>
> +static void __init remap_setup_data(u64 pa_data, u32 data_len,
> +                                   struct setup_data **data, u32 *map_len)
> +{
> +       if (data_len <= *map_len)
> +               return;
> +
> +       early_iounmap(*data, *map_len);
> +       *data = early_memremap(pa_data, data_len);
> +       *map_len = data_len;
> +}
> +
>  static void __init parse_setup_data(void)
>  {
>         struct setup_data *data;
> @@ -432,18 +443,16 @@ static void __init parse_setup_data(void)
>         while (pa_data) {
>                 u32 data_len, map_len;
>
> +               /* The data length may be too large for early remapping,
> +                  remap the data only when needed. */
>                 map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
>                               (u64)sizeof(struct setup_data));
>                 data = early_memremap(pa_data, map_len);
>                 data_len = data->len + sizeof(struct setup_data);
> -               if (data_len > map_len) {
> -                       early_iounmap(data, map_len);
> -                       data = early_memremap(pa_data, data_len);
> -                       map_len = data_len;
> -               }
>
>                 switch (data->type) {
>                 case SETUP_E820_EXT:
> +                       remap_setup_data(pa_data, data_len, &data, &map_len);
>                         parse_e820_ext(data);
>                         break;
>                 case SETUP_DTB:

how about just passing phys_addr and length with parse_e820_ext and parse_dtb?
let them to worry about length and handle oversize case.

Thanks

Yinghai
