Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaFGNRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 09:17:31 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60261 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaFGNRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 09:17:30 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21395.4324.692609.399604@gargle.gargle.HOWL>
Date: Sat, 7 Jun 2014 15:17:24 +0200
To: paulmck@linux.vnet.ibm.com
Cc: Greg Ungerer <gerg@uclinux.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: rcu alignment warning tripping on m68k
In-Reply-To: <20140606184605.GT4581@linux.vnet.ibm.com>
References: <538696A0.5090601@uclinux.org>
	<20140529141151.21ed6f95@alan.etchedpixels.co.uk>
	<5387DF05.1020103@uclinux.org>
	<20140606184605.GT4581@linux.vnet.ibm.com>
X-Mailer: VM 8.1.2 under 24.2.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney writes:
 > On Fri, May 30, 2014 at 11:29:41AM +1000, Greg Ungerer wrote:
 > > On 29/05/14 23:11, One Thousand Gnomes wrote:
 > > > On Thu, 29 May 2014 12:08:32 +1000
 > > > Greg Ungerer <gerg@uclinux.org> wrote:
 > > > 
 > > >> Hi All,
 > > >>
 > > >> Inside kernel/rcy/tree.c in __call_rcu() it does an alignment check on
 > > >> the head pointer passed in. This trips on m68k systems, because they only
 > > >> need alignment of 32bit quantities to 16bit boundaries.
 > > > 
 > > > __alignof perhaps ?
 > > 
 > > That might do. Change then becomes something like:
 > > 
 > > --- a/kernel/rcu/tree.c
 > > +++ b/kernel/rcu/tree.c
 > > @@ -2467,7 +2467,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_
 > >         unsigned long flags;
 > >         struct rcu_data *rdp;
 > > 
 > > -       WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
 > > +       WARN_ON_ONCE((unsigned long)head & (__alignof__(head) - 1)); /* Misaligned rcu_head! */
 > 
 > Hmmm...  The purpose of the check is to reserve the low-order bits to
 > allow RCU to classify callbacks as being time-critical or not.  RCU
 > can probably live with a single bit, but if there is some architecture
 > out there that simply refuses to do alignment, I need to know about it.
 > 
 > (See "git show 0bb7b59d6e2b8" for more info.)
 > 
 > So how about this instead?
 > 
 >  -       WARN_ON_ONCE((unsigned long)head & 0x1); /* Misaligned rcu_head! */
 > 
 > (Trying to remember if I have seen Linux kernel code that uses both
 > the lower bits...)

As stated above, m68k-linux aligns to 16-bit boundaries by default, so you'd
get one bit but not necessarily more.  If you want more free low bits, why
not attach an explicit attribute aligned to the rcu_head type declaration?
