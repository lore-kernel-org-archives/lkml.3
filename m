Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaK0Sf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:35:27 -0500
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:56182 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750888AbaK0SfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:35:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:2:41:334:355:368:369:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4050:4119:4321:4385:4605:5007:6119:6238:6261:6691:6742:7576:7903:7904:7974:8531:8603:9391:10004:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740:13146:13230:13870:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: deer58_2eec50d399f01
X-Filterd-Recvd-Size: 8770
Message-ID: <1417113321.4305.1.camel@perches.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Nov 2014 10:35:21 -0800
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9FDA63@AcuExch.aculab.com>
References: <CAADnVQK3iui8cAmhi28=65p2CJbTu45fR98ri8Uh8xLRb=cwnA@mail.gmail.com>
	 <1417032059.16355.4.camel@perches.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1C9FDA63@AcuExch.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 12:25 +0000, David Laight wrote:
> From: Joe Perches
> > On Wed, 2014-11-26 at 10:34 -0800, Alexei Starovoitov wrote:
> > > On Wed, Nov 26, 2014 at 10:02 AM, Joe Perches <joe@perches.com> wrote:
> > > > On Wed, 2014-11-26 at 09:23 -0800, Alexei Starovoitov wrote:
> > > >> On Wed, Nov 26, 2014 at 8:58 AM, Joe Perches <joe@perches.com> wrote:
> > > >
> > > >> > Is there any value in reordering these tests for frequency
> > > >> > or maybe using | instead of || to avoid multiple jumps?
> > > >>
> > > >> probably not. It's not a critical path.
> > > >> compiler may fuse conditions depending on values anyway.
> > > >> If it was a critical path, we could have used
> > > >> (1 << reg) & mask trick.
> > > >> I picked explicit 'return true' else 'return false' here,
> > > >> because it felt easier to read. Just a matter of taste.
> > > >
> > > > There is a size difference though: (allyesconfig)
> > > >
> > > > $ size arch/x86/net/built-in.o*
> > > >    text    data     bss     dec     hex filename
> > > >   12999    1012    4336   18347    47ab arch/x86/net/built-in.o.new
> > > >   13177    1076    4592   18845    499d arch/x86/net/built-in.o.old
> > >
> > > interesting. Compiler obviously thinks that 178 byte increase
> > > with -O2 is the right trade off. Which I agree with :)
> > >
> > > If I think dropping 'inline' and using -Os will give bigger savings...
> > 
> > This was allyesconfig which already uses -Os
> > 
> > Using -O2, there is no difference using inline
> > or not, but the size delta with the bitmask is
> > much larger
> > 
> > $ size arch/x86/net/built-in.o* (allyesconfig, but not -Os)
> >    text	   data	    bss	    dec	    hex	filename
> >   13410	    820	   3624	  17854	   45be	arch/x86/net/built-in.o.new
> >   16130	    884	   4200	  21214	   52de	arch/x86/net/built-in.o.old
> >   16130	    884	   4200	  21214	   52de	arch/x86/net/built-in.o.static
> 
> That is quite a big % change in the code size.
> Why the change in data?

$ objdump -t arch/x86/net/bpf_jit_comp.o.new  > new
$ objdump -t arch/x86/net/bpf_jit_comp.o.old  > old
$ diff -urN old new
--- old	2014-11-27 10:31:36.654373756 -0800
+++ new	2014-11-27 10:31:31.254373453 -0800
@@ -1,5 +1,5 @@
 
-arch/x86/net/bpf_jit_comp.o.old:     file format elf64-x86-64
+arch/x86/net/bpf_jit_comp.o.new:     file format elf64-x86-64
 
 SYMBOL TABLE:
 0000000000000000 l    df *ABS*	0000000000000000 bpf_jit_comp.c
@@ -8,28 +8,26 @@
 0000000000000000 l    d  .bss	0000000000000000 .bss
 0000000000000000 l    d  .text.unlikely	0000000000000000 .text.unlikely
 0000000000000000 l     F .text	000000000000001f jit_fill_hole
-0000000000000098 l     O .bss	0000000000000008 __gcov0.jit_fill_hole
+0000000000000060 l     O .bss	0000000000000008 __gcov0.jit_fill_hole
 0000000000000000 l    d  .rodata.str1.1	0000000000000000 .rodata.str1.1
 0000000000000000 l    d  .rodata.str1.8	0000000000000000 .rodata.str1.8
-0000000000000020 l     F .text	00000000000030a2 do_jit
-00000000000000c0 l     O .bss	0000000000000b68 __gcov0.do_jit
+0000000000000020 l     F .text	000000000000260b do_jit
+0000000000000080 l     O .bss	0000000000000970 __gcov0.do_jit
 00000000000006e0 l     O .rodata	0000000000000034 reg2hex
 0000000000000000 l    d  .rodata	0000000000000000 .rodata
