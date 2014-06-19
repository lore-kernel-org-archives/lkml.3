Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaFSPWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:22:39 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60704 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbaFSPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:22:37 -0400
X-Originating-IP: 50.43.32.211
Date: Thu, 19 Jun 2014 08:22:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bug: Fix CONFIG_BUG=n BUG_ON()
Message-ID: <20140619152228.GA16426@thin>
References: <53A2E573.6080407@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A2E573.6080407@acm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:28:19PM +0200, Bart Van Assche wrote:
> Patch "bug: Make BUG() always stop the machine" changed the
> behavior of BUG() with CONFIG_BUG=n from a no-op into an infinite
> loop. Modify the definition of BUG_ON() accordingly such that the
> behavior of BUG_ON(1) is identical to that of BUG().

No, this patch should not go in.  CONFIG_BUG=n exists for this exact
purpose; if you want BUG_ON to do something then use CONFIG_BUG=y with
BUGVERBOSE disabled instead.

Making BUG() stop the machine even with CONFIG_BUG=n eliminated a number
of compiler warnings about code that should be unreachable, and added
fairly little size to the kernel.  BUG_ON, on the other hand, occurs in
far more places, adds much more size if enabled, and tends to serve as
an assert of a condition; it makes perfect sense to allow compiling out
an assert, and compiling it out does not introduce any compiler
warnings.

What problem are you trying to solve here?  With this change,
CONFIG_BUG=n and CONFIG_BUG=y would become effectively equivalent.

Also:

> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -142,7 +142,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>  #endif
>  
>  #ifndef HAVE_ARCH_BUG_ON
> -#define BUG_ON(condition) do { if (condition) ; } while (0)
> +#define BUG_ON(condition) do { } while (unlikely(condition))

Even if making this change, it should not take this form, which would
evaluate the conditional repeatedly.  See the form used with
CONFIG_BUG=y (without HAVE_ARCH_BUG_ON), defined earlier in the same
file.

- Josh Triplett
