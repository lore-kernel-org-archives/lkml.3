Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaERHRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:17:06 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:37009 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaERHRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:17:05 -0400
Message-ID: <53785E6C.9010300@acm.org>
Date: Sun, 18 May 2014 09:17:00 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Mateusz Guzik <mguzik@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v2] kref: warn on uninitialized kref
References: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com> <20140517110454.GA1939@mguzik.redhat.com> <alpine.LRH.2.02.1405170836070.15837@file01.intranet.prod.int.rdu2.redhat.com> <53776918.7040402@acm.org> <alpine.LRH.2.02.1405171646290.32012@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1405171646290.32012@file01.intranet.prod.int.rdu2.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/14 23:14, Mikulas Patocka wrote:
> BTW. if we talk about performance - what about replacing:
> 
> 	if (atomic_dec_and_test(&variable)) {
> 		... release(object);
> 	}
> 
> with this:
> 
> 	if (atomic_read(&variable) == 1 || atomic_dec_and_test(&variable)) {
> 		barrier();
> 		... release(object);
> 	}
> 
> It avoids the heavy atomic instruction if there is just one reference. Is 
> there any problem with this? At least on x86 we could do this always 
> (there is no read reordering in hardware, so barrier() is sufficient to 
> prevent reads from being reordered with atomic_read). On the architectures 
> that reorder reads, we could do it only if the release method doesn't 
> contain any reads of the object being released.

Although I'm not sure how big the performance impact is in this context,
this change has a performance impact if variable > 1. The
atomic_dec_and_test() triggers at most one cache line state transition.
The atomic_read() + atomic_dec_and_test() triggers two cache line state
transitions if "variable" is not in the local cache, namely first from
invalid to shared and then from shared to exclusive. See also section
"11.4 CACHE CONTROL PROTOCOL" and "Table 11-4 MESI Cache Line States" in
the Intel Software Developer Manual, Volume 3 for more information.

Bart.

