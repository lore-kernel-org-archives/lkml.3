Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbaGXTqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:46:55 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35504 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934354AbaGXTqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:46:54 -0400
Date: Thu, 24 Jul 2014 23:46:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, keescook@chromium.org,
        tj@kernel.org, akpm@linux-foundation.org, avagin@openvz.org,
        ebiederm@xmission.com, hpa@zytor.com, serge.hallyn@canonical.com,
        xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [rfc 1/4] mm: Introduce may_adjust_brk helper
Message-ID: <20140724194651.GE17876@moon>
References: <20140724164657.452106845@openvz.org>
 <20140724165047.437075575@openvz.org>
 <20140724193225.GT26600@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724193225.GT26600@ubuntumail>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 07:32:25PM +0000, Serge Hallyn wrote:
> Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> > To eliminate code duplication lets introduce may_adjust_brk
> > helper which we will use in brk() and prctl() syscalls.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Andrew Vagin <avagin@openvz.org>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Vasiliy Kulikov <segoon@openwall.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> > Cc: Julien Tinnes <jln@google.com>
> > ---
> >  include/linux/mm.h |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > Index: linux-2.6.git/include/linux/mm.h
> > ===================================================================
> > --- linux-2.6.git.orig/include/linux/mm.h
> > +++ linux-2.6.git/include/linux/mm.h
> > @@ -18,6 +18,7 @@
> >  #include <linux/pfn.h>
> >  #include <linux/bit_spinlock.h>
> >  #include <linux/shrinker.h>
> > +#include <linux/resource.h>
> >  
> >  struct mempolicy;
> >  struct anon_vma;
> > @@ -1780,6 +1781,19 @@ extern struct vm_area_struct *copy_vma(s
> >  	bool *need_rmap_locks);
> >  extern void exit_mmap(struct mm_struct *);
> >  
> > +static inline int may_adjust_brk(unsigned long rlim,
> > +				 unsigned long new_brk,
> > +				 unsigned long start_brk,
> > +				 unsigned long end_data,
> > +				 unsigned long start_data)
> > +{
> > +	if (rlim < RLIMIT_DATA) {
> 
> In the code you're replacing, this was RLIM_INFINITY.  Did you really
> mean for this to be RLIMIT_DATA, aka 2?

Good catch, thanks Serge! Better would be to pass the type of resource
(as Kees suggested) here instead of @rlim itself and sure to compare
with RLIM_INFINITY.
