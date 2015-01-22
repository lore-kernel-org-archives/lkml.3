Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbbAVRyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:54:20 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52789 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbAVRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:54:17 -0500
Date: Thu, 22 Jan 2015 18:54:12 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] bpf: Call rcu_read_unlock() before copy_to_user()
Message-ID: <20150122185412.66a0a920@holzheu>
In-Reply-To: <CAADnVQLnrAgk3vTppugqCtSsHL4XiZeQJrQi3cqhgLCCq1v8Pg@mail.gmail.com>
References: <CAADnVQLnrAgk3vTppugqCtSsHL4XiZeQJrQi3cqhgLCCq1v8Pg@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012217-0025-0000-0000-000003921981
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 09:27:21 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Jan 22, 2015 at 7:57 AM, Michael Holzheu
> <holzheu@linux.vnet.ibm.com> wrote:
> > We must not hold locks when calling copy_to_user():
> >
> > BUG: sleeping function called from invalid context at mm/memory.c:3732
> > in_atomic(): 0, irqs_disabled(): 0, pid: 671, name: test_maps
> > 1 lock held by test_maps/671:
> >  #0:  (rcu_read_lock){......}, at: [<0000000000264190>] map_lookup_elem+0xe8/0x260
> > Preemption disabled at:[<00000000001be3b6>] vprintk_default+0x56/0x68
> >
> > CPU: 0 PID: 671 Comm: test_maps Not tainted 3.19.0-rc5-00117-g5eb11d6-dirty #424
> >        000000001e447bb0 000000001e447c40 0000000000000002 0000000000000000
> >        000000001e447ce0 000000001e447c58 000000001e447c58 0000000000115c8a
> >        0000000000000000 0000000000c08246 0000000000c27e8a 000000000000000b
> >        000000001e447ca0 000000001e447c40 0000000000000000 0000000000000000
> >        0000000000000000 0000000000115c8a 000000001e447c40 000000001e447ca0
> > Call Trace:
> > ([<0000000000115b7e>] show_trace+0x12e/0x150)
> >  [<0000000000115c40>] show_stack+0xa0/0x100
> >  [<00000000009b163c>] dump_stack+0x74/0xc8
> >  [<000000000017424a>] ___might_sleep+0x23a/0x248
> >  [<00000000002b58e8>] might_fault+0x70/0xe8
> >  [<0000000000264230>] map_lookup_elem+0x188/0x260
> >  [<0000000000264716>] SyS_bpf+0x20e/0x840
> >  [<00000000009bbe3a>] system_call+0xd6/0x24c
> >  [<000003fffd15f566>] 0x3fffd15f566
> > 1 lock held by test_maps/671:
> >  #0:  (rcu_read_lock){......}, at: [<0000000000264190>] map_lookup_elem+0xe8/0x260
> >
> > So call rcu_read_unlock() before copy_to_user(). We can
> > release the lock earlier because it is not needed for copy_to_user().
> 
> we cannot move the rcu unlock this way, since it protects the value.
> So we need to copy the value while still under rcu.

Ok, right. I assume you will provide the correct fix.

> I'm puzzled how I missed this warning.
> I guess you have CONFIG_PREEMPT_RCU=y ?

Yes.

Regards,
Michael

