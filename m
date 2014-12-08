Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaLHWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:16:26 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48942 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaLHWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:16:21 -0500
MIME-Version: 1.0
In-Reply-To: <87sigppzch.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87sigppzch.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 8 Dec 2014 14:15:59 -0800
Message-ID: <CALCETrVJ1Ld00TQOUjOT3n=G8PRpY=FG8Py+t1H9_mw93AO-aQ@mail.gmail.com>
Subject: Re: [CFT][PATCH 5/7] userns: Only allow the creator of the userns
 unprivileged mappings
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

On Mon, Dec 8, 2014 at 2:10 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> If you did not create the user namespace and are allowed
> to write to uid_map or gid_map you should already have the necessary
> privilege in the parent user namespace to establish any mapping
> you want so this will not affect userspace in practice.
>
> Limiting unprivileged uid mapping establishment to the creator of the
> user namespace reduces the set of credentials that must be verified
> can be obtained without privielge, making code verification simpler.
>

s/privielge/privilege/

But I still can't parse that sentence.

The code itself is:

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

> Limiting unprivileged gid mapping establishment (which is temporarily
> absent) to the creator of the user namespace also ensures that the
> combination of uid and gid can already be obtained without privilege.
>
> This is part of the fix for CVE-2014-8989.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index da1eeb927b21..413f60fd5983 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -812,14 +812,16 @@ static bool new_idmap_permitted(const struct file *file,
>                                 struct user_namespace *ns, int cap_setid,
>                                 struct uid_gid_map *new_map)
>  {
> +       const struct cred *cred = file->f_cred;
>         /* Don't allow mappings that would allow anything that wouldn't
>          * be allowed without the establishment of unprivileged mappings.
>          */
> -       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
> +       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
> +           uid_eq(ns->owner, cred->euid)) {
>                 u32 id = new_map->extent[0].lower_first;
>                 if (cap_setid == CAP_SETUID) {
>                         kuid_t uid = make_kuid(ns->parent, id);
> -                       if (uid_eq(uid, file->f_cred->euid))
> +                       if (uid_eq(uid, cred->euid))
>                                 return true;
>                 }
>         }
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
