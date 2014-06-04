Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaFDQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:26:24 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:48852 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaFDQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <538F44AD.4090906@kernel.dk>
References: <20140509120733.GA27918@kernel.org>
	<20140509150018.GA26215@infradead.org>
	<20140510040023.GA13788@kernel.org>
	<5388912F.7010609@kernel.dk>
	<20140604111133.GA7826@infradead.org>
	<538F2A11.4060800@kernel.dk>
	<20140604142012.GA20056@infradead.org>
	<538F331F.60101@kernel.dk>
	<20140604145803.GA7826@infradead.org>
	<538F34FB.7050003@kernel.dk>
	<20140604153159.GA27096@infradead.org>
	<CACVXFVNNTPrq29eS9GzJDequtFXCTNWPLJfzB4Z-XJVE5j8+aA@mail.gmail.com>
	<538F3FB5.2020102@kernel.dk>
	<CACVXFVM-aJwBgrvgT-nNbbi81vE4qeS1LgsS5cFGiz5cbsApZw@mail.gmail.com>
	<538F44AD.4090906@kernel.dk>
Date: Thu, 5 Jun 2014 00:26:15 +0800
Message-ID: <CACVXFVOxx973ho9yN0W95YCj2XQBoYqyu4aD4bZ_9Pv89XGgnQ@mail.gmail.com>
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec51ba27b63502c04fb0516b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec51ba27b63502c04fb0516b9
Content-Type: text/plain; charset=UTF-8

On Thu, Jun 5, 2014 at 12:09 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/04/2014 10:00 AM, Ming Lei wrote:
>> On Wed, Jun 4, 2014 at 11:48 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 06/04/2014 09:43 AM, Ming Lei wrote:
>>>> On Wed, Jun 4, 2014 at 11:31 PM, Christoph Hellwig <hch@infradead.org> wrote:
>>>>> On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
>>>>>>> scsi_mq_find_tag only gets the scsi host, which may have multiple
>>>>>>> queues.  When called from scsi_find_tag we actually have a scsi device,
>>>>>>> so that's not an issue, but when called from scsi_host_find_tag the
>>>>>>> driver only provides the host.
>>>>>>
>>>>>> Only solution I see right now is to have the flush_rq in the shared
>>>>>> tags, but that would potentially be a regression for multiple
>>>>>> devices and heavy flush uses cases. I'll see if I can come up with
>>>>>> something better, or maybe Shaohua has an idea.
>>>>>
>>>>> What about something like the following (untest, uncompiled, maybe
>>>>> pseudo-code):
>>>>>
>>>>> struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
>>>>> {
>>>>>         struct request *rq = tags->rqs[tag];
>>>>>
>>>>>         if ((rq->cmd_flags & REQ_FLUSH_SEQ) && rq->q->flush_rq->tag == tag)
>>>>>                 return rq->q->flush_rq;
>>>>>         return rq;
>>>>> }
>>>>
>>>> Looks we thought it together, :-)
>>>>
>>>> Also maybe the flush_rq->tag need to be cleared in flush_end_io().
>>>
>>> It clears the command flag, so that should be enough.
>>
>> Only the flush_rq's command flag is cleared, and its parent request
>> flag isn't cleared.
>
> Good point. Care to send in a patch? We can just clear it to -1U, at
> least in blk-mq that's defined as an invalid tag.

Attachment patch should be enough.

Thanks,
-- 
Ming Lei

--bcaec51ba27b63502c04fb0516b9
Content-Type: text/x-patch; charset=US-ASCII; name="clear_flush_rq_tag.patch"
Content-Disposition: attachment; filename="clear_flush_rq_tag.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hw0ukfp80

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1mbHVzaC5jIGIvYmxvY2svYmxrLWZsdXNoLmMKaW5kZXgg
ZmY4N2M2Ni4uOGZmZWU0YiAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLWZsdXNoLmMKKysrIGIvYmxv
Y2svYmxrLWZsdXNoLmMKQEAgLTIyNSw3ICsyMjUsNyBAQCBzdGF0aWMgdm9pZCBmbHVzaF9lbmRf
aW8oc3RydWN0IHJlcXVlc3QgKmZsdXNoX3JxLCBpbnQgZXJyb3IpCiAKIAlpZiAocS0+bXFfb3Bz
KSB7CiAJCXNwaW5fbG9ja19pcnFzYXZlKCZxLT5tcV9mbHVzaF9sb2NrLCBmbGFncyk7Ci0JCXEt
PmZsdXNoX3JxLT5jbWRfZmxhZ3MgPSAwOworCQlxLT5mbHVzaF9ycS0+dGFnID0gLTE7CiAJfQog
CiAJcnVubmluZyA9ICZxLT5mbHVzaF9xdWV1ZVtxLT5mbHVzaF9ydW5uaW5nX2lkeF07Cg==
--bcaec51ba27b63502c04fb0516b9--
