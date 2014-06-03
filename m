Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaFCIeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaFCIeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:34:10 -0400
Message-ID: <538D884E.5030007@redhat.com>
Date: Tue, 03 Jun 2014 10:33:18 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Chema Gonzalez <chema@google.com>,
        David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 net-next 1/4] net: flow_dissector: avoid multiple calls
 in eBPF
References: <1398882591-30422-1-git-send-email-chema@google.com> <1401389758-13252-1-git-send-email-chema@google.com> <5387C8AD.6000909@redhat.com> <CA+ZOOTNobzzJPgQnVVZ+b6rRD=0_pdjUB8q5FQVkbO+dob0BSg@mail.gmail.com> <538C6FD8.9040305@redhat.com> <CAMEtUuyduk1sHBeVm=d5GYEgB4ma7sVFYeBLdapbeEpQY9nA1Q@mail.gmail.com>
In-Reply-To: <CAMEtUuyduk1sHBeVm=d5GYEgB4ma7sVFYeBLdapbeEpQY9nA1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 06:48 PM, Alexei Starovoitov wrote:
> extending cc-list, since I think this thread is related to bpf split thread.
>
> On Mon, Jun 2, 2014 at 5:36 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>> On 05/30/2014 07:12 PM, Chema Gonzalez wrote:
>>>
>>> On Thu, May 29, 2014 at 4:54 PM, Daniel Borkmann <dborkman@redhat.com>
>>> wrote:
>>>>
>>>> I actually liked [1] most ... ;)
>>
>> ...
>>
>>>> one extension e.g. SKF_AD_DISSECT where you call the external
>>>> skb_flow_dissect()
>>>> helper or similar on?
>>>>
>>>> I could imagine that either these offsets are squashed into the return or
>>>> stored if you really need them from the struct flow_keys into M[] itself.
>>>> So
>>>> you would end up with one e.g. 'ld #keys' call that e.g. fills
>>>> out/overwrites
>>>> your M[] with the dissected metadata. Then, you'd only have a reason to
>>>> call
>>>> that once and do further processing based on these information. Whether
>>>> you
>>>> also need poff could e.g. be determined if the user does e.g. 'ldx #1' or
>>>> so
>>>> to indicate to the function it eventually calls, that it would further do
>>>> the dissect and also give you poff into fixed defined M[] slots back.
>>>
>>>
>>> IIUC, you're suggesting to have the classic BPF user writes "ld #keys"
>>> to load flow_keys in the stack and then *explicitly* adds "ld
>>> mem[<offset>]" to access the field she's interested on. Note that if
>>> the "ld mem[]" is implicit, then the user must use "ld #thoff" to let
>>> the compiler know she wants "ld #keys" and then "ld
>>> mem[<thoff_offset>]" (and not "ld mem[<other_offset>]"), which is
>>> equivalent to what we're doing right now*.
>>
>>
>> I think there are many ways to design that, but for something possibly
>> generic, what I mean is something like this:
>>
>> We would a-priori know per API documentation what slots in M[] are
>> filled with which information, just for example:
>>
>> M[0] <-- nhoff  [network header off]
>> M[1] <-- nproto [network header proto]
>> M[2] <-- thoff  [transport header off]
>> M[3] <-- tproto [transport header proto]
>> M[4] <-- poff   [payload off]
>>
>> Now a user could load the following pseudo bpf_asm style program:
>>
>> ld #5     <-- indicates to fill the first 5 slots of M[], so M[0] to M[4]
>> ld #keys  <-- triggers the extension to fill the M[] slots
>> ld M[0]   <-- loads nhoff from M[0] into accu
>> <do sth with it>
>> ld M[3]   <-- loads tproto into accu, etc
>> …
>
> imo there are pros and cons in Daniel's and Chema's proposals
> for classic BPF extensions.
> I like Chema's a bit more, since his proposal doesn't require to
> change classic BPF verifier and that's always a delicate area
> (seccomp also allows to use M[] slots).

What bothers me is that you have to *special case* this extension
all over the BPF converter and stack, even you need to introduce a
prologue just to walk the whole filter program and to check if the
extension is present; next to that instead of one extension you
need to add a couple of them to uapi. I understand Chema's proposal
or his need to easily access these data but that's why I proposed
the above if he wants to go for that. Btw, seccomp doesn't allow
for loading BPF extensions, you said so yourself Alexei.

