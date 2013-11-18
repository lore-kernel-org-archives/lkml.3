Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3KRSiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:38:46 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54598 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3KRSie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:38:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131116190141.GC22666@redhat.com>
References: <20131101232521.GA23119@www.outflux.net>
	<20131114170337.GA11068@redhat.com>
	<CAGXu5jLXpLqjCAMFwKp7t7GpMq4+WBqNzSFC=up+CBvgGDuFCw@mail.gmail.com>
	<20131115203652.GA13476@redhat.com>
	<CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com>
	<20131116190057.GA22666@redhat.com>
	<20131116190141.GC22666@redhat.com>
Date: Mon, 18 Nov 2013 10:38:33 -0800
X-Google-Sender-Auth: EOh49mpGfEBsUi5yshSqYupQ4YI
Message-ID: <CAGXu5jK4sJ6zwi+rPqP-FjwY4C+6gsOVUOBfN7ztu9wNQYnk4g@mail.gmail.com>
Subject: Re: [PATCH 2/3] kill MMF_DUMPABLE and MMF_DUMP_SECURELY
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>,
        Petr Matousek <pmatouse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 11:01 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Nobody actually needs MMF_DUMPABLE/MMF_DUMP_SECURELY, there
> are only used to enforce the encoding of SUID_DUMP_* enum in
> mm->flags & MMF_DUMPABLE_MASK.
>
> Now that set_dumpable() updates both bits atomically we can
> kill them and simply store the value "as is" in 2 lower bits.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/exec.c             |   18 +++---------------
>  include/linux/sched.h |    4 +---
>  2 files changed, 4 insertions(+), 18 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 613c9dc..5303005 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1620,8 +1620,7 @@ void set_binfmt(struct linux_binfmt *new)
>  EXPORT_SYMBOL(set_binfmt);
>
>  /*
> - * set_dumpable converts traditional three-value dumpable to two flags and
> - * stores them into mm->flags.
> + * set_dumpable stores three-value SUID_DUMP_* into mm->flags.
>   */
>  void set_dumpable(struct mm_struct *mm, int value)
>  {
> @@ -1629,24 +1628,13 @@ void set_dumpable(struct mm_struct *mm, int value)
>
>         do {
>                 old = ACCESS_ONCE(mm->flags);
> -               new = old & ~MMF_DUMPABLE_MASK;
> -
> -               switch (value) {
> -               case SUID_DUMP_ROOT:
> -                       new |= (1 << MMF_DUMP_SECURELY);
> -               case SUID_DUMP_USER:
> -                       new |= (1<< MMF_DUMPABLE);
> -               }
> -
> +               new = (old & ~MMF_DUMPABLE_MASK) | value;

Just to make this safe against insane callers, perhaps mask the value as well?

    new = (old & ~MMF_DUMPABLE_MASK) | (value & MMF_DUMPABLE_MASK);

>         } while (cmpxchg(&mm->flags, old, new) != old);
>  }
>
>  int __get_dumpable(unsigned long mm_flags)
>  {
> -       int ret;
> -
> -       ret = mm_flags & MMF_DUMPABLE_MASK;
> -       return (ret > SUID_DUMP_USER) ? SUID_DUMP_ROOT : ret;
> +       return mm_flags & MMF_DUMPABLE_MASK;
>  }
>
>  /*
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 838a3d9..828c00d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -326,10 +326,8 @@ extern int get_dumpable(struct mm_struct *mm);
>  #define SUID_DUMP_ROOT         2       /* Dump as root */
>
>  /* mm flags */
> -/* dumpable bits */
> -#define MMF_DUMPABLE      0  /* core dump is permitted */
> -#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
>
> +/* for SUID_DUMP_* above */
>  #define MMF_DUMPABLE_BITS 2
>  #define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)

Besides that, looks great.

-Kees

-- 
Kees Cook
Chrome OS Security
