Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaGFKE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 06:04:28 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42086 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGFKE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 06:04:26 -0400
Date: Sun, 6 Jul 2014 12:04:20 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: fs: use after free in /proc/pid/mountinfo
Message-ID: <20140706100420.GB3589@osiris>
References: <53B3F331.7090204@oracle.com>
 <53B4CAB8.5070407@oracle.com>
 <alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>
 <53B6C051.2060704@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B6C051.2060704@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070610-4966-0000-0000-0000009F9253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 10:55:13AM -0400, Sasha Levin wrote:
> On 07/03/2014 05:37 PM, David Rientjes wrote:
> > On Wed, 2 Jul 2014, Sasha Levin wrote:
> > 
> >>> Hi all,
> >>>
> >>> While fuzzing with trinity inside a KVM tools guest running the latest -next
> >>> kernel I've stumbled on the following spew:
> >>>
> >>> [ 3569.869749] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >>> [ 3569.869769] Dumping ftrace buffer:
> >>> [ 3569.869879]    (ftrace buffer empty)
> >>> [ 3569.869894] Modules linked in:
> >>> [ 3569.869900] CPU: 7 PID: 10239 Comm: trinity-c86 Tainted: G        W      3.16.0-rc3-next-20140701-sasha-00023-g4eb2544-dirty #759
> >>> [ 3569.869906] task: ffff88039e873000 ti: ffff880393f8c000 task.ti: ffff880393f8c000
> >>> [ 3569.869932] RIP: show_mountinfo (fs/proc_namespace.c:127)

So that would be this line then:

static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
{
	struct proc_mounts *p = proc_mounts(m);
	struct mount *r = real_mount(mnt);
	struct super_block *sb = mnt->mnt_sb;
	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt }; <---

if I understand the output correctly?

> >>> All code
> >>> ========
> >>>    0:	00 00                	add    %al,(%rax)
> >>>    2:	00 00                	add    %al,(%rax)
> >>>    4:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
> >>>    9:	55                   	push   %rbp
> >>>    a:	48 89 e5             	mov    %rsp,%rbp
> >>>    d:	48 83 ec 50          	sub    $0x50,%rsp
> >>>   11:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
> >>>   15:	48 89 f3             	mov    %rsi,%rbx
> >>>   18:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
> >>>   1c:	49 89 fc             	mov    %rdi,%r12
> >>>   1f:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
> >>>   23:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
> >>>   27:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
> >>>   2b:*	48 8b 06             	mov    (%rsi),%rax		<-- trapping instruction
> >>>   2e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
> >>>   32:	4c 8b 76 08          	mov    0x8(%rsi),%r14
> >>>   36:	8b 96 ec 00 00 00    	mov    0xec(%rsi),%edx
> >>>   3c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

Does that fit to this asm code? Sorry.. I'm not very familar with x86 asm.

> > Does this now reproduce on Linus's tree?  If so, does reverting commit
> > 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") prevent this 
> > issue?
> > 
> > This is a use-after-free since the poison value is 0x6b and I'm presuming 
> > that your /proc/self/mountinfo may be larger than PAGE_SIZE in your 
> > testing environment.
> 
> Good call, reverting that patch made both issues go away.

Ok, does that mean you have a test case so you can reproduce the crashes?
Just wondering, since trinity is usually quite random in what it does.

I tried to reproduce a crash on one of my systems by enforcing several
seq_files to grow beyond PAGE_SIZE, but couldn't reproduce anything yet.

Could you try the patch below please? It basically reverts my patch and
just leaves the kfree->kvfree conversion in. This is just a shot in the
dark, since I can't make any sense of this ...yet :)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3857b720cb1b..c1cf494cc238 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -34,12 +34,7 @@ static void seq_set_overflow(struct seq_file *m)
 
 static void *seq_buf_alloc(unsigned long size)
 {
-	void *buf;
-
-	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (!buf && size > PAGE_SIZE)
-		buf = vmalloc(size);
-	return buf;
+	return kmalloc(size, GFP_KERNEL);
 }
 
 /**

