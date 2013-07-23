Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab3GWOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:38:49 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:51542 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab3GWOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:38:47 -0400
Date: Tue, 23 Jul 2013 10:38:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
Message-ID: <20130723143841.GA18458@mtj.dyndns.org>
References: <51E55B7D.2040209@linux.vnet.ibm.com>
 <51E66CCC.9010600@cn.fujitsu.com>
 <51E84EDC.5090502@linux.vnet.ibm.com>
 <51E89ABB.20808@cn.fujitsu.com>
 <51E8FF76.5030706@linux.vnet.ibm.com>
 <51ED1D02.80205@cn.fujitsu.com>
 <20130722213231.GC16776@mtj.dyndns.org>
 <51EDDB02.20502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EDDB02.20502@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Tue, Jul 23, 2013 at 09:23:14AM +0800, Lai Jiangshan wrote:
> The problem is that the userS may not know their work_on_cpu() nested,
> especially when work_on_cpu()s are on different subsystems and the call depth
> is deep enough but the nested work_on_cpu() depends on some conditions.

Yeah, that's a possibility.  Not sure how much it'd actually matter
tho given that this is the only instance we have and we've had the
lockdep annotation for years.

> I prefer to change the user instead of introducing work_on_cpu_nested(), and
> I accept to change the user only instead of change work_on_cpu() since there is only
> one nested-calls case found.
> 
> But I'm thinking, since nested work_on_cpu() don't have any problem,
> Why workqueue.c don't offer a more friendly API/behavior?

If we wanna solve it from workqueue side, let's please do it by
introduing an internal flush_work() variant which skips the lockdep
annotation.  I'd really like to avoid using completion here.  It's
nasty as it depends solely on the fact that completion doesn't have
lockdep annotation yet.  Let's do it explicitly.

Thanks.

-- 
tejun
