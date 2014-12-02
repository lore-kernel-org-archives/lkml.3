Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbaLBVFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:05:32 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36374 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaLBVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Dec 2014 13:05:07 -0800
Message-ID: <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
Subject: Re: [CFT][PATCH 2/3] userns: Add a knob to disable setgroups on a per
 user namespace basis
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

On Tue, Dec 2, 2014 at 12:28 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> - Expose the knob to user space through a proc file /proc/<pid>/setgroups

Can you rename this to something clearer, e.g. userns_setgroups_mode?

>
>   A value of 0 means the setgroups system call is disabled in the
>   current processes user namespace and can not be enabled in the
>   future in this user namespace.
>
>   A value of 1 means the segtoups system call is enabled.

Would it make more sense to put strings like "allow" and "deny" in
here?  That way, future extensions could add additional values.

> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
> index 21c91feeca2d..6d0ee1b089fb 100644
> --- a/arch/s390/kernel/compat_linux.c
> +++ b/arch/s390/kernel/compat_linux.c
> @@ -252,6 +252,7 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
>         int retval;
>
>         if (!gid_mapping_possible(user_ns) ||
> +           !atomic_read(&user_ns->setgroups_allowed) ||
>             !capable(CAP_SETGID))
>                 return -EPERM;

This is now incomprehensible because of the gid_mapping_possible
thing.  If you renamed gid_mapping_possible to
userns_setgroup_allowed, then this could be added to the
implementation, and this would all make sense (not to mention avoiding
duplicating this thing).

> @@ -826,6 +827,11 @@ static bool new_idmap_permitted(const struct file *file,
>                         kuid_t uid = make_kuid(ns->parent, id);
>                         if (uid_eq(uid, cred->euid))
>                                 return true;
> +               } else if (cap_setid == CAP_SETGID) {
> +                       kgid_t gid = make_kgid(ns->parent, id);
> +                       if (!atomic_read(&ns->setgroups_allowed) &&
> +                           gid_eq(gid, cred->egid))
> +                               return true;

I still don't see why egid is any better than fsgid here.

>                 }
>         }
>
> @@ -844,6 +850,93 @@ static bool new_idmap_permitted(const struct file *file,
>         return false;
>  }
>
> +static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
> +{
> +       struct user_namespace *ns = seq->private;
> +
> +       return (*ppos == 0) ?  ns : NULL;
> +}
> +
> +static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
> +{
> +       ++*ppos;
> +       return NULL;
> +}
> +
> +static void setgroups_m_stop(struct seq_file *seq, void *v)
> +{
> +}
> +
> +static int setgroups_m_show(struct seq_file *seq, void *v)
> +{
> +       struct user_namespace *ns = seq->private;
> +
> +       seq_printf(seq, "%u\n", atomic_read(&ns->setgroups_allowed));
> +       return 0;
> +}
> +
> +const struct seq_operations proc_setgroups_seq_operations = {
> +       .start  = setgroups_m_start,
> +       .stop = setgroups_m_stop,
> +       .next = setgroups_m_next,
> +       .show = setgroups_m_show,
> +};
> +
> +ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
> +                            size_t count, loff_t *ppos)
> +{
> +       struct seq_file *seq = file->private_data;
> +       struct user_namespace *ns = seq->private;
> +       char kbuf[3];
> +       int setgroups_allowed;
> +       ssize_t ret;
> +
> +       ret = -EPERM;
> +       if (!file_ns_capable(file, ns, CAP_SETGID))
> +               goto out;

CAP_SYS_ADMIN?  This isn't setting a gid in the namespace; it's
reconfiguring the namespace.

> +
> +       /* Only allow a very narrow range of strings to be written */
> +       ret = -EINVAL;
> +       if ((*ppos != 0) || (count >= sizeof(kbuf)) || (count < 1))
> +               goto out;
> +
> +       /* What was written? */
> +       ret = -EFAULT;
> +       if (copy_from_user(kbuf, buf, count))
> +               goto out;
> +       kbuf[count] = '\0';
> +
> +       /* What is being requested? */
> +       ret = -EINVAL;
> +       if (kbuf[0] == '0')
> +               setgroups_allowed = 0;
> +       else if (kbuf[0] == '1')
> +               setgroups_allowed = 1;
> +       else
> +               goto out;
> +
> +       /* Allow a trailing newline */
> +       ret = -EINVAL;
> +       if ((count == 2) && (kbuf[1] != '\n'))
> +               goto out;
> +
> +
> +       if (setgroups_allowed) {
> +               ret = -EINVAL;
> +               if (atomic_read(&ns->setgroups_allowed) == 0)
> +                       goto out;
> +       } else {

I would disallow this if gid_map has been written in the interest of sanity.

> +               atomic_set(&ns->setgroups_allowed, 0);
> +               /* sigh memory barriers! */

I don't think that any barriers are needed.  If you ever observe
setgroups_allowed == 0, it will stay that way forever.

> +       }
> +
> +       /* Report a successful write */
> +       *ppos = count;
> +       ret = count;
> +out:
> +       return ret;
> +}
> +
>  static void *userns_get(struct task_struct *task)
>  {
>         struct user_namespace *user_ns;

--Andy
