Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaK3GYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 01:24:31 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56977 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaK3GY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 01:24:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141129.210158.2021042941461629799.davem@davemloft.net>
References: <1417066951-1999-1-git-send-email-ast@plumgrid.com>
	<1417066951-1999-4-git-send-email-ast@plumgrid.com>
	<20141129.210158.2021042941461629799.davem@davemloft.net>
Date: Sat, 29 Nov 2014 22:24:28 -0800
Message-ID: <CAMEtUuw+z61FL81-_aZ0=D5XKm-_gh+Cs1uGL2th+0A+hcYPGQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] samples: bpf: example of stateful socket filtering
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

On Sat, Nov 29, 2014 at 9:01 PM, David Miller <davem@davemloft.net> wrote:
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Wed, 26 Nov 2014 21:42:28 -0800
>
>> this socket filter example does:
>> - creates arraymap in kernel with key 4 bytes and value 8 bytes
>>
>> - loads eBPF program:
>>   r0 = skb[14 + 9]; // load one byte of ip->proto
>  ...
>> +             BPF_LD_ABS(BPF_B, 14 + 9 /* R0 = ip->proto */),
>
> I do not want anything having to do with fixed offsets from
> the skb.
>
> Nothing should know where things are in the SKB structure,
> especially user facing things.
>
> That's why we have explicit BPF operations for fetching
> specific SKB members, so that the layout is completely
> transparent to the entity generating BPF programs.
>
> Besides retaining the flexibility of changing the SKB
> layout arbitrarily without breaking bpf programs, there
> are also security considerations from allowing bpf
> programs to load arbitrary offsets.
>
> Sorry, I do not like this patch series at all.

sigh.
You misunderstood one wrong comment in the whole series.
r0 = skb[14 + 9]; // load one byte of ip->proto
is saying
r0 = skb->data[14 + 9]; // load one byte of ip->proto
it's loading one byte of packet payload and
not one byte of skb structure.

There are plenty of other comments where I mentioned that.
Including cover letter:
"Though native eBPF programs are way more powerful than classic filters
(attachable through similar setsockopt() call), they don't have skb field
accessors yet. Like skb->pkt_type, skb->dev->ifindex are not accessible.
There are sevaral ways to achieve that. That will be in the next set of patches.
So in this set native eBPF programs can only read data from packet and
access maps"

and in patch #2:
+static bool sock_filter_is_valid_access(int off, int size, enum
bpf_access_type type)
+{
+       /* skb fields cannot be accessed yet */
+       return false;
+}

In other words, there is no way to access skb fields yet.
There are several different ways I've implemented to
access skb fields, but they all had their cons and pros, so I
dropped them all to focus on basic things first.
Which is: read packet data and access maps.

Please let me know if you want me to fix this comment
in this patch of sample code.
