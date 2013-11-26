Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3KZApF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:45:05 -0500
Received: from peace.netnation.com ([204.174.223.2]:58558 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3KZAo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:44:59 -0500
Date: Mon, 25 Nov 2013 16:44:56 -0800
From: Simon Kirby <sim@hostway.ca>
To: Ian Applegate <ia@cloudflare.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20131126004456.GF19648@hostway.ca>
References: <20130706000949.GD16853@hostway.ca>
 <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
 <20130820040648.GG27005@ZenIV.linux.org.uk>
 <CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
 <20130820072143.GJ27005@ZenIV.linux.org.uk>
 <CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:51:11AM -0700, Ian Applegate wrote:

> Unfortunately no boxen with CONFIG_DEBUG_MUTEXES among them. I can
> enable on a few and should have some results within the day. These
> mainly serve (quite a bit of) HTTP/S cache traffic.
> 
> On Tue, Aug 20, 2013 at 12:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Aug 20, 2013 at 12:17:52AM -0700, Ian Applegate wrote:
> >> We are also seeing this or a similar issue. On a fairly widespread
> >> deployment of 3.10.1 & 3.10.6 this occurred fairly consistently on the
> >> order of 36 days (combined MTBF.)
> >
> > Do you have any boxen with CONFIG_DEBUG_MUTEXES among those?  What
> > kind of setup do you have on those, BTW?

Hmm. So, we went through a few months of running with Linus' suggested
culprit-catching patch w/DEBUG_PAGE_ALLOC, but it never tripped. We also
ran with DEBUG_MUTEXES, but that never seem to catch anything, either.

Ian, is it true that what you saw involved no btrfs? I was still guessing
this is related to btrfs, as we are only seeing this on boxes doing btrfs
rsync-snapshot backups. I don't know what else is interesting about our
workload there, since we're not doing anything exotic.

Meanwhille, with DEBUG_LIST on 3.12-rc, we found list corruption, which
Josef fixed in 93858769172c4e3678917810e9d5de360eb991cc. This missed
3.12, unfortunately, so I built a 3.12 with Josef's btrfs-next merged (to
54563d41a58be77e9bd9ef7af1ea4026cf0e7e07, which contained that fix).

I was hoping this or something else by 3.12 would have fixed it, so after
testing we deployed this everywhere and turned off the rest of the debug
options. I missed slub_debug on one server, though...and it just hit
another case of overwritten poison.

Is it true that with slub_debug, aliasing of equal-sized objects is
turned off, and so they shouldn't be immediately side-by-side? In other
words, would there be similar scrawling victim chances as allocating
pipe_inode_info with pages instead of slabs? "slabinfo -a" is empty.

