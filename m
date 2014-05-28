Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaE1Mow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:44:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:52647 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaE1Mov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:44:51 -0400
Message-ID: <5385DA19.2060008@parallels.com>
Date: Wed, 28 May 2014 16:44:09 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 02:24 PM, Chen Hanxiao wrote:
> We need a direct method of getting the pid inside containers.

But there's more generic issue -- some day we'll need to know not only
PIDs as seen from different namespaces, but also SIDs and PGIDs.

> If some issues occurred inside container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
> 
> This patch adds two fields:
> 
> NStgid and NSpid.
> 
> a) In init_pid_ns, nothing changed;
> 
> b) In one pidns, will tell the pid inside containers:
> NStgid:	1628 	9 	3
> NSpid:	1628 	9 	3
> ** Process id is 1628 in level 0, 9 in level 1, 3 in level 2.
> 
> c) If pidns is nested, it depends on which pidns are you in.
> NStgid:	9 	3
> NSpid:	9 	3
> ** Views from level 1
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
> v2: add two new fields: NStgid and NSpid.
>     keep fields of Tgid and Pid unchanged for back compatibility.
> 
>  fs/proc/array.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 64db2bc..9b7e65c 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -193,6 +193,15 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  		from_kgid_munged(user_ns, cred->egid),
>  		from_kgid_munged(user_ns, cred->sgid),
>  		from_kgid_munged(user_ns, cred->fsgid));
> +	seq_puts(m, "NStgid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_tgid_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSpid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_pid_nr_ns(p, pid->numbers[g].ns));
> +	seq_putc(m, '\n');
>  
>  	task_lock(p);
>  	if (p->files)
> 


