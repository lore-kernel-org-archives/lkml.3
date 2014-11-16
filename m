Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbaKPVY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 16:24:57 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52642 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaKPVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 16:24:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141116.140422.570375628237589645.davem@davemloft.net>
References: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
	<1415929010-9361-7-git-send-email-ast@plumgrid.com>
	<20141116.140422.570375628237589645.davem@davemloft.net>
Date: Sun, 16 Nov 2014 13:24:53 -0800
Message-ID: <CAMEtUuwrST6wGnBU6UU2NYEubskHYf1XZmZQpkgM+cUc8YD9OA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 6/7] bpf: allow eBPF programs to use maps
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 11:04 AM, David Miller <davem@davemloft.net> wrote:
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Thu, 13 Nov 2014 17:36:49 -0800
>
>> +static u64 bpf_map_lookup_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
>> +{
>> +     /* verifier checked that R1 contains a valid pointer to bpf_map
>> +      * and R2 points to a program stack and map->key_size bytes were
>> +      * initialized
>> +      */
>> +     struct bpf_map *map = (struct bpf_map *) (unsigned long) r1;
>> +     void *key = (void *) (unsigned long) r2;
>> +     void *value;
>> +
>> +     WARN_ON_ONCE(!rcu_read_lock_held());
>> +
>> +     value = map->ops->map_lookup_elem(map, key);
>> +
>> +     /* lookup() returns either pointer to element value or NULL
>> +      * which is the meaning of PTR_TO_MAP_VALUE_OR_NULL type
>> +      */
>> +     return (unsigned long) value;
>> +}
>
> You should translate this into a true boolean '1' or '0' value so that
> kernel pointers don't propagate to the user or his eBPF programs.

that won't work. eBPF programs have to see all sorts of kernel
pointers. In this case it's a pointer to map element value
or NULL. There are pointers to stack, pointers to map root,
pointers to context, etc. Programs can read pointers from
other data structures. And in the case of tracing they can
pretty much access any kernel memory in read only way.
Just like 'perf probe' filters.
The requirement that _unprivileged_ programs should
not be able to pass all these pointers back to user is
well understood and was discussed in detail several
month back. It's verifier that will prevent leaking of
kernel addresses. Today, the whole thing is for root
only. When the infra is ready for non-root I will add
a pass to verifier, that will kick in only for unprivileged
programs. Verifier already tracks all pointers and
can prevent passing them to user. In this case
verifier knows that register R0 after a call to
bpf_map_lookup_elem() is
"either pointer to element value or NULL",
so it will prevent storing it into any memory or
doing arithmetic on it, so that user space cannot
see the pointer, whereas eBPF program can use
it to access map element value.
