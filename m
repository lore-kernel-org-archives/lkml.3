Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaANPmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:42:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36337 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:41:58 -0500
Date: Tue, 14 Jan 2014 16:41:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
Message-ID: <20140114154142.GG7572@laptop.programming.kicks-ass.net>
References: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au>
 <20140114125153.GY7572@laptop.programming.kicks-ass.net>
 <52D55479.9010802@zytor.com>
 <CAMuHMdUt2jCVLHr9mbV8JVnY4+vv5vEKNfk1=FoSnZ+nx6qhNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUt2jCVLHr9mbV8JVnY4+vv5vEKNfk1=FoSnZ+nx6qhNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:20:36PM +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 14, 2014 at 4:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 01/14/2014 04:51 AM, Peter Zijlstra wrote:
> >> On Tue, Jan 14, 2014 at 03:53:31PM +1100, Stephen Rothwell wrote:
> >>> Hi Andrew,
> >>>
> >>> Today's linux-next merge of the akpm-current tree got a conflict in
> >>> kernel/futex.c between commit a52b89ebb6d4 ("futexes: Increase hash table
> >>> size for better performance") from the tip tree and commit 61beee6c76e5
> >>> ("futex: switch to USER_DS for futex test") from the akpm-current tree.
> >>>
> >>> @@@ -2869,10 -2748,13 +2871,13 @@@
> >>>       * implementation, the non-functional ones will return
> >>>       * -ENOSYS.
> >>>       */
> >>> +    fs = get_fs();
> >>> +    set_fs(USER_DS);
> >>>      if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
> >>>              futex_cmpxchg_enabled = 1;
> >>> +    set_fs(fs);
> >>>
> >>
> >> This seems terribly broken, the *futex_value*() ops should not need
> >> that; they are supposed to access userspace without any of that.
> >
> > I am *guessing* that m68k is has get_fs() == KERNEL_DS at the point that
> > futex_init() is called.  This would seem a bit of a peculiarity to m68k,
> > and as such it would seem like it would be better for it to belong in
> > the m68k-specific code, but since futex_init() is init code and only
> > called once anyway it shouldn't cause any harm...
> 
> Yes it does. So when getting the exception on 68030, we notice it's a kernel
> space access error, not a user space access error, and crash.

Is there a good reason m68k works like this? That is, shouldn't we fix
the arch code instead of littering the generic code with weirdness like
this?
