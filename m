Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3BGVS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:18:57 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34981 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab3BGVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:18:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130207173447.GA5888@redhat.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
	<1359486181-29088-1-git-send-email-avagin@openvz.org>
	<20130207173447.GA5888@redhat.com>
Date: Fri, 8 Feb 2013 01:13:13 +0400
Message-ID: <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Oleg Nesterov <oleg@redhat.com>:
> Andrey, sorry for delay.
>
> As for API, I leave this to you and Michael. Not that I like these
> new flags, but I agree that pread() hack was not pretty too.
>
> On 01/29, Andrey Vagin wrote:
>> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
>> +                             siginfo_t *info, loff_t *ppos, int queue_mask)
>> +{
>> +     loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
>> +     int signr = 0;
>> +
>> +     if (queue_mask & SIGQUEUE_PRIVATE)
>> +             signr = peek_signal(&current->pending,
>> +                                     &ctx->sigmask, info, &seq);
>> +     else if (queue_mask & SIGQUEUE_SHARED)
>> +             signr = peek_signal(&current->signal->shared_pending,
>> +                                      &ctx->sigmask, info, &seq);
>> +     (*ppos) += sizeof(struct signalfd_siginfo);
>
> Now that this can work even with normal read(), we will actually change
> f_pos. Then perhaps signalfd_fops->llseek() should work too. But this
> is minor...

lseek works only if FMODE_LSEEK is set.

You have explained why read&lseek have strange semantics for SIGNALFD_PEEK.

>Damn. But after I wrote this email I realized that llseek() probably can't
> work. Because peek_offset/f_pos/whatever has to be shared with all processes
> which have this file opened.
>
> Suppose that the task forks after sys_signalfd(). Now if parent or child
> do llseek this affects them both. This is insane because signalfd is
> "strange" to say at least, fork/dup/etc inherits signalfd_ctx but not the
> "source" of the data.

So I want to suggest a way how to forbid read() for SIGNALFD_PEEK.
file->f_pos can be initialized to -1. read() returns EINVAL in this
case. In a man page we will write that signals can be dumped only with
help pread(). Is it overload or too ugly?

>
> Hmm. but since it works with read(), we shouldn't increment *ppos unless
> signalfd_copyinfo() succeeds?

No, we shouldn't.

>
> Btw, why do you pass seq by reference? Looks unneeded.

You are right. I created this code for reading signals from both
queues, but then we decided to forbid using SIGNALFD_PEEK for both
queues simultaneously.


Oleg, thank you for the comments. I'm waiting an answer on the
question and after that I'm going to send a final version.

>
> Oleg.
>
