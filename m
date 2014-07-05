Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbaGEV7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 17:59:11 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47975 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaGEV7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 17:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWQnQS=jjuhQzxM9YMhGk-fJ1oNetdPuZ0v4yujBLZ+fA@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-4-git-send-email-ast@plumgrid.com>
	<CALCETrV3WLBmHewCZgfhCkjODWfq_byRg6sF7HpqZ6n9BVMBVQ@mail.gmail.com>
	<CAMEtUuzWs+MbSOGGD-Rc01DHKASa4GxbHdtCrSCLit4cUM35mA@mail.gmail.com>
	<CALCETrWy6=dzTycy-ckiMR92+nQeqAWp_Hw=hi__VSzVWZ43Ag@mail.gmail.com>
	<CAMEtUuwRf--qyPu3rKB7-57KAu2NdsQdEpVRckqabmf61g+h-g@mail.gmail.com>
	<CALCETrUoOTtQ1R1A8Ak35fxHxaFTPHWP6oZWnXDVLKa_ESziWw@mail.gmail.com>
	<CAMEtUuzS=9Y_ZjigofvQ5d3=89RS=+d8-WGPk9VVSMc3qawWsw@mail.gmail.com>
	<CALCETrWq+=Q3G2Smjd2RYES42UagpmD0EKxFM+jNufi6_qitWg@mail.gmail.com>
	<CAMEtUuyKY=haqP11VgXHdfHBkqfB-KxuswygUd7hDPLkOFz9HQ@mail.gmail.com>
	<CALCETrW3=idHOKF56d94suiA0NoiUGwr7pENm13q6=1XMbBPdw@mail.gmail.com>
	<CAMEtUuyX-tybpMEW=f-00qgq9h3AcHovLNW0_bak3oT4Oj3FuA@mail.gmail.com>
	<CALCETrWpA5M74pKJLFJ0t-2hi2TXMi_BV6DbJMmdDOJyOoHOyg@mail.gmail.com>
	<CAMEtUuzHrzyUG1nie5cWzGZYTDTnqL7vPvAmPZdie_uSM_wqRA@mail.gmail.com>
	<CALCETrW5WitpzcFmkGDwR6U=qOwCkOfQMy=XOtQTuHs-942Drw@mail.gmail.com>
	<CAMEtUuzkVANM341xPTKH1bNVNuK6TQcyqsdZdkGWausLT5Qj6A@mail.gmail.com>
	<CALCETrWQnQS=jjuhQzxM9YMhGk-fJ1oNetdPuZ0v4yujBLZ+fA@mail.gmail.com>
Date: Sat, 5 Jul 2014 14:59:07 -0700
Message-ID: <CAMEtUuwjGykxr2rg-pSqmfZwHt4JRceJj96ENX9tjawU=y8QXQ@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 8:17 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jul 2, 2014 at 7:29 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>
>> non-root API:
>>
>> ufd = bpf_create_map(local_map_id,… )
>> bpf_map_update/delete/lookup_elem(ufd,…)
>> ufd = bpf_prog_load(insns)
>> close(ufd)
>>
>> root only API:
>>
>> global_id = bpf_get_id(ufd) // returns either map or prog global id
>> bpf_map_delete(global_map_id)
>> bpf_prog_unload(global_prog_id)
>>
>> Details:
>>
>> ufd = bpf_create_map(local_map_id, ...);
>>
>> local_map_id - process local map_id
>> (this id is used to access maps from eBPF program loaded by this process)
>>
>> ufd - process local file descriptor
>> (used to update/lookup maps from this process)
>>
>> global_map_id = bpf_get_id(ufd)
>> this is root only call to get global_ids and pass them to global events
>> like tracing.
>>
>> global ids will only be seen by root. There is no way for root or non-root
>> to influence id ranges.
>>
>> I think it will be cleaner once I finish fd conversion as a patch.
>
> OK
>
> FWIW, per-process local id maps sound almost equivalent to relocations
> -- the latter could be as simple as an extra nlattr giving a list of
> pairs of (per-eBPF-program id, fd).

I thought about array of such pairs as well, but it felt cleaner to remember
the (per-eBPF-program id, fd) pair in a kernel, instead of asking user
space to keep track of them. Either way I think it's minor. I'll implement
both and see which way is cleaner.

So far I did 3-way enum split in verifier and addressed Namhyung's
and Chema's comments. Updated in the same place:
git://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf master

I'll be traveling next week.
Once I'm done with fd-style interface, I'll post a v2.

Thanks
