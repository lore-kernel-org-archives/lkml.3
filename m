Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaDEOnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 10:43:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:23359 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbaDEOnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 10:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,800,1389772800"; 
   d="scan'208";a="515025338"
Date: Sat, 5 Apr 2014 10:43:37 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Optimising IS_ERR_OR_NULL
Message-ID: <20140405144337.GA5727@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(4 days too late for April Fools ... oh well :-)

I don't like the look of IS_ERR_OR_NULL.  It does two tests when (due to
the bit patterns used to represent errors and NULL pointers) it could
use just one:

#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)

static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
{
	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
}

It needs some performance testing to be sure that it's a win, but I'm
essentially suggesting this:

+++ b/include/linux/err.h
@@ -34,10 +34,8 @@ static inline long __must_check IS_ERR(__force const void *pt
        return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
-{
-       return !ptr || IS_ERR_VALUE((unsigned long)ptr);
-}
+#define IS_ERR_OR_NULL(ptr) \
+       unlikely(((unsigned long)PTR_ERR(ptr) + MAX_ERRNO) <= MAX_ERRNO)
 
 /**
  * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type

(deliberately whitespace-damaged to ensure it doesn't get applied
without thought).

Comments, before I go off and run some perf tests?

Here's how I got to this point:

Let's take kern_unmount() as our example caller (for no particular reason
... first one I came across.  It is blessedly short though):

void kern_unmount(struct vfsmount *mnt)
{
        /* release long term mount so mount point can be released */
        if (!IS_ERR_OR_NULL(mnt)) {
                real_mount(mnt)->mnt_ns = NULL;
                synchronize_rcu();      /* yecchhh... */
                mntput(mnt);
        }
}

Here's the assembly for it:

0000000000001180 <kern_unmount>:
    1180:       48 85 ff                test   %rdi,%rdi
    1183:       53                      push   %rbx
    1184:       48 89 fb                mov    %rdi,%rbx
    1187:       74 27                   je     11b0 <kern_unmount+0x30>
    1189:       48 81 ff 00 f0 ff ff    cmp    $0xfffffffffffff000,%rdi
    1190:       77 1e                   ja     11b0 <kern_unmount+0x30>
    1192:       48 c7 87 c0 00 00 00    movq   $0x0,0xc0(%rdi)
    1199:       00 00 00 00 
    119d:       e8 00 00 00 00          callq  11a2 <kern_unmount+0x22>
                        119e: R_X86_64_PC32     synchronize_sched-0x4
    11a2:       48 89 df                mov    %rbx,%rdi
    11a5:       5b                      pop    %rbx
    11a6:       e9 00 00 00 00          jmpq   11ab <kern_unmount+0x2b>
                        11a7: R_X86_64_PC32     mntput-0x4
    11ab:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
    11b0:       5b                      pop    %rbx
    11b1:       c3                      retq   
    11b2:       66 66 66 66 66 2e 0f    data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
    11b9:       1f 84 00 00 00 00 00 

So we do two tests and jumps; first at 1180 and then at 1189, in either
case we jump forward to the end.  Now here's what happens when we optimise
IS_ERR_OR_NULL to make use of the fact that 0 is actually contiguous
with the range of errors:

 static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
-       return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+       return ((unsigned long)ptr + MAX_ERRNO) <= MAX_ERRNO;
 }

0000000000001180 <kern_unmount>:
    1180:       48 8d 87 ff 0f 00 00    lea    0xfff(%rdi),%rax
    1187:       48 3d ff 0f 00 00       cmp    $0xfff,%rax
    118d:       77 09                   ja     1198 <kern_unmount+0x18>
    118f:       f3 c3                   repz retq 
    1191:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
    1198:       48 83 ec 08             sub    $0x8,%rsp
    119c:       48 c7 87 c0 00 00 00    movq   $0x0,0xc0(%rdi)
    11a3:       00 00 00 00 
    11a7:       48 89 3c 24             mov    %rdi,(%rsp)
    11ab:       e8 00 00 00 00          callq  11b0 <kern_unmount+0x30>
                        11ac: R_X86_64_PC32     synchronize_sched-0x4
    11b0:       48 8b 3c 24             mov    (%rsp),%rdi
    11b4:       48 83 c4 08             add    $0x8,%rsp
    11b8:       e9 00 00 00 00          jmpq   11bd <kern_unmount+0x3d>
                        11b9: R_X86_64_PC32     mntput-0x4
    11bd:       0f 1f 00                nopl   (%rax)

It's fewer instructions, and only one compare, which is nice.  But gcc
now thinks that IS_ERR_OR_NULL is the likely case and has an early return
embedded in the function (118f).  So let's quickly fix that up:

-       if (!IS_ERR_OR_NULL(mnt)) {
+       if (!unlikely(IS_ERR_OR_NULL(mnt))) {

0000000000001180 <kern_unmount>:
    1180:       48 8d 87 ff 0f 00 00    lea    0xfff(%rdi),%rax
    1187:       53                      push   %rbx
    1188:       48 89 fb                mov    %rdi,%rbx
    118b:       48 3d ff 0f 00 00       cmp    $0xfff,%rax
    1191:       76 19                   jbe    11ac <kern_unmount+0x2c>
    1193:       48 c7 87 c0 00 00 00    movq   $0x0,0xc0(%rdi)
    119a:       00 00 00 00 
    119e:       e8 00 00 00 00          callq  11a3 <kern_unmount+0x23>
                        119f: R_X86_64_PC32     synchronize_sched-0x4
    11a3:       48 89 df                mov    %rbx,%rdi
    11a6:       5b                      pop    %rbx
    11a7:       e9 00 00 00 00          jmpq   11ac <kern_unmount+0x2c>
                        11a8: R_X86_64_PC32     mntput-0x4
    11ac:       5b                      pop    %rbx
    11ad:       c3                      retq   
    11ae:       66 90                   xchg   %ax,%ax

Now that's a genuine improvement; we saved one instruction (lea, cmp,
jbe vs test, je, cmp, ja), and due to various alignment / padding / etc.
we ended up saving 4 bytes on the length of the function which turns
into 16 bytes due to function alignment.

