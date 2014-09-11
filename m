Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaIKMnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:43:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbaIKMnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:43:00 -0400
Date: Thu, 11 Sep 2014 14:42:49 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521235003.GE6985@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:50:03AM +0900, Tejun Heo wrote:
> Hmmmmmm..... I'd normally apply this patch but block layer is just
> growing multi-queue support and libata is likely to be converted to mq
> in foreseeable future, so I'm a bit hesitant to make irq handling more
> sophiscated right now.  Would you be interested in looking into
> converting libata to blk mq support?  I'm pretty sure it'd yield far
> better outcome if done properly.

Hi Tejun,

As conversion of libata to blk mq has long done I tried the change
against the recent version and the results still appear worthwhile.

The numbers are taken by running 'dd if=/dev/sd{a,b} of=/dev/null'
in parallel. All time values are in us.

Before this update host lock average holdtime was 2.45 and
average waittime was 1.24. After the update average holdtime
dropped to 0.29 (about eight times) while average waittime
decreased to 0.58 (about two times).

Also, port events are handled with local interrupts enabled
and compete on individual per-port locks with average holdtime
1.25 and average waittime 1.48. So combined average holdtime
spent while holding host and port locks decreased from 2.45 to
0.29 + 1.25 = 1.54 (about 1.6 times).

The downside of this change is introduction of a kernel thread.

The upside is shorter access time to port locks and moving port
interrupts handling out of the hardware interrupt context.

Thanks!

> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
