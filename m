Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaGUW1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:27:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36407 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaGUW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:27:10 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53CD93BA.1010302@mit.edu>
Date: Mon, 21 Jul 2014 15:27:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
CC: Andrew Vagin <avagin@openvz.org>, "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Steve Grubb <sgrubb@redhat.com>,
        Dan Walsh <dwalsh@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] CAPABILITIES: remove undefined caps from all processes
References: <1405976341-23818-1-git-send-email-eparis@redhat.com>
In-Reply-To: <1405976341-23818-1-git-send-email-eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 01:59 PM, Eric Paris wrote:
> This is effectively a revert of 7b9a7ec565505699f503b4fcf61500dceb36e744
> plus fixing it a different way...
> 
> We found, when trying to run an application from an application which
> had dropped privs that the kernel does security checks on undefined
> capability bits.  This was ESPECIALLY difficult to debug as those
> undefined bits are hidden from /proc/$PID/status.
> 
> Consider a root application which drops all capabilities from ALL 4
> capability sets.  We assume, since the application is going to set
> eff/perm/inh from an array that it will clear not only the defined caps
> less than CAP_LAST_CAP, but also the higher 28ish bits which are
> undefined future capabilities.
> 
> The BSET gets cleared differently.  Instead it is cleared one bit at a
> time.  The problem here is that in security/commoncap.c::cap_task_prctl()
> we actually check the validity of a capability being read.  So any task
> which attempts to 'read all things set in bset' followed by 'unset all
> things set in bset' will not even attempt to unset the undefined bits
> higher than CAP_LAST_CAP.
> 
> So the 'parent' will look something like:
> CapInh:	0000000000000000
> CapPrm:	0000000000000000
> CapEff:	0000000000000000
> CapBnd:	ffffffc000000000
> 
> All of this 'should' be fine.  Given that these are undefined bits that
> aren't supposed to have anything to do with permissions.  But they do...
> 
> So lets now consider a task which cleared the eff/perm/inh completely
> and cleared all of the valid caps in the bset (but not the invalid caps
> it couldn't read out of the kernel).  We know that this is exactly what
> the libcap-ng library does and what the go capabilities library does.
> They both leave you in that above situation if you try to clear all of
> you capapabilities from all 4 sets.  If that root task calls execve()
> the child task will pick up all caps not blocked by the bset.  The bset
> however does not block bits higher than CAP_LAST_CAP.  So now the child
> task has bits in eff which are not in the parent.  These are
> 'meaningless' undefined bits, but still bits which the parent doesn't
> have.
> 
> The problem is now in cred_cap_issubset() (or any operation which does a
> subset test) as the child, while a subset for valid cap bits, is not a
> subset for invalid cap bits!  So now we set durring commit creds that
> the child is not dumpable.  Given it is 'more priv' than its parent.  It
> also means the parent cannot ptrace the child and other stupidity.
> 
> The solution here is 2 things.
> 1) stop hiding capability bits in status
> 	we hide those upper bits which meant I couldn't spot this issue
> 2) stop giving any task undefined capability bits.  it's simple, it you
> don't put those invalid bits in CAP_FULL_SET you won't get them in init
> and you won't get them in any other task either.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Andrew G. Morgan <morgan@kernel.org>
> Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Steve Grubb <sgrubb@redhat.com>
> Cc: Dan Walsh <dwalsh@redhat.com>
> Cc: stable@kernel.org
> ---
>  fs/proc/array.c            | 9 ---------
>  include/linux/capability.h | 2 +-
>  2 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 64db2bc..d882018 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -302,10 +302,6 @@ static void render_cap_t(struct seq_file *m, const char *header,
>  	seq_putc(m, '\n');
>  }
>  
> -/* Remove non-existent capabilities */
> -#define NORM_CAPS(v) (v.cap[CAP_TO_INDEX(CAP_LAST_CAP)] &= \
> -				CAP_TO_MASK(CAP_LAST_CAP + 1) - 1)
> -
>  static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  {
>  	const struct cred *cred;
> @@ -319,11 +315,6 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  	cap_bset	= cred->cap_bset;
>  	rcu_read_unlock();
>  
> -	NORM_CAPS(cap_inheritable);
> -	NORM_CAPS(cap_permitted);
> -	NORM_CAPS(cap_effective);
> -	NORM_CAPS(cap_bset);
> -
>  	render_cap_t(m, "CapInh:\t", &cap_inheritable);
>  	render_cap_t(m, "CapPrm:\t", &cap_permitted);
>  	render_cap_t(m, "CapEff:\t", &cap_effective);
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 84b13ad..1c36782 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -79,7 +79,7 @@ extern const kernel_cap_t __cap_init_eff_set;
>  #else /* HAND-CODED capability initializers */
>  
>  # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
> -# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
> +# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, CAP_TO_MASK(CAP_LAST_CAP + 1) -1 }})

" - 1", please.

Acked-by: Andy Lutomirski <luto@amacapital.net>

--Andy
