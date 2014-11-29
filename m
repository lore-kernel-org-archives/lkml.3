Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaK2EYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 23:24:32 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56381 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbaK2EYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 23:24:31 -0500
X-Sasl-enc: 4VQq/SnhwNWDQvJEnaFKKVDB9MZboh5h8EtYzEhX9050 1417235070
Date: Fri, 28 Nov 2014 20:23:08 -0800
From: Greg KH <greg@kroah.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
Message-ID: <20141129042308.GB30450@kroah.com>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:05:01PM -0800, Andy Lutomirski wrote:
> Pid reuse is common, which means that it's difficult or impossible
> to read information about a pid from /proc without races.
> 
> This introduces a second number associated with each (task, pidns)
> pair called highpid.  Highpid is a 64-bit number, and, barring
> extremely unlikely circumstances or outright error, a (highpid, pid)
> will never be reused.
> 
> With just this change, a program can open /proc/PID/status, read the
> "Highpid" field, and confirm that it has the expected value.  If the
> pid has been reused, then highpid will be different.
> 
> The initial implementation is straightforward: highpid is simply a
> 64-bit counter. If a high-end system can fork every 3 ns (which
> would be amazing, given that just allocating a pid requires at
> atomic operation), it would take well over 1000 years for highpid to
> wrap.
> 
> For CRIU's benefit, the next highpid can be set by a privileged
> user.
> 
> NB: The sysctl stuff only works on 64-bit systems.  If the approach
> looks good, I'll fix that somehow.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> If this goes in, there's plenty of room to add new interfaces to
> make this more useful.  For example, we could add a fancier tgkill
> that adds and validates hightgid and highpid, and we might want to
> add a syscall to read one's own hightgid and highpid.  These would
> be quite useful for pidfiles.
> 
> David, would this be useful for kdbus?
> 
> CRIU people: will this be unduly difficult to support in CRIU?
> 
> If you all think this is a good idea, I'll fix the sysctl stuff and
> document it.  It might also be worth adding "Hightgid" to status.
> 
>  fs/proc/array.c               |  5 ++++-
>  include/linux/pid.h           |  2 ++
>  include/linux/pid_namespace.h |  1 +
>  kernel/pid.c                  | 19 +++++++++++++++----
>  kernel/pid_namespace.c        | 22 ++++++++++++++++++++++
>  5 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index cd3653e4f35c..f1e0e69d19f9 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -159,6 +159,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  	int g;
>  	struct fdtable *fdt = NULL;
>  	const struct cred *cred;
> +	const struct upid *upid;
>  	pid_t ppid, tpid;
>  
>  	rcu_read_lock();
> @@ -170,12 +171,14 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  		if (tracer)
>  			tpid = task_pid_nr_ns(tracer, ns);
>  	}
> +	upid = pid_upid_ns(pid, ns);
>  	cred = get_task_cred(p);
>  	seq_printf(m,
>  		"State:\t%s\n"
>  		"Tgid:\t%d\n"
>  		"Ngid:\t%d\n"
>  		"Pid:\t%d\n"
> +		"Highpid:\t%llu\n"
>  		"PPid:\t%d\n"
>  		"TracerPid:\t%d\n"
>  		"Uid:\t%d\t%d\t%d\t%d\n"

Changing existing proc files like this is dangerous and can cause lots
of breakage in userspace programs if you are not careful.  Usually
adding fields to the end of the file is best, but sometimes even then
things can break :(
