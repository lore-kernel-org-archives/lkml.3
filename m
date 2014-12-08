Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaLHWRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:17:42 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65279 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaLHWRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:17:40 -0500
Message-ID: <5486237D.4060304@nod.at>
Date: Mon, 08 Dec 2014 23:17:33 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Linux Containers <containers@lists.linux-foundation.org>,
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
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Subject: Re: [CFT][PATCH 2/7] userns: Don't allow setgroups until a gid mapping
 has been setablished
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>	<87h9xez20g.fsf@x220.int.ebiederm.org>	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>	<87mw75ygwp.fsf@x220.int.ebiederm.org>	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>	<87a935u3nj.fsf@x220.int.ebiederm.org>	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>	<87388xodlj.fsf@x220.int.ebiederm.org>	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>	<87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87bnndre2h.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87bnndre2h.fsf_-_@x220.int.ebiederm.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.12.2014 um 23:07 schrieb Eric W. Biederman:
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
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  include/linux/user_namespace.h | 9 +++++++++
>  kernel/groups.c                | 7 ++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index e95372654f09..41cc26e5a350 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -37,6 +37,15 @@ struct user_namespace {
>  
>  extern struct user_namespace init_user_ns;
>  
> +static inline bool userns_gid_mappings_established(const struct user_namespace *ns)
> +{
> +	bool established;
> +	smp_mb__before_atomic();
> +	established = ACCESS_ONCE(ns->gid_map.nr_extents) != 0;
> +	smp_mb__after_atomic();
> +	return established;
> +}
> +

Maybe this is a stupid question, but why do we need all this magic
around established =  ... ?
The purpose of this code is to check whether ns->gid_map.nr_extents != 0
in a lock-free manner?

Thanks,
//richard
