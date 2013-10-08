Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3JHKdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:33:47 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50457 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3JHKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:33:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131004110356.42a2d268@gandalf.local.home>
References: <20130930143955.GF2425@suse.de>
	<20131004110356.42a2d268@gandalf.local.home>
Date: Tue, 8 Oct 2013 16:03:44 +0530
Message-ID: <CAC4Lta0V-GU83seotmNM3uyGEH=1R6e_DRYM1drazOLO+4P6Mw@mail.gmail.com>
Subject: Re: [REGRESSION] jump label safety checks break automatic numa balancing
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 8:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
CCing my IBM id
> >
> > Bisection identified this as the problem commit.
> >
> > 9c85f3bdf400665eecf62658a9106501f6a77a13 is the first bad commit
> > commit 9c85f3bdf400665eecf62658a9106501f6a77a13
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Thu Jan 26 18:38:07 2012 -0500
> >
> >     x86/jump-label: Add safety checks to jump label conversions
> >
> > I did no further investigation yet in case this is already a known
> > problem.
> >
>
> We had a similar bug with Xen like this. It ended up being that jump
> labels are used before they are initialized, and that is a real bug
> too, as the jump labels do not get converted until initialization, and
> why would something convert it before then?

Just FYI,

I also faced KVM hang with CONFIG_PARAVIRT_SPINLOCK=y that uses jump label

The bisection lead to:

# good: [8d7551eb1916832f2a5b27346edf24e7b2382f67] Merge tag
'cris-for-3.12' of git://jni.nu/cris
git bisect good 8d7551eb1916832f2a5b27346edf24e7b2382f67
# good: [fb40d7a8994a3cc7a1e1c1f3258ea8662a366916] x86/jump-label:
Show where and what was wrong on errors
git bisect good fb40d7a8994a3cc7a1e1c1f3258ea8662a366916
# good: [8876dd78d9f0cd317d55dc19e5cd17194af15b52] hwmon: (ina2xx)
Remove casting the return value which is a void pointer
git bisect good 8876dd78d9f0cd317d55dc19e5cd17194af15b52
# bad: [442e0973e9273ae8832abd70f52efde8b8326178] Merge branch
'x86/jumplabel' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 442e0973e9273ae8832abd70f52efde8b8326178

I got confirmed that reverting three hunks from the jump label merge
solved the problem.
Disabling jump label resulted in eventual halt of all the VCPUs when
we use paravirt spinlock.
But I think exact fix is to split kvm_guest_spinlock_init similar to
what Xen did.

I am testing the fix and will post that soon.
