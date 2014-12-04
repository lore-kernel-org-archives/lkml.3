Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaLDATV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:19:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLDATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:19:19 -0500
Date: Wed, 3 Dec 2014 16:19:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, aquini@redhat.com, davidlohr@hp.com,
        Joe Perches <joe@perches.com>, manfred@colorfullife.com,
        avagin@openvz.org, LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero'
 variable
Message-Id: <20141203161917.33350777442ce949fb8e98f4@linux-foundation.org>
In-Reply-To: <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
References: <547F0486.7020400@samsung.com>
	<1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
	<20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 15:25:24 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 03 Dec 2014 15:41:21 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> 
> > 
> > Use the 'unsigned long' type for 'zero' variable to fix this.
> > Changing type to 'unsigned long' shouldn't affect any other users
> > of this variable.
> > 
> > Reported-by: Dmitry Vyukov <dvyukov@google.com>
> > Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
> > Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> > ---
> >  kernel/sysctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 15f2511..45c45c9 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -120,7 +120,7 @@ static int sixty = 60;
> >  
> >  static int __maybe_unused neg_one = -1;
> >  
> > -static int zero;
> > +static unsigned long zero;
> >  static int __maybe_unused one = 1;
> >  static int __maybe_unused two = 2;
> >  static int __maybe_unused four = 4;
> 
> Yeah, this is ghastly.
> 
> Look at 
> 
> 	{
> 		.procname	= "numa_balancing",
> 		.data		= NULL, /* filled in by handler */
> 		.maxlen		= sizeof(unsigned int),
> 		.mode		= 0644,
> 		.proc_handler	= sysctl_numa_balancing,
> 		.extra1		= &zero,
> 		.extra2		= &one,
> 	},
> 
> Now extra1 points at a long and extra2 points at an int. 
> sysctl_numa_balancing() calls proc_dointvec_minmax() and I think your
> patch just broke big-endian 64-bit machines.  "sched_autogroup_enabled"
> breaks as well.

Taking another look at this...

numa_balancing will continue to work on big-endian because of course
zero is still zero when byteswapped.  But that's such a hack, isn't
documented and doesn't work for "one", "sixty", etc.

I'm thinking a better fix here is to switch hugetlb_sysctl_handler to
use `int's.  2^32 hugepages is enough for anybody.

hugetlb_overcommit_handler() will need conversion also.

Perhaps auditing all the proc_doulongvec_minmax callsites is the way to
attack this.
