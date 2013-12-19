Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3LSGOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:14:25 -0500
Received: from mail-gg0-f180.google.com ([209.85.161.180]:60240 "EHLO
	mail-gg0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3LSGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:14:24 -0500
Date: Wed, 18 Dec 2013 22:14:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vegard Nossum <vegard.nossum@oracle.com>
cc: linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
Message-ID: <alpine.DEB.2.02.1312182213340.1247@chino.kir.corp.google.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, vegard.nossum@oracle.com wrote:

> diff --git a/security/exploit.c b/security/exploit.c
> new file mode 100644
> index 0000000..a732613
> --- /dev/null
> +++ b/security/exploit.c
> @@ -0,0 +1,28 @@
> +#include <linux/cred.h>
> +#include <linux/exploit.h>
> +#include <linux/printk.h>
> +#include <linux/ratelimit.h>
> +#include <linux/sched.h>
> +
> +void _exploit(const char *id)
> +{
> +	/*
> +	 * This function needs to be super defensive/conservative, since
> +	 * userspace can easily get to it from several different contexts.
> +	 * We don't want it to become an attack vector in itself!
> +	 *
> +	 * We can assume that we're in process context, but spinlocks may
> +	 * be held, etc.

Not task_lock(current), though.

> +	 */
> +
> +	struct task_struct *task = current;
> +	pid_t pid = task_pid_nr(task);
> +	uid_t uid = from_kuid(&init_user_ns, current_uid());
> +	char comm[sizeof(task->comm)];
> +
> +	get_task_comm(comm, task);
> +
> +	pr_warn_ratelimited("warning: possible %s exploit attempt by pid=%u uid=%u comm=%s\n",
> +		id, pid, uid, comm);
> +}
> +EXPORT_SYMBOL(_exploit);
