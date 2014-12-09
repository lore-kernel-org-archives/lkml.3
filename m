Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaLIWuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:50:01 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59500 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaLIWty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <87mw6wk12i.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org> <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org> <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87mw6wk12i.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 9 Dec 2014 14:49:32 -0800
Message-ID: <CALCETrXffwu6+yn76FXB2xnk+2GQq5UZSxXokOk8pxsHz6Ye_Q@mail.gmail.com>
Subject: Re: [CFT][PATCH 6/8] userns: Rename id_map_mutex to userns_state_mutex
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 12:41 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Generalize id_map_mutex so it can be used for more state of a user namespace.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 1e34de2fbd60..44a555ac6104 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -24,6 +24,7 @@
>  #include <linux/fs_struct.h>
>
>  static struct kmem_cache *user_ns_cachep __read_mostly;
> +static DEFINE_MUTEX(userns_state_mutex);
>
>  static bool new_idmap_permitted(const struct file *file,
>                                 struct user_namespace *ns, int cap_setid,
> @@ -583,9 +584,6 @@ static bool mappings_overlap(struct uid_gid_map *new_map,
>         return false;
>  }
>
> -
> -static DEFINE_MUTEX(id_map_mutex);
> -
>  static ssize_t map_write(struct file *file, const char __user *buf,
>                          size_t count, loff_t *ppos,
>                          int cap_setid,
> @@ -602,7 +600,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>         ssize_t ret = -EINVAL;
>
>         /*
> -        * The id_map_mutex serializes all writes to any given map.
> +        * The userns_state_mutex serializes all writes to any given map.
>          *
>          * Any map is only ever written once.
>          *
> @@ -620,7 +618,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>          * order and smp_rmb() is guaranteed that we don't have crazy
>          * architectures returning stale data.
>          */
> -       mutex_lock(&id_map_mutex);
> +       mutex_lock(&userns_state_mutex);
>
>         ret = -EPERM;
>         /* Only allow one successful write to the map */
> @@ -750,7 +748,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>         *ppos = count;
>         ret = count;
>  out:
> -       mutex_unlock(&id_map_mutex);
> +       mutex_unlock(&userns_state_mutex);
>         if (page)
>                 free_page(page);
>         return ret;
> @@ -845,12 +843,12 @@ bool userns_may_setgroups(const struct user_namespace *ns)
>  {
>         bool allowed;
>
> -       mutex_lock(&id_map_mutex);
> +       mutex_lock(&userns_state_mutex);
>         /* It is not safe to use setgroups until a gid mapping in
>          * the user namespace has been established.
>          */
>         allowed = ns->gid_map.nr_extents != 0;
> -       mutex_unlock(&id_map_mutex);
> +       mutex_unlock(&userns_state_mutex);
>
>         return allowed;
>  }
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
