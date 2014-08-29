Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaH2SDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:03:01 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:43815 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaH2SC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <5400BAB7.80001@redhat.com>
References: <1409171833-6979-1-git-send-email-ast@plumgrid.com>
	<1409171833-6979-3-git-send-email-ast@plumgrid.com>
	<5400BAB7.80001@redhat.com>
Date: Fri, 29 Aug 2014 11:02:58 -0700
Message-ID: <CAADnVQJbgiUK1vt_SDEG6Yee-Ht67e2M82PrHb3Kx533BOF-rg@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:39 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 08/27/2014 10:37 PM, Alexei Starovoitov wrote:
>>
>> allow user space to generate eBPF programs
>>
>> uapi/linux/bpf.h: eBPF instruction set definition
>>
>> linux/filter.h: the rest
>
>
> Very sorry for being late, but just a thought since we're touching user
> space headers anyway ...
>
> Wouldn't it be more consistent to have it organized as follows ...
>
>  - uapi/linux/bpf.h    : classic BPF instruction set parts only
>  - uapi/linux/ebpf.h   : eBPF instruction set definition (which also
>                          includes uapi/linux/bpf.h though)
> ... and have ...
>
>  - uapi/linux/filter.h : just include uapi/linux/bpf.h but rest is empty
>
> That way, it would be more consistent ...
>
> Old legacy application can stay with linux/filter.h; new applications
> based on their needs can choose between linux/{e,}bpf.h and in the kernel,
> we can just include linux/ebpf.h.
>
> Right now, it seems, an eBPF user space program would need to include
> 2 header files in user space (linux/filter.h, linux/bpf.h) which I find
> a bit confusing.

It's been bugging me as well, but I suspect having it the way you
described won't work. Mainly because we cannot do include <uapi/..>
inside uapi/*.h, so we would need to do include <linux/bpf.h>
inside uapi/linux/filter.h, but that will cause serious include path
confusion. That was the reason I didn't simply do include <linux/filter.h>
inside uapi/linux/bpf.h

Also I really dislike 'ebpf' name in all lower case. If we make such header
file name, we would need to rename all macros and function names
to EBPF_... which I find very ugly looking. I think all good abbreviations are
three letters :)
So I very much prefer bpf.h as a main file name.
Later we can move some of old classic BPF defines into
uapi/linux/bpf_common.h and then include it in both uapi/linux/bpf.h
and in uapi/linux/filter.h, then the nuisance of two include files for
user space will go away. Classic users will keep using linux/filter.h
and new apps will include linux/bpf.h only.
I think we should probably do such header optimization later and very carefully.
I'm a bit afraid to touch uapi/linux/filter.h since it's used in so
many user apps.
