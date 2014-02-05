Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBEOvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:51:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:65297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaBEOvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:51:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,786,1384329600"; 
   d="scan'208";a="478488246"
Message-ID: <52F251FD.1080503@linux.intel.com>
Date: Wed, 05 Feb 2014 17:00:13 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv2 01/10] xhci: Use command structures when calling xhci_configure_endpoint
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>	<1391091027-31783-2-git-send-email-mathias.nyman@linux.intel.com> <CAPcyv4gqcf2b8Yv-rqg0OiEeOeN4P4g-um+oYzMDXW6Y7N8qeQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gqcf2b8Yv-rqg0OiEeOeN4P4g-um+oYzMDXW6Y7N8qeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 04:21 AM, Dan Williams wrote:
> Hi Mathias, comments below:
>
> s/xhci_check_bandwith/xhci_check_bandwidth/
> s/strucure/structure/
> s/strucure/structure/
> s/requre/require/
> s/strucure/structure/
>

Thanks
I guess I need to start using a spell checker for commit messages.

>
> One cleanup we may want to consider in this series is making
> xhci_alloc_command() more readable.  My brain hurts when I see "false,
> false" as I wonder what that means.  I took a look and of the 4
> possible ways to call xhci_alloc_command, we only use 2:
>
> $ git grep xhci_alloc_command\(.*\) | grep -o
> xhci_alloc_command\(xhci,.*,.*, | sort -u
> xhci_alloc_command(xhci, false, true,
> xhci_alloc_command(xhci, true, true,
>
> So a first take is to just have a xhci_alloc_command() for "true,
> true" and a xhci_alloc_command_no_ctx() for "false, true".
>
> ...uh oh, this series adds a usage of:
> xhci_alloc_command(xhci, false, false,
>
> ...any reason we can't just use something like
> xhci_alloc_command_no_ctx() instead?
>
> Actually just make xhci_alloc_command() take an option in_ctx
> parameter, when it is NULL xhci_alloc_command will allocate one,
> otherwise it will use the passed in one.
>

This would make the code more readable.
The same thing needs to be done for the completion parameter as well then.

Do you think this change would fit in this patch series, or maybe as a 
separate fix?

>>                  xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
>>                                  "Queueing configure endpoint command");
>>                  xhci_queue_configure_endpoint(xhci,
>>                                  xhci->devs[slot_id]->in_ctx->dma, slot_id,
>>                                  false);
>>                  xhci_ring_cmd_db(xhci);
>> +               kfree(command);
>
> It's not really acceptable to add dead code in a patch.  Consider the
> case where some of the patches are reverted due to a regression.  If,
> for example we revert patch 2, the unused infrastructure in patch1
> does not get deleted.  Patch size minimization is good, but not when
> it separates new infrastructure from its first user.

This was a tradeoff I wasn't sure how to do. The first six patches make 
sure there exists a command structure every time a command is submitted. 
I added the kfrees because I didn't want to leak memory
up to the patch where the command can be freed in its right place (patch 
9).

Actually, now looking at it, the command is still not properly freed
between patches 7 and 9.

Any suggestions? squashing first most of the commits together, or just 
ignoring that memory is leaked mid-series?

>> -bandwidth_change:
>> -       xhci_dbg_trace(xhci,  trace_xhci_dbg_context_change,
>> -                       "Completed config ep cmd");
>> -       virt_dev->cmd_status = cmd_comp_code;
>> -       complete(&virt_dev->cmd_completion);
>>          return;
>
> This change has no description in the change log.  What's the reason
> for deleting the goto?
>

Previously xhci_configure_endpoint() could also be called without a 
command parameter. In this case the completion was _not_ added to 
device's own "command wait list". xhci_configure_endpoint() would wait 
for completion on xhci->devs[udev->slot_id]->cmd_completion, and
the code after the bandwith_change goto was run.

Now this patch forces all xhci_configure_endpoint() callers to have a 
command structure parameter, and now in all cases we're waiting for a 
configure endpoint completion, the completion is added to the device's 
own "command wait list". These completions are called in the beginning 
of handle_cmd_completion_ep by handle_cmd_in_cmd_wait_list().

I probably should add some description about this in the changelog as well.

>
> Given that we are waiting for the command to finish within
> xhci_configure_endpoint() shouldn't we free the completion in
> xhci_configure_endpoint as well?  In other words in what cases do we
> need an xhci_command to have a longer lifetime than the scope of the
> execution routine (xhci_stop_device, xhci_configure_endpoint,
> xhci_discover_or_reset_device, xhci_alloc_dev, xhci_setup_device).

Many of the functions that call xhci_configure_endpoint() handle their
command strucure and completion allocation/freeing in their own little 
way. I didn't want to mess with these.

For example
xhci_free_streams() uses some pre-allocated command strucure
command = vdev->eps[ep_index].stream_info->free_streams_command;

while xhci_update_hub_device() allocates a new command with completion 
before calling xhci_configure_endpoint(), and frees them both afterwards


>
> Taking things a step further it seems that all the locations where we
> asynchronously queue commands are in the completion handlers for other
> commands.  I'm wondering if this would be cleaner if we simply queued
> all command submissions and completion events to a single threaded
> workqueue.  I'll go through the rest of the series to see if that
> impression makes sense, but something to consider...
>

Handling the command completions in a workqueue could make sense, then 
all the async-queued commands could be allocated outside interrupt 
context. Not sure if this would expose or create some new races.

I'm not completely sure on what you have in mind when you say you want 
to "queue all command submission and completion events to a single 
threaded workqueue"

Thanks for taking a look at this

-Mathias
