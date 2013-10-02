Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3JBSKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:10:19 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61291 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3JBSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:10:16 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
References: <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
	<20130930165420.GI3081@twins.programming.kicks-ass.net>
	<CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
	<20131002112316.GP3081@twins.programming.kicks-ass.net>
	<20131002115826.GM26785@twins.programming.kicks-ass.net>
	<20131002123953.GB27811@gmail.com>
	<20131002124610.GD28601@twins.programming.kicks-ass.net>
	<CABPqkBQyCfz5d+SQxDwPD5m52ofE6y5HKur+s-F0s=hN00cxkw@mail.gmail.com>
	<20131002130143.GF28601@twins.programming.kicks-ass.net>
	<CABPqkBTdWZaJzv4PA3yBor+o_iaBSmK73CrUQeY1tANR36ah8Q@mail.gmail.com>
	<20131002133759.GH28601@twins.programming.kicks-ass.net>
	<CAGXu5jLd3yw+RasWgMg_JJPhsfiM+hVhMru4gfkXmAcn7asEdw@mail.gmail.com>
	<CABPqkBTeJarBCkVBMGex+g32ak8vzH__x1V0aq4c22dyWJKhGA@mail.gmail.com>
	<CAGXu5jJPtfXd47fG2OR5MW1tZ_MMrv5s5NR9nMvnhnFvcuNWtA@mail.gmail.com>
	<CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
Date: Wed, 2 Oct 2013 11:10:15 -0700
X-Google-Sender-Auth: 16d6QkshosUd4xccqpIpEkHUAV0
Message-ID: <CAGXu5jLPJRCX2G31khiMyn5eRuAMchF=k3j0qH0MdL7mXUCCrg@mail.gmail.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
From: Kees Cook <keescook@chromium.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 10:49 AM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Oct 2, 2013 at 7:29 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Oct 2, 2013 at 10:20 AM, Stephane Eranian <eranian@google.com> wrote:
>>> On Wed, Oct 2, 2013 at 7:14 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> On Wed, Oct 2, 2013 at 6:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>> On Wed, Oct 02, 2013 at 03:13:16PM +0200, Stephane Eranian wrote:
>>>>>> On Wed, Oct 2, 2013 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>> > On Wed, Oct 02, 2013 at 02:59:32PM +0200, Stephane Eranian wrote:
>>>>>> >> On Wed, Oct 2, 2013 at 2:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>> >> > On Wed, Oct 02, 2013 at 02:39:53PM +0200, Ingo Molnar wrote:
>>>>>> >> >>  - then there are timing attacks, and someone having access to a PMU
>>>>>> >> >>    context and who can trigger this SHA1 computation arbitrarily in task
>>>>>> >> >>    local context can run very accurate and low noise timing attacks...
>>>>>> >> >>
>>>>>> >> >>    I don't think the kernel's sha_transform() is hardened against timing
>>>>>> >> >>    attacks, it's performance optimized so it has variable execution time
>>>>>> >> >>    highly dependent on plaintext input - which leaks information about the
>>>>>> >> >>    plaintext.
>>>>>> >> >
>>>>>> >> > Typical user doesn't have enough priv to profile kernel space; once you
>>>>>> >> > do you also have enough priv to see kernel addresses outright (ie.
>>>>>> >> > kallsyms etc..).
>>>>>> >> >
>>>>>> >> I was going to say just that. But that's not the default, paranoid level
>>>>>> >> is at 1 by default and not 2. So I supposedly can still do:
>>>>>> >>
>>>>>> >> $ perf record -e cycles ......
>>>>>> >>
>>>>>> >> In per-thread mode and collect kernel level addresses.
>>>>>> >
>>>>>> > Oh right you are.. so yes that's a very viable avenue.
>>>>>>
>>>>>> You mean simply encoding the vma->vm_mm as the ino number, for instance.
>>>>>
>>>>> Nah.. I think Kees would very much shoot us on the spot for doing that.
>>>>> But with the paranoid level defaulting to 1 the PMU attack on the kernel
>>>>> SHA implenentation is feasible.
>>>>
>>>> We already have other kernel address leaks (e.g. heap addresses via
>>>> INET_DIAG), and I'd like to avoid adding more. It'd be nice if there
>>>> was a common way to uniquely mask these values that are really just
>>>> "handles". We could use it both here and in the network code.
>>>>
>>>> Would it be possible to just have a "regular" incrementing handle,
>>>> like fd, or are we talking about doing that map for all VMAs, which
>>>> would make that mapping unfeasible due to storage needs?
>>>>
>>> All we need is a way to report that two vmas point to the same
>>> vma->vm_mm, i..e, same physical data. If I understand what
>>> you are suggesting, you'd add some sort of generation number
>>> to the vm_mm. Each new vm_mm gets a new number. That
>>> would work, I think. No kernel addresses reported directly nor
>>> hashed.
>>
>> Right. Is that workable? It sounds like this handle is only needed at
>> inspection time, though. Is this uniqueness test limited to a single
>> process, or is this uniqueness test across processes?
>>
> Each time that vm_mm is allocated we would allocate a new generation
> number.

Seems like a simple enough solution. Surely there must be a catch. :)

>
> Uniqueness is across processes. But that's by construction of the
> address space.

Okay, that's what I figured.

-Kees

-- 
Kees Cook
Chrome OS Security
