Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaAUUCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:02:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:22378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaAUUCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:02:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="462443151"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peng Tao <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Thread-Topic: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Thread-Index: AQHPE2C8z70eL8jSIUCfqXMMm5K1JJqJgYiAgAAFBgCAAAdMgIAFWv6A
Date: Tue, 21 Jan 2014 20:02:03 +0000
Message-ID: <CF037522.8B804%andreas.dilger@intel.com>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com> <20140117145128.GR7444@mwanda>
 <20140117151735.GB16623@kroah.com>
In-Reply-To: <20140117151735.GB16623@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.1.137]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC73B415C3D5CD4E9910D4E21BFBD472@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/01/17, 8:17 AM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
wrote:

>On Fri, Jan 17, 2014 at 05:51:28PM +0300, Dan Carpenter wrote:
>> We will want to get rid of lustre's custom allocator before this gets
>> out of staging.
>> 
>> But one feature that the lustre allocator has which is pretty neat is
>> that it lets you debug how much memory the filesystem is using.  Is
>> there a standard way to find this information?
>
>Create your own mempool/slab/whatever_it's_called and look in the
>debugfs or proc files for the allocator usage, depending on the memory
>allocator the kernel is using.
>
>That's how the rest of the kernel does it, no reason lustre should be
>any different.

The Lustre allocation macros track the memory usage across the whole
filesystem,
not just of a single structure that a mempool/slab/whatever would do.
This is
useful to know for debugging purposes (e.g. user complains about not having
enough RAM for their highly-tuned application, or to check for leaks at
unmount).

It can also log the alloc/free calls and post-process them to find leaks
easily, or find pieces code that is allocating too much memory that are not
using dedicated slabs.  This also works if you encounter a system with a
lot
of allocated memory, enable "free" logging, and then unmount the
filesystem.
The logs will show which structures are being freed (assuming they are not
leaked completely) and point you to whatever is not being shrunk properly.

I don't know if there is any way to track this with regular kmalloc(), and
creating separate slabs for so ever data structure would be ugly.  The
generic
/proc/meminfo data doesn't really tell you what is using all the memory,
and
the size-NNNN slabs give some information, but are used all over the
kernel.

I'm pretty much resigned to losing all of this functionality, but it
definitely
has been very useful for finding problems.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


