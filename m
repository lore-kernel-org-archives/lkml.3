Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaFSC37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:29:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64048 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbaFSC3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:29:50 -0400
Message-ID: <53A24B1C.1070004@kernel.dk>
Date: Wed, 18 Jun 2014 19:29:48 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Paolo Valente <paolo.valente@unimore.it>
CC: Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <538926F6.7080409@kernel.dk> <20140531051635.GA19925@mtj.dyndns.org> <538C8A47.1050502@kernel.dk> <0A5218F8-0215-4B4F-959B-EE5AAEFC164A@unimore.it> <20140619014600.GA20100@mtj.dyndns.org>
In-Reply-To: <20140619014600.GA20100@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-18 18:46, Tejun Heo wrote:
> Hello,
>
> On Tue, Jun 17, 2014 at 05:55:57PM +0200, Paolo Valente wrote:
>> In general, with both a smooth but messy and a sharp but clean
>> transformation, there seems to be the following common problems:
>>
>> 1) The main benefits highlighted by Jens, i.e., being able to move
>> back and forth and easily understand what works and what does not,
>> seem to be lost, because, with both solutions, intermediate versions
>> would likely have a worse performance than the current version of
>> cfq.
>
> So, the perfectly smooth and performant transformation is possible,
> it'd be great, but I don't really think that'd be the case.  My
> opinion is that if the infrastructure pieces can be mostly maintained
> while making logical gradual steps it should be fine.  ie. pick
> whatever strategy which seems executable, chop down the pieces which
> get in the way (ie. tear down all the cfq heuristics if you have to),
> transform the base and then build things on top again.  Ensuring that
> each step is logical and keeps working should give us enough safety
> net, IMO.
>
> Jens, what do you think?

I was thinking the same - strip CFQ back down, getting rid of the 
heuristics, then go forward to BFQ. That should be feasible. You need to 
find the common core first.

>> 2) bfq, on one side, does not export some of the sysfs parameters of
>> cfq, such as slice_sync, and, on the other side, uses other common
>> parameters in a different way. For example, bfq turns I/O priorities
>> into throughput shares in a different way than cfq does. As a
>> consequence, existing configurations may break or behave in
>> unexpected ways.
>
> This is why I hate exposing internal knobs without layering proper
> semantic interpretation on top.  It ends up creating unnecessary
> lock-in effect too often just to serve some esoteric cases which
> aren't all that useful.  For knobs which don't make any sense for the
> new scheduler, the appropriate thing to do would be just making them
> noop and generate a warning message when it's written to.
>
> As for behavior change for existing users, any change to scheduler
> does that.  I don't think it's practical to avoid any changes for that
> reason.  I think there already is a pretty solid platform to base
> things on and the way forward is making the changes and iterating as
> testing goes on and issues get reported.

Completely agree, don't worry about that. It's not like we advertise 
hard guarantees on the priorities right now, for instance, so as long as 
the end result isn't orders of magnitude different for the 
classes/levels, then it'll likely be good enough.

Ditto on the sysfs files, as some of those are likely fairly widely 
used. But if we warn and do nothing, then that'll allow us to sort out 
popular uses of it before we (later on) remove the files.

-- 
Jens Axboe

