Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaFDPC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:02:27 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54334 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFDPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:02:23 -0400
Message-ID: <538F34FB.7050003@kernel.dk>
Date: Wed, 04 Jun 2014 09:02:19 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org> <538F2A11.4060800@kernel.dk> <20140604142012.GA20056@infradead.org> <538F331F.60101@kernel.dk> <20140604145803.GA7826@infradead.org>
In-Reply-To: <20140604145803.GA7826@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 08:58, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 08:54:23AM -0600, Jens Axboe wrote:
>>> It's not as simple as the added code wants to get a queue from the
>>> hwctx, which we can't get at.  I was planning to look into this, but
>>> there are various other regressions in the recent block updates that I
>>> need to fix before I can even test a tree with this one reverted.
>>
>> Which regressions? Performance or crashes?
>
> Both.  I've tracked down the SCSI boot crash and you'll have a patch for
> that soon, still working on bisecting the performance crawl, but I'm
> getting close.

OK strange, there hasn't been that much churn since the last rebase. In 
my for-linus, there's a patch for a single queue crash, but that should 
just hit for the removal case. And then there's the atomic schedule 
patch, but that issue was actually in the code base for about a month, 
so not a new one either.

>>> If you can get to sorting this out soon I'd love you to handle it,
>>> otherwise I'll look into it as soon as I can.
>>
>> Just took a look at it, but I don't see the problematic path. I'm
>> looking at wip-9.
>
> scsi_mq_find_tag only gets the scsi host, which may have multiple
> queues.  When called from scsi_find_tag we actually have a scsi device,
> so that's not an issue, but when called from scsi_host_find_tag the
> driver only provides the host.

Only solution I see right now is to have the flush_rq in the shared 
tags, but that would potentially be a regression for multiple devices 
and heavy flush uses cases. I'll see if I can come up with something 
better, or maybe Shaohua has an idea.


-- 
Jens Axboe

