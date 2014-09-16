Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaIPUoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:44:16 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37907 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaIPUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140916.151606.448751391205382097.davem@davemloft.net>
References: <1410808721-27493-1-git-send-email-ast@plumgrid.com>
	<1410808721-27493-4-git-send-email-ast@plumgrid.com>
	<20140916.151606.448751391205382097.davem@davemloft.net>
Date: Tue, 16 Sep 2014 13:44:12 -0700
Message-ID: <CAMEtUuxp6709mdygiQyCqwjv-0kF-CbNOzCCZmKw_mUckF4NZA@mail.gmail.com>
Subject: Re: [PATCH v12 net-next 03/11] bpf: add lookup/update/delete/iterate
 methods to BPF maps
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
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

On Tue, Sep 16, 2014 at 12:16 PM, David Miller <davem@davemloft.net> wrote:
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Mon, 15 Sep 2014 12:18:33 -0700
>
>> @@ -83,6 +112,15 @@ union bpf_attr {
>>               __u32   value_size;     /* size of value in bytes */
>>               __u32   max_entries;    /* max number of entries in a map */
>>       };
>> +
>> +     struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
>> +             int map_fd;
>> +             void __user *key;
>> +             union {
>> +                     void __user *value;
>> +                     void __user *next_key;
>> +             };
>> +     };
>>  };
>>
>>  #endif /* _UAPI__LINUX_BPF_H__ */
>
> Depending upon the processor ABI, this change can increase the
> alignment requirements of union bpf_attr.  So the structure is not
> compatible between patch #1 and patch #3 here.

the union indeed changes alignment from patch #1 to #3,
but, imo, it is not a problem, since kernel does:
/* copy attributes from user space, may be less than sizeof(bpf_attr) */
if (copy_from_user(attr, uattr, size) != 0)
and then proceeds with further bpf_attr validation, so even
if user space alignment is 4 and user assumes contents
from patch 1, but kernel alignment is 8 and contents from
patch 3, it is still ok. Backwards compatibility is preserved.

> Also, you haven't implemented any compat layer whatsoever for the
> necessary translations.  This happens because you are using pointers
> which are different sized between 32-bit and 64-bit ABIs.

I mentioned it in the cover letter:
- implemented and tested compat support (not part of this set)

I'll roll compat layer into the set to make it less confusing.

> I would suggest you use instead something like "aligned_u64" since
> these are just arbitrary userland cookies and using "aligned_u64"
> vs. "u64" will make it so that you don't have to deal with the 64-bit
> type alignment differences between x86-32 and x86-64 while writing the
> compat wrappers (if any).

I haven't thought of 'aligned_u64' for this case.
For counters and masks it would be perfect, but here user is
passing real pointers to key and value, so they have to
be 'void __user *', otherwise user would need to type cast
them, which I want to avoid.

>> +     struct { /* anonymous struct used by BPF_PROG_LOAD command */
>> +             __u32 prog_type;        /* one of enum bpf_prog_type */
>> +             __u32 insn_cnt;
>> +             const struct bpf_insn __user *insns;
>> +             const char __user *license;
>> +     };
>> +};
>
> Again, these need syscall compat handling.  You may want to redesign
> the types so that perhaps no compat layer translations will be needed.

'foo __user *' pointers vs 'aligned_u64'... It's a trade off.
I can make all pointer fields to be u64 and then, indeed,
no compat layer will be needed, but user would need to
do ugly type casts. I think compat layer is a better option.
It's simple enough. I'll roll it into the set and respin.

Thanks!
