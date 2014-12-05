Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaLEWuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:50:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaLEWuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:50:16 -0500
Date: Fri, 5 Dec 2014 14:50:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, aquini@redhat.com, davidlohr@hp.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero'
 variable
Message-Id: <20141205145014.2f8a076eb5ba15bd2f97dd36@linux-foundation.org>
In-Reply-To: <547FFB5D.8000503@colorfullife.com>
References: <547F0486.7020400@samsung.com>
	<1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
	<20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
	<547FFB5D.8000503@colorfullife.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2014 07:12:45 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:

> Hi Andrew,
> 
> On 12/04/2014 12:25 AM, Andrew Morton wrote:
> > On Wed, 03 Dec 2014 15:41:21 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> >
> >> Use the 'unsigned long' type for 'zero' variable to fix this.
> >> Changing type to 'unsigned long' shouldn't affect any other users
> >> of this variable.
> >>
> >> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> >> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
> >> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> >> ---
> >>   kernel/sysctl.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> >> index 15f2511..45c45c9 100644
> >> --- a/kernel/sysctl.c
> >> +++ b/kernel/sysctl.c
> >> @@ -120,7 +120,7 @@ static int sixty = 60;
> >>   
> >>   static int __maybe_unused neg_one = -1;
> >>   
> >> -static int zero;
> >> +static unsigned long zero;
> >>   static int __maybe_unused one = 1;
> >>   static int __maybe_unused two = 2;
> >>   static int __maybe_unused four = 4;
> > Yeah, this is ghastly.
> >
> > Look at
> >
> > 	{
> > 		.procname	= "numa_balancing",
> > 		.data		= NULL, /* filled in by handler */
> > 		.maxlen		= sizeof(unsigned int),
> > 		.mode		= 0644,
> > 		.proc_handler	= sysctl_numa_balancing,
> > 		.extra1		= &zero,
> > 		.extra2		= &one,
> > 	},
> >
> > Now extra1 points at a long and extra2 points at an int.
> > sysctl_numa_balancing() calls proc_dointvec_minmax() and I think your
> > patch just broke big-endian 64-bit machines.  "sched_autogroup_enabled"
> > breaks as well.
> What about getting rid of "extra1" and "extra2" as well and replace it 
> with "min" and "max"?
>
> I've attached an idea

Looks sane.
 
> > and change proc_dointvec_minmax() and a million other functions to take
> > `union sysctl_payload *' arguments.  But I haven't thought about it much.
> Another idea: why do we pass "int *" instead of "int"?
> 
> With "int", we could use
>      .int_min = 0;
>      .int_max = 1;

Presumably they were originally made void* so they could point at any
thing at all.  But I don't recall seeing extra1 and extra2 used for
anything other than bounds checking on a scalar.

Problem is, these things aren't always compile-time constants.  For
example, pid_max_min and pid_max_max are altered at runtime.

I doubt if we need to support both ints and longs in extra1/2 - longs
should be OK for range-checking int values.  The signed/unsigned issue
needs thinking about - there's a "neg_one" in there.  If we make
everything "long" then we might run into signedness/range issues for
sysctls which can have large unsigned values with the top bit set:
0x8000000-0xffffffff and 0x8000000000000000 - ...
