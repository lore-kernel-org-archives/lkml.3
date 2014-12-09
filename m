Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaLIXAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:00:50 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:34138 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaLIXAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:00:46 -0500
MIME-Version: 1.0
In-Reply-To: <874mt4lfr6.fsf_-_@x220.int.ebiederm.org>
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
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <874mt4lfr6.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 9 Dec 2014 15:00:24 -0800
Message-ID: <CALCETrU+xU3N+kPW1Mf2MV6QF2_cJFmatR2x_Mq7RTDJLcM68A@mail.gmail.com>
Subject: Re: [CFT][PATCH 3/8] userns: Don't allow unprivileged creation of gid mappings
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

On Tue, Dec 9, 2014 at 12:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> As any gid mapping will allow and must allow for backwards
> compatibility dropping groups don't allow any gid mappings to be
> established without CAP_SETGID in the parent user namespace.
>
> For a small class of applications this change breaks userspace
> and removes useful functionality.  This small class of applications
> includes tools/testing/selftests/mount/unprivilged-remount-test.c
>
> Most of the removed functionality will be added back with the addition
> of a one way knob to disable setgroups.  Once setgroups is disabled
> setting the gid_map becomes as safe as setting the uid_map.
>
> For more common applications that set the uid_map and the gid_map
> with privilege this change will have no affect.
>

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

> This is part of a fix for CVE-2014-8989.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 27c8dab48c07..1ce6d67c07b7 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -821,10 +821,6 @@ static bool new_idmap_permitted(const struct file *file,
>                         kuid_t uid = make_kuid(ns->parent, id);
>                         if (uid_eq(uid, file->f_cred->fsuid))
>                                 return true;
> -               } else if (cap_setid == CAP_SETGID) {
> -                       kgid_t gid = make_kgid(ns->parent, id);
> -                       if (gid_eq(gid, file->f_cred->fsgid))
> -                               return true;
>                 }
>         }
>
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
