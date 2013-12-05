Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab3LENrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:47:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26590 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362Ab3LENrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:47:02 -0500
Date: Thu, 5 Dec 2013 08:46:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131205084657.09b6a2ce@gandalf.local.home>
In-Reply-To: <20131205104113.GB20283@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131205104113.GB20283@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013 11:41:13 +0100
Ingo Molnar <mingo@kernel.org> wrote:

 
> > so with one 'if' condition the difference ktap vs bpf is 350-145 vs 183-145
> > 
> > obviously ktap is an interpreter, so it's not really fair.
> > 
> > To make it really unfair I did:
> > trace skb:kfree_skb {
> >         if (arg2 == 0x100 || arg2 == 0x200 || arg2 == 0x300 || arg2 == 0x400 ||
> >             arg2 == 0x500 || arg2 == 0x600 || arg2 == 0x700 || arg2 == 0x800 ||
> >             arg2 == 0x900 || arg2 == 0x1000) {
> >                 printf("%x %x\n", arg1, arg2)
> >         }
> > }
> > 1M skb alloc/free 484280 (usecs)
> 
> Real life scripts, for examples the ones related to network protocol 
> analysis will often have such patterns in them, so I don't think this 
> measurement is particularly unfair.

I agree. As the size of the if statement grows, the filter logic gets
lineally expensive, but the bpf filter does not.

I know that it would be great to have the bpf filter run before
recording of the tracepoint, but as that becomes quite awkward for a
user interface, because it requires intimate knowledge of the kernel
source, this speed up on the filter itself may be worth while to have
it happen after the recording of the buffer. When it happens after the
record, then the bpf has direct access to the event entry and its
fields as described by the trace event format files.

-- Steve
