Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3KGAwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:52:00 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52792 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KGAv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:51:59 -0500
Date: Thu, 7 Nov 2013 09:51:51 +0900
From: "tj@kernel.org" <tj@kernel.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
Message-ID: <20131107005151.GB32200@mtj.dyndns.org>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
 <20131107002959.GA32200@mtj.dyndns.org>
 <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 07, 2013 at 12:36:56AM +0000, Liu, Chuansheng wrote:
> Yes, I knew I can put the code always like below:
> A = devm_kzalloc();
> C = devm_kzalloc();
> ...
> B= devm_request_threaded_irq(isr_handler);
> 
> But, the above is just one simple coding prototype, if there are many calling:
> E -- > F -- > D -- >... then to devm_kzalloc().
> 
> To be honest, it will make code too hard to always adapt the rule?
> And I trying to find out every potential devm_kzalloc() before irq requesting.

It isn't a good idea to paper over existing bugs from upper layer.
You realize that the above code sequence is already buggy during init
unless there's something explicitly blocking generation of irqs until
init is complete, right?  The right thing to do would be either
reordering the operations or wrapping the operation which unblocks irq
at the end of init with devres so that irq gets blocked before the
rest of release proceeds.

What we must *NOT* do is working around existing bugs in a half-assed
way from midlayer.  What if some of the devres resources are more
complex and actually need to be released by the devres release
callback instead of being freed along with @dr?  What if devres blocks
are in use and releases are done in multiple steps and irq release
belongs to a later group?

-- 
tejun
