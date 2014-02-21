Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaBUUoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:44:18 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39893 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaBUUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:44:16 -0500
X-Originating-IP: 173.246.103.110
Date: Fri, 21 Feb 2014 12:44:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Jiri Slaby <jslaby@suse.cz>,
        Eric Paris <eparis@redhat.com>, Dwight Engen <dwight.engen@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs, kernel: Support disabling the uselib syscall
Message-ID: <20140221204144.GA3861@jtriplet-mobl1>
References: <20140221181103.GA5773@jtriplet-mobl1>
 <20140221121627.19e5d04dbba25984d4be8a15@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221121627.19e5d04dbba25984d4be8a15@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:16:27PM -0800, Andrew Morton wrote:
> On Fri, 21 Feb 2014 10:11:06 -0800 Josh Triplett <josh@joshtriplett.org> wrote:
> > uselib hasn't been used since libc5; glibc does not use it.  Support
> > turning it off.
> > 
> > When disabled, also omit the load_elf_library implementation from
> > binfmt_elf.c, which only uselib invokes.
> > 
> > bloat-o-meter:
> > add/remove: 0/4 grow/shrink: 0/1 up/down: 0/-785 (-785)
> > function                                     old     new   delta
> > padzero                                       39      36      -3
> > uselib_flags                                  20       -     -20
> > sys_uselib                                   168       -    -168
> > SyS_uselib                                   168       -    -168
> > load_elf_library                             426       -    -426
> > 
> 
> The patch disables CONFIG_USELIB by default.  This important decision
> should be mentioned and justified in the changelog, please.

Gah, that was not intentional.  Will fix in v2.  I did very
intentionally not make it require CONFIG_EXPERT or CONFIG_EMBEDDED,
since (like CONFIG_BINFMT_AOUT) almost everyone will want it disabled,
but I had intended to make it "default y".

> > +#ifdef CONFIG_USELIB
> 
> I wonder if CONFIG_SYS_USELIB would be a better identifier.  We haven't
> done anything consistent here.

As far as I can tell, there's no use of CONFIG_SYS_* or any other
consistent prefix for configuring out syscalls; all such symbols appear
unprefixed.  I think it would make sense to have a single common menu
and prefix for configuring out unused syscalls, but given the large
number of existing Kconfig options for that, I think that change ought
to occur as a separate patch series that isn't also trying to add a new
such option.

Perhaps Dave Hansen (CCed) might be interested in incorporating such a
change into his ongoing kconfig consolidation and reorganization?

- Josh Triplett
