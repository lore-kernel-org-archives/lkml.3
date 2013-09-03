Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734Ab3ICV10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:27:26 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38743 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3ICV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YjAHgN2fvUsDZ2VZyBVmYacKZdwHJSCJXoHh_P=3dOaQ@mail.gmail.com>
References: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
 <CACT4Y+artcxiies1q3XP3+yCh+QzPZQ96dDttpdYXoQ+w2xosQ@mail.gmail.com>
 <CACT4Y+YobKoy9Yp5b6eM21oQrt+bj74qW6uM_DYPkeL-TVA3dQ@mail.gmail.com>
 <20130903202755.GA26033@gmail.com> <CACT4Y+YjAHgN2fvUsDZ2VZyBVmYacKZdwHJSCJXoHh_P=3dOaQ@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 3 Sep 2013 18:27:04 -0300
Message-ID: <CAKi4VAKGqpTSdVB0xZbPbKdnYCXAuYt63U5W0EVkX48X6knDKg@mail.gmail.com>
Subject: Re: Potential use-after-free in ____call_usermodehelper
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Dan Aloni <alonid@stratoscale.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Alexander Potapenko <glider@google.com>,
        Evgeniy Stepanov <eugenis@google.com>, oleg <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 5:49 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Wed, Sep 4, 2013 at 12:27 AM, Dan Aloni <alonid@stratoscale.com> wrote:
>> On Tue, Sep 03, 2013 at 05:49:03PM +0400, Dmitry Vyukov wrote:
>>> Is anybody reading this? Is it a correct place to post such things?
>>> Maybe there is a more appropriate place?
>>
>> This is the correct place, and people are reading this. However, the
>> bug is not an obvious one, and you mentioned that this bug reproduces
>> on a tree with significant deviation from vanilla in core kernel code
>> (i.e. memory allocations) with potential bugs, and it also relies on a
>> gcc feature not used by the kernel yet.
>>
>> Because of that it went down in priority compared to other kernel bugs
>> that are currently being investigated.
>
> Thanks Dan!
>
> I am new here, so I was thinking maybe I am doing something wrong.

Another thing is.... try to put in CC who touched this function
lately. I remember touching it some time ago and also Oleg (adding
him).


>
>
>> Your work and contribution is appreciated nonetheless, but your bug
>> report needs to pertain closer to the work the core kernel hackers
>> are doing.
>
> What exactly do you mean?
>
>
>> Despite that, I did look into your report, and I'll address your analysis:
>>
>>> >> I've looked at the sources, but I can't say that I fully understand
>>> >> them. The report looks valid, though. I see several potential issues
>>> >> in the code.
>>> >>
>>> >> 1. When wait=UMH_WAIT_EXEC and do_execve() fails,
>>> >> ____call_usermodehelper() writes sub_info->retval=retval to freed
>>> >> memory. This is the use-after-free reported by the tool.
>>
>> The 'pid = kernel_thread(call_helper, sub_info, CLONE_VFORK | SIGCHLD);'
>> call is designed to block until either do_execve() succeeds or the kernel
>> thread exits - that happens after the store that triggers the issue,
>> so the use-after-free cannot occur in that case.
>>
>> This is thanks to the CLONE_VFORK flag, and I doubt it is broken.
>
> Aha! I've missed VFORK. It's all like in userspace, right? I will redo
> my analysis.

yes... the VFORK here is what you were missing.


>
>
>>> >> 2. When wait=UMH_NO_WAIT, __call_usermodehelper() starts child thread
>>> >> and instantly frees subprocess_info. The child thread reads
>>> >> subprocess_info. Looks like another use-after-free.
>>
>> Same, kernel_thread() would be blocking because of CLONE_VFORK.
>>
>>> >> 3. UMH_WAIT_EXEC does not actually wait for exec, it only waits for
>>> >> starting the child thread that will do exec. I don't know whether it's
>>> >> a problem with the code or with the name.
>>
>> Same.

Agreed

Lucas De Marchi
