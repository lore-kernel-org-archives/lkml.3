Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3LCJOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:14:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3LCJOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:14:00 -0500
X-IronPort-AV: E=Sophos;i="4.93,816,1378828800"; 
   d="scan'208";a="9179320"
Message-ID: <529D9E1C.8050008@cn.fujitsu.com>
Date: Tue, 03 Dec 2013 17:02:20 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
References: <20131126032645.GA32301@redhat.com> <20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel> <20131126152337.GL15489@kvack.org> <20131126155618.GA624@redhat.com>
In-Reply-To: <20131126155618.GA624@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/03 17:08:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/03 17:13:53,
	Serialize complete at 2013/12/03 17:13:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
According to your analysis and the dump stack, it seems that it tried to migrate
aio ring pages in the compact path, but the aio context(mapping->private_data) is
invalid (not NULL), so only one case can cause this condition, aio ring file was
left and not cleaned up in the fail path of ioctx_alloc.

So please try the following patch, I think it can fix this issue.


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 08159ed..5255548 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -367,8 +367,10 @@ static int aio_setup_ring(struct kioctx *ctx)
 	if (nr_pages > AIO_RING_PAGES) {
 		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
 					  GFP_KERNEL);
-		if (!ctx->ring_pages)
+		if (!ctx->ring_pages) {
+			put_aio_ring_file(ctx);
 			return -ENOMEM;
+		}
 	}
 
 	ctx->mmap_size = nr_pages * PAGE_SIZE;
-- 
1.7.7



On 11/26/2013 11:56 PM, Dave Jones wrote:

> On Tue, Nov 26, 2013 at 10:23:37AM -0500, Benjamin LaHaise wrote:
>  > On Mon, Nov 25, 2013 at 11:19:53PM -0800, Kent Overstreet wrote:
>  > > On Tue, Nov 26, 2013 at 01:01:32AM -0500, Dave Jones wrote:
>  > > > On Mon, Nov 25, 2013 at 10:26:45PM -0500, Dave Jones wrote:
>  > > >  > Hi Kent,
>  > > >  > 
>  > > >  > I hit the GPF below on a tree based on 8e45099e029bb6b369b27d8d4920db8caff5ecce
>  > > >  > which has your commit e34ecee2ae791df674dfb466ce40692ca6218e43
>  > > >  > ("aio: Fix a trinity splat").  Is this another path your patch missed, or
>  > > >  > a completely different bug to what you were chasing ?
>  > > > 
>  > > > And here's another from a different path, this time on 32bit.
>  > 
>  > For Dave: what line is this bug on?  Is it the dereference of ctx when 
>  > doing spin_lock_irqsave(&ctx->completion_lock, flags); or is the 
>  > ctx->ring_pages[idx] = new; ?
> 
>>From the 32bit trace:
> 
>> EIP is at aio_migratepage+0xad/0x126
> 
> disasm of aio.o shows aio_migratepage at 0x6f5, which means we oopsed at 7a2...
> 
> 
> 
>                         ctx->ring_pages[idx] = new;
>      79f:       8b 57 50                mov    0x50(%edi),%edx
>      7a2:       89 34 82                mov    %esi,(%edx,%eax,4)
>         raw_spin_unlock_irq(&lock->rlock);
> 
> which matches up with the Code: line.
> 
> So that's actually..
> 
> 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> 
> 
> The 64bit trace looks a little funky due to gcc optimising and moving
> things around, but I think it's the same thing except this time it's
> in the lock acquire path instead of lock release.
> 
>> aio_migratepage+0xa6/0x150
> 
> aio_migratepage is at 0x540, and at 0x5e6, we see...
> 
>          */
>         spin_lock(&mapping->private_lock);
>         ctx = mapping->private_data;
>      5c3:       4d 8b ad a8 01 00 00    mov    0x1a8(%r13),%r13
>         if (ctx) {
>      5ca:       4d 85 ed                test   %r13,%r13
>      5cd:       0f 84 85 00 00 00       je     658 <aio_migratepage+0x118>
>                 pgoff_t idx;
>                 spin_lock_irqsave(&ctx->completion_lock, flags);
>      5d3:       49 8d 95 c8 02 00 00    lea    0x2c8(%r13),%rdx
>      5da:       48 89 d7                mov    %rdx,%rdi
>      5dd:       48 89 55 c8             mov    %rdx,-0x38(%rbp)
>      5e1:       e8 00 00 00 00          callq  5e6 <aio_migratepage+0xa6>
>                 migrate_page_copy(new, old);
>      5e6:       48 89 de                mov    %rbx,%rsi
>      5e9:       4c 89 e7                mov    %r12,%rdi
>          */
>         spin_lock(&mapping->private_lock);
>         ctx = mapping->private_data;
>         if (ctx) {
>                 pgoff_t idx;
>                 spin_lock_irqsave(&ctx->completion_lock, flags);
> 
> 
>  > Actually, is there easy way to reproduce this with Trinity?  I can have a 
>  > look if you point me in the right direction.
> 
> I've not found a simple reproducer recipe yet, working on it.
> So far I've just been running it for an hour and waiting. If I can narrow down
> the syscalls necessary I'll let you know.
>  
> 	Dave
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


