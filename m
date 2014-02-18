Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaBRQbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:31:24 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60234 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750961AbaBRQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:31:22 -0500
Message-ID: <53038AD6.9080609@hurleysoftware.com>
Date: Tue, 18 Feb 2014 11:31:18 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Document exceptions to work item non-reentrancy
 guarantee
References: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com> <1392687834.10088.17.camel@deadeye.wl.decadent.org.uk> <5302C58E.1070903@hurleysoftware.com> <20140218153056.GC30043@htj.dyndns.org>
In-Reply-To: <20140218153056.GC30043@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 10:30 AM, Tejun Heo wrote:
> On Mon, Feb 17, 2014 at 09:29:34PM -0500, Peter Hurley wrote:
>>> It never would have occurred to me that you could safely change the
>>> function for a work item that is already scheduled or running.
>>> Especially given that PREPARE_WORK() is just a simple assignment (i.e.
>>> no serialisation).
>>
>> process_one_work() has an established order that safely allows for
>> resetting the work function and scheduling the work, and further
>> guaranteeing that the new work function will run.
>>
>> Further, existing memory barriers ensure that
>> 1. The new work function is visible on all cpus before testing if
>>     the work is already pending.
>> 2. The new work function is stored as the worker's current function
>>     before the work is marked as not pending.
>>
>> If this wasn't possible, then single-threaded workqueues could
>> not be used for multiple functions without flushing work.
>>
>> I wonder if the floppy driver is broken too.
>
> Ugh... I'd just rather remove PREPARE_WORK altogether.

Ok.

That doesn't make the use-case go away; it simply moves it outside
the workqueue subsystem.

For example, in the case of the firewire subsystem, this technique
was used to essentially single-thread per-device work using only one
designated workqueue for all devices. The possibility of accidentally
running a work item 2x is a non-issue since the device state is
managed atomically.

Of the other use cases in the kernel, it seems only the floppy
driver uses a similar technique. But maybe that's ok because it's
on a single-threaded workqueue.

USB and AFS use PREPARE_{DELAYED}_WORK to reschedule from within
the current work function to a new function, which seems ok.

fwserial already serializes its use of PREPARE_WORK with &peer->lock
(and checks if the work is already pending).

> It's a pretty dumb thing to do anyway.

Fragile, yes; dumb, no. At least not from the point-of-view of the
documentation and what the workqueue actually did. But obviously from
your reaction, unintentional design.

> I'll look into it.

Thanks.

Regards,
Peter Hurley

