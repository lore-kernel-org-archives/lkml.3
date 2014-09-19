Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbaISNgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:36:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:56057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858AbaISNgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:36:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="478686513"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "<kernel-janitors@vger.kernel.org>" <kernel-janitors@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<HPDD-discuss@ml01.01.org>" <HPDD-discuss@ml01.01.org>
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: llite: Use kzalloc and
 rewrite null tests
Thread-Topic: [HPDD-discuss] [PATCH] staging: lustre: llite: Use kzalloc and
 rewrite null tests
Thread-Index: AQHP038cV7KKUWUf/U2QvPeJwPvEYJwIAvSAgAA2K4D//6k1TIABCW6A
Date: Fri, 19 Sep 2014 13:36:24 +0000
Message-ID: <4533064F-A093-4DED-8294-CF049CB591A8@intel.com>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
 <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
 <20140918234309.GP17875@mwanda>
 <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com>
 <517B3353-BD3C-4326-A8F4-F1775B4865E5@intel.com>
 <alpine.DEB.2.10.1409190637190.2507@hadrien>
In-Reply-To: <alpine.DEB.2.10.1409190637190.2507@hadrien>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.9.123]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <38ECBE9C0338C2439C5CF8B04415A4B4@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

   First, thanks for your patches and efforts spent on these cleanups.

On Sep 19, 2014, at 12:45 AM, Julia Lawall wrote:

> With respect to the upper case lower case issue, does the thing need to be
> a macro?  I think that the lowercase is more or less fine, but only if
> what is behind it is a function.

I don't have a strong opinion either way as long as we have all the functionality
we need.

> I say more or less fine, because normally in the kernel the special
> allocators have special purposes, eg allocating and initializing the xyz
> structure.  Here what is wanted is a general purpose allocator with lots
> of special tracing features, so it is not quite the same thing.  And one
> can wonder why all of these special tracing features are not relevant to
> the kernel as a whole?

Like I explained in my previous email, many of the tracing features are already
possible to replace with other existing in-kernel mechanisms like kmemleak.

Except the total tally of allocations/frees so that a memleak could be visibly
easily seen on module unload time. I think this would be useful for other
kinds of modules too, not just lustre, so having that as a generic allocator
feature would be cool too.

> In reading through the description of the needed features, it seems like
> only the _ptr extension requires being a macro.  Do we need that?  The

We only need that as a less error-prone way of having
x = obd_kzalloc(sizeof(*x), ….)
…
obd_free(…, sizeof(*x))

Real free function does not take size argument, but we need that for
total allocated/freed accounting. Easy to have disconnect with
the size argument of obd_free to be wrong.

> rest of the kernel manages to do x = kzalloc(sizeof(*x),...) ok.  It's
> unpleasant to have an assignment hidden in this way.  And currently it is
> not used consistently.  There are some OBD_ALLOCs that have the same form.

Yes, those are converted as thy are noticed.

> Sorry for overlooking the frees.  I was focusing on trying one thing at a
> time...

I kind of think it's a related issue.
Touching ones needs to touch the other if not in the same patch then in
a next patch. And that's why I think consideations for what FREEs would need
is needed from the start, so the FREEs removal patch does not goes and patches a bunch of just patched allocs.

Thanks.

Bye,
    Oleg