Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaBLVul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:50:41 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:60738 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaBLVug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
References: <1392219611-13260-1-git-send-email-avagin@openvz.org>
	<20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
Date: Wed, 12 Feb 2014 13:50:35 -0800
X-Google-Sender-Auth: 7X3rqSpHDbw2CBt8WmCDI_KKbfQ
Message-ID: <CAGXu5jLwH82BSTMTB_iP=2_0yUBEeLuNOcCaotyw_iADvizb-A@mail.gmail.com>
Subject: Re: [PATCH] kernel: reduce required permission for prctl_set_mm
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        criu@openvz.org, Oleg Nesterov <oleg@redhat.com>,
        Robin Holt <holt@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Chen Gang <gang.chen@asianux.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 1:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 12 Feb 2014 19:40:11 +0400 Andrey Vagin <avagin@openvz.org> wrote:
>
>> Currently prctl_set_mm requires the global CAP_SYS_RESOURCE,
>> this patch reduce requiremence to CAP_SYS_RESOURCE in the current
>> namespace.
>>
>> When we restore a task we need to set up text, data and data heap sizes
>> from userspace to the values a task had at checkpoint time.
>>
>> Currently we can not restore these parameters, if a task lives in
>> a non-root user name space, because it has no capabilities in the
>> parent namespace.
>>
>> prctl_set_mm() changes parameters of the current task and doesn't affect
>> other tasks.
>>
>> This patch affects the RLIMIT_DATA limit, because a consumtiuon is
>> calculated relatively to mm->end_data, mm->start_data, mm->start_brk.
>
> I can't for the life of me work out what you were trying to say here.
> Please fix and resend this paragraph?
>
>> rlim = rlimit(RLIMIT_DATA);
>> if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
>>               (mm->end_data - mm->start_data) > rlim)
>>       goto out;
>>
>> This limit affects calls to brk() and sbrk(), but it doesn't affect
>> mmap. So I think requirement of CAP_SYS_RESOURCE in the current
>> namespace is enough for this limit.
>>
>> ...
>>
>> Cc: security@kernel.org
>
> That list is for reporting kernel security bugs.
>
>>
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1701,7 +1701,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
>>       if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
>>               return -EINVAL;
>>
>> -     if (!capable(CAP_SYS_RESOURCE))
>> +     if (!ns_capable(current_user_ns(), CAP_SYS_RESOURCE))
>>               return -EPERM;
>>
>>       if (opt == PR_SET_MM_EXE_FILE)
>
> This looks harmless.

I want to be convinced of this, but weakening this cap check seems
like an easy way for a process to hide itself trivially from the real
root user. It can change it's exe file link, and dodge RLIMIT_DATA by
changing the brk addresses. The whole reason this cap check was there
was to stop that kind of thing. Limiting it to a namespace isn't great
since USER_NS means unprivileged processes can enter a new NS as the
NS root user.

-Kees

-- 
Kees Cook
Chrome OS Security
