Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaEJMVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:21:43 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:40634 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaEJMVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:21:41 -0400
Date: Sat, 10 May 2014 08:21:38 -0400
From: Tejun Heo <tj@kernel.org>
To: George Spelvin <linux@horizon.com>
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
Message-ID: <20140510122138.GA4721@mtj.dyndns.org>
References: <20140313121032.GA9981@htj.dyndns.org>
 <20140510031356.22726.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510031356.22726.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 09, 2014 at 11:13:56PM -0400, George Spelvin wrote:
> +config GLOB
> +	tristate
> +#	(Prompt disabled to reduce kbuild clutter until someone needs it.)
> +#	prompt "glob_match() function"
> +	help
> +	  This option provides a glob_match function for performing simple
> +	  text pattern matching.  It is primarily used by the ATA code
> +	  to blacklist particular drive models, but other device drivers
> +	  may need similar functionality.
> +
> +	  All in-kernel drivers that require this function automatically
> +	  select this option.  Say N unless you are compiling an out-of
> +	  tree driver which tells you it depend on it.

Just adding glob.o to lib-y should be enough.  It will be excluded
from linking if unused.

> +#ifdef UNITTEST
> +/* To do a basic sanity test, "cc -DUNITTEST glob.c" and run a.out. */
> +
> +#include <stdbool.h>
> +#define __pure __attribute__((pure))
> +#define NOP(x)
> +#define EXPORT_SYMBOL NOP	/* Two stages to avoid checkpatch complaints */

These things tend to bitrot.  Let's please keep testing harness out of
tree.

> +#else
> +
> +#include <linux/module.h>
> +#include <linux/glob.h>
> +
> +MODULE_DESCRIPTION("glob(7) matching");
> +MODULE_LICENSE("Dual MIT/GPL");

Do we make library routines separate modules usually?

...
> +bool __pure
> +glob_match(char const *pat, char const *str)

The whole thing fits in a single 80 column line, right?

bool __pure glob_match(char const *pat, char const *str)

> +{
> +	/*
> +	 * Backtrack to previous * on mismatch and retry starting one
> +	 * character later in the string.  Because * matches all characters
> +	 * (no exception for /), it can be easily proved that there's
> +	 * never a need to backtrack multiple levels.
> +	 */
> +	char const *back_pat = 0, *back_str = back_str;

Blank line here.

I haven't delved into the actual implementation.  Looks sane on the
first glance.

> +#ifdef UNITTEST
> +
> +/* Test code */
> +#include <stdio.h>
> +#include <stdlib.h>
> +struct glob_test {
> +	char const *pat, *str;
> +	bool expected;
> +};
> +
> +static void
> +test(struct glob_test const *g)
> +{
> +	bool match = glob_match(g->pat, g->str);
> +
> +	printf("\"%s\" vs. \"%s\": %s %s\n", g->pat, g->str,
> +		match ? "match" : "mismatch",
> +		match == g->expected ? "OK" : "*** ERROR ***");
> +	if (match != g->expected)
> +		exit(1);
> +}
> +
> +static struct glob_test const tests[] = {
> +	{ "a", "a", true },
...
> +	{ "*ab*cd*", "abcabcabcabcefg", false }
> +};
> +
> +int
> +main(void)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < sizeof(tests)/sizeof(*tests); i++)
> +		test(tests + i);
> +
> +	return 0;
> +}
> +
> +#endif	/* UNITTEST */

Again, I don't really think the userland testing code belongs here.
If you wanna keep them, please make it in-kernel selftesting.  We
don't really wanna keep code which can't get built and tested in
kernel tree proper.

Thanks.

-- 
tejun
