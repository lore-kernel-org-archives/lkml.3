Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaFSNMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:12:25 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:33415 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaFSNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:12:23 -0400
Date: Thu, 19 Jun 2014 09:12:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/6] blk-mq: make blk_mq_stop_hw_queue() reliably block
 queue processing
Message-ID: <20140619131220.GE11042@htj.dyndns.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
 <1403104872-22236-2-git-send-email-tj@kernel.org>
 <CACVXFVMhkKgvzXO7QnXRup3wqy2Bom-iPWVQoe_EGZkSMcneag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMhkKgvzXO7QnXRup3wqy2Bom-iPWVQoe_EGZkSMcneag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ming.

On Thu, Jun 19, 2014 at 06:10:28PM +0800, Ming Lei wrote:
> >  void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
> >  {
> > -       cancel_delayed_work(&hctx->run_work);
> > -       cancel_delayed_work(&hctx->delay_work);
> >         set_bit(BLK_MQ_S_STOPPED, &hctx->state);
> > +       cancel_delayed_work_sync(&hctx->run_work);
> > +       cancel_delayed_work_sync(&hctx->delay_work);
> 
> The function can be called from atomic context, like virtio-blk.
> 
> Currently blk_mq_stop_hw_queue() is called in case of queue
> being busy, so looks it is ok with cancel_delayed_work().

Hmm... you're right.  So the function is used to stop future
invocations of the queue processing function and thus the order
doesn't matter.  We probably wanna document that.  I don't understand
why virblk_freeze() is invoking it tho.  If freezing is complete,
there's no request in-flight on the driver side, why does it need to
invoke stop too?

Jens, please drop this one.

Thanks.

-- 
tejun
