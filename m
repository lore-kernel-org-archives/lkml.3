Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbaGWUWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:22:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37922 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaGWUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+gMepR-euMhBjYqMVHsdJM-Do5yc0rLw5dMK-C9BBieA@mail.gmail.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-10-git-send-email-ast@plumgrid.com>
	<CAGXu5j+gMepR-euMhBjYqMVHsdJM-Do5yc0rLw5dMK-C9BBieA@mail.gmail.com>
Date: Wed, 23 Jul 2014 13:22:21 -0700
Message-ID: <CAMEtUuw9paQJXEzg=dJw6z--3UqFp-pWq4uyxV-oT4_0_+7Gxg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 09/16] bpf: expand BPF syscall with
 program load/unload
From: Alexei Starovoitov <ast@plumgrid.com>
To: Kees Cook <keescook@chromium.org>
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

On Wed, Jul 23, 2014 at 12:00 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 17, 2014 at 9:19 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> eBPF programs are safe run-to-completion functions with load/unload
>> methods from userspace similar to kernel modules.
>>
>> User space API:
>>
>> - load eBPF program
>>   fd = bpf_prog_load(bpf_prog_type, struct nlattr *prog, int len)
>>
>>   where 'prog' is a sequence of sections (TEXT, LICENSE, MAP_ASSOC)
>>   TEXT - array of eBPF instructions
>>   LICENSE - must be GPL compatible to call helper functions marked gpl_only
>>   MAP_FIXUP - array of {insn idx, map fd} used by kernel to adjust
>>   imm constants in 'mov' instructions used to access maps
>
> Nit: naming mismatch between MAP_ASSOC vs MAP_FIXUP.

ohh yes, I used map_assoc name initially and forgot to rename it
in commit log. will fix.

>> + */
>> +static int fixup_bpf_map_id(struct sk_filter *prog, struct nlattr *map_fixup)
>> +{
>> +       struct {
>> +               u32 insn_idx;
>> +               u32 ufd;
>> +       } *fixup = nla_data(map_fixup);
>> +       int fixup_len = nla_len(map_fixup) / sizeof(*fixup);
>> +       struct bpf_insn *insn;
>> +       struct fd f;
>> +       u32 idx;
>> +       int i, map_id;
>> +
>> +       if (fixup_len <= 0)
>> +               return -EINVAL;
>> +
>> +       for (i = 0; i < fixup_len; i++) {
>> +               idx = fixup[i].insn_idx;
>> +               if (idx >= prog->len)
>> +                       return -EINVAL;
>> +
>> +               insn = &prog->insnsi[idx];
>> +               if (insn->code != (BPF_ALU64 | BPF_MOV | BPF_K) &&
>> +                   insn->code != (BPF_ALU | BPF_MOV | BPF_K))
>> +                       return -EINVAL;
>> +
>> +               f = fdget(fixup[i].ufd);
>> +
>> +               map_id = get_map_id(f);
>> +
>> +               if (map_id < 0)
>> +                       return map_id;
>> +
>> +               insn->imm = map_id;
>> +               fdput(f);
>
> It looks like there a potentially race risk of a map_id changing out
> from under a running program? Between the call to fixup_bpf_map_id()
> and the bpf_map_get() calls during bpf_prog_load() below...

Excellent question!
If user space created a bunch of maps and has another thread
that closes fds (and may be creating new maps) while main thread is
doing syscall(prog_load,...) then map_ids stored inside instructions
can become stale by the time bpf_check() is called. In such case
bpf_check() will reject the program. Either it will find unknown map_id
or map will have invalid key/value ranges for the program to access.
So this is not an issue, but I agree the code is not obviously correct.
My bad to allow such subtle races.
I'll increase mutex_lock() range.

>> +       if (tb[BPF_PROG_MAP_FIXUP]) {
>> +               /* if program is using maps, fixup map_ids */
>> +               err = fixup_bpf_map_id(prog, tb[BPF_PROG_MAP_FIXUP]);
>> +               if (err < 0)
>> +                       goto free_prog;
>> +       }
>> +
>> +       /* allocate eBPF related auxilary data */
>> +       prog->info = kzalloc(sizeof(struct bpf_prog_info), GFP_USER);
>> +       if (!prog->info)
>> +               goto free_prog;
>> +       prog->ebpf = 1;
>> +       prog->info->is_gpl_compatible = is_gpl;
>> +
>> +       /* find program type: socket_filter vs tracing_filter */
>> +       err = find_prog_type(type, prog);
>> +       if (err < 0)
>> +               goto free_prog;
>> +
>> +       /* lock maps to prevent any changes to maps, since eBPF program may
>> +        * use them. In such case bpf_check() will populate prog->used_maps
>> +        */
>> +       mutex_lock(&bpf_map_lock);
>> +
>> +       /* run eBPF verifier */
>> +       /* err = bpf_check(prog); */
>> +
>> +       if (err == 0 && prog->info->used_maps) {
>> +               /* program passed verifier and it's using some maps,
>> +                * hold them
>> +                */
>> +               for (i = 0; i < prog->info->used_map_cnt; i++) {
>> +                       map = bpf_map_get(prog->info->used_maps[i]);
>> +                       BUG_ON(!map);
>> +                       atomic_inc(&map->refcnt);
>> +               }
>> +       }
>> +       mutex_unlock(&bpf_map_lock);
>
> As mentioned above, I think fixup_bpf_map_id needs to be done under
> the map_lock mutex, unless I'm misunderstanding something in the
> object lifetime.

yes. Excellent point. Will increase the range.

Thank you so much for the review!
