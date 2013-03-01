Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3CAIoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:44:32 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:53036 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab3CAIob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:44:31 -0500
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: kprobing "hash_64.constprop.26" crashes the system, recursion through get_kprobe?
References: <84ehg2jdny.fsf@sauna.l.org> <20130301053123.GA30500@in.ibm.com>
	<513041D0.4010209@hitachi.com>
Date: Fri, 01 Mar 2013 10:43:46 +0200
In-Reply-To: <513041D0.4010209@hitachi.com> (Masami Hiramatsu's message of
	"Fri, 01 Mar 2013 14:51:12 +0900")
Message-ID: <84sj4fik71.fsf@sauna.l.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>> I am unable to recreate this problem on a fedora system; hash_64 is
>> inlined AFAICS.

Thanks testing. How does the disassembly of get_kprobes look for you?

> I also tried and couldn't recreate hash_64 problem on my ubuntu 12.10.
> Could you tell us your kconfig?

Sure, see

http://lindi.iki.fi/lindi/config-3.7-trunk-amd64_3.7.3-1~experimental.1

Note that I am doing the tests under xen. Should I redo the tests under
kvm?

>> This is a clear case of recursion. Either of the two options should fix
>> the problem.
>
> I think __kprobes is better if it works, because it causes kprobes
> issue (no problem in other parts).
> (Again, since I can't reproduce this hash_64.constprop,
> I'm not sure that __kprobes can fix that clearly.)

Ok. My worry is that hash_64 is not the only function that is called
from a __kprobes marked function. For example kprobes_module_callback
calls mutex_lock. Should we also mark mutex_lock with __kprobes?

Based on the disassembly of code between __kprobes_text_start and
__kprobes_text_end I made a function call graph that shows functions
that get called from this region:

http://lindi.iki.fi/lindi/kprobes/function-call-graph1.png

The __kprobes functions are marked with red color. I had to omit
mutex_lock, mutex_unlock and printk from the graph to make it readable
(I also omited functions that don't call other functions). As you can
see, this is quite a minefield :)
