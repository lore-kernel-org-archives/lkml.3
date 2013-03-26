Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab3CZM1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab3CZM1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:27:32 -0400
Date: Tue, 26 Mar 2013 12:27:13 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        Milan Broz <gmazyland@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: [dm-devel] dm-crypt performance
Message-ID: <20130326122713.GC27610@agk-dp.fab.redhat.com>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
	Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
	Milan Broz <gmazyland@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Christian Schmidt <schmidt@digadd.de>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding dm-crypt + linux-kernel]

On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
> I performed some dm-crypt performance tests as Mike suggested.
> 
> It turns out that unbound workqueue performance has improved somewhere 
> between kernel 3.2 (when I made the dm-crypt patches) and 3.8, so the 
> patches for hand-built dispatch are no longer needed.
> 
> For RAID-0 composed of two disks with total throughput 260MB/s, the 
> unbound workqueue performs as well as the hand-built dispatch (both 
> sustain the 260MB/s transfer rate).
> 
> For ramdisk, unbound workqueue performs better than hand-built dispatch 
> (620MB/s vs 400MB/s). Unbound workqueue with the patch that Mike suggested 
> (git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git) improves 
> performance slighlty on ramdisk compared to 3.8 (700MB/s vs. 620MB/s).
> 
> 
> 
> However, there is still the problem with request ordering. Milan found out 
> that under some circumstances parallel dm-crypt has worse performance than 
> the previous dm-crypt code. I found out that this is not caused by 
> deficiencies in the code that distributes work to individual processors. 
> Performance drop is caused by the fact that distributing write bios to 
> multiple processors causes the encryption to finish out of order and the 
> I/O scheduler is unable to merge these out-of-order bios.
> 
> The deadline and noop schedulers perform better (only 50% slowdown 
> compared to old dm-crypt), CFQ performs very badly (8 times slowdown).
> 
> 
> If I sort the requests in dm-crypt to come out in the same order as they 
> were received, there is no longer any slowdown, the new crypt performs as 
> well as the old crypt, but the last time I submitted the patches, people 
> objected to sorting requests in dm-crypt, saying that the I/O scheduler 
> should sort them. But it doesn't. This problem still persists in the 
> current kernels.
> 
> 
> For best performance we could use the unbound workqueue implementation 
> with request sorting, if people don't object to the request sorting being 
> done in dm-crypt.


On Tue, Mar 26, 2013 at 02:52:29AM -0400, Christoph Hellwig wrote:
> FYI, XFS also does it's own request ordering for the metadata buffers,
> because it knows the needed ordering and has a bigger view than than
> than especially CFQ.  You at least have precedence in a widely used
> subsystem for this code.


So please post this updated version of the patches for a wider group of
people to try out.

Alasdair

