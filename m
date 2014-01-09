Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaAIJRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:17:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAIJRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:17:01 -0500
Message-ID: <52CE85C6.8000405@suse.de>
Date: Thu, 09 Jan 2014 12:19:34 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Darrick J. Wong" <darrick.wong@oracle.com>, chuck.lever@oracle.com,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Doug Gilbert <dgilbert@interlog.com>
Subject: Re: status of block-integrity
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de>	<yq1a9f7wjqr.fsf@sermon.lab.mkp.net> <52CCFADB.6080909@suse.de> <yq1lhyqv6ns.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1lhyqv6ns.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 04:23 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
>
> Hannes,
>
> Hannes> As there is no user (apart from oracleasm) no-one can attach
> Hannes> protection information to any data, so even the most dedicated
> Hannes> admin cannot exercise this path, let alone find issues here.
>
> That's not how it works!
>
> If the filesystem has not attached protection information to a bio the
> block layer will do it for you. The block layer generates protection
> information for writes and verifies it for reads. That's how it's worked
> since day one. The code is there, it is used by everyone with a
> DIX-capable HBA. See Documentation/block/data-integrity.txt.
>
> Normal applications do not want to have to deal with generating
> protection information, using an async I/O model, keeping completion
> state around for extended periods of time to figure out whether the I/O
> actually completed or not and so on. So the kernel-to-platter protection
> scheme we have in place now is good enough.
>
Ah. I stand corrected.
Sorry.

> That doesn't mean that I'm not interested in augmenting libaio. I
> am. Very. And I know of several applications that are keen to use
> it. But getting page cache passthrough and filesystem interaction
> working is non-trivial. That's what has inhibited progress, not
> extending the libaio API.
>
Same here. Actually I _like_ DIX, but the missing libaio / userland API 
makes it very hard to utilize it.

> Hannes> Doug Gilbert and I are currently discussing LID4 / ROD Token
> Hannes> copy for sg3_utils and the block layer, so any patches would be
> Hannes> very helpful here.
>
> I'm only doing LID1 right now. Any particular reason you are exploring
> LID4 and ROD?
>
Yes. LID4/ROD token is far easier to use (conceptually).
With LID1/XCopy you have the ambiguity on where to actually send the 
command to; the spec is silent in this area.
Also for LID1/XCopy you have three steps:
- Query the source disk
- Query the target disk
- Send the command to either source or target
Which is very awkward and one has to think really carefully on how to 
implement this without all sorts of layering violations.
And you have to mix-and-match between all the various xcopy descriptors;
if there's only one it's easy enough, but when several things are 
getting interesting.

With LID4/ROD Token copy you basically have _two_ steps:
- Get the ROD Token from the source device
- Send the ROD Token to the target device

Which is far easier (conceptually).
Or that's the hope, anyway.
Also, the ROD Token in principle has an independent lifetime, so
you could take an arbitrary amount of time between those steps.
It might expire, though, but then failure is always an option when
working with copy offload.

As said, Doug and me are working on putting this into sg3_utils, then
we'll have a better idea on the actual workings.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
