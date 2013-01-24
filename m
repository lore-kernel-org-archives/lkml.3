Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3AXMfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:35:43 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:32884 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3AXMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:35:36 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 07:35:36 EST
MIME-Version: 1.0
In-Reply-To: <20130124121720.GA3104@gmail.com>
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com>
From: Anton Arapov <anton@redhat.com>
Date: Thu, 24 Jan 2013 22:28:31 +1000
X-Google-Sender-Auth: xZoGHAV1_dnaFXNZk3rF2hZSTpc
Message-ID: <CAMeizLf1XTwaLLE2eBm+XMRQZPgBY=dUkEcpaDYdupB0T3+2Lg@mail.gmail.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Christoph Hellwig <hch@infradead.org>, Josh Stone <jistone@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Thu, Jan 24, 2013 at 11:17 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
>> Ingo, please pull from
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
>>
>> Mostly pre-filtering. This needs more work and perhaps more functionality.
>> In particular, perhaps dup_mmap() should remove the unwanted breakpoints.
>> And we can add more ->filter() hooks to, say, speedup uprobe_register().
>> Plus we can do some optimizations to avoid register_for_each_vma() in
>> case when we know that all mm's were previously acked/nacked.
>>
>> Srikar, the only patch you did not ack explicitely is 1fecb96d
>> "Do not allocate current->utask unnecessary", but afaics you do not
>> object.
>>
>> And the patch from Josh which exports uprobe_register/unregister for modules.
>> Christoph (cc'ed) doesn't like this change, but I disagree. Whatever you
>> think about systemtap it is the widely used tool, and uprobes can have other
>> out-of-tree users. This is like kprobes, kprobe_register() is exported but
>> it doesn't have a modular in-kernel user too. I do not see why should we
>> limit the usage of uprobes.
>>
>>
>>
>> Josh Stone (1):
>>       uprobes: Add exports for module use
>>
>> Oleg Nesterov (26):
>>       uprobes: Move __set_bit(UPROBE_SKIP_SSTEP) into alloc_uprobe()
>>       uprobes: Kill the "uprobe != NULL" check in uprobe_unregister()
>>       uprobes: Kill the pointless inode/uc checks in register/unregister
>>       uprobes: Kill uprobe_consumer->filter()
>>       uprobes: Introduce filter_chain()
>>       uprobes: _unregister() should always do register_for_each_vma(false)
>>       uprobes: _register() should always do register_for_each_vma(true)
>>       uprobes: Introduce uprobe->register_rwsem
>>       uprobes: Change filter_chain() to iterate ->consumers list
>>       uprobes: Kill UPROBE_RUN_HANDLER flag
>>       uprobes: Kill uprobe->copy_mutex
>>       uprobes: Kill uprobe_events, use RB_EMPTY_ROOT() instead
>>       uprobes: Introduce uprobe_is_active()
>>       uprobes: Kill uprobes_mutex[], separate alloc_uprobe() and __uprobe_register()
>>       uprobes: Rationalize the usage of filter_chain()
>>       uprobes: Reintroduce uprobe_consumer->filter()
>>       uprobes: Teach handler_chain() to filter out the probed task
>>       uprobes/x86: Change __skip_sstep() to actually skip the whole insn
>>       uprobes: Change handle_swbp() to expose bp_vaddr to handler_chain()
>>       uprobes: Move alloc_page() from xol_add_vma() to xol_alloc_area()
>>       uprobes: Fold xol_alloc_area() into get_xol_area()
>>       uprobes: Turn add_utask() into get_utask()
>>       uprobes: Do not play with utask in xol_get_insn_slot()
>>       uprobes: Fix utask->xol_vaddr leak in pre_ssout()
>>       uprobes: Do not allocate current->utask unnecessary
>>       uprobes: Kill the bogus IS_ERR_VALUE(xol_vaddr) check
>>
>>  arch/x86/kernel/uprobes.c   |    4 +-
>>  include/linux/uprobes.h     |   17 ++-
>>  kernel/events/uprobes.c     |  433 ++++++++++++++++++++++---------------------
>>  kernel/ptrace.c             |    6 +
>>  kernel/trace/trace_uprobe.c |    5 +-
>>  5 files changed, 243 insertions(+), 222 deletions(-)
>
> The kernel side looks good to me - but how does 'perf uprobe'
> make use of it in practice, how can I test it?

I'm not sure whether you looking into testing specific changes in this
pull, but in general, syntax is:
  perf probe -x /lib64/libc.so.6 malloc
  perf record -e probe_libc:p_malloc -aR sleep 30

hope this is what you was looking for,
Anton.
