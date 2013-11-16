Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3KPFTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 00:19:07 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64423 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3KPFS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 00:18:59 -0500
Date: Sat, 16 Nov 2013 14:18:54 +0900
From: Tejun Heo <tj@kernel.org>
To: Don Morris <don.morris@hp.com>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: 3.10.16 cgroup css_set_lock deadlock
Message-ID: <20131116051854.GB5618@mtj.dyndns.org>
References: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115081929.GA11530@mtj.dyndns.org>
 <5286355A.9060509@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5286355A.9060509@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 15, 2013 at 09:53:14AM -0500, Don Morris wrote:
> Are we getting some other thread from while_each_task()
> repeatedly keeping us in the loop? Or is there something
> else going on? The gut instinct is that calling something
> like while_each_task() on an exiting thread would either
> reliably give other threads in the group or quit [if the
> thread is the only one left in the group or if an exiting
> thread is no longer part of the group], but since that would
> make the continue work, obviously I'm missing something.

Thread group leaders are stable at that point because threadgroup_lock
is held and are guaranteed to show up in while_each_thread traversal;
however, !leaders may already be in the process of exiting by the time
control reaches that point and may not show up in the iteration.  As
RCU lock is held, it'll be *safe* to initiate or continue iteration
from it but when the iteration comes around, there's no guarantee that
it'll be included in it and the term condition depends on it showing
up again.  That's what I remember anyway.  Li, please correct me if
I'm mistaken.

Thanks.

-- 
tejun
