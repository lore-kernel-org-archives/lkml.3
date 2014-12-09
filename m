Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaLIWt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:49:29 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:59785 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaLIWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:49:24 -0500
MIME-Version: 1.0
In-Reply-To: <87d27slfsw.fsf_-_@x220.int.ebiederm.org>
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
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87d27slfsw.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 9 Dec 2014 14:49:02 -0800
Message-ID: <CALCETrVraEnTxq1iQmb9Gbtb1Jtj8W-8BYstPzzHfKW0wH1xVw@mail.gmail.com>
Subject: Re: [CFT][PATCH 2/8] userns: Don't allow setgroups until a gid
 mapping has been setablished
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

On Tue, Dec 9, 2014 at 12:38 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> setgroups is unique in not needing a valid mapping before it can be called,
> in the case of setgroups(0, NULL) which drops all supplemental groups.
>
> The design of the user namespace assumes that CAP_SETGID can not actually
> be used until a gid mapping is established.  Therefore add a helper function
> to see if the user namespace gid mapping has been established and call
> that function in the setgroups permission check.
>
> This is part of the fix for CVE-2014-8989, being able to drop groups
> without privilege using user namespaces.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  include/linux/user_namespace.h |  5 +++++
>  kernel/groups.c                |  4 +++-
>  kernel/user_namespace.c        | 14 ++++++++++++++
>  3 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index e95372654f09..8d493083486a 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -63,6 +63,7 @@ extern const struct seq_operations proc_projid_seq_operations;
>  extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
>  extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
>  extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
> +extern bool userns_may_setgroups(const struct user_namespace *ns);
>  #else
>
>  static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
> @@ -87,6 +88,10 @@ static inline void put_user_ns(struct user_namespace *ns)
>  {
>  }
>
> +static inline bool userns_may_setgroups(const struct user_namespace *ns)
> +{
> +       return true;
> +}
>  #endif
>
>  #endif /* _LINUX_USER_H */
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 02d8a251c476..664411f171b5 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -6,6 +6,7 @@
>  #include <linux/slab.h>
>  #include <linux/security.h>
>  #include <linux/syscalls.h>
> +#include <linux/user_namespace.h>
>  #include <asm/uaccess.h>
>
>  /* init to 2 - one for init_task, one to ensure it is never freed */
> @@ -217,7 +218,8 @@ bool may_setgroups(void)
>  {
>         struct user_namespace *user_ns = current_user_ns();
>
> -       return ns_capable(user_ns, CAP_SETGID);
> +       return ns_capable(user_ns, CAP_SETGID) &&
> +               userns_may_setgroups(user_ns);
>  }
>
>  /*
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index b99c862a2e3f..27c8dab48c07 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -843,6 +843,20 @@ static bool new_idmap_permitted(const struct file *file,
>         return false;
>  }
>
> +bool userns_may_setgroups(const struct user_namespace *ns)
> +{
> +       bool allowed;
> +
> +       mutex_lock(&id_map_mutex);
> +       /* It is not safe to use setgroups until a gid mapping in
> +        * the user namespace has been established.
> +        */
> +       allowed = ns->gid_map.nr_extents != 0;
> +       mutex_unlock(&id_map_mutex);
> +
> +       return allowed;
> +}
> +
>  static void *userns_get(struct task_struct *task)
>  {
>         struct user_namespace *user_ns;
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
