Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbaFIPY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:24:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58657 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbaFIPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:24:23 -0400
Date: Mon, 9 Jun 2014 08:24:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikael Pettersson <mikpelinux@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: rcu alignment warning tripping on m68k
Message-ID: <20140609152415.GA4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <538696A0.5090601@uclinux.org>
 <20140529141151.21ed6f95@alan.etchedpixels.co.uk>
 <5387DF05.1020103@uclinux.org>
 <20140606184605.GT4581@linux.vnet.ibm.com>
 <21395.4324.692609.399604@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21395.4324.692609.399604@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060915-1542-0000-0000-000002712198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 03:17:24PM +0200, Mikael Pettersson wrote:
> Paul E. McKenney writes:
>  > On Fri, May 30, 2014 at 11:29:41AM +1000, Greg Ungerer wrote:
>  > > On 29/05/14 23:11, One Thousand Gnomes wrote:
>  > > > On Thu, 29 May 2014 12:08:32 +1000
>  > > > Greg Ungerer <gerg@uclinux.org> wrote:
>  > > > 
>  > > >> Hi All,
>  > > >>
>  > > >> Inside kernel/rcy/tree.c in __call_rcu() it does an alignment check on
>  > > >> the head pointer passed in. This trips on m68k systems, because they only
>  > > >> need alignment of 32bit quantities to 16bit boundaries.
>  > > > 
>  > > > __alignof perhaps ?
>  > > 
>  > > That might do. Change then becomes something like:
>  > > 
>  > > --- a/kernel/rcu/tree.c
>  > > +++ b/kernel/rcu/tree.c
>  > > @@ -2467,7 +2467,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_
>  > >         unsigned long flags;
>  > >         struct rcu_data *rdp;
>  > > 
>  > > -       WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
>  > > +       WARN_ON_ONCE((unsigned long)head & (__alignof__(head) - 1)); /* Misaligned rcu_head! */
>  > 
>  > Hmmm...  The purpose of the check is to reserve the low-order bits to
>  > allow RCU to classify callbacks as being time-critical or not.  RCU
>  > can probably live with a single bit, but if there is some architecture
>  > out there that simply refuses to do alignment, I need to know about it.
>  > 
>  > (See "git show 0bb7b59d6e2b8" for more info.)
>  > 
>  > So how about this instead?
>  > 
>  >  -       WARN_ON_ONCE((unsigned long)head & 0x1); /* Misaligned rcu_head! */
>  > 
>  > (Trying to remember if I have seen Linux kernel code that uses both
>  > the lower bits...)
> 
> As stated above, m68k-linux aligns to 16-bit boundaries by default, so you'd
> get one bit but not necessarily more.  If you want more free low bits, why
> not attach an explicit attribute aligned to the rcu_head type declaration?

One bit should do it for the time being, but yes, if I ever need two bits,
your suggestion of explicitly aligning the rcu_head type declaration
sounds like a very good one.

								Thanx, Paul

