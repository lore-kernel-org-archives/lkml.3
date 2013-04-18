Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3DRMiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:38:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab3DRMh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:37:59 -0400
Date: Thu, 18 Apr 2013 05:37:38 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: gaowanlong@cn.fujitsu.com, Tejun Heo <tj@kernel.org>, namhyung@gmail.com,
        agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130418123738.GV4816@kernel.dk>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366209997.8817.12.camel@pippen.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17 2013, Steven Rostedt wrote:
> On Wed, 2013-04-17 at 16:36 +0800, Wanlong Gao wrote:
> > Hi Tj, all,
> > 
> > I can get kernel panic on my machine with kernel 3.9.0-rc7-4-gbb33db7 every time
> > after booting for several minutes.
> > 
> > Here attached the panic picture and the config.
> > I'm sorry that the panic log is not completed.
> > 
> > But fortunately, the panic was gone when I reverted the below commit from Tj,
> > 
> > commit 3a366e614d0837d9fc23f78cdb1a1186ebc3387f
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Fri Jan 11 13:06:33 2013 -0800
> > 
> >     block: add missing block_bio_complete() tracepoint
> > 
> > I think this will be helpful for you to resolve this bug, and this may be urgent,
> > because it's already rc-7 now.
> 
> 
> Doing a objdump on the code I found this:
> 
> ffffffff8123d479:       8b 77 48                mov    0x48(%rdi),%esi
> ffffffff8123d47c:       48 8d 7d c8             lea    -0x38(%rbp),%rdi
> ffffffff8123d480:       48 8b 4d b8             mov    -0x48(%rbp),%rcx
> ffffffff8123d484:       ba 28 00 00 00          mov    $0x28,%edx
> ffffffff8123d489:       45 89 e8                mov    %r13d,%r8d
> ffffffff8123d48c:       e8 1f d3 ea ff          callq  ffffffff810ea7b0 <trace_current_buffer_lock_reserve>
> ffffffff8123d491:       48 85 c0                test   %rax,%rax
> ffffffff8123d494:       49 89 c6                mov    %rax,%r14
> ffffffff8123d497:       74 5a                   je     ffffffff8123d4f3 <ftrace_raw_event_block_bio_complete+0xb3>
> ffffffff8123d499:       48 89 c7                mov    %rax,%rdi
> ffffffff8123d49c:       e8 5f 4f ea ff          callq  ffffffff810e2400 <ring_buffer_event_data>
> ffffffff8123d4a1:       48 8b 4b 10             mov    0x10(%rbx),%rcx
> ffffffff8123d4a5:       31 d2                   xor    %edx,%edx
> ffffffff8123d4a7:       48 85 c9                test   %rcx,%rcx
> ffffffff8123d4aa:       74 02                   je     ffffffff8123d4ae <ftrace_raw_event_block_bio_complete+0x6e>
> 
> ffffffff8123d4ac:       8b 11                   mov    (%rcx),%edx   <<<---- BUG IS HERE
> 
> ffffffff8123d4ae:       89 50 08                mov    %edx,0x8(%rax)
> ffffffff8123d4b1:       48 8b 13                mov    (%rbx),%rdx
> ffffffff8123d4b4:       48 8d 78 20             lea    0x20(%rax),%rdi
> ffffffff8123d4b8:       48 89 50 10             mov    %rdx,0x10(%rax)
> ffffffff8123d4bc:       8b 53 30                mov    0x30(%rbx),%edx
> ffffffff8123d4bf:       44 89 78 1c             mov    %r15d,0x1c(%rax)
> ffffffff8123d4c3:       c1 ea 09                shr    $0x9,%edx
> ffffffff8123d4c6:       89 50 18                mov    %edx,0x18(%rax)
> ffffffff8123d4c9:       8b 53 30                mov    0x30(%rbx),%edx
> ffffffff8123d4cc:       48 8b 73 20             mov    0x20(%rbx),%rsi
> 
> According to the picture, that showed where in the code dump, it has the
> command that died: "<8b> 11 89 50 08".
> 
> Just before that, rcx was tested for zero, and passed (wasn't zero). But
> it seems that it wasn't a real address space either.
> 
> bio is allocated with kmalloc and not kzalloc, so it is possible that if
> bio->bi_bdev never got initialized and is just garbage.

A bio is always fully initialized, regardless of which internal
allocator it came from. If people are doing private kmallocs, then they
better be using bio_init() as well.

Wanlong, would it be possible to get a full dmesg on boot see I can see
what drivers and file systems are in use? Anything special about your
setup.

Will get this reverted for 3.9 final, so we have some time to
investigate.

-- 
Jens Axboe

