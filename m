Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaGABkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:40:12 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53371 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGABkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:40:10 -0400
Date: Tue, 1 Jul 2014 09:40:02 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
Message-ID: <20140701014002.GA20267@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <53AAFDF7.2010607@oracle.com>
 <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
 <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070101-2674-0000-0000-000000A4E740
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 03:03:21PM -0700, David Rientjes wrote:
>On Wed, 25 Jun 2014, Christoph Lameter wrote:
>
>> On Wed, 25 Jun 2014, Sasha Levin wrote:
>> 
>> > [  791.669480] ? init_object (mm/slub.c:665)
>> > [  791.669480] setup_object.isra.34 (mm/slub.c:1008 mm/slub.c:1373)
>> > [  791.669480] new_slab (mm/slub.c:278 mm/slub.c:1412)
>> 
>> So we just got a new page from the page allocator but somehow cannot
>> write to it. This is the first write access to the page.
>> 
>
>I'd be inclined to think that this was a result of "slub: reduce duplicate 
>creation on the first object" from -mm[*] that was added the day before 
>Sasha reported the problem.
>
>It's not at all clear to me that that patch is correct.  Wei?
>
>Sasha, with a revert of that patch, does this reproduce?
>
> [*] http://ozlabs.org/~akpm/mmotm/broken-out/slub-reduce-duplicate-creation-on-the-first-object.patch

David,

So sad to see the error after applying my patch. In which case this is
triggered? The kernel with this patch runs fine on my laptop. Maybe there is
some corner case I missed? If you could tell me the way you reproduce it, I
would have a try on my side.

I did a simple test for this patch, my test code and result is attached.

1. kmem_cache.c
   The test module.
2. kmem_log.txt
   In this log, you can see 26 objects are initialized once exactly, while
   without this patch, the first object will be initialized twice.

     Fetch a cache from kmem_cache
     new_slab: page->objects is 26
     new_slab: setup on ffff880097038000, ffff8800970384e0
       init_once: [00]ffff880097038000 is created
     new_slab: setup on ffff8800970384e0, ffff8800970389c0
       init_once: [01]ffff8800970384e0 is created
     new_slab: setup on ffff8800970389c0, ffff880097038ea0
       init_once: [02]ffff8800970389c0 is created
     new_slab: setup on ffff880097038ea0, ffff880097039380
       init_once: [03]ffff880097038ea0 is created
     new_slab: setup on ffff880097039380, ffff880097039860
       init_once: [04]ffff880097039380 is created
     new_slab: setup on ffff880097039860, ffff880097039d40
       init_once: [05]ffff880097039860 is created
     new_slab: setup on ffff880097039d40, ffff88009703a220
       init_once: [06]ffff880097039d40 is created
     new_slab: setup on ffff88009703a220, ffff88009703a700
       init_once: [07]ffff88009703a220 is created
     new_slab: setup on ffff88009703a700, ffff88009703abe0
       init_once: [08]ffff88009703a700 is created
     new_slab: setup on ffff88009703abe0, ffff88009703b0c0
       init_once: [09]ffff88009703abe0 is created
     new_slab: setup on ffff88009703b0c0, ffff88009703b5a0
       init_once: [10]ffff88009703b0c0 is created
     new_slab: setup on ffff88009703b5a0, ffff88009703ba80
       init_once: [11]ffff88009703b5a0 is created
     new_slab: setup on ffff88009703ba80, ffff88009703bf60
       init_once: [12]ffff88009703ba80 is created
     new_slab: setup on ffff88009703bf60, ffff88009703c440
       init_once: [13]ffff88009703bf60 is created
     new_slab: setup on ffff88009703c440, ffff88009703c920
       init_once: [14]ffff88009703c440 is created
     new_slab: setup on ffff88009703c920, ffff88009703ce00
       init_once: [15]ffff88009703c920 is created
     new_slab: setup on ffff88009703ce00, ffff88009703d2e0
       init_once: [16]ffff88009703ce00 is created
     new_slab: setup on ffff88009703d2e0, ffff88009703d7c0
       init_once: [17]ffff88009703d2e0 is created
     new_slab: setup on ffff88009703d7c0, ffff88009703dca0
       init_once: [18]ffff88009703d7c0 is created
     new_slab: setup on ffff88009703dca0, ffff88009703e180
       init_once: [19]ffff88009703dca0 is created
     new_slab: setup on ffff88009703e180, ffff88009703e660
       init_once: [20]ffff88009703e180 is created
     new_slab: setup on ffff88009703e660, ffff88009703eb40
       init_once: [21]ffff88009703e660 is created
     new_slab: setup on ffff88009703eb40, ffff88009703f020
       init_once: [22]ffff88009703eb40 is created
     new_slab: setup on ffff88009703f020, ffff88009703f500
       init_once: [23]ffff88009703f020 is created
     new_slab: setup on ffff88009703f500, ffff88009703f9e0
       init_once: [24]ffff88009703f500 is created
     new_slab: do it again? ffff88009703f9e0
       init_once: [25]ffff88009703f9e0 is created

-- 
Richard Yang
Help you, Help me

--zhXaljGHf11kAtnf
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="kmem_cache.c"

/*
 * =====================================================================================
 *
 *       Filename:  kmem_cache.c
 *
 *    Description:  /proc/slabinfo
 *
 *        Version:  1.0
 *        Created:  04/26/2014 09:12:04 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Wei Yang (weiyang), weiyang.kernel@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
MODULE_LICENSE("Dual BSD/GPL");

static struct kmem_cache *test_cache;
void *tmp;

static void init_once(void *foo)
{
	static int num;
	printk(KERN_ERR "%s: [%02d]%p is created\n", __func__, num++, foo);
}

static int kmem_cache_test_init(void)
{
	test_cache = kmem_cache_create("test_cache", 1234, 4,
			0, init_once);
	if (test_cache == NULL)
		return -ENOMEM;

	printk(KERN_ERR "Fetch a cache from kmem_cache\n", __func__);
	tmp = kmem_cache_zalloc(test_cache, GFP_KERNEL);

	return 0;
}
static void kmem_cache_test_exit(void)
{
	kmem_cache_free(test_cache, tmp);
	kmem_cache_destroy(test_cache);
}
module_init(kmem_cache_test_init);
module_exit(kmem_cache_test_exit);

--zhXaljGHf11kAtnf--

