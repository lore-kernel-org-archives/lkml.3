Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbaKUQdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:33:43 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:37479 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaKUQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <1416582363-20661-8-git-send-email-bobby.prani@gmail.com>
References: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
	<1416582363-20661-8-git-send-email-bobby.prani@gmail.com>
Date: Fri, 21 Nov 2014 08:33:40 -0800
X-Google-Sender-Auth: m39MLKCdpBSCly49mO_Z6HoBAZQ
Message-ID: <CAGXu5j+voSykTQ1sCh9+a8XuA-uhSKn1iNkEPX2bap0g4kK9PA@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] seccomp: Replace smp_read_barrier_depends() with lockless_dereference()
From: Kees Cook <keescook@chromium.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 7:06 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/seccomp.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

Do you need me to carry this patch in the seccomp tree, or will
someone else be taking your entire series?

-Kees

>
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 4ef9687..3729b06 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -175,17 +175,16 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
>   */
>  static u32 seccomp_run_filters(struct seccomp_data *sd)
>  {
> -       struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
>         struct seccomp_data sd_local;
>         u32 ret = SECCOMP_RET_ALLOW;
> +       /* Make sure cross-thread synced filter points somewhere sane. */
> +       struct seccomp_filter *f =
> +                       lockless_dereference(current->seccomp.filter);
>
>         /* Ensure unexpected behavior doesn't result in failing open. */
>         if (unlikely(WARN_ON(f == NULL)))
>                 return SECCOMP_RET_KILL;
>
> -       /* Make sure cross-thread synced filter points somewhere sane. */
> -       smp_read_barrier_depends();
> -
>         if (!sd) {
>                 populate_seccomp_data(&sd_local);
>                 sd = &sd_local;
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security
