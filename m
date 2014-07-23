Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbaGWUdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:33:33 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:50312 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaGWUda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuyRUG6ZdRvL0JuakD0zPdYo3WoqQepK7_b_MW+r2aVzVA@mail.gmail.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-9-git-send-email-ast@plumgrid.com>
	<CAGXu5jK1hrwvPs7f+mSOer+81J9SBxwMrqb=6fFeZQ7hd-FMzA@mail.gmail.com>
	<CAMEtUuyRUG6ZdRvL0JuakD0zPdYo3WoqQepK7_b_MW+r2aVzVA@mail.gmail.com>
Date: Wed, 23 Jul 2014 13:33:29 -0700
X-Google-Sender-Auth: uuRDZB3Kc5gWA7DRuRA_lTYZXZ8
Message-ID: <CAGXu5jLbcrR76=omiqRNERhjZS8bsR1-jG+Ctra97uCrpHLPUA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 08/16] bpf: add hashtable type of BPF maps
From: Kees Cook <keescook@chromium.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:57 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Wed, Jul 23, 2014 at 11:36 AM, Kees Cook <keescook@chromium.org> wrote:
>>> +static struct bpf_map *htab_map_alloc(struct nlattr *attr[BPF_MAP_ATTR_MAX + 1])
>>> +{
>>> +       struct bpf_htab *htab;
>>> +       int err, i;
>>> +
>>> +       htab = kmalloc(sizeof(*htab), GFP_USER);
>>
>> I'd prefer kzalloc here.
>
> in this case I agree. will change, since it's not in critical path and we
> can waste few cycles zeroing memory.
>
>>> +       err = -ENOMEM;
>>> +       htab->buckets = kmalloc(htab->n_buckets * sizeof(struct hlist_head),
>>> +                               GFP_USER);
>>
>> I'd prefer kcalloc here, even though n_buckets can't currently trigger
>> an integer overflow.
>
> hmm, I would argue that kmalloc_array is a preferred way, but kcalloc ?
> Few lines below the whole array is inited with INIT_HLIST_HEAD...

Ah! I didn't realize kmalloc_array existed! Perfect. Yes, that would
be great to use. The zeroing is not needed, due to the init below, as
you say.

>
>>> +       for (i = 0; i < htab->n_buckets; i++)
>>> +               INIT_HLIST_HEAD(&htab->buckets[i]);
>
>>> +       htab->slab_name = kasprintf(GFP_USER, "bpf_htab_%p", htab);
>>
>> This leaks a kernel heap memory pointer to userspace. If a unique name
>> needed, I think map_id should be used instead.
>
> it leaks, how? slabinfo is only available to root.
> The same code exists in conntrack:
> net/netfilter/nf_conntrack_core.c:1767

Right, in extreme cases, there are system configurations where leaking
addresses even to root can be considered a bug. There are a lot of
these situations in the kernel still, that's true. However, if we can
at all avoid it, I'd really like to avoid adding new ones. Nearly all
the cases of using a memory pointer is for uniqueness concerns, but I
think can already get that from the map_id.

-Kees

-- 
Kees Cook
Chrome OS Security
