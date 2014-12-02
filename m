Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbaLBU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:58:32 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:51133 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaLBU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Dec 2014 12:58:07 -0800
Message-ID: <CALCETrXsQbCeQBUo_FrXNVS42mBEFXz1jku9TicVbFhxTmNGmA@mail.gmail.com>
Subject: Re: [CFT][PATCH 1/3] userns: Avoid problems with negative groups
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

On Tue, Dec 2, 2014 at 12:25 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Classic unix permission checks have an interesting feature, the group
> permissions for a file can be set to less than the other permissions
> on a file.  Occassionally this is used deliberately to give a certain
> group of users fewer permissions than the default.
>
> Overlooking negative groups has resulted in the permission checks for
> setting up a group mapping in a user namespace to be too lax.  Tighten
> the permission checks in new_idmap_permitted to ensure that mapping
> uids and gids into user namespaces without privilege will not result
> in new combinations of credentials being available to the users.
>
> When setting mappings without privilege only the creator of the user
> namespace is interesting as all other users that have CAP_SETUID over
> the user namespace will also have CAP_SETUID over the user namespaces
> parent.  So the scope of the unprivileged check is reduced to just
> the case where cred->euid is the namespace creator.
>
> For setting a uid mapping without privilege only euid is considered as
> setresuid can set uid, suid and fsuid from euid without privielege
> making any combination of uids possible with user namespaces already
> possible without them.
>
> For now seeting a gid mapping without privilege is removed.  The only
> possible set of credentials that would be safe without a gid mapping
> (egid without any supplementary groups) just doesn't happen in practice
> so would simply lead to unused untested code.
>
> setgroups is modified to fail not only when the group ids do not
> map but also when there are no gid mappings at all, preventing
> setgroups(0, NULL) from succeeding when gid mappings have not been
> established.
>
> For a small class of applications this change breaks userspace
> and removes useful functionality.  This small class of applications
> includes tools/testing/selftests/mount/unprivileged-remount-test.c
>
> Most of the removed functionality will be added back with the
> addition of a one way knob to disable setgroups.  Once setgroups
> is disabled setting the gid_map becomes as safe as setting the uid_map.
>
> For more common applications that set the uid_map and the gid_map with
> privilege this change will have no effect on them.
>
> This should fix CVE-2014-8989.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---

>
> +static inline bool gid_mapping_possible(const struct user_namespace *ns)
> +{
> +       return ns->gid_map.nr_extents != 0;
> +}
> +

Can you rename this to userns_may_setgroups or something like that?
To me, gid_mapping_possible sounds like you're allowed to map gids,
which sounds like the opposite condition, and it doesn't explain what
the point is.


> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index aa312b0dc3ec..51d65b444951 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -812,16 +812,19 @@ static bool new_idmap_permitted(const struct file *file,
>                                 struct user_namespace *ns, int cap_setid,
>                                 struct uid_gid_map *new_map)
>  {
> -       /* Allow mapping to your own filesystem ids */
> -       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
> +       const struct cred *cred = file->f_cred;
> +
> +       /* Allow a mapping without capabilities when allowing the root
> +        * of the user namespace capabilities restricted to that id
> +        * will not change the set of credentials available to that
> +        * user.
> +        */
> +       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
> +           uid_eq(ns->owner, cred->euid)) {

What's uid_eq(ns->owner, cred->euid)) for?  This should already be covered by:

    if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
        goto out;

(except that I don't know why cap_valid(cap_setid) is checked -- this
ought to be enforced for projid_map, too, right?)

>                 u32 id = new_map->extent[0].lower_first;
>                 if (cap_setid == CAP_SETUID) {
>                         kuid_t uid = make_kuid(ns->parent, id);
> -                       if (uid_eq(uid, file->f_cred->fsuid))
> -                               return true;
> -               } else if (cap_setid == CAP_SETGID) {
> -                       kgid_t gid = make_kgid(ns->parent, id);
> -                       if (gid_eq(gid, file->f_cred->fsgid))
> +                       if (uid_eq(uid, cred->euid))

Why'd you change this from fsuid to euid?

--Andy
