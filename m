Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBRC3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:29:40 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40992 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753753AbaBRC3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:29:39 -0500
Message-ID: <5302C58E.1070903@hurleysoftware.com>
Date: Mon, 17 Feb 2014 21:29:34 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Document exceptions to work item non-reentrancy
 guarantee
References: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com> <1392687834.10088.17.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1392687834.10088.17.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 08:43 PM, Ben Hutchings wrote:
> On Sat, 2014-02-15 at 14:38 -0500, Peter Hurley wrote:
>> Since commit a2c1c57be8d9fd5b716113c8991d3d702eeacf77,
>>    workqueue: consider work function when searching for busy work items
>> work items whose work functions are re-assigned are no longer guaranteed
>> non-reentrancy with the previously assigned work function. For example,
>>
>>          PREPARE_WORK(&work, funcA)
>>          schedule_work(&work)
>>            .
>>          < funcA starts >
>>            .
>>          PREPARE_WORK(&work, funcB)
>>          schedule_work(&work)
>>
>> funcA() may run concurrently with funcB().
>>
>> The work item non-reentrancy guarantee is a crucial design guarantee
>> which, if violated, may not have obvious consequences. For example,
>> the entire firewire subsystem expects the as-documented per-work item
>> non-reentrancy guarantee, which was the behavior prior to the above
>> commit, not the per-work function + per-work item behavior since.
>>
>> Document the known exceptions to this guarantee.
> [...]
>
> It never would have occurred to me that you could safely change the
> function for a work item that is already scheduled or running.
> Especially given that PREPARE_WORK() is just a simple assignment (i.e.
> no serialisation).

process_one_work() has an established order that safely allows for
resetting the work function and scheduling the work, and further
guaranteeing that the new work function will run.

Further, existing memory barriers ensure that
1. The new work function is visible on all cpus before testing if
    the work is already pending.
2. The new work function is stored as the worker's current function
    before the work is marked as not pending.

If this wasn't possible, then single-threaded workqueues could
not be used for multiple functions without flushing work.

I wonder if the floppy driver is broken too.

Regards,
Peter Hurley


