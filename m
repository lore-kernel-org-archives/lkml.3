Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaIQQJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:09:05 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:43301 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaIQQJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <54192F66.8020200@redhat.com>
References: <1410914370-29883-1-git-send-email-ast@plumgrid.com>
	<1410914370-29883-8-git-send-email-ast@plumgrid.com>
	<54192F66.8020200@redhat.com>
Date: Wed, 17 Sep 2014 09:08:58 -0700
Message-ID: <CAMEtUuxK68ZoJ-izjLoygv0f+rLtPmMLUUq1=BJ+_ZBGfynkdA@mail.gmail.com>
Subject: Re: [PATCH v13 net-next 07/11] bpf: verifier (add ability to receive
 verification log)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 11:51 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
>>
>>   /* last field in 'union bpf_attr' used by this command */
>> -#define        BPF_PROG_LOAD_LAST_FIELD license
>> +#define        BPF_PROG_LOAD_LAST_FIELD log_buf
>
>
> I was looking to find a use case for this item, but couldn't find anything,
> so
> this seems to be dead code?

See CHECK_ATTR() macro and comment next to it in patch #1

> Was it, so that each time you extend an uapi structure like above that you
> would
> only access the structure up to BPF_PROG_LOAD_LAST_FIELD? That might not
> work for
> old binaries using this ABI running on newer kernels where there are
> different
> expectations of what BPF_PROG_LOAD_LAST_FIELD has been at the time of
> compilation.

exactly the opposite.
CHECK_ATTR() is checking that all fields beyond last for given
command are zero, so we can extend bpf_attr with new fields
added after last.
Transition from patch 4 to patch 7 and the hunk you quoted are
demonstrating exactly that. Say, userspace was compiled
with bpf_attr as defined in patch 4 and it populated fields all the way
till 'license', and kernel is compiled with patch 7. Kernel does:
union bpf_attr attr = {};
/* copy attributes from user space, may be less than sizeof(bpf_attr) */
copy_from_user(&attr, uattr, size)
so newer fields (all the way till log_buf) stay zero and kernel
behavior is the same as it was in patch 4.
So older user space works as-is with newer kernel.
Another example:
say, we want to add another flag to lookup() method added in patch 3,
we just add another 'flags' field after 'value' field and adjust:
-#define BPF_MAP_LOOKUP_ELEM_LAST_FIELD value
+#define BPF_MAP_LOOKUP_ELEM_LAST_FIELD flags
Older user apps stay binary compatible with newer kernel.
Does this explain things?

>> +
>> +       /* grab the mutex to protect few globals used by verifier */
>> +       mutex_lock(&bpf_verifier_lock);
>
>
> So only because of the verifier error log (which are global vars here) we
> now have to hold a eBPF-related mutex lock each time when attaching a
> program?

correct.
it's done on purpose to simplify verifier code.
User app is blocked in bpf syscall until verifier checks the program.
Not a big deal. I don't expect a lot of concurrent program loading.
If it somehow becomes an issue, when can fix it, but for now I think
less lines of verifier code is definitely a better trade off.

> Also, if you really have to do the verifier error log, can't we spare
> ourself
> most part of the textifying parts if you would encode the verifier log into
> a
> normal structure array with eBPF specific error codes and then do all this
> pretty printing in user space? Why is that impossible? I really think it's
> odd.

I thought I explained this already...
verifier log is not at all "an array of specific error codes".
verifier is printing the trace and state of what it's seeing
while analyzing the program. Very branchy program may
generate a trace log several times larger than program size.
pretty text is the most convenient way to pass it to user.
Theoretically we can come with some obscure log format for
this internal verifier state, but what do we get ? only additional
complexity. This obscure format will change just as text will
change, because verifier will evolve. If you're looking for a way
to fix this output into ABI, it's not possible. Verifier will
become more advanced in the future and it's trace whether
in text or in obscure encoded structs will change.
Therefore text is much simpler option.
Also consider the learning curve for somebody planning
to add new features to verifier. This trace log is a perfect way
to understand how verifier is working. Try simple program
with multiple branches and see what kind of log is dumped.

Another example:
To make verifier easier to review, in this patch set I didn't
include 'state pruning optimization' patch. That patch
will change the trace log, because it changes the way
verifier is working. If we had to introduce struct
encoding of trace log, it would need to be changed already.
So pretty text is the simplest and most convenient way.
