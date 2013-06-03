Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3FCLw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:52:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54915 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3FCLw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:52:26 -0400
Date: Mon, 3 Jun 2013 12:52:19 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Achin Gupta <Achin.Gupta@arm.com>
Subject: Re: [RFC PATCH 2/3] drivers: mfd: vexpress: add timeout API to
 vexpress config interface
Message-ID: <20130603115219.GA22821@e102568-lin.cambridge.arm.com>
References: <1369399986-15649-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1369399986-15649-3-git-send-email-lorenzo.pieralisi@arm.com>
 <1370254532.3407.36.camel@linaro1.home>
MIME-Version: 1.0
In-Reply-To: <1370254532.3407.36.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 03 Jun 2013 11:52:22.0703 (UTC) FILETIME=[CF02A3F0:01CE6050]
X-MC-Unique: 113060312522400501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:15:32AM +0100, Jon Medhurst (Tixy) wrote:
> On Fri, 2013-05-24 at 13:53 +0100, Lorenzo Pieralisi wrote:
> > In case some transactions to the Serial Power Controller (SPC) are lost owing
> > to multiple operations handled at once by the M3 controller the OS needs to
> > rely on a configuration API that can time out so that failures do not result
> > in an unusable system.
> > 
> > This patch adds a timeout API to the vexpress config programming interface,
> > and refactors the existing read/write functions so that they can be reused
> > seamlessly on top of the newly defined API.
> 
> Isn't one of the main purposes of the config interface to serialise
> transactions to the config bus, so why would the SPC be handling
> multiple transactions at once? And if we can in fact loose transactions
> doesn't this mean we get random failures in the system? E.g. if this
> happened at boot in vexpress_spc_populate_opps then cpufreq will fail.

It has more to do with firmware carrying out background operations like
powering up a cluster when a DVFS is requested. You are absolutely right
though:

a) the timeout interface is broken, as you mentioned (I noticed after
   posting it)
b) we should not add a timeout interface to paper over FW issues

I can prepare a v2 with timeout interface dropped and extensively test that
one, I do not think we should add the required complexity that you describe
below for something that should never happen.

> Also, I think the code implementing timeouts is broken, see below.

I will have a look asap and repost a v2 accordingly.

> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Achin Gupta <achin.gupta@arm.com>
> > Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Amit Kucheria <amit.kucheria@linaro.org>
> > Cc: Jon Medhurst <tixy@linaro.org>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > ---
> >  drivers/mfd/vexpress-config.c | 26 +++++++---
> >  include/linux/vexpress.h      | 23 ++++++--
> >  2 files changed, 37 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
> > index 1af2b0e..6f4aa5a 100644
> > --- a/drivers/mfd/vexpress-config.c
> > +++ b/drivers/mfd/vexpress-config.c
> > @@ -266,8 +266,18 @@ int vexpress_config_wait(struct vexpress_config_trans *trans)
> >  }
> >  EXPORT_SYMBOL(vexpress_config_wait);
> >  
> > -int vexpress_config_read(struct vexpress_config_func *func, int offset,
> > -		u32 *data)
> > +int vexpress_config_wait_timeout(struct vexpress_config_trans *trans,
> > +			long jiffies)
> > +{
> > +	int ret;
> > +	ret = wait_for_completion_timeout(&trans->completion, jiffies);
> 
> If the request times out, don't we need to call vexpress_config_complete
> to dequeue the timed out request and trigger the next one? Though we
> will still have a problem where the timeout happens but the request
> then does in fact complete normally, in that case we would signal
> completion of the second request before it has in fact completed.
> 
> So, if transactions really can get silently dropped by thing on the end
> of the config bus, then we must have a mechanism for associating a
> particular transaction with a completion signal, otherwise we won't know
> what transaction actually got completed OK and which ones were dropped
> and should receive -ETIMEDOUT.
> 
> Finally, I don't think these issues are purely theoretical, I'm pretty
> certain that the kernel panics and spinlock bad magic errors I see with
> his patch series are due to requests completing after they have been
> timed out and then the stack based transaction object is being accessed
> after it has gone out of scope.

You are absolutely right, apologies for wasting your time in testing it.

Thanks a lot for the review,
Lorenzo

