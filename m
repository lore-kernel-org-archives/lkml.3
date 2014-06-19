Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbaFSRVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:21:49 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33999 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530AbaFSRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:21:48 -0400
Date: Thu, 19 Jun 2014 10:21:42 -0700
From: josh@joshtriplett.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bart Van Assche <bvanassche@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bug: Fix CONFIG_BUG=n BUG_ON()
Message-ID: <20140619172142.GA15696@cloud>
References: <53A2E573.6080407@acm.org>
 <5061693.b4BPIj9quA@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061693.b4BPIj9quA@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 07:00:14PM +0200, Arnd Bergmann wrote:
> On Thursday 19 June 2014 15:28:19 Bart Van Assche wrote:
> > Patch "bug: Make BUG() always stop the machine" changed the
> > behavior of BUG() with CONFIG_BUG=n from a no-op into an infinite
> > loop. Modify the definition of BUG_ON() accordingly such that the
> > behavior of BUG_ON(1) is identical to that of BUG().
> > 
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  include/asm-generic/bug.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > index 630dd23..f3241cd 100644
> > --- a/include/asm-generic/bug.h
> > +++ b/include/asm-generic/bug.h
> > @@ -142,7 +142,7 @@ extern void warn_slowpath_null(const char *file, const int line);
> >  #endif
> >  
> >  #ifndef HAVE_ARCH_BUG_ON
> > -#define BUG_ON(condition) do { if (condition) ; } while (0)
> > +#define BUG_ON(condition) do { } while (unlikely(condition))
> >  #endif
> >  
> >  #ifndef HAVE_ARCH_WARN_ON
> > 
> 
> How about making it 
> 
> 	do { if (condition) BUG(); } while (0)
> 
> That way it can be optimized for architectures that have their own
> BUG but not BUG_ON.

That's exactly what BUG_ON becomes if CONFIG_BUG=y, and that
significantly increases kernel size; if you want that, set CONFIG_BUG=y.
BUG_ON should continue to compile to nothing if CONFIG_BUG=n, or
CONFIG_BUG=n has no reason to exist.

- Josh Triplett
