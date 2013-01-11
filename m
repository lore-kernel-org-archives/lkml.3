Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3AKNtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:49:04 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49366 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3AKNtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:49:01 -0500
MIME-Version: 1.0
In-Reply-To: <50EFDF15.4080606@csamuel.org>
References: <50EFDF15.4080606@csamuel.org>
Date: Fri, 11 Jan 2013 08:49:00 -0500
Message-ID: <CA+5PVA7F1RV3=Ynv+et=ZzOTRszop=sXY2QscuuHGO2RhLpSYg@mail.gmail.com>
Subject: Re: [PATCH] MODSIGN: Warn when sign check fails due to -ENOKEY
From: Josh Boyer <jwboyer@gmail.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 4:44 AM, Chris Samuel <chris@csamuel.org> wrote:
> /* Please CC me in responses, I am not subscribed to LKML */
>
> Currently if a signature check fails on module load due to not having
> the appropriate key (-ENOKEY) and we are not doing strict checking
> there is no information provided to the user other than the lock debug
> taint warning:
>
> Disabling lock debugging due to kernel taint
>
> This patch causes a single warning to be emitted to explain why the
> kernel is being tainted, before the above taint warning occurs.
>
> Module verification failed, required key not present, tainting kernel
>
> Found whilst trying to work out why all the 3.8 development kernels
> I was building and testing were warning about taints and why all modules
> were listed as forced load (F) in /proc/modules when that wasn't the
> case in the 3.5, 3.6 or 3.7 kernels I'd tried.
>
> Signed-off-by: Christopher Samuel <chris@csamuel.org>
> ---
>  kernel/module.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 250092c..27de534 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2443,8 +2443,10 @@ static int module_sig_check(struct load_info *info)
>         if (err < 0 && fips_enabled)
>                 panic("Module verification failed with error %d in FIPS
> mode\n",
>                       err);
> -       if (err == -ENOKEY && !sig_enforce)
> +       if (err == -ENOKEY && !sig_enforce) {
> +               printk_once(KERN_DEBUG "Module verification failed, required
> key not present, tainting kernel\n");
>                 err = 0;
> +       }
>         return err;

I'd suggest putting the printk in load_module where we call the
add_taint_module function instead.  Also, you might want to make the
priority a bit higher if it's meant to be informative.  Something like
KERN_INFO.

josh
