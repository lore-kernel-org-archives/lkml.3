Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab3IFJzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:55:31 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60694 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3IFJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <1378459933-367-1-git-send-email-teg@jklm.no>
References: <1378459933-367-1-git-send-email-teg@jklm.no>
Date: Fri, 6 Sep 2013 11:55:29 +0200
Message-ID: <CANq1E4Tco9K1zeL2d7MhBQ=UjHFOktrrR8GHp8cJm3V6CTqf0g@mail.gmail.com>
Subject: Re: [PATCH] x86: simplefb: avoid overflow
From: David Herrmann <dh.herrmann@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Sep 6, 2013 at 11:32 AM, Tom Gundersen <teg@jklm.no> wrote:
> lfb_size can easily be say 4M, which would make the bitshit overflow and
> the test fail.
>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/sysfb_simplefb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
> index 22513e9..fff44a5 100644
> --- a/arch/x86/kernel/sysfb_simplefb.c
> +++ b/arch/x86/kernel/sysfb_simplefb.c
> @@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info *si,
>          * the part that is occupied by the framebuffer */
>         len = mode->height * mode->stride;
>         len = PAGE_ALIGN(len);
> -       if (len > si->lfb_size << 16) {
> +       if (len > ((unsigned long) si->lfb_size) << 16) {

Nice catch. vesafb uses "lfb_size * 65535" which causes an implicit
cast. I thought <<16 looks nicer but that doesn't do any implicit
cast..

Nothing crucial, as it only causes the simple-fb conversion to fail.
But would still be good to see in -rc2:
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

>                 printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
>                 return -EINVAL;
>         }
> --
> 1.8.4
>
