Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaAUVPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:15:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:12127 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaAUVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:15:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="470332464"
Message-ID: <52DEE374.7040908@intel.com>
Date: Tue, 21 Jan 2014 13:15:32 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peng Tao <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com> <20140117143329.GA6877@kroah.com> <20140117145128.GR7444@mwanda> <20140117151735.GB16623@kroah.com> <CF037522.8B804%andreas.dilger@intel.com>
In-Reply-To: <CF037522.8B804%andreas.dilger@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 12:02 PM, Dilger, Andreas wrote:
> The Lustre allocation macros track the memory usage across the whole
> filesystem,
> not just of a single structure that a mempool/slab/whatever would do.
> This is
> useful to know for debugging purposes (e.g. user complains about not having
> enough RAM for their highly-tuned application, or to check for leaks at
> unmount).

Urg, it does this with a global variable.  If we did this kind of thing
generically, we'd get eaten alive by all of the cacheline bouncing from
that atomic.  It's also a 32-bit atomic.  Guess it's never had more than
4GB of memory tracked in there. :)

This also doesn't track overhead from things that *are* in slabs like
the inodes, or the 14 kmem_caches that lustre has, so it's far from a
complete picture of how lustre is using memory.

> It can also log the alloc/free calls and post-process them to find leaks
> easily, or find pieces code that is allocating too much memory that are not
> using dedicated slabs.  This also works if you encounter a system with a
> lot of allocated memory, enable "free" logging, and then unmount the
> filesystem. 
> The logs will show which structures are being freed (assuming they are not
> leaked completely) and point you to whatever is not being shrunk properly.

This isn't perfect, but it does cover most of the ext4 call sites in my
kernel.  It would work better for a module, I'd imagine:

cd /sys/kernel/debug/tracing/events/kmem
echo -n 'call_site < 0xffffffff81e0af00 && call_site >=
0xffffffff81229cf0' > kmalloc/filter
echo 1 > kmalloc/enable
cat /sys/kernel/debug/tracing/trace_pipe

It will essentially log all the kmalloc() calls from the ext4 code.  I
got the call site locations from grepping System.map.  It would be
_really_ nice if we were able to do something like:

	echo 'call_site =~ *ext4*'

but there's no way to do that which I know of.  You could probably rig
something up with the function graph tracer by triggering only on entry
to the lustre code.

> I don't know if there is any way to track this with regular kmalloc(), and
> creating separate slabs for so ever data structure would be ugly.  The
> generic
> /proc/meminfo data doesn't really tell you what is using all the memory,
> and
> the size-NNNN slabs give some information, but are used all over the
> kernel.
> 
> I'm pretty much resigned to losing all of this functionality, but it
> definitely
> has been very useful for finding problems.

Yeah, it is hard to find out who is responsible for leaking pages or
kmalloc()s, especially after the fact.  But, we seem to limp along just
fine.  If lustre is that bad of a memory leaker that it *NEEDS* this
feature, we have bigger problems on our hands. :)



