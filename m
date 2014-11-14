Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176AbaKNKqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:46:16 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33218 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965084AbaKNKqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:46:10 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexander Duyck'" <alexander.h.duyck@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mikey@neuling.org" <mikey@neuling.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "mathieu.desnoyers@polymtl.ca" <mathieu.desnoyers@polymtl.ca>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "matthew.vick@intel.com" <matthew.vick@intel.com>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: RE: [PATCH 1/3] arch: Introduce load_acquire() and store_release()
Thread-Topic: [PATCH 1/3] arch: Introduce load_acquire() and store_release()
Thread-Index: AQHP/3g3jNC6aMe4I0WBkBJJ0iGb4Jxf7s2A
Date: Fri, 14 Nov 2014 10:45:41 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9F0780@AcuExch.aculab.com>
References: <20141113191250.12579.19694.stgit@ahduyck-server>
 <20141113192723.12579.25343.stgit@ahduyck-server>
In-Reply-To: <20141113192723.12579.25343.stgit@ahduyck-server>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAEAkMoo031292

From: Alexander Duyck
> It is common for device drivers to make use of acquire/release semantics
> when dealing with descriptors stored in device memory.  On reviewing the
> documentation and code for smp_load_acquire() and smp_store_release() as
> well as reviewing an IBM website that goes over the use of PowerPC barriers
> at http://www.ibm.com/developerworks/systems/articles/powerpc.html it
> occurred to me that the same code could likely be applied to device drivers.
> 
> As a result this patch introduces load_acquire() and store_release().  The
> load_acquire() function can be used in the place of situations where a test
> for ownership must be followed by a memory barrier.  The below example is
> from ixgbe:
> 
> 	if (!rx_desc->wb.upper.status_error)
> 		break;
> 
> 	/* This memory barrier is needed to keep us from reading
> 	 * any other fields out of the rx_desc until we know the
> 	 * descriptor has been written back
> 	 */
> 	rmb();
> 
> With load_acquire() this can be changed to:
> 
> 	if (!load_acquire(&rx_desc->wb.upper.status_error))
> 		break;

If I'm quickly reading the 'new' code I need to look up yet another
function, with the 'old' code I can easily see the logic.

You've also added a memory barrier to the 'break' path - which isn't needed.

The driver might also have additional code that can be added before the barrier
so reducing the cost of the barrier.

The driver may also be able to perform multiple actions before a barrier is needed.

Hiding barriers isn't necessarily a good idea anyway.
If you are writing a driver you need to understand when and where they are needed.

Maybe you need a new (weaker) barrier to replace rmb() on some architectures.

...


	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
