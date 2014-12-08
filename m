Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaLHW1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:27:10 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53152 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLHW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <87egs9pz5u.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87egs9pz5u.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 8 Dec 2014 14:26:44 -0800
Message-ID: <CALCETrU+4EpVZ51uAKPOfPBp7qGaEnB60R2R0RdWOkoTciDUzA@mail.gmail.com>
Subject: Re: [CFT][PATCH 7/7] userns: Allow setting gid_maps without privilege
 when setgroups is disabled
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

On Mon, Dec 8, 2014 at 2:14 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Now that setgroups can be disabled and not reenabled, setting gid_map
> without privielge can now be enabled when setgroups is disabled.
>
> This restores most of the functionality that was lost when unprivilege

unprivileged.

> setting of gid_map was removed.  Applications that use this
> functionality will need to check to see if they use setgroups or
> init_groups, and if they don't they can be fixed by simply
> disabling of setgroups before they run.

"disabling setgroups before writing to gid_map"?

The code is:

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 3d128f91ced3..459c7f647072 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -828,6 +828,11 @@ static bool new_idmap_permitted(const struct file *file,
>                         kuid_t uid = make_kuid(ns->parent, id);
>                         if (uid_eq(uid, cred->euid))
>                                 return true;
> +               } else if (cap_setid == CAP_SETGID) {
> +                       kgid_t gid = make_kgid(ns->parent, id);
> +                       if (!userns_setgroups_allowed(ns) &&
> +                           gid_eq(gid, cred->egid))
> +                               return true;
>                 }
>         }
>
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