-0000000000000060 l     O .bss	0000000000000038 __gcov0.add_2mod
-0000000000000c28 l     O .bss	0000000000000008 __gcov0.bpf_jit_compile
-0000000000000c40 l     O .bss	00000000000003f0 __gcov0.bpf_int_jit_compile
+00000000000009f0 l     O .bss	0000000000000008 __gcov0.bpf_jit_compile
+0000000000000a00 l     O .bss	00000000000003f0 __gcov0.bpf_int_jit_compile
 0000000000000040 l     O .bss	0000000000000020 __gcov0.bpf_jit_dump
-0000000000001040 l     O .bss	0000000000000028 __gcov0.bpf_jit_free
+0000000000000e00 l     O .bss	0000000000000028 __gcov0.bpf_jit_free
 0000000000000010 l     O .bss	0000000000000018 __gcov0.bpf_prog_unlock_free
 0000000000000000 l    d  .text.startup	0000000000000000 .text.startup
 0000000000000000 l     F .text.startup	0000000000000012 _GLOBAL__sub_I_65535_0_bpf_jit_compile
 0000000000000000 l    d  .init_array	0000000000000000 .init_array
-0000000000000340 l     O .data	0000000000000028 __gcov_.bpf_jit_free
-0000000000000260 l     O .data	0000000000000028 __gcov_.bpf_int_jit_compile
-0000000000000220 l     O .data	0000000000000028 __gcov_.bpf_jit_compile
-00000000000001e0 l     O .data	0000000000000028 __gcov_.do_jit
-00000000000001a0 l     O .data	0000000000000028 __gcov_.jit_fill_hole
-0000000000000160 l     O .data	0000000000000028 __gcov_.add_2mod
+0000000000000300 l     O .data	0000000000000028 __gcov_.bpf_jit_free
+0000000000000220 l     O .data	0000000000000028 __gcov_.bpf_int_jit_compile
+00000000000001e0 l     O .data	0000000000000028 __gcov_.bpf_jit_compile
+00000000000001a0 l     O .data	0000000000000028 __gcov_.do_jit
+0000000000000160 l     O .data	0000000000000028 __gcov_.jit_fill_hole
 0000000000000120 l     O .data	0000000000000028 __gcov_.bpf_jit_dump
 00000000000000e0 l     O .data	0000000000000028 __gcov_.bpf_prog_unlock_free
 00000000000000a0 l     O .data	0000000000000028 __gcov_.__get_order
@@ -43,17 +41,17 @@
 0000000000000000         *UND*	0000000000000000 memset
 0000000000000000         *UND*	0000000000000000 sk_load_half
 0000000000000000         *UND*	0000000000000000 printk
+0000000000000000         *UND*	0000000000000000 sk_load_byte
+0000000000000000         *UND*	0000000000000000 sk_load_word
 0000000000000000         *UND*	0000000000000000 sk_load_half_positive_offset
 0000000000000000         *UND*	0000000000000000 sk_load_half_negative_offset
-0000000000000000         *UND*	0000000000000000 sk_load_word_positive_offset
-0000000000000000         *UND*	0000000000000000 sk_load_byte
 0000000000000000         *UND*	0000000000000000 sk_load_byte_positive_offset
 0000000000000000         *UND*	0000000000000000 sk_load_byte_negative_offset
-0000000000000000         *UND*	0000000000000000 sk_load_word
+0000000000000000         *UND*	0000000000000000 sk_load_word_positive_offset
 0000000000000000         *UND*	0000000000000000 __bpf_call_base
 0000000000000000         *UND*	0000000000000000 sk_load_word_negative_offset
-00000000000030d0 g     F .text	0000000000000013 bpf_jit_compile
-00000000000030f0 g     F .text	0000000000000352 bpf_int_jit_compile
+0000000000002630 g     F .text	0000000000000013 bpf_jit_compile
+0000000000002650 g     F .text	0000000000000352 bpf_int_jit_compile
 0000000000000000 g     O .data..read_mostly	0000000000000004 bpf_jit_enable
 0000000000000000         *UND*	0000000000000000 __kmalloc
 0000000000000000         *UND*	0000000000000000 bpf_jit_binary_alloc
@@ -62,7 +60,7 @@
 0000000000000000         *UND*	0000000000000000 set_memory_ro
 0000000000000000         *UND*	0000000000000000 kfree
 0000000000000000         *UND*	0000000000000000 bpf_jit_binary_free
-0000000000003450 g     F .text	000000000000008c bpf_jit_free
+00000000000029b0 g     F .text	000000000000008c bpf_jit_free
 0000000000000000         *UND*	0000000000000000 set_memory_rw
 0000000000000000         *UND*	0000000000000000 __bpf_prog_free
 0000000000000000         *UND*	0000000000000000 __gcov_init


