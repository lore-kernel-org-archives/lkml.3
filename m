Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3BBHPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 02:15:48 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:36321 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3BBHPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 02:15:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgNAkgQA=zK=2ZnytPFU=DH6jr0sja0iy6K+j6c7unheLFniQ@mail.gmail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
	<1359486181-29088-1-git-send-email-avagin@openvz.org>
	<CAKgNAkgQA=zK=2ZnytPFU=DH6jr0sja0iy6K+j6c7unheLFniQ@mail.gmail.com>
Date: Sat, 2 Feb 2013 08:15:44 +0100
Message-ID: <CANaxB-zAh_kC=P1CPPB0EMa4JVozVizOc_KMw1Y0=7ocUsqHzA@mail.gmail.com>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
From: Andrey Wagin <avagin@gmail.com>
To: mtk.manpages@gmail.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, criu@openvz.org,
        Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/2 Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>:
>
> On Jan 30, 2013 8:05 AM, "Andrey Vagin" <avagin@openvz.org> wrote:
>>
>> If signalfd is created with the flag SFD_PEEK, it reads siginfo-s
>> without dequeuing signals.
>>
>> For reading not first siginfo pread(fd, buf, size, pos) can be used,
>> where ppos / sizeof(signalfd_siginfo) is a sequence number of a signal
>> in a queue.
>
> Andrey,
>
> Is it perhaps worth erroring (EINVAL) if  ((ppos % sizeof
> (signalfd_siginfo)) != 0) ?

Yes, it's already in the patch.

@@ -257,9 +298,15 @@ static ssize_t signalfd_read(struct file *file,
char __user *buf, size_t count,
        if (!count)
                return -EINVAL;

+       if (*ppos % sizeof(struct signalfd_siginfo))
+               return -EINVAL;
+


>
> Cheers,
>
> Michael
>
>> This functionality is required for checkpointing pending signals.
>>
>> v2: * signals can be dumped only from one queue.
>>     * treat pos as offset in bytes, not in elements, so pos should be
>>       aligned to the size of signalfd_siginfo.
>>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: Dave Jones <davej@redhat.com>
>> Cc: Andrey Vagin <avagin@openvz.org>
>> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>> Cc: Pavel Emelyanov <xemul@parallels.com>
>> CC: Cyrill Gorcunov <gorcunov@openvz.org>
>> Signed-off-by: Andrey Vagin <avagin@openvz.org>
>> ---
>>  fs/signalfd.c                 | 61
>> ++++++++++++++++++++++++++++++++++++++++---
>>  include/uapi/linux/signalfd.h |  2 ++
>>  2 files changed, 60 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/signalfd.c b/fs/signalfd.c
>> index 8019ec9..0da6a30 100644
>> --- a/fs/signalfd.c
>> +++ b/fs/signalfd.c
>> @@ -51,6 +51,47 @@ struct signalfd_ctx {
>>         sigset_t sigmask;
>>  };
>>
>> +static int peek_signal(struct sigpending *pending, sigset_t *mask,
>> +                               siginfo_t *info, loff_t *pseq)
>> +{
>> +       struct sigqueue *q;
>> +       int ret = 0;
>> +
>> +       spin_lock_irq(&current->sighand->siglock);
>> +
>> +       list_for_each_entry(q, &pending->list, list) {
>> +               if (sigismember(mask, q->info.si_signo))
>> +                       continue;
>> +
>> +               if ((*pseq)-- == 0) {
>> +                       copy_siginfo(info, &q->info);
>> +                       ret = info->si_signo;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       spin_unlock_irq(&current->sighand->siglock);
>> +
>> +       return ret;
>> +}
>> +
>> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
>> +                               siginfo_t *info, loff_t *ppos, int
>> queue_mask)
>> +{
>> +       loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
>> +       int signr = 0;
>> +
>> +       if (queue_mask & SIGQUEUE_PRIVATE)
>> +               signr = peek_signal(&current->pending,
>> +                                       &ctx->sigmask, info, &seq);
>> +       else if (queue_mask & SIGQUEUE_SHARED)
>> +               signr = peek_signal(&current->signal->shared_pending,
>> +                                        &ctx->sigmask, info, &seq);
>> +       (*ppos) += sizeof(struct signalfd_siginfo);
>> +
>> +       return signr;
>> +}
>> +
>>  static int signalfd_release(struct inode *inode, struct file *file)
>>  {
>>         kfree(file->private_data);
>> @@ -257,9 +298,15 @@ static ssize_t signalfd_read(struct file *file, char
>> __user *buf, size_t count,
>>         if (!count)
>>                 return -EINVAL;
>>
>> +       if (*ppos % sizeof(struct signalfd_siginfo))
>> +               return -EINVAL;
>> +
>>         siginfo = (struct signalfd_siginfo __user *) buf;
>>         do {
>> -               ret = signalfd_dequeue(ctx, &info, nonblock, qmask);
>> +               if (file->f_flags & SFD_PEEK)
>> +                       ret = signalfd_peek(ctx, &info, ppos, qmask);
>> +               else
>> +                       ret = signalfd_dequeue(ctx, &info, nonblock,
>> qmask);
>>
>>                 if (unlikely(ret <= 0))
>>                         break;
>> @@ -315,7 +362,12 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user
>> *, user_mask,
>>         BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
>>         BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
>>
>> -       if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW | SFD_QUEUES))
>> +       if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK |
>> +                       SFD_RAW | SFD_PEEK | SFD_QUEUES))
>> +               return -EINVAL;
>> +
>> +       /* SFD_PEEK can be used for one queue only */
>> +       if ((flags & SFD_PEEK) && ((flags & SFD_QUEUES) == SFD_QUEUES))
>>                 return -EINVAL;
>>
>>         if (sizemask != sizeof(sigset_t) ||
>> @@ -352,7 +404,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user
>> *, user_mask,
>>                 }
>>
>>                 file->f_flags |= (flags & SFD_QUEUES) ? : SFD_QUEUES;
>> -               file->f_flags |= flags & SFD_RAW;
>> +               file->f_flags |= flags & (SFD_RAW | SFD_PEEK);
>> +
>> +               if (file->f_flags & SFD_PEEK)
>> +                       file->f_mode |= FMODE_PREAD;
>>
>>                 fd_install(ufd, file);
>>         } else {
>> diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
>> index 481b658..24c5d2d 100644
>> --- a/include/uapi/linux/signalfd.h
>> +++ b/include/uapi/linux/signalfd.h
>> @@ -20,6 +20,8 @@
>>  #define SFD_SHARED_QUEUE O_DIRECTORY
>>  /* Read signals from a per-thread queue */
>>  #define SFD_PER_THREAD_QUEUE O_EXCL
>> +/* Read signals without removing them from a queue */
>> +#define SFD_PEEK O_APPEND
>>
>>  struct signalfd_siginfo {
>>         __u32 ssi_signo;
>> --
>> 1.7.11.7
>>
