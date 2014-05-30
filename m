Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaE3MLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:11:30 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50020 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaE3ML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:11:28 -0400
Date: Fri, 30 May 2014 20:11:19 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>, sbradshaw@micron.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: per-cpu counters for in-flight IO accounting
Message-ID: <20140530121119.GA1637@kernel.org>
References: <1399627061-5960-1-git-send-email-m@bjorling.me>
 <1399627061-5960-2-git-send-email-m@bjorling.me>
 <536CE25C.5040107@kernel.dk>
 <536D0537.7010905@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536D0537.7010905@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 10:41:27AM -0600, Jens Axboe wrote:
> On 05/09/2014 08:12 AM, Jens Axboe wrote:
> > On 05/09/2014 03:17 AM, Matias Bjørling wrote:
> >> With multi-million IOPS and multi-node workloads, the atomic_t in_flight
> >> tracking becomes a bottleneck. Change the in-flight accounting to per-cpu
> >> counters to elevate.
> > 
> > The part stats are a pain in the butt, I've tried to come up with a
> > great fix for them too. But I don't think the percpu conversion is
> > necessarily the right one. The summing is part of the hotpath, so percpu
> > counters aren't necessarily the right way to go. I don't have a better
> > answer right now, otherwise it would have been fixed :-)
> 
> Actual data point - this slows my test down ~14% compared to the stock
> kernel. Also, if you experiment with this, you need to watch for the
> out-of-core users of the part stats (like DM).

I had a try with Matias's patch. Performance actually boost significantly.
(there are other cache line issue though, eg, hd_struct_get). Jens, what did
you run? part_in_flight() has 3 usages. 2 are for status output, which are cold
path. part_round_stats_single() uses it too, but it's a cold path too as we
simple data every jiffy. Are you using HZ=1000? maybe we should simple the data
every 10ms instead of every jiffy?

Thanks,
Shaohua
