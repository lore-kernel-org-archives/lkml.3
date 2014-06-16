Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaFPJws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:52:48 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:44928 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaFPJwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:52:47 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 05:52:47 EDT
Date: Mon, 16 Jun 2014 09:44:32 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        edumazet@google.com, viro@zeniv.linux.org.uk, jbaron@akamai.com
Subject: Re: eventpoll __list_del_entry corruption
Message-ID: <20140616094432.GA28074@dcvr.yhbt.net>
References: <5370EBE9.6@oracle.com>
 <20140515181102.GH11096@twins.programming.kicks-ass.net>
 <53750472.1040703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53750472.1040703@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> wrote:
> On 05/15/2014 02:11 PM, Peter Zijlstra wrote:
> > On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
> >> Hi all,
> >>
> >> While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> kernel I've stumbled on the following spew. Maybe related to the very recent
> >> change in freeing on task exit?

> > [ 5823.690004]  [<ffffffff8109a544>] do_exit+0x2d4/0xa90
> > [ 5823.690004]  [<ffffffff813825c4>] ? lockdep_sys_exit_thunk+0x35/0x67
> > [ 5823.690004]  [<ffffffff8109ae2c>] do_group_exit+0x4c/0xc0
> > [ 5823.690004]  [<ffffffff8109aeb7>] SyS_exit_group+0x17/0x20
> > [ 5823.690004]  [<ffffffff8168a2c2>] system_call_fastpath+0x16/0x1b
> > [ 5823.690004] ---[ end trace 515b7fa3169c0906 ]---
> 
> Dave reported something similar to that last year(!) and that never got fixed
> AFAIK: https://lkml.org/lkml/2013/10/14/353.

Both stack traces happen during exit, so it may be a destruction
ordering problem when the eventpoll and files it references are
all released together.

I've never seen this in normal use, perhaps because I'm in the habit of
closing all descriptors before exit to keep valgrind happy :)
