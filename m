Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3LCVxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:53:43 -0500
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:34761 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755253Ab3LCVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:53:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3868:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sea52_59c4eca569d57
X-Filterd-Recvd-Size: 2652
Message-ID: <1386107616.30493.18.camel@joe-AO722>
Subject: Re: [PATCH 2/2] test: check copy_to/from_user boundary validation
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 03 Dec 2013 13:53:36 -0800
In-Reply-To: <1386106054-27636-3-git-send-email-keescook@chromium.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org>
	 <1386106054-27636-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 13:27 -0800, Kees Cook wrote:
> To help avoid an architecture failing to correctly check kernel/user
> boundaries when handling copy_to_user, copy_from_user, put_user, or
> get_user, perform some simple tests and fail to load if any of them
> behave unexpectedly.

> diff --git a/kernel/test_user_copy.c b/kernel/test_user_copy.c

> +#define failed(msg) {	\
> +	pr_warn(msg);	\
> +	ret = -EINVAL;	\
> +}

That's an ugly macro.

Maybe use something like:

#define test(func, msg)				\
({						\
	int ret = func;				\
	if (ret)				\
		pr_warn("%s\n", msg);		\
	ret;					\
})

> +static int __init test_user_copy_init(void)
> +{
> +	int ret = 0;
> +	char *kmem;
> +	char __user *usermem;
> +	unsigned long user_addr;
> +	unsigned long value = 0x5A;
> +
> +	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
> +	if (!kmem) {
> +		pr_warn("Failed to allocate kernel memory\n");

Unnecessary as there's a generic alloc OOM
with a dump_stack()

[]

> +	/* Legitimate usage: none of these should fail. */
> +	if (copy_from_user(kmem, usermem, PAGE_SIZE))
> +		failed("legitimate copy_from_user failed");

	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
		    "legitimate copy_from_user failed");

> +	if (copy_to_user(usermem, kmem, PAGE_SIZE))
> +		failed("legitimate copy_to_user failed");

	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
		    "legitimate copy_to_user failed");

etc.


