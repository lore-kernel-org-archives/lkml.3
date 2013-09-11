Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3IKTpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:45:06 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:43321 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754803Ab3IKTpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:45:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3865:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7514:7652:7875:7903:9025:9040:9388:10004:10848:11232:11257:11473:11658:11914:12043:12262:12296:12438:12517:12519:12555:12663:12679:12700:12737:12740:12926:13019:13161:13229,0,RBL:none,CacheIP
X-HE-Tag: waves67_6607c80bddf61
X-Filterd-Recvd-Size: 5377
Message-ID: <1378928700.4714.17.camel@joe-AO722>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>
Date: Wed, 11 Sep 2013 12:45:00 -0700
In-Reply-To: <CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
References: <20130911044116.GA17294@www.outflux.net>
	 <1378875632.606.5.camel@joe-AO722>
	 <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
	 <20130911093118.GD25896@mwanda>
	 <CAGXu5j+H_RLwj9c6CKxMpaYeR9kS-qDnK+e1mOHHt9zh6vAm=w@mail.gmail.com>
	 <1378926562.4714.11.camel@joe-AO722>
	 <CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 12:25 -0700, Kees Cook wrote:
> On Wed, Sep 11, 2013 at 12:09 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2013-09-11 at 11:19 -0700, Kees Cook wrote:
> >> On Wed, Sep 11, 2013 at 2:31 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >> > On Tue, Sep 10, 2013 at 10:19:17PM -0700, Kees Cook wrote:
> >> >> In the former case, format characters will get processed by the
> >> >> sprintf logic. In the latter, they are printed as-is. In this specific
> >> >> case, if there was a way to inject strings like "ohai %n" into the
> >> >> msgbuf string, the former would actually attempt to resolve the %n. In
> >> >> the simple case, this could lead to Oopses, and in the unlucky case,
> >> >> it could allow arbitrary memory writing and execution control.
> >> >>
> >> >> http://en.wikipedia.org/wiki/Uncontrolled_format_string
> >> >
> >> > The kernel ignores %n so hopefully it can't actually write to memory.
> >>
> >> I wish! This is not the case, though. See FORMAT_TYPE_NRCHARS in
> >> lib/vsprintf.c's vsnprintf().
> >>
> >> $ git grep '%n' | wc -l
> >> 111
> >
> > Umm.
> >
> > See: lib/vsprintf.c
> >
> > /**
> >  * vsnprintf - Format a string and place it in a buffer
> > [...]
> >  * %n is ignored
> >
> > %n does work for vsscanf though.
> 
> The comment is a lie:
> 
>         int len = 0;
>         printk("len:%d\n", len);
>         printk("%s%n\n", "Ohai!", &len);
>         printk("len:%d\n", len);
> 
> [    0.025930] len:0
> [    0.026003] Ohai!
> [    0.026261] len:5
> 
> The functionality between scanf and printf was, I think, merged in
> 2009, if I'm reading the git blame correctly.

Yeah.

commit fef20d9c1380f04ba9492d6463148db07b413708
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Fri Mar 6 17:21:50 2009 +0100

    vsprintf: unify the format decoding layer for its 3 users

Maybe it should be reignored...

There are a few more in net/ though that may be pretty
easy to change to use the seq_printf return value.


net/ipv4/fib_trie.c-                            seq_printf(seq,
net/ipv4/fib_trie.c-                                     "%s\t%08X\t%08X\t%04X\t%d\t%u\t"
net/ipv4/fib_trie.c:                                     "%d\t%08X\t%d\t%u\t%u%n",
net/ipv4/fib_trie.c-                                     fi->fib_dev ? fi->fib_dev->name : "*",
--
net/ipv4/fib_trie.c-                            seq_printf(seq,
net/ipv4/fib_trie.c-                                     "*\t%08X\t%08X\t%04X\t%d\t%u\t"
net/ipv4/fib_trie.c:                                     "%d\t%08X\t%d\t%u\t%u%n",
net/ipv4/fib_trie.c-                                     prefix, 0, flags, 0, 0, 0,
--
net/ipv4/ping.c-        seq_printf(f, "%5d: %08X:%04X %08X:%04X"
net/ipv4/ping.c:                " %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d%n",
net/ipv4/ping.c-                bucket, src, srcp, dest, destp, sp->sk_state,
--
net/ipv4/tcp_ipv4.c-    seq_printf(f, "%4d: %08X:%04X %08X:%04X"
net/ipv4/tcp_ipv4.c:            " %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK%n",
net/ipv4/tcp_ipv4.c-            i,
--
net/ipv4/tcp_ipv4.c-    seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
net/ipv4/tcp_ipv4.c:                    "%08X %5u %8d %lu %d %pK %lu %lu %u %u %d%n",
net/ipv4/tcp_ipv4.c-            i, src, srcp, dest, destp, sk->sk_state,
--
net/ipv4/tcp_ipv4.c-    seq_printf(f, "%4d: %08X:%04X %08X:%04X"
net/ipv4/tcp_ipv4.c:            " %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK%n",
net/ipv4/tcp_ipv4.c-            i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
--
net/ipv4/udp.c- seq_printf(f, "%5d: %08X:%04X %08X:%04X"
net/ipv4/udp.c:         " %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d%n",
net/ipv4/udp.c-         bucket, src, srcp, dest, destp, sp->sk_state,
--
net/sctp/objcnt.c:	seq_printf(seq, "%s: %d%n", sctp_dbg_objcnt[i].label,
net/sctp/objcnt.c-				atomic_read(sctp_dbg_objcnt[i].counter), &len);



