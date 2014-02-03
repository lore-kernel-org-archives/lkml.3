Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBCUWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:22:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaBCUWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:22:41 -0500
Date: Mon, 3 Feb 2014 15:22:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] block devices: validate block device capacity
In-Reply-To: <20140203081506.GA10961@infradead.org>
Message-ID: <alpine.LRH.2.02.1402031513070.18926@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com> <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com> <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com>
 <1391125027.2181.114.camel@dabdike.int.hansenpartnership.com> <alpine.LRH.2.02.1401301905520.25766@file01.intranet.prod.int.rdu2.redhat.com> <1391132609.2181.131.camel@dabdike.int.hansenpartnership.com> <alpine.LRH.2.02.1401302116180.9767@file01.intranet.prod.int.rdu2.redhat.com>
 <1391147127.2181.159.camel@dabdike.int.hansenpartnership.com> <alpine.LRH.2.02.1401310316560.21451@file01.intranet.prod.int.rdu2.redhat.com> <20140203081506.GA10961@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Feb 2014, Christoph Hellwig wrote:

> On Fri, Jan 31, 2014 at 03:20:17AM -0500, Mikulas Patocka wrote:
> > So if you think you can support 16TiB devices and leave pgoff_t 32-bit, 
> > send a patch that does it.
> > 
> > Until you make it, you should apply the patch that I sent, that prevents 
> > kernel lockups or data corruption when the user uses 16TiB device on 
> > 32-bit kernel.
> 
> Exactly.  I had actually looked into support for > 16TiB devices for
> a NAS use case a while ago, but when explaining the effort involves
> the idea was dropped quickly.  The Linux block device is too deeply
> tied to the pagecache to make it easily feasible.

The memory management routines use pgoff_t, so we could define pgoff_t to 
be 64-bit type. But there is lib/radix_tree.c that uses unsigned long as 
an index into the radix tree - and pgoff_t is cast to unsigned long when 
calling the radix_tree routines - so we'd need to change lib/radix_tree to 
use pgoff_t.

Then, there may be other places where pgoff_t is cast to unsigned long and 
they are not trivial to find (one could enable some extra compiler 
warnings about truncating values when casting them, but I suppose, this 
would trigger a lot of false positives). This needs some deep review by 
people who designed the memory management code.

Mikulas
