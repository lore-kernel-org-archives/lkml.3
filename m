Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaJPUHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:07:19 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58266 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaJPUHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:07:16 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>
CC: "hare@suse.de" <hare@suse.de>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>
Subject: RE: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
Thread-Topic: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
Thread-Index: AQHP6XV5Z3Xq7PZeKkq7bBkX3e8aQZwzG9wAgAAAk4CAAAL30A==
Date: Thu, 16 Oct 2014 20:05:58 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>
References: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com>
 <1413487720.15773.1.camel@perches.com> <54401CE3.8000307@free-electrons.com>
In-Reply-To: <54401CE3.8000307@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Michael Opdenacker
> Sent: Thursday, 16 October, 2014 2:31 PM
...
> On 10/16/2014 09:28 PM, Joe Perches wrote:
> > On Thu, 2014-10-16 at 21:14 +0200, Michael Opdenacker wrote:
> >
> >
> >  	/* Allocate SCB resources */
> > -	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> GFP_ATOMIC);
> > +	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> > +				GFP_ATOMIC);
...
> >
> > Probably better as kcalloc.
> 
> Hey, well spotted! Thanks for your review. I will post a new version soon.

kcalloc is helpful when one of the values is a variable that 
might cause the multiply to overflow during runtime.  Here, 
two constants are being multiplied together, which can
be done and checked by the compiler at compile time.  

Since kcalloc and kmalloc_array are both static inline 
functions:
static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
{
        if (size != 0 && n > SIZE_MAX / size)
                return NULL;
        return __kmalloc(n * size, flags);
}
static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
{
        return kmalloc_array(n, size, flags | __GFP_ZERO);
}

a compiler that detects an overflow will probably just reduce
that to an inlined "return NULL."
	
BUILD_BUG_ON could be used to trigger a compile-time error,
instead of building a kernel that returns a run-time error.

---
Rob Elliott    HP Server Storage



