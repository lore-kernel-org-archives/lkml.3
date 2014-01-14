Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaANL5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:57:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:10927 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANL5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:57:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="458509757"
Message-ID: <52D5281F.4080108@linux.intel.com>
Date: Tue, 14 Jan 2014 14:05:51 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 00/10] xhci: re-work command queue management
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com> <063D6719AE5E284EB5DD2968C1650D6D45938C@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45938C@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> IMHO the xhci driver is already far too complicated, and this probably just makes
> it even worse.

This is an attempt to make it cleaner and less complicated.
In the end this series removes far more more code than it adds:
5 files changed, 373 insertions(+), 530 deletions(-)

The timers are also simplified, so now we only have one timeout timer 
instead of each command running its own timer.

>
> The fact that you are having to allocate memory ion an ISR ought also to be
> ringing alarm bells.

It did.
Other options are as you said to use a 'software command ring'. Either 
just pre-allocate a full command ring (64 trbs * sizeof(struct 
xhci_command)), roughly 2300 bytes when driver loads,
or then a smaller pool of commands just used for ISR submitted commands.
(We then need to either either expand pool, or start allocating in isr 
if pool is empty)

These solutions require some ring management and possibly expansion 
code, and increases the complexity again. I selected this simpler 
approach as I understood that the frequency of commands allocated in ISR 
is quite low.

This also feels like trying to optimize before we get the main
changes working.

>
> Have you considered adding a 'software command ring' (indexed with the
> same value as the hardware one) and using it to hold additional parameters?
>
> It might even be worth only putting a single command into the hardware ring!
> That might simplify the timer code.

This is something I haven't thought about. Could be one possibility, but 
feels like artificially restricting something the HW is designed to care 
of. The timer code isn't that complex anyway. In addition to init/exit 
parts we basically got:

queue_command(...)
{
   if (command list is empty)
     /* start timer for new command added to empty list*/
     mod_timer(cmd_timer, timeout);
}

handle_cmd_completion(...)   /* in ISR */
{
   /* A commandcompleted, remove timeout timer */
   del_timer(cmd_timer)

   do_other_stuff

   if(more commands in list)
     mod_timer(cmd_timer, timeout); /* start timer for next command */
}

>
> This still has a fixed constraint on the number of queued commands, but
> I suspect that is bounded anyway (a few per device?).

64 commands fit on the command ring segment, I'm not aware of any 
per-device limits?

Thanks for the comments and ideas

-Mathias

