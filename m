Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3DOQVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:21:47 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:58347 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3DOQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:21:45 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.02.1304151205140.17281@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1304151205140.17281@vincent-weaver-1.um.maine.edu>
Date: Mon, 15 Apr 2013 18:21:44 +0200
Message-ID: <CAMsRxfLUvRw-PUxgX_909PLCFtqqnKO3iiZ8Wvc5DHGAPp3yxA@mail.gmail.com>
Subject: Re: perf: forcing instructions event to run on Fixed Counter 0
From: Stephane Eranian <eranian@googlemail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 6:13 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>
> It turns out that perf_event for intel seems to use the INST_RETIRED.ALL
> event interchangably with the "Fixed Counter 0" event.
>
Yes, it does.

> It turns out they are not equivelent.  The Fixed Counter 0 event turns out
> to be deterministic, while INST_RETIRED.ALL has a bug where it counts
> extra events due to hardware interrupts.
>
Never heard of that problem. I know there was another problem due to leaking
during priv level transitions. It would be take a few instr or cycles to realize
you were not in user level any more when doing event:u.

Interrupt should impact fixed and generic counters the same way.

> Having a user-accessible deterministic instructions event would be really
> useful.  So is there a way we can specify we want an event to run on Fixed
> Counter 0?  I think there is code already that does this for Fixed Counter
> 2 for similar reasons.
>
No. Fixed counter 2 (ref-cycles) is a different reason. It's because it measures
an event that does not exist on generic counters: unhalted_reference_cycles.

> For an example of this happening in real life, take the
> ./retired_instr.all.x86_64 from my deterministic benchmark that
> I'll be presenting at the ISPASS conference next week.
>   (can be found here git://github.com/deater/deterministic.git )
>
> If you run this benchmark with the same event listed 5 times on an Ivy
> Bridge machine you get these results, notice the last one is the "proper"
> deterministic result and thus the one that ran on Fixed Counter 0.
>
Are you sure that the 5th event stayed in fixed counter 0 all along?

> $ perf stat -e instructions:u,instructions:u,instructions:u,instructions:u,instructions:u ./retired_instr.all.x86_64
> ...
>  Performance counter stats for './retired_instr.all.x86_64':
>
>        227,010,687 instructions:u            #    0.00  insns per cycle
>        227,010,687 instructions:u            #    0.00  insns per cycle
>        227,010,687 instructions:u            #    0.00  insns per cycle
>        227,010,687 instructions:u            #    0.00  insns per cycle
>        227,000,723 instructions:u            #    0.00  insns per cycle
>
>        1.902648316 seconds time elapsed
>
> Thanks,
>
> Vince Weaver
> vincent.weaver@maine.edu
> http://www.eece.maine.edu/~vweaver/
