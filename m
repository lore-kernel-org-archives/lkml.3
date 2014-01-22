Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaAVBwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:52:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:64704 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaAVBwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:52:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="462584251"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peng Tao <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Thread-Topic: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Thread-Index: AQHPE2C8z70eL8jSIUCfqXMMm5K1JJqJgYiAgAAFBgCAAAdMgIAFWv6AgAFSWACAAE1GAA==
Date: Wed, 22 Jan 2014 01:52:07 +0000
Message-ID: <091A6C4E-6D40-4CEF-A487-ABA25F1F924A@intel.com>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com> <20140117145128.GR7444@mwanda>
 <20140117151735.GB16623@kroah.com> <CF037522.8B804%andreas.dilger@intel.com>
 <52DEE374.7040908@intel.com>
In-Reply-To: <52DEE374.7040908@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.20]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <7E93D53AEF92214798E09DC20EC64B7D@intel.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jan 21, 2014, at 4:15 PM, Dave Hansen wrote:

> On 01/21/2014 12:02 PM, Dilger, Andreas wrote:
>> The Lustre allocation macros track the memory usage across the whole
>> filesystem,
>> not just of a single structure that a mempool/slab/whatever would do.
>> This is
>> useful to know for debugging purposes (e.g. user complains about not having
>> enough RAM for their highly-tuned application, or to check for leaks at
>> unmount).
> Urg, it does this with a global variable.  If we did this kind of thing
> generically, we'd get eaten alive by all of the cacheline bouncing from
> that atomic.  It's also a 32-bit atomic.  Guess it's never had more than
> 4GB of memory tracked in there. :)

No, hopefully we'll never get to be this memory hungry on a single node.
Good point about the cacheline, I guess.

> This also doesn't track overhead from things that *are* in slabs like
> the inodes, or the 14 kmem_caches that lustre has, so it's far from a
> complete picture of how lustre is using memory.

The inodes are per filesystem, so we do have complete picture there.
dentries and some other structures are shared, but e.g. on a client lustre is
frequently the only active FS in use and as such it's easy.

>> It can also log the alloc/free calls and post-process them to find leaks
>> easily, or find pieces code that is allocating too much memory that are not
>> using dedicated slabs.  This also works if you encounter a system with a
>> lot of allocated memory, enable "free" logging, and then unmount the
>> filesystem. 
>> The logs will show which structures are being freed (assuming they are not
>> leaked completely) and point you to whatever is not being shrunk properly.
> 
> This isn't perfect, but it does cover most of the ext4 call sites in my
> kernel.  It would work better for a module, I'd imagine:
> 
> cd /sys/kernel/debug/tracing/events/kmem
> echo -n 'call_site < 0xffffffff81e0af00 && call_site >=
> 0xffffffff81229cf0' > kmalloc/filter
> echo 1 > kmalloc/enable
> cat /sys/kernel/debug/tracing/trace_pipe

That's a neat trick.

> It will essentially log all the kmalloc() calls from the ext4 code.  I
> got the call site locations from grepping System.map.  It would be
> _really_ nice if we were able to do something like:
> 
> 	echo 'call_site =~ *ext4*'

So basically module address plus len from /proc/modules should do for modular features? Should be easy to script.

Is there any neat way to enable this after module is loaded, but before it gets any control, so that there's
a full track of all allocations and deallocations (obviously that's only going to be used for debugging).

> Yeah, it is hard to find out who is responsible for leaking pages or
> kmalloc()s, especially after the fact.  But, we seem to limp along just
> fine.  If lustre is that bad of a memory leaker that it *NEEDS* this
> feature, we have bigger problems on our hands. :)

It's one of those things that you don't need often, but that does come very handy once the need arises ;)
It's also nice that it warns you on module unload that "hey, you left this much stuff behind, bad boy!".
But we can live without it, that's true too.

Bye,
    Oleg

