Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaLHPNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:13:15 -0500
Received: from sf1.bxl.stone.is ([87.238.167.36]:47857 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaLHPNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:13:13 -0500
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2014 10:13:13 EST
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <5485BBD2.4040103@acm.org>
Date: Mon, 08 Dec 2014 15:55:14 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Avoid that I/O hangs in bt_get()
References: <54328A97.3030201@acm.org> <5432D414.4060408@kernel.dk> <5432E524.90407@kernel.dk> <5433A85E.2070207@acm.org> <545B7A6D.8040208@acm.org>
In-Reply-To: <545B7A6D.8040208@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Filter-ID: s0sct1PQhAABKnZB5plbIYrcAt68paBzxGNV4bZScc8DDDH9IcRzs4ldqK5vEMwbuZt+PpRPW1h0
 yigPev+a+0IH1r+MXIsiQIovLy1C/Q9kR+vd8RcnMtIipX97qEvSTHVzM6LFZfR2MCqK4xRbWTJy
 0TnZwXPOV+X+NrCvBfi3wL2Y4F0412ezGCyTUPanO2cvvJsPGAKsAtoK+MVPygs0dgixl+GnJcx/
 9FDUoOk1KIWqlrDdVP53B6UFvjzm9DMExvBAmKp7vzgzedHxMVFfEoXm0/FPF8PR0w363lmHqMEy
 dAx7LKTGBzBGt6dfyGUvT6k9PPf/BbHQFSmtD2vvcf/z1qxv6F6PVXsOSYkvCsd+5e7BEVONeGno
 7KkTy4RDa/CXWzeXNjWtT5qz4VSqeZhBqz8nR05j/2nHmzoDYjOnyexsJ2zOx1IDltOC67dyYJUv
 zBvt/v8maDfvp7qWaJB7Vag9M+StoOcFIS85DB1NnhVJVBYBFJ7Rf6wEDMWDwTd37F6kUiTf/gb0
 MKsA/k03B9kvx4+nrbrM1yp0Wiri3vMVSxza3+BtngT9Rta7pp1tbckhtJIUkl4lhlIxef5Osv7g
 WWQW3tnvs02Ay+i2XM7H4FgTQ34SsZEoGplHcpVCCoX989hgB8R+yFp9/qpHX/a9a7RQwySlNdia
 E5tc/GqyB3xXEI9+04dYTRaB0dlb9inm85LMKG/w6gNTXSMrSFHHlIYXUvutwWg=
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: IFrWXGses7OKB5S5G8/dJR8Z5VD7FZiiT9tK6RAzQuhA3cTUQ1R++keuE7RDJ8Kg3RbMLUalw1oC
 mj99/u+PoqoVy8a3lsStJtAvpObFX0Wok1JBYnOLzfRIhlEHQynLUpndEJ0YoaLytXXo8BMTaX2p
 Mk7LBarWD9Fj4R3eIu5cOy/3Wm9qfF/CZNvP/2Kowv61T+KDYyYtREgszdyFwv8IxCB3p/oCKvxr
 eyISh3JGb7OS5oVgiO+kDxZrVPLz3MmEGC2PrUKqLq5WmHK+Nw==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.03)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/14 14:41, Bart Van Assche wrote:
> With kernel 3.18-rc3 and with can_queue=62 I can trigger a hang in
> bt_get() easily.

(once more replying to my own e-mail)

Hello Jens,

Finally I found the time to look further into this. The patch below 
seems to be sufficient to prevent this hang. However, I'm not a block 
layer expert so it's not clear to me whether the patch below makes sense ?

Thanks,

Bart.

[PATCH] blk-mq: Fix bt_get() hang

Avoid that if there are fewer hardware queues than CPU threads that
bt_get() can hang. The symptoms of the hang were as follows:
* All tags allocated for a particular hardware queue.
* (nr_tags) pending commands for that hardware queue.
* No pending commands for the software queues associated with that
   hardware queue.
---
  block/blk-mq-tag.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 67ab88b..e88af88 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -256,6 +256,8 @@ static int bt_get(struct blk_mq_alloc_data *data,
  			break;
  		}

+		blk_mq_run_hw_queue(hctx, false);
+
  		blk_mq_put_ctx(data->ctx);

  		io_schedule();
