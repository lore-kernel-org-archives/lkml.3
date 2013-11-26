Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3KZP4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:56:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab3KZP4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:56:32 -0500
Date: Tue, 26 Nov 2013 10:56:18 -0500
From: Dave Jones <davej@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
Message-ID: <20131126155618.GA624@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Kent Overstreet <kmo@daterainc.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Sasha Levin <sasha.levin@oracle.com>
References: <20131126032645.GA32301@redhat.com>
 <20131126060132.GA6400@redhat.com>
 <20131126071953.GE9244@kmo-pixel>
 <20131126152337.GL15489@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126152337.GL15489@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:23:37AM -0500, Benjamin LaHaise wrote:
 > On Mon, Nov 25, 2013 at 11:19:53PM -0800, Kent Overstreet wrote:
 > > On Tue, Nov 26, 2013 at 01:01:32AM -0500, Dave Jones wrote:
 > > > On Mon, Nov 25, 2013 at 10:26:45PM -0500, Dave Jones wrote:
 > > >  > Hi Kent,
 > > >  > 
 > > >  > I hit the GPF below on a tree based on 8e45099e029bb6b369b27d8d4920db8caff5ecce
 > > >  > which has your commit e34ecee2ae791df674dfb466ce40692ca6218e43
 > > >  > ("aio: Fix a trinity splat").  Is this another path your patch missed, or
 > > >  > a completely different bug to what you were chasing ?
 > > > 
 > > > And here's another from a different path, this time on 32bit.
 > 
 > For Dave: what line is this bug on?  Is it the dereference of ctx when 
 > doing spin_lock_irqsave(&ctx->completion_lock, flags); or is the 
 > ctx->ring_pages[idx] = new; ?

>From the 32bit trace:

> EIP is at aio_migratepage+0xad/0x126

disasm of aio.o shows aio_migratepage at 0x6f5, which means we oopsed at 7a2...



                        ctx->ring_pages[idx] = new;
     79f:       8b 57 50                mov    0x50(%edi),%edx
     7a2:       89 34 82                mov    %esi,(%edx,%eax,4)
        raw_spin_unlock_irq(&lock->rlock);

which matches up with the Code: line.

So that's actually..

	spin_unlock_irqrestore(&ctx->completion_lock, flags);


The 64bit trace looks a little funky due to gcc optimising and moving
things around, but I think it's the same thing except this time it's
in the lock acquire path instead of lock release.

> aio_migratepage+0xa6/0x150

aio_migratepage is at 0x540, and at 0x5e6, we see...

         */
        spin_lock(&mapping->private_lock);
        ctx = mapping->private_data;
     5c3:       4d 8b ad a8 01 00 00    mov    0x1a8(%r13),%r13
        if (ctx) {
     5ca:       4d 85 ed                test   %r13,%r13
     5cd:       0f 84 85 00 00 00       je     658 <aio_migratepage+0x118>
                pgoff_t idx;
                spin_lock_irqsave(&ctx->completion_lock, flags);
     5d3:       49 8d 95 c8 02 00 00    lea    0x2c8(%r13),%rdx
     5da:       48 89 d7                mov    %rdx,%rdi
     5dd:       48 89 55 c8             mov    %rdx,-0x38(%rbp)
     5e1:       e8 00 00 00 00          callq  5e6 <aio_migratepage+0xa6>
                migrate_page_copy(new, old);
     5e6:       48 89 de                mov    %rbx,%rsi
     5e9:       4c 89 e7                mov    %r12,%rdi
         */
        spin_lock(&mapping->private_lock);
        ctx = mapping->private_data;
        if (ctx) {
                pgoff_t idx;
                spin_lock_irqsave(&ctx->completion_lock, flags);


 > Actually, is there easy way to reproduce this with Trinity?  I can have a 
 > look if you point me in the right direction.

I've not found a simple reproducer recipe yet, working on it.
So far I've just been running it for an hour and waiting. If I can narrow down
the syscalls necessary I'll let you know.
 
	Dave
 
