Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaLCXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:25:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLCXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:25:26 -0500
Date: Wed, 3 Dec 2014 15:25:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, David Rientjes <rientjes@google.com>,
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
Message-Id: <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
In-Reply-To: <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
References: <547F0486.7020400@samsung.com>
	<1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014 15:41:21 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:

> 
> Use the 'unsigned long' type for 'zero' variable to fix this.
> Changing type to 'unsigned long' shouldn't affect any other users
> of this variable.
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  kernel/sysctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 15f2511..45c45c9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -120,7 +120,7 @@ static int sixty = 60;
>  
>  static int __maybe_unused neg_one = -1;
>  
> -static int zero;
> +static unsigned long zero;
>  static int __maybe_unused one = 1;
>  static int __maybe_unused two = 2;
>  static int __maybe_unused four = 4;

Yeah, this is ghastly.

Look at 

	{
		.procname	= "numa_balancing",
		.data		= NULL, /* filled in by handler */
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= sysctl_numa_balancing,
		.extra1		= &zero,
		.extra2		= &one,
	},

Now extra1 points at a long and extra2 points at an int. 
sysctl_numa_balancing() calls proc_dointvec_minmax() and I think your
patch just broke big-endian 64-bit machines.  "sched_autogroup_enabled"
breaks as well.

These sysctl tables drove a big truck straight through the C type
system and enabled all sorts of nasty breakage.

So how do we fix it?  Maybe we could actually use the type system a bit
and do something like

union sysctl_payload {
	int i;
	unsigned long ul;
	...
};

static union zero_int = {
	.i = 0
};

static union zero_ulong = {
	.ul = 0
};

and change proc_dointvec_minmax() and a million other functions to take
`union sysctl_payload *' arguments.  But I haven't thought about it much.

Even for a minimal fix, someone should go through each and every
ctl_table and audit/fix the .extra1/.extra2 types/sizes.  And until
that's done I'm not inclined to apply anything, because at least the
current code appears to work a bit.
