Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaF1GnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:43:08 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63433 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaF1GnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWy6=dzTycy-ckiMR92+nQeqAWp_Hw=hi__VSzVWZ43Ag@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-4-git-send-email-ast@plumgrid.com>
	<CALCETrV3WLBmHewCZgfhCkjODWfq_byRg6sF7HpqZ6n9BVMBVQ@mail.gmail.com>
	<CAMEtUuzWs+MbSOGGD-Rc01DHKASa4GxbHdtCrSCLit4cUM35mA@mail.gmail.com>
	<CALCETrWy6=dzTycy-ckiMR92+nQeqAWp_Hw=hi__VSzVWZ43Ag@mail.gmail.com>
Date: Fri, 27 Jun 2014 23:43:03 -0700
Message-ID: <CAMEtUuwRf--qyPu3rKB7-57KAu2NdsQdEpVRckqabmf61g+h-g@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 03/14] bpf: introduce syscall(BPF, ...) and
 BPF maps
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jun 27, 2014 at 10:55 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Fri, Jun 27, 2014 at 5:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Jun 27, 2014 at 5:05 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> BPF syscall is a demux for different BPF releated commands.
>>>>
>>>> 'maps' is a generic storage of different types for sharing data between kernel
>>>> and userspace.
>>>>
>>>> The maps can be created/deleted from user space via BPF syscall:
>>>> - create a map with given id, type and attributes
>>>>   map_id = bpf_map_create(int map_id, map_type, struct nlattr *attr, int len)
>>>>   returns positive map id or negative error
>>>>
>>>> - delete map with given map id
>>>>   err = bpf_map_delete(int map_id)
>>>>   returns zero or negative error
>>>
>>> What's the scope of "id"?  How is it secured?
>>
>> the map and program id space is global and it's cap_sys_admin only.
>> There is no pressing need to do it with per-user limits.
>> So the whole thing is root only for now.
>>
>
> Hmm.  This may be unpleasant if you ever want to support non-root or
> namespaced operation.

I think it will be easy to extend it per namespace when we lift
root-only restriction. It will be seamless without user api changes.

> How hard would it be to give these things fds?

you mean programs/maps auto-terminate when creator process
exits? I thought about it and it's appealing at first glance, but
doesn't fit the model of existing tracepoint events which are global.
The programs attached to events need to live without 'daemon'
hanging around. Therefore I picked 'kernel module'- like method.
