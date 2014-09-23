Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaIWPtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:49:36 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40990 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaIWPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:49:35 -0400
Message-ID: <5421968B.7080309@kernel.dk>
Date: Tue, 23 Sep 2014 09:49:31 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk> <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org>
In-Reply-To: <20140923061152.GI11740@mtj.dyndns.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 12:11 AM, Tejun Heo wrote:
> On Tue, Sep 23, 2014 at 08:09:06AM +0200, Christoph Hellwig wrote:
>> On Tue, Sep 23, 2014 at 02:01:41AM -0400, Tejun Heo wrote:
>>> On Tue, Sep 23, 2014 at 07:59:24AM +0200, Christoph Hellwig wrote:
>>>> "[PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()"
>>>>
>>>> looks way to big for 3.17, and the regression was introduced in the 3.17
>>>> merge window.  I'm not sure what was broken before, but it defintively
>>>> survived a lot of testing.
>>>
>>> Do we even care about fixing it for 3.17?  scsi-mq isn't enabled by
>>> default even for 3.18.  The open-coded percpu ref thing was subtly
>>> broken there.  It'd be difficult to trigger but I'm fairly sure it'd
>>> crap out in the wild once in a blue moon.
>>
>> It's compiled in by default, and people are extremly eager to test it.
> 
> Ugh, I don't know.  It's not like we have a very good baseline we can
> go back to and reverting it for -stable and then redoing it seems
> kinda excessive for a yet experimental feature.  Jens?

It's not just scsi-mq, there are active users of blk-mq in the current
tree - like virtio_blk, mtip32xx. None of those are affected by the RCU
slowdown due to these changes, so it's not a big deal to them. But it is
a big deal if we can't tell people to test scsi-mq in 3.17, that was the
entire point of having it there but not default to on. So yeah, this
really should be fixed for 3.17.

I'm not aware of any reports on the existing enter count breaking things
for them. So while it may not be perfect, reverting the percpu ref count
changes for 3.17 may be the best option that we have.

-- 
Jens Axboe

