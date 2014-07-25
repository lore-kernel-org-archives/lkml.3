Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbaGYP7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:59:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64764 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaGYP7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <1406296033-32693-12-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com> <1406296033-32693-12-git-send-email-drysdale@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 25 Jul 2014 08:59:30 -0700
Message-ID: <CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
To: David Drysdale <drysdale@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25, 2014 6:48 AM, "David Drysdale" <drysdale@google.com> wrote:
>
> Add the current thread and thread group IDs into the data
> available for seccomp-bpf programs to work on.  This allows
> installation of filters that police syscalls based on thread
> or process ID, e.g. tgkill(2)/kill(2)/prctl(2).
>
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  include/uapi/linux/seccomp.h | 10 ++++++++++
>  kernel/seccomp.c             |  2 ++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index ac2dc9f72973..b88370d6f6ca 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -36,12 +36,22 @@
>   * @instruction_pointer: at the time of the system call.
>   * @args: up to 6 system call arguments always stored as 64-bit values
>   *        regardless of the architecture.
> + * @tgid: thread group ID of the thread executing the BPF program.
> + * @tid: thread ID of the thread executing the BPF program.
> + * The SECCOMP_DATA_TID_PRESENT macro indicates the presence of the
> + * tgid and tid fields; user programs may use this macro to conditionally
> + * compile code against older versions of the kernel.  Note also that
> + * BPF programs should cope with the absence of these fields by testing
> + * the length of data available.
>   */
>  struct seccomp_data {
>         int nr;
>         __u32 arch;
>         __u64 instruction_pointer;
>         __u64 args[6];
> +       __u32 tgid;
> +       __u32 tid;
>  };
> +#define SECCOMP_DATA_TID_PRESENT       1
>
>  #endif /* _UAPI_LINUX_SECCOMP_H */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 301bbc24739c..dd5146f15d6d 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -80,6 +80,8 @@ static void populate_seccomp_data(struct seccomp_data *sd)
>         sd->args[4] = args[4];
>         sd->args[5] = args[5];
>         sd->instruction_pointer = KSTK_EIP(task);
> +       sd->tgid = task_tgid_vnr(current);
> +       sd->tid = task_pid_vnr(current);
>  }

This is, IMO, problematic.  These should probably be relative to the
filter creator, not the filtered task.  This will also hurt
performance.

What's the use case?  Can it be better achieved with a new eBPF function?

--Andy

>
>  /**
> --
> 2.0.0.526.g5318336
>
