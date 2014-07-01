Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbaGAUEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:04:45 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64198 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbaGAUEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <53B26BB0.90209@redhat.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<53B26BB0.90209@redhat.com>
Date: Tue, 1 Jul 2014 13:04:41 -0700
Message-ID: <CAMEtUuyc3+jrxG4r4=fk=Gc9OMhO8a2X1oyWPx1LsKzewVf01w@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 1:05 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 06/28/2014 02:06 AM, Alexei Starovoitov wrote:
>>
>> Safety of eBPF programs is statically determined by the verifier, which
>> detects:
>> - loops
>> - out of range jumps
>> - unreachable instructions
>> - invalid instructions
>> - uninitialized register access
>> - uninitialized stack access
>> - misaligned stack access
>> - out of range stack access
>> - invalid calling convention
>
> ...
>
>> More details in Documentation/networking/filter.txt
>>
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>> ---
>
> ...
>>
>>   kernel/bpf/verifier.c               | 1431
>> +++++++++++++++++++++++++++++++++++
>
>
> Looking at classic BPF verifier which checks safety of BPF
> user space programs, it's roughly 200 loc. :-/

I'm not sure what's your point comparing apples to oranges.
For the record 1431 lines include ~200 lines worth of comments
and 200 lines of verbose prints. Without them rejected eBPF
program is black box. Users need a way to understand why
verifier rejected it.

>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> new file mode 100644
>
> ...
>
>> +#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })
>
> ...
>>
>> +       _(get_map_info(env, map_id, &map));
>
> ...
>>
>> +       _(size = bpf_size_to_bytes(bpf_size));
>
>
> Nit: such macros should be removed, please.

It may surely look unconventional, but alternative is to replace
every usage of _ macro with:
err = …
if (err)
  return err;

and since this macro is used 38 times, it will add ~120 unnecessary
lines that will only make code much harder to follow.
I tried not using macro and results were not pleasing.