[158037.526662] =============================================================================
[158037.528014] BUG kmalloc-192 (Not tainted): Poison overwritten
[158037.528014] -----------------------------------------------------------------------------
[158037.528014] 
[158037.528014] Disabling lock debugging due to kernel taint
[158037.528014] INFO: 0xffff88013af3da6c-0xffff88013af3da6c. First byte 0x6c instead of 0x6b
[158037.528014] INFO: Allocated in alloc_pipe_info+0x1f/0xb0 age=22 cpu=3 pid=26402
[158037.528014]         __slab_alloc.constprop.63+0x35b/0x3a0
[158037.528014]         kmem_cache_alloc_trace+0xab/0x110
[158037.528014]         alloc_pipe_info+0x1f/0xb0
[158037.528014]         create_pipe_files+0x41/0x1f0
[158037.528014]         __do_pipe_flags+0x3c/0xb0   
[158037.528014]         SyS_pipe2+0x1b/0xa0
[158037.528014]         SyS_pipe+0xb/0x10  
[158037.528014]         system_call_fastpath+0x16/0x1b
[158037.528014] INFO: Freed in free_pipe_info+0x6a/0x70 age=39 cpu=1 pid=26402
[158037.528014]         __slab_free+0x2d/0x2d4
[158037.528014]         kfree+0xfd/0x130
[158037.528014]         free_pipe_info+0x6a/0x70
[158037.528014]         pipe_release+0x94/0xf0  
[158037.528014]         __fput+0xa7/0x230
[158037.528014]         ____fput+0x9/0x10
[158037.528014]         task_work_run+0x97/0xd0
[158037.528014]         do_notify_resume+0x66/0x70
[158037.528014]         int_signal+0x12/0x17
[158037.528014] INFO: Slab 0xffffea0004ebcf00 objects=31 used=29 fp=0xffff88013af3e080 flags=0x8000000000004080
[158037.528014] INFO: Object 0xffff88013af3da68 @offset=6760 fp=0xffff88013af3ca28
[158037.528014] 
[158037.528014] Bytes b4 ffff88013af3da58: 97 b8 59 02 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ..Y.....ZZZZZZZZ
[158037.528014] Object ffff88013af3da68: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk  
[158037.528014] Object ffff88013af3da78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3da88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3da98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3daa8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3dab8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3dac8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3dad8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3dae8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3daf8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3db08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk  
[158037.528014] Object ffff88013af3db18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.  
[158037.528014] Redzone ffff88013af3db28: bb bb bb bb bb bb bb bb                          ........
[158037.528014] Padding ffff88013af3dc68: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[158037.528014] CPU: 3 PID: 26402 Comm: perl Tainted: G    B        3.12.0-hw+ #75
[158037.528014] Hardware name: Dell Inc. PowerEdge 1950/0UR033, BIOS 2.0.1 10/30/2007
[158037.528014]  ffff88013af3da68 ffff88012252fc98 ffffffff817f6c6e 0000000000000007 
[158037.528014]  ffff88042d804900 ffff88012252fcc8 ffffffff81135099 ffff88013af3da6d 
[158037.528014]  ffff88042d804900 000000000000006b ffff88013af3da68 ffff88012252fd18 
[158037.528014] Call Trace:
[158037.528014]  [<ffffffff817f6c6e>] dump_stack+0x46/0x58
[158037.528014]  [<ffffffff81135099>] print_trailer+0xf9/0x160
[158037.528014]  [<ffffffff81135232>] check_bytes_and_report+0xe2/0x120
[158037.528014]  [<ffffffff81135437>] check_object+0x1c7/0x240
[158037.528014]  [<ffffffff8114325f>] ? alloc_pipe_info+0x1f/0xb0
[158037.528014]  [<ffffffff817f2d0c>] alloc_debug_processing+0x153/0x168
[158037.528014]  [<ffffffff817f307c>] __slab_alloc.constprop.63+0x35b/0x3a0
[158037.528014]  [<ffffffff8114325f>] ? alloc_pipe_info+0x1f/0xb0
[158037.528014]  [<ffffffff811369ab>] kmem_cache_alloc_trace+0xab/0x110
[158037.528014]  [<ffffffff81152f2d>] ? inode_init_always+0xed/0x1b0   
[158037.528014]  [<ffffffff8114325f>] alloc_pipe_info+0x1f/0xb0
[158037.528014]  [<ffffffff81143781>] create_pipe_files+0x41/0x1f0
[158037.528014]  [<ffffffff8114396c>] __do_pipe_flags+0x3c/0xb0   
[158037.528014]  [<ffffffff8107808c>] ? task_work_run+0x9c/0xd0   
[158037.528014]  [<ffffffff81143a3b>] SyS_pipe2+0x1b/0xa0
[158037.528014]  [<ffffffff818045f0>] ? int_signal+0x12/0x17
[158037.528014]  [<ffffffff81143acb>] SyS_pipe+0xb/0x10
[158037.528014]  [<ffffffff818043b9>] system_call_fastpath+0x16/0x1b
[158037.528014] FIX kmalloc-192: Restoring 0xffff88013af3da6c-0xffff88013af3da6c=0x6b
[158037.528014] 
[158037.528014] FIX kmalloc-192: Marking all objects used

There was a crash from btrfs memcpy shortly after this, which may or may
not be related, followed by another poison overwritten. Writeback was
wedged at this point.

Full kernel log: http://0x.ca/sim/ref/3.12/dmesg
Other stuff: http://0x.ca/sim/ref/3.12/

Simon-
