Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbbA2EUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:20:09 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:46560 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbbA2EUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:20:06 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 28 Jan 2015 20:19:45 -0800
Message-ID: <CAMEtUuzW2xGGy6xGE_5EcKTEk-US1_o02qFbokxB2h9rU+TZfg@mail.gmail.com>
Subject: Re: [PATCH v2 linux-trace 4/8] samples: bpf: simple tracing example
 in C
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 12:44 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
>> > #define memcmp(s1, s2, n) bpf_memcmp(s1, s2, n)
>
>> >> in bpf_helpers.h to have it work?
>
>> yes, that will work just fine.
>> Since it's an example I made it explicit that bpf_memcmp()
>> has memcmp() semantics, but little bit different:
>> int bpf_memcmp(void *unsafe_ptr, void *safe_ptr, int size)
>
> Not knowing about the safe/unsafe pointers (at this point in my
> conceptual eBPF learning process), I would think that it would be easier
> to understand if it would reuse another well known idiom:
>
> #define memcmp_from_user(kernel, user, n) bpf_memcmp(user, kernel, n)

that actually won't be right. It's not reading from user.
'unsafe' means that pointer is not known to be safe
within the program. So far, bpf verifier recognizes pointer
to context, stack and maps. Everything else is unsafe.
Therefore all pointer walking of unknown data structures
need to use bpf_fetch_*() helpers to access memory.
Similarly bpf_memcmp() is used to do memcmp() of
two memory regions: one known to be safe and one
unknown.

 > I don't reuse anything I've learned before trying to understand eBPF,
> not I see any well known marker (__user) that would help me understand
> that that pointer needs special treatment/belongs to a different "domain".

I tried to do exactly that actually :)
bpf_fetch_*() helpers suppose to match existing fetch*()
primitives used to do the same pointer walking for kprobes.
Maybe bpf_probe_memcmp() would be a better name?
Hard to tell.

>> bpf_fetch_*() helpers are also explicit in examples.
>> If one need to do a lot of pointer walking, then macro like
>> #define D(P) ((typeof(P))bpf_fetch_ptr(&P))
>> would be easier to use: p = D(D(skb->dev)->ifalias)
>> multiple pointer derefs would look more natural...
>
> And if possible, i.e. if the eBPF compiler would take care of that
> somehow, would indeed be preferred as it looks more natural :-)

yes, on the user space side we have all the freedom.
Note, these examples are using user's bpf_helpers.h
which defines it as:
static int (*bpf_memcmp)(void *unsafe_ptr, void *safe_ptr, int size) =
        (void *) BPF_FUNC_memcmp;

so whether we want to call the function bpf_memcmp() or
bpf_probe_memcmp() is up to user space.
The BPF_FUNC_memcmp name is what matters which
is defined in uapi/linux/bpf.h
I'll try to come up with more explicit name...
