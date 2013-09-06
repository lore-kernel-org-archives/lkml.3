Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3IFD6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab3IFD6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:58:37 -0400
Date: Thu, 5 Sep 2013 23:58:27 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906035827.GA13446@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130906011924.GA7970@redhat.com>
 <20130905212834.605408a4@gandalf.local.home>
 <20130906013455.GA10073@redhat.com>
 <20130905214455.101c6347@gandalf.local.home>
 <20130906014859.GB10073@redhat.com>
 <20130905215154.74c55e9a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905215154.74c55e9a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:51:54PM -0400, Steven Rostedt wrote:
 > On Thu, 5 Sep 2013 21:48:59 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Thu, Sep 05, 2013 at 09:44:55PM -0400, Steven Rostedt wrote:
 > >  > On Thu, 5 Sep 2013 21:34:55 -0400
 > >  > Dave Jones <davej@redhat.com> wrote:
 > >  > 
 > >  > > On Thu, Sep 05, 2013 at 09:28:34PM -0400, Steven Rostedt wrote:
 > 
 > >  > Did you change a config option, or update your gcc?
 > > 
 > > Yeah, changed CONFIG_DEBUG_KOBJECT, which rebuilt the world.
 > 
 > Still doesn't explain why it gave you that splat there.
 > 
 > Do you still have that binary module, and can you show me what's at
 > reiserfs_init_bitmap_cache+0x0 with objdump?

I didn't, but it turns out I can recreate this. A little convoluted but..

disable DEBUG_KOBJECT_RELEASE
build, install and boot into kernel

enable DEBUG_KOBJECT_RELEASE
build kernel
install -> boom


00000000000028b0 <reiserfs_init_bitmap_cache>:

        return bh;
}

int reiserfs_init_bitmap_cache(struct super_block *sb)
{
    28b0:       e8 00 00 00 00          callq  28b5 <reiserfs_init_bitmap_cache+0x5>
    28b5:       55                      push   %rbp

/* Don't trust REISERFS_SB(sb)->s_bmap_nr, it's a u16
 * which overflows on large file systems. */
static inline __u32 reiserfs_bmap_count(struct super_block *sb)
{
        return (SB_BLOCK_COUNT(sb) - 1) / (sb->s_blocksize * 8) + 1;
    28b6:       31 d2                   xor    %edx,%edx
    28b8:       48 89 e5                mov    %rsp,%rbp
    28bb:       41 54                   push   %r12
    28bd:       53                      push   %rbx
    28be:       48 89 fb                mov    %rdi,%rbx
    28c1:       48 8b 87 50 07 00 00    mov    0x750(%rdi),%rax
    28c8:       48 8b 77 18             mov    0x18(%rdi),%rsi
    28cc:       48 8b 40 08             mov    0x8(%rax),%rax
    28d0:       48 8d 0c f5 00 00 00    lea    0x0(,%rsi,8),%rcx
    28d7:       00 
    28d8:       8b 00                   mov    (%rax),%eax
    28da:       83 e8 01                sub    $0x1,%eax
    28dd:       48 f7 f1                div    %rcx

