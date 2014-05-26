Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaEZLJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:09:43 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:53343 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaEZLJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <1401098728-2001-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1401098728-2001-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Date: Mon, 26 May 2014 13:09:39 +0200
Message-ID: <CAFLxGvxNu8dR5AYC6oar3-Jus3oBLZm10=BWcEe0wR+hRxz7eA@mail.gmail.com>
Subject: Re: [PATCH] /proc/pid/status: show all sets of pid according to ns
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:05 PM, Chen Hanxiao
<chenhanxiao@cn.fujitsu.com> wrote:
> We need a direct method of getting the pid inside containers.
> If some issues occurred inside a container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
>
> This patch expands fields of Tgid and Pid:
> a) In init_pid_ns, nothing changed;
>
> b) In one pidns, they will tell the pid inside containers:
> Tgid:   1628    9       3
> Pid:    1628    9       3
> ** process id is 1628 in level 0, 9 in level 1, 3 in level 2.
>
> c) If pidns is nested, it depends on which pidns are you in.
> Tgid:   9       3
> Pid:    9       3
> ** Views from level 1 for Pid 1628 in host.
>
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
>  fs/proc/array.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 64db2bc..eef20dd 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -173,17 +173,23 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>         cred = get_task_cred(p);
>         seq_printf(m,
>                 "State:\t%s\n"
> -               "Tgid:\t%d\n"
> -               "Ngid:\t%d\n"
> -               "Pid:\t%d\n"
> +               "Ngid:\t%d\n",

You're changing the ordering of Tgid and Ngid here.

> +               get_task_state(p),
> +               task_numa_group_id(p));
> +       seq_puts(m, "Tgid:");
> +       for (g = ns->level; g <= pid->level; g++)
> +               seq_printf(m, "\t%d ",
> +               task_tgid_nr_ns(p, pid->numbers[g].ns));

I like the idea but IMHO we should keep Tgid and Pid as is and better
add two new fields to /proc/pid/status.
What about NSpid and NSgid?

> +       seq_puts(m, "\nPid:");
> +       for (g = ns->level; g <= pid->level; g++)
> +               seq_printf(m, "\t%d ",
> +               task_pid_nr_ns(p, pid->numbers[g].ns));
> +       seq_putc(m, '\n');
> +       seq_printf(m,
>                 "PPid:\t%d\n"
>                 "TracerPid:\t%d\n"
>                 "Uid:\t%d\t%d\t%d\t%d\n"
>                 "Gid:\t%d\t%d\t%d\t%d\n",
> -               get_task_state(p),
> -               task_tgid_nr_ns(p, ns),
> -               task_numa_group_id(p),
> -               pid_nr_ns(pid, ns),
>                 ppid, tpid,
>                 from_kuid_munged(user_ns, cred->uid),
>                 from_kuid_munged(user_ns, cred->euid),
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
