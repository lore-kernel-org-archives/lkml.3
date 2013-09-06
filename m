Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3IFNcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3IFNcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:32:53 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BbXNHQx3NekA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fxhqf5xVK60A:10 a=20KFwNOVAAAA:8 a=-Ys57mbRvl4lIYqhvVYA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 09:32:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906093252.02c748f5@gandalf.local.home>
In-Reply-To: <20130906035827.GA13446@redhat.com>
References: <20130906011924.GA7970@redhat.com>
	<20130905212834.605408a4@gandalf.local.home>
	<20130906013455.GA10073@redhat.com>
	<20130905214455.101c6347@gandalf.local.home>
	<20130906014859.GB10073@redhat.com>
	<20130905215154.74c55e9a@gandalf.local.home>
	<20130906035827.GA13446@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013 23:58:27 -0400
Dave Jones <davej@redhat.com> wrote:

> On Thu, Sep 05, 2013 at 09:51:54PM -0400, Steven Rostedt wrote:
>  > On Thu, 5 Sep 2013 21:48:59 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  > 
>  > > On Thu, Sep 05, 2013 at 09:44:55PM -0400, Steven Rostedt wrote:
>  > >  > On Thu, 5 Sep 2013 21:34:55 -0400
>  > >  > Dave Jones <davej@redhat.com> wrote:
>  > >  > 
>  > >  > > On Thu, Sep 05, 2013 at 09:28:34PM -0400, Steven Rostedt wrote:
>  > 
>  > >  > Did you change a config option, or update your gcc?
>  > > 
>  > > Yeah, changed CONFIG_DEBUG_KOBJECT, which rebuilt the world.
>  > 
>  > Still doesn't explain why it gave you that splat there.
>  > 
>  > Do you still have that binary module, and can you show me what's at
>  > reiserfs_init_bitmap_cache+0x0 with objdump?
> 
> I didn't, but it turns out I can recreate this. A little convoluted but..
> 
> disable DEBUG_KOBJECT_RELEASE
> build, install and boot into kernel
> 
> enable DEBUG_KOBJECT_RELEASE
> build kernel
> install -> boom

Did it report failing on the same function as before?

> 
> 
> 00000000000028b0 <reiserfs_init_bitmap_cache>:
> 
>         return bh;
> }
> 
> int reiserfs_init_bitmap_cache(struct super_block *sb)
> {
>     28b0:       e8 00 00 00 00          callq  28b5 <reiserfs_init_bitmap_cache+0x5>

That looks to be the call to fentry, but without being resolved. What
we saw in the previous report wasn't 0xe8 but 0x14, and it was
unresolved after loading!

I'm surprised that the module built with a different
DEBUG_KOBJECT_RELEASE config would load. Does it not affect module
versions?

-- Steve

>     28b5:       55                      push   %rbp
> 
> /* Don't trust REISERFS_SB(sb)->s_bmap_nr, it's a u16
>  * which overflows on large file systems. */
> static inline __u32 reiserfs_bmap_count(struct super_block *sb)
> {
>         return (SB_BLOCK_COUNT(sb) - 1) / (sb->s_blocksize * 8) + 1;
>     28b6:       31 d2                   xor    %edx,%edx
>     28b8:       48 89 e5                mov    %rsp,%rbp
>     28bb:       41 54                   push   %r12
>     28bd:       53                      push   %rbx
>     28be:       48 89 fb                mov    %rdi,%rbx
>     28c1:       48 8b 87 50 07 00 00    mov    0x750(%rdi),%rax
>     28c8:       48 8b 77 18             mov    0x18(%rdi),%rsi
>     28cc:       48 8b 40 08             mov    0x8(%rax),%rax
>     28d0:       48 8d 0c f5 00 00 00    lea    0x0(,%rsi,8),%rcx
>     28d7:       00 
>     28d8:       8b 00                   mov    (%rax),%eax
>     28da:       83 e8 01                sub    $0x1,%eax
>     28dd:       48 f7 f1                div    %rcx

