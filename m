Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbaEMLGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:06:24 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:60716 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbaEMLGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:06:21 -0400
Date: Tue, 13 May 2014 19:06:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stanimir Vabanov <svarbanov@mm-sol.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/9] crypto: qce: Add core driver implementation
Message-ID: <20140513110607.GA21662@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com>
 <20140428085928.GA16310@gondor.apana.org.au>
 <536BFDD3.9090609@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BFDD3.9090609@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:57:39AM +0300, Stanimir Vabanov wrote:
> Hi Herbert,
> 
> On 04/28/2014 11:59 AM, Herbert Xu wrote:
> > On Mon, Apr 14, 2014 at 03:48:37PM +0300, Stanimir Varbanov wrote:
> >>
> >> +#define QCE_MAJOR_VERSION5	0x05
> >> +#define QCE_QUEUE_LENGTH	50
> > 
> > What is the purpose of this software queue? Why can't you directly
> > feed the requests to the hardware?
> > 
> > If the hardware can't handle more than 50 requests in-flight,
> > then your software queue has failed to handle this since you're
> > taking requests off the queue before you touch the hardware so
> > you're not really limiting it to 50.  That is, for users that
> > can wait you're potentially dropping their requests instead
> > of letting them wait through the backlog mechanism.
> 
> My assumption was that crypto_ablkcipher_encrypt/decrypt couldn't sleep
> and I should take the request almost immediately and return the
> appropriate error value - EINPROGRESS if the hardware is idle and EBUSY
> if the hardware working on some previous request. Thus if the returned
> error is EBUSY and the request could be backlogged I should call
> backlog->complete() when this request is taken actually for processing.
> 
> What I've done in practice is another story.
> 
> Is that assumption correct? If so, is crypto_enqueue|dequeue_request()
> are the proper tools to implement this behaviour?

Technically you are allowed to sleep if the MAY_SLEEP bit is set
but it's safe to just not sleep if that makes things easier for
you.

The enqueue/dequeue functions implement a software queue.  Typically
you would have a software queue in addition to whatever requests
you have in flight on the actual hardware.

For example, if your hardware is only able to handle one outstanding
request, then your software queue should only be dequeued once the
outstanding request has completed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
