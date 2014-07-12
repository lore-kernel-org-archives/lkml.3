Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaGLXfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:35:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:42773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaGLXfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:35:17 -0400
Message-ID: <1405208082.20996.54.camel@pasglop>
Subject: Re: bit fields && data tearing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Dan <opendtv@yahoo.com>
Date: Sun, 13 Jul 2014 09:34:42 +1000
In-Reply-To: <20140712205130.GA16437@redhat.com>
References: <20140712181328.GA8738@redhat.com>
	 <20140712205130.GA16437@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 22:51 +0200, Oleg Nesterov wrote:
> OK, looks like this is compiler bug,
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52080
> 
> Thanks to Dan who informed me privately.

So yes, there's is this compiler bug which means a bitfield
access can cause a r-m-w access to a neighbouring field but
in general, I would be weary of bitfields anyway since accessing
them isn't going to be atomic anyway... it's too easy to get things
wrong and in most cases the benefit is yet to be demonstrated.

In your example, I don't see the point of the bitfield.

Cheers,
Ben.

> On 07/12, Oleg Nesterov wrote:
> >
> > Hello,
> >
> > I am not sure I should ask here, but since Documentation/memory-barriers.txt
> > mentions load/store tearing perhaps my question is not completely off-topic...
> >
> > I am fighting with mysterious RHEL bug, it can be reproduced on ppc and s390
> > but not on x86. Finally I seem to understand the problem, and I even wrote the
> > stupid kernel module to ensure, see it below at the end.
> >
> > It triggers the problem immediately, kt_2() sees the wrong value in freeze_stop.
> > (If I turn ->freeze_stop int "long", the problem goes away).
> >
> > So the question is: is this gcc bug or the code below is buggy?
> >
> > If it is buggy, then probably memory-barriers.txt could mention that you should
> > be carefull with bit fields, even ACCESS_ONCE() obviously can't help.
> >
> > Or this just discloses my ignorance and you need at least aligned(long) after a
> > bit field to be thread-safe ? I thought that compiler should take care and add
> > the necessary alignment if (say) CPU can't update a single byte/uint.
> >
> > gcc version 4.4.7 20120313 (Red Hat 4.4.7-9) (GCC). Asm:
> >
> > 	0000000000000000 <.kt_2>:
> > 	   0:	7c 08 02 a6 	mflr    r0
> > 	   4:	fb 81 ff e0 	std     r28,-32(r1)
> > 	   8:	fb a1 ff e8 	std     r29,-24(r1)
> > 	   c:	fb c1 ff f0 	std     r30,-16(r1)
> > 	  10:	fb e1 ff f8 	std     r31,-8(r1)
> > 	  14:	eb c2 00 00 	ld      r30,0(r2)
> > 	  18:	f8 01 00 10 	std     r0,16(r1)
> > 	  1c:	f8 21 ff 71 	stdu    r1,-144(r1)
> > 	  20:	7c 7d 1b 78 	mr      r29,r3
> > 	  24:	3b e0 00 00 	li      r31,0
> > 	  28:	78 3c 04 64 	rldicr  r28,r1,0,49
> > 	  2c:	3b 9c 00 80 	addi    r28,r28,128
> > 	  30:	48 00 00 2c 	b       5c <.kt_2+0x5c>
> > 	  34:	60 00 00 00 	nop
> > 	  38:	60 00 00 00 	nop
> > 	  3c:	60 00 00 00 	nop
> > 	  40:	93 fd 00 04 	stw     r31,4(r29)
> > 	  44:	e8 9d 00 06 	lwa     r4,4(r29)
> > 	  48:	7f 84 f8 00 	cmpw    cr7,r4,r31
> > 	  4c:	40 de 00 4c 	bne-    cr7,98 <.kt_2+0x98>
> > 	  50:	e8 1c 00 00 	ld      r0,0(r28)
> > 	  54:	78 09 f7 e3 	rldicl. r9,r0,62,63
> > 	  58:	40 c2 00 54 	bne-    ac <.kt_2+0xac>
> > 	  5c:	48 00 00 01 	bl      5c <.kt_2+0x5c>
> > 	  60:	60 00 00 00 	nop
> > 	  64:	3b ff 00 01 	addi    r31,r31,1
> > 	  68:	2f a3 00 00 	cmpdi   cr7,r3,0
> > 	  6c:	7f ff 07 b4 	extsw   r31,r31
> > 	  70:	41 9e ff d0 	beq+    cr7,40 <.kt_2+0x40>
> > 	  74:	38 21 00 90 	addi    r1,r1,144
> > 	  78:	38 60 00 00 	li      r3,0
> > 	  7c:	e8 01 00 10 	ld      r0,16(r1)
> > 	  80:	eb 81 ff e0 	ld      r28,-32(r1)
> > 	  84:	eb a1 ff e8 	ld      r29,-24(r1)
> > 	  88:	eb c1 ff f0 	ld      r30,-16(r1)
> > 	  8c:	eb e1 ff f8 	ld      r31,-8(r1)
> > 	  90:	7c 08 03 a6 	mtlr    r0
> > 	  94:	4e 80 00 20 	blr
> > 	  98:	e8 7e 80 28 	ld      r3,-32728(r30)
> > 	  9c:	7f e5 fb 78 	mr      r5,r31
> > 	  a0:	48 00 00 01 	bl      a0 <.kt_2+0xa0>
> > 	  a4:	60 00 00 00 	nop
> > 	  a8:	4b ff ff a8 	b       50 <.kt_2+0x50>
> > 	  ac:	48 00 00 01 	bl      ac <.kt_2+0xac>
> > 	  b0:	60 00 00 00 	nop
> > 	  b4:	4b ff ff a8 	b       5c <.kt_2+0x5c>
> > 	  b8:	60 00 00 00 	nop
> > 	  bc:	60 00 00 00 	nop
> >
> > 	00000000000000c0 <.kt_1>:
> > 	  c0:	7c 08 02 a6 	mflr    r0
> > 	  c4:	fb 81 ff e0 	std     r28,-32(r1)
> > 	  c8:	fb a1 ff e8 	std     r29,-24(r1)
> > 	  cc:	fb c1 ff f0 	std     r30,-16(r1)
> > 	  d0:	fb e1 ff f8 	std     r31,-8(r1)
> > 	  d4:	eb c2 00 00 	ld      r30,0(r2)
> > 	  d8:	f8 01 00 10 	std     r0,16(r1)
> > 	  dc:	f8 21 ff 71 	stdu    r1,-144(r1)
> > 	  e0:	7c 7d 1b 78 	mr      r29,r3
> > 	  e4:	3b e0 00 00 	li      r31,0
> > 	  e8:	78 3c 04 64 	rldicr  r28,r1,0,49
> > 	  ec:	3b 9c 00 80 	addi    r28,r28,128
> > 	  f0:	48 00 00 38 	b       128 <.kt_1+0x68>
> > 	  f4:	60 00 00 00 	nop
> > 	  f8:	60 00 00 00 	nop
> > 	  fc:	60 00 00 00 	nop
> > 	 100:	e8 1d 00 00 	ld      r0,0(r29)
> > 	 104:	79 20 e8 0e 	rldimi  r0,r9,61,0
> > 	 108:	f8 1d 00 00 	std     r0,0(r29)
> > 	 10c:	80 1d 00 00 	lwz     r0,0(r29)
> > 	 110:	54 00 1f 7e 	rlwinm  r0,r0,3,29,31
> > 	 114:	7f 80 f8 00 	cmpw    cr7,r0,r31
> > 	 118:	40 de 00 6c 	bne-    cr7,184 <.kt_1+0xc4>
> > 	 11c:	e8 1c 00 00 	ld      r0,0(r28)
> > 	 120:	78 09 f7 e3 	rldicl. r9,r0,62,63
> > 	 124:	40 c2 00 70 	bne-    194 <.kt_1+0xd4>
> > 	 128:	48 00 00 01 	bl      128 <.kt_1+0x68>
> > 	 12c:	60 00 00 00 	nop
> > 	 130:	3b ff 00 01 	addi    r31,r31,1
> > 	 134:	2f a3 00 00 	cmpdi   cr7,r3,0
> > 	 138:	7f ff 07 b4 	extsw   r31,r31
> > 	 13c:	2f 1f 00 07 	cmpwi   cr6,r31,7
> > 	 140:	7b e9 07 60 	clrldi  r9,r31,61
> > 	 144:	40 9e 00 1c 	bne-    cr7,160 <.kt_1+0xa0>
> > 	 148:	40 9a ff b8 	bne+    cr6,100 <.kt_1+0x40>
> > 	 14c:	39 20 00 00 	li      r9,0
> > 	 150:	3b e0 00 00 	li      r31,0
> > 	 154:	4b ff ff ac 	b       100 <.kt_1+0x40>
> > 	 158:	60 00 00 00 	nop
> > 	 15c:	60 00 00 00 	nop
> > 	 160:	38 21 00 90 	addi    r1,r1,144
> > 	 164:	38 60 00 00 	li      r3,0
> > 	 168:	e8 01 00 10 	ld      r0,16(r1)
> > 	 16c:	eb 81 ff e0 	ld      r28,-32(r1)
> > 	 170:	eb a1 ff e8 	ld      r29,-24(r1)
> > 	 174:	eb c1 ff f0 	ld      r30,-16(r1)
> > 	 178:	eb e1 ff f8 	ld      r31,-8(r1)
> > 	 17c:	7c 08 03 a6 	mtlr    r0
> > 	 180:	4e 80 00 20 	blr
> > 	 184:	e8 7e 80 30 	ld      r3,-32720(r30)
> > 	 188:	48 00 00 01 	bl      188 <.kt_1+0xc8>
> > 	 18c:	60 00 00 00 	nop
> > 	 190:	4b ff ff 8c 	b       11c <.kt_1+0x5c>
> > 	 194:	48 00 00 01 	bl      194 <.kt_1+0xd4>
> > 	 198:	60 00 00 00 	nop
> > 	 19c:	4b ff ff 8c 	b       128 <.kt_1+0x68>
> >
> > Unfortunately it tells me nothing, I do not know ppc.
> >
> > Oleg.
> >
> > --------------------------------------------------------------------------------
> > #include <linux/module.h>
> > #include <linux/kernel.h>
> > #include <linux/kthread.h>
> >
> > struct utrace {
> > 	unsigned int resume:3;
> > 	int freeze_stop;
> > };
> >
> > static int kt_1(void *arg)
> > {
> > 	struct utrace *u = arg;
> > 	int r = 0;
> >
> > 	while (!kthread_should_stop()) {
> > 		if (++r == 7)
> > 			r = 0;
> >
> > 		u->resume = r;
> > 		barrier();
> > 		if (u->resume != r)
> > 			printk(KERN_CRIT "BUG! bitfield\n");
> >
> > 		if (need_resched())
> > 			schedule();
> > 	}
> >
> > 	return 0;
> > }
> >
> > static int kt_2(void *arg)
> > {
> > 	struct utrace *u = arg;
> > 	int f = 0;
> >
> > 	while (!kthread_should_stop()) {
> > 		u->freeze_stop = ++f;
> > 		barrier();
> > 		if (u->freeze_stop != f)
> > 			printk(KERN_CRIT "BUG! freeze_stop %d != %d\n", u->freeze_stop, f);
> >
> > 		if (need_resched())
> > 			schedule();
> > 	}
> >
> > 	return 0;
> > }
> >
> > static struct task_struct *t_1, *t_2;
> >
> > static struct utrace utrace;
> >
> > static int __init mod_init(void)
> > {
> > 	WARN_ON(IS_ERR(t_1 = kthread_run(kt_1, &utrace, "kt_1")));
> > 	WARN_ON(IS_ERR(t_2 = kthread_run(kt_2, &utrace, "kt_2")));
> >
> > 	return 0;
> > }
> >
> > static void __exit mod_exit(void)
> > {
> > 	kthread_stop(t_1);
> > 	kthread_stop(t_2);
> > }
> >
> > MODULE_LICENSE("GPL");
> > module_init(mod_init);
> > module_exit(mod_exit);


