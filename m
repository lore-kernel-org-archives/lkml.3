Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaISC5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:57:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:50047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaISC5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:57:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,551,1406617200"; 
   d="scan'208";a="601976388"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "<kernel-janitors@vger.kernel.org>" <kernel-janitors@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<HPDD-discuss@ml01.01.org>" <HPDD-discuss@ml01.01.org>
Subject: Re: [PATCH] staging: lustre: llite: Use kzalloc and rewrite null
 tests
Thread-Topic: [PATCH] staging: lustre: llite: Use kzalloc and rewrite null
 tests
Thread-Index: AQHP038cV7KKUWUf/U2QvPeJwPvEYJwIAvSAgAA2K4A=
Date: Fri, 19 Sep 2014 02:57:03 +0000
Message-ID: <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
 <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
 <20140918234309.GP17875@mwanda>
In-Reply-To: <20140918234309.GP17875@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.20.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC11593B060ADF45934B30D45AB4727F@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sep 18, 2014, at 7:43 PM, Dan Carpenter wrote:

> On Thu, Sep 18, 2014 at 10:24:02PM +0200, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>> 
>> This patch removes some kzalloc-related macros and rewrites the
>> associated null tests to use !x rather than x == NULL.
> This is sort of exactly what Oleg asked us not to do in his previous
> email.  ;P

Hey, Thanks for remembering me ;)

> I think there might be ways to get good enough tracing using standard
> kernel features but it's legitimately tricky to update everything to
> using mempools or whatever.  Maybe we should give Oleg some breathing
> room to do this.

In fact I was mostly mourning ENTRY/EXIT/GOTO stuff back then - I don't know how to
replace anything like that even one bit at the scale we need.
the OBD_ALLOC()/FREE() served multiple purposes most of which could be done with other ways now:
1. general accounting for lustre memory usage (all types directly allocated through the macros), with a message present at the module unload if we freed less than allocated - a warning is printed on unload which would set off a search for the leak (hey, at least we know there is a leak somewhat fast, we also know how much was leaked, and we might probably find out how many allocations were not freed if we wanted to add that stats). - I don't know how to replace that, so perhaps a macro for this still be useful.
2. Hunting memory leaks (this is what the variable allocated, where it was allocated, where it was freed, and the address of the allocation printed) - on non-production systems this could be replaced with kernel memory leak detector now - in fact it's even more convenient since you don't need to match up logs with a script to see what allocated what, and there's even a convenient backtrace printed as a bonus. I used it and really liked the result.
This is not really fitting in production, as kmemleak tends to eat memory like there's no tomorrow (at least in my config) and also might need a kernel rebuild. But it's not like getting people
to gather proper debug logs was easy too. So we can probably do away with that.
3. Fault injections - there's now a way to do this in the kernel, so we probably can do away with this too.
4. Sometimes we need large allocations. general kmalloc is less reliable as system lives on and memory fragmentation worsens. So we have this "allocations over 2-4 pages get switched to vmalloc" logic,
if there's a way to do that automatically - that would be great.

> I hate looking at the OBD_ALLOC* macros, but really it's not as if we
> don't have allocation helper functions anywhere in the rest of the
> kernel.  It's just that the style of the lustre helpers is so very very
> ugly.  It took me a while to spot that OBD_ALLOC() zeroes memory, for
> example.
> 
> It should be relatively easy to re-write the macros so we can change
> formats like this:
> 
> old:	OBD_ALLOC(ptr, size);
> new:	ptr = obd_zalloc(size, GFP_NOFS);
> 
> old:	OBD_ALLOC_WAIT(ptr, size);
> new:	ptr = obd_zalloc(size, GFP_KERNEL);
> 
> old:	OBD_ALLOC_PTR(ptr);
> new:	ptr = obd_zalloc(sizeof(*ptr), GFP_NOFS);
> 
> etc...
> 
> Writing it this way means that we can't put the name of the pointer
> we're allocating in the debug output but we could use the file and line
> number instead or something.  Oleg, what do you think?

I think we don't really need the allocated pointer and the name all that much now with kmemleak.
But we still need to remember the allocation amount like we do now (and when freeing them later).
This is where OBD_ALLOC_PTR/OBD_FREE_PTR come handy - the size is derived from structure size
automatically - less space for error or unintentional mismatch (since kfree does not really care
about number of bytes freed).
so if you prefer to just have everything lowercased, we probably can do obd_zalloc and obd_zallc_ptr still?
(of course in some other world, there might have been a "context-aware" general alloc/free functions
that would have known if an allocation came from a module context and did the tallying internally,
and then warned on module unload if something did not match. But I imagine such module context determination
would not be easy to do. Perhaps registered callbacks for pools that could be called on alloc and on free - though such pools would also need to allow to allocate different sized chunks too).

> If we decide to mass convert to standard functions later then it's dead
> simple to do that with sed.

It's more ugly with OBD_FREE*, though, where the size is needed, while kfree/vfee does not take size.
Also if you convert allocs while not converting frees, that makes code even more ugly (see the current patch at hand even for the example of that).

> The __OBD_MALLOC_VERBOSE() is hard to read.  It has side effect bugs if
> you try to call OBD_ALLOC(ptr++, size);  The kernel already has a way to
> inject kmalloc() failures for a specific module so that bit can be
> removed.  Read Documentation/fault-injection/fault-injection.txt

Yes, I think I agree here.

Bye,
    Oleg