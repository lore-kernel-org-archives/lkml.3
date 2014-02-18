Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaBRExm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 23:53:42 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:54872
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754066AbaBRExl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 23:53:41 -0500
Date: Tue, 18 Feb 2014 05:53:39 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 2/3] capabilities: add a secure bit to allow changing a
 task exe link
Message-ID: <20140218045339.GA1175@mail.hallyn.com>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
 <1392387209-330-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392387209-330-3-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrey Vagin (avagin@openvz.org):
> When we restore a task we need to restore its exe link from userspace to
> the values the task had at checkpoint time.
> 
> Currently this operations required the global CAP_SYS_RESOURCE, which is
> always absent in a non-root user namespace.
> 
> So this patch introduces a new security bit which:
> * can be set only if a task has the global CAP_SYS_RESOURCE
> * inherited  by  child  processes
> * is saved when a task moves in another userns
> * allows to change a task exe link even if a task doesn't have CAP_SYS_RESOURCE

I'm late to this party anyway, but fwiw I don't like this use
of securebits.  It also seems to prevent c/r in a nested
container anyway so wouldn't seem to suffice.

But I assume I don't really need to argue it as it appears Pavel
and Eric are looking into a better all-around design.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Aditya Kali <adityakali@google.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  include/uapi/linux/securebits.h | 12 +++++++++++-
>  kernel/sys.c                    |  5 +++++
>  kernel/user_namespace.c         |  3 ++-
>  security/commoncap.c            |  7 +++++++
>  4 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/securebits.h
> index 985aac9..c99803b 100644
> --- a/include/uapi/linux/securebits.h
> +++ b/include/uapi/linux/securebits.h
> @@ -43,9 +43,19 @@
>  #define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
>  #define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
>  
> +/* When set, a process can do PR_SET_MM_EXE_FILE even if it doesn't
> + * have CAP_SYS_RESOURCE. Setting of this bit requires CAP_SYS_RESOURCE.
> + * This bit is not dropped when a task moves in another userns. */
> +#define SECURE_SET_EXE_FILE		6
> +#define SECURE_SET_EXE_FILE_LOCKED	7  /* make bit-6 immutable */
> +
> +#define SECBIT_SET_EXE_FILE	   (issecure_mask(SECURE_SET_EXE_FILE))
> +#define SECBIT_SET_EXE_FILE_LOCKED (issecure_mask(SECURE_SET_EXE_FILE_LOCKED))
> +
>  #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
>  				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
> -				 issecure_mask(SECURE_KEEP_CAPS))
> +				 issecure_mask(SECURE_KEEP_CAPS) | \
> +				 issecure_mask(SECURE_SET_EXE_FILE))
>  #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
>  
>  #endif /* _UAPI_LINUX_SECUREBITS_H */
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 939370c..2f0925d 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -18,6 +18,7 @@
>  #include <linux/kernel.h>
>  #include <linux/workqueue.h>
>  #include <linux/capability.h>
> +#include <linux/securebits.h>
>  #include <linux/device.h>
>  #include <linux/key.h>
>  #include <linux/times.h>
> @@ -1714,6 +1715,10 @@ static int prctl_set_mm(int opt, unsigned long addr,
>  			if (rlimit(RLIMIT_STACK) < RLIM_INFINITY)
>  				return -EPERM;
>  			break;
> +		case PR_SET_MM_EXE_FILE:
> +			if (!issecure(SECURE_SET_EXE_FILE))
> +				return -EPERM;
> +			break;
>  		default:
>  			return -EPERM;
>  		}
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 240fb62..59584fe 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -34,7 +34,8 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>  	/* Start with the same capabilities as init but useless for doing
>  	 * anything as the capabilities are bound to the new user namespace.
>  	 */
> -	cred->securebits = SECUREBITS_DEFAULT;
> +	cred->securebits = SECUREBITS_DEFAULT |
> +				(cred->securebits & SECBIT_SET_EXE_FILE);
>  	cred->cap_inheritable = CAP_EMPTY_SET;
>  	cred->cap_permitted = CAP_FULL_SET;
>  	cred->cap_effective = CAP_FULL_SET;
> diff --git a/security/commoncap.c b/security/commoncap.c
> index b9d613e..eda1eb8 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -907,6 +907,13 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  		    )
>  			/* cannot change a locked bit */
>  			goto error;
> +
> +		/* Setting SECURE_SET_EXE_FILE requires CAP_SYS_RESOURCE */
> +		if ((arg2 & SECBIT_SET_EXE_FILE) &&
> +		    !(new->securebits & SECBIT_SET_EXE_FILE) &&
> +		    !capable(CAP_SYS_RESOURCE))
> +			goto error;
> +
>  		new->securebits = arg2;
>  		goto changed;
>  
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
