Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaEKGCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 02:02:46 -0400
Received: from ns.horizon.com ([71.41.210.147]:40317 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757913AbaEKGCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 02:02:45 -0400
Date: 11 May 2014 02:02:39 -0400
Message-ID: <20140511060239.22063.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tj@kernel.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
In-Reply-To: <20140510122138.GA4721@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014 08:21:38 -0400, Tejun Heo wrote:
> On Fri, May 09, 2014 at 11:13:56PM -0400, George Spelvin wrote:
>> +config GLOB
>> +	tristate
>> +#	(Prompt disabled to reduce kbuild clutter until someone needs it.)
>> +#	prompt "glob_match() function"
>> +	help
>> +	  This option provides a glob_match function for performing simple
>> +	  text pattern matching.  It is primarily used by the ATA code
>> +	  to blacklist particular drive models, but other device drivers
>> +	  may need similar functionality.
>> +
>> +	  All in-kernel drivers that require this function automatically
>> +	  select this option.  Say N unless you are compiling an out-of
>> +	  tree driver which tells you it depend on it.

> Just adding glob.o to lib-y should be enough.  It will be excluded
> from linking if unused.

But, I just confirmed, it will also be excluded from linking if
CONFIG_ATA=m.  See for example commit b4d3ba3346f0 where some helpers
had to be moved from lib-y to obj-y to fix module load errors.
(Thanks to Randy Dunlap for this example.)

>> +#else
>> +
>> +#include <linux/module.h>
>> +#include <linux/glob.h>
>> +
>> +MODULE_DESCRIPTION("glob(7) matching");
>> +MODULE_LICENSE("Dual MIT/GPL");

> Do we make library routines separate modules usually?

There are basically three options I can see:
1) Make it non-configurable and always include the code in the kernel
   using oby-y, and just accept the wasted space if CONFIG_ATA=n
2) Make it a boolean option, so CONFIG_ATA=m will force CONFIG_GLOB=y and
   it will be included in the static kernel but unused until the module
   is loaded.
3) Make it a tristate option, which compiles into the kernel if
   CONFIG_ATA=y (the common case), and is its own module if CONFIG_ATA=m.
   An awful lot of the files in lib/ take this approach.

Do you have a preference?  Option 3 is the current status.

(Revised patch will come when I have the self-test converted.)
