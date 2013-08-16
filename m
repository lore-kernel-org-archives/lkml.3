Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3HPNhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:37:22 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49689 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPNhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <C9C6655E-4974-4C04-8CEE-CA16563F4CC5@gmail.com>
References: <C9C6655E-4974-4C04-8CEE-CA16563F4CC5@gmail.com>
Date: Fri, 16 Aug 2013 15:37:17 +0200
Message-ID: <CANq1E4STAFLpDoyLHxXVXqk7mjzmBr1jO3XuxL2B+cJzgHe0vA@mail.gmail.com>
Subject: Re: [PATCH] efifb: prevent null dereferences by removing unused array
 indices from dmi_list
From: David Herrmann <dh.herrmann@gmail.com>
To: James Bates <james.h.bates@gmail.com>
Cc: Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Aug 7, 2013 at 1:15 AM, James Bates <james.h.bates@gmail.com> wrote:
> Hi all,
>
> The dmi_list array is initialized using gnu designated initializers, and therefore
> contains fewer explicitly defined entries as there are elements in it. This
> is because the enum above with M_blabla constants contains more items than the designated
> initializer. Those elements not explicitly initialized are implicitly set to 0.
>
> Now efifb_setup(), L.322 & L.323, loops through all these array elements, and performs
> a strcmp o a field (optname) in each item. For non explicitly initialized elements this
> will be a null pointer:
>
>                         for (i = 0; i < M_UNKNOWN; i++) {
>                                 if (!strcmp(this_opt, dmi_list[i].optname) &&
>
> On my macbook6,1 the predefined values are for some reason incorrect, and most parameters
> are preset correctly by my efi bootloader (elilo). but stride/line_length is not detected
> correctly and so I wish to set it explicitly using a "video=efifb:stride:2048" command-line
> argument. Because of the above null dereference, an exception (presumably) occurs before
> the parsing code (L.333) is ever reached. I say presumably since the mac hangs on boot
> without a console, and I can therefore not see any output.
>
> By removing the unused values from the enum, and thus preventing implicitly initialized items
> in the dmi_list array, the null dereference does not occur, my customer command-line arg is
> parsed correctly, and my console displays correctly.
>
> Signed-off-by: James Bates <james.h.bates@gmail.com>

(CC'ing hpa)

Yepp, this patch looks good:
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

However, I'd like to see some code to prevent this from happening
again. It isn't really obvious that removing an entry will result in a
NULL-deref. I am not the maintainer of this code, but I'd really like
to see a "(dmi_list[i].optname && !strcmp())" check in efifb_setup().
Otherwise we _will_ run into this again.

Side note: this code got moved to arch/x86/kernel/sysfb_efi.c in the
x86 tree. I am adding hpa here so he will remember this once Linus
gets a merge conflict (iff the sysfb changes get merged through the
x86 tree).

Thanks
David

> ---
>  drivers/video/efifb.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 50fe668..52d1d88 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -50,12 +50,9 @@ enum {
>         M_MINI_3_1,     /* Mac Mini, 3,1th gen */
>         M_MINI_4_1,     /* Mac Mini, 4,1th gen */
>         M_MB,           /* MacBook */
> -       M_MB_2,         /* MacBook, 2nd rev. */
> -       M_MB_3,         /* MacBook, 3rd rev. */
>         M_MB_5_1,       /* MacBook, 5th rev. */
>         M_MB_6_1,       /* MacBook, 6th rev. */
>         M_MB_7_1,       /* MacBook, 7th rev. */
> -       M_MB_SR,        /* MacBook, 2nd gen, (Santa Rosa) */
>         M_MBA,          /* MacBook Air */
>         M_MBA_3,        /* Macbook Air, 3rd rev */
>         M_MBP,          /* MacBook Pro */
> --
> 1.7.12.4 (Apple Git-37)
>