> Both still look like a stop gap until next classic extension
> appears on horizon.
>
> I think explicit eBPF program solves this particular task cleaner
> and it doesn't require changing eBPF.
>
>> A program like:
>>
>> ld #2
>> ld #keys
>> ...
>>
>> Would then on the other hand only fill the first two slots of M[] as
>> the user does not need all information from the kernel's flow dissector
>> and thus also does not fully need to dissect the skb.
>>
>> This also permits in future to add new fields by enabling them with
>> ld #6 etc, for example.
>>
>> I think this would fit much more into the design of BPF (although I
>> don't strictly like referring to the kernel's flow dissector and thus
>> bypassing BPF's actual purpose; but I understand that it can get quite
>> complicated with tunnels, etc).
>>
>> But this idea would allow you to only add 1 new extension and to have
>> it return dynamically a part or all information you would need in your
>> program, and thus solves the issue of calling the skb flow dissector
>> multiple times just because we have ld #thoff, ld #nhoff, etc, we can
>> avoid making such a stack_layout + filter_prologue hack and thus design
>> it more cleanly into the BPF architecture.
>>
>>
>>> The only advantage I can see is that we're only adding one new
>>> ancillary load, which is more elegant. I can see some issues with this
>>> approach:
>>>
>>> - usability. The user has to actually know what's the right offset of
>>> the thoff, which is cumbersome and may change with kernels. We'd be
>>> effectively exporting the flow_keys struct layout to the users.
>>
>>
>> See above.
>>
>>
>>> - have to take care that the classic BPF filter does not muck with
>>> mem[] between the "ld #keys" and all of the the "ld* mem[]" that
>>> access to it. Note that we're currently storing the flow_keys struct
>>> in the stack outside of the mem[] words, so this is not a problem
>>> here. (It is only accessible using ebpf insns.)
>>
>>
>> Since it is part of the API/ABI, and a new instruction, it is then
>> known that ld #keys would fill particular slots of M[] to the user.
>> That however, must be carefully designed, so that in future one
>> doesn't need to add ld #keys2. The part of not mucking with M[] fields
>> is then part of the user's task actually, just the same way as a
>> user shouldn't store something to A resp. X while an ld resp. ldx
>> knowingly would overwrite that value stored previously. I don't
>> think it would be any different than that.
>>
>>
>>> *Now, if your comment is ebpf-only, that could be ok. That would mean:
>>>
>>> - a. the user writes "ld #thoff"
>>> - b. the BPF->eBPF compiler generates one common BPF_CALL
>>> (__skb_get_flow_dissect) plus a "ebpf_ldx stack[right_offset]". This
>>> would not include payload_offset (which needs to run its own function
>>> to get the poff from flow_keys).
>>
>>
>> Since we're not using eBPF in user space right now, the comment is not
>> about eBPF. I think if you would use eBPF from user space, you don't
>> need to add such extensions anymore, but could just write yourself a
>> minimal flow dissector in 'restricted' C to solve that problem.
>
> Exactly.
> I think exposing eBPF to user space is not a matter of 'if' but 'when'.
>
> I'm not sure how pressing it is now to add another extension to classic,
> when the goal of this patch set fits into eBPF model just fine.
> yes, eBPF verifier is not in tree yet and it will obviously take longer to
> review than Chema's or Daniel's set.
>
> When eBPF is exposed to user space the inner header access can
> be done in two ways without changing eBPF instruction set or eBPF
> verifier.
>
> eBPF approach #1:
> -- code packet parser in restricted C
> Pros:
> skb_flow_dissect() stays hidden in kernel.
> No additional uapi headache which exist if we start reusing
> in-kernel skb_flow_dissect() either via classic or eBPF.
> Such eBPF program will be just as fast as in-kernel skb_flow_dissect()
> (I provided performance numbers before)
> Cons:
> in-kernel skb_flow_dissect() is not reused, but mostly copy-pasted to userspace.
>
> eBPF approach #2:
> -- reuse in-kernel skb_flow_dissect() via bpf_call insn from eBPF program
> Pros:
> eBPF program becomes much shorter and can be done in asm like:
> bpf_mov r2, fp
> bpf_sub r2, 64
> bpf_call bpf_skb_flow_dissect  // call in-kernel helper function from
> eBPF program
> bpf_ldx r1, [fp - 64]  // access flow_keys data
> bpf_ldx r2, [fp - 60]
>
> Cons:
> bpf_skb_flow_dissect() (wrapper on top of skb_flow_dissect()) becomes
> uapi visible helper function
>
> imo both eBPF approaches are cleaner than extending classic.
>
