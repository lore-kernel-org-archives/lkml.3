Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3BDPGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:06:50 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:43678 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3BDPGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:06:48 -0500
Date: Mon, 04 Feb 2013 09:06:44 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [docs] /proc/irq/
To: Oleg <lego12239@yandex.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20130130094432.GA30556@localhost> (from lego12239@yandex.ru on
	Wed Jan 30 03:44:32 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1359990404.12062.9@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 03:44:32 AM, Oleg wrote:
>   Hello.
> 
>   Where can i find an info about /proc/irq/*/affinity_hint ?
>   Documentation/filesystems/proc.txt says nothing about it (3.2.37  
> kernel).

The general procedure is to look for the git commit, which may have a  
good commit comment, and also gives you an idea when it went in so you  
can look in the mailing list archives:

cd linux
find . -name '"affinity_hint"'
git annotate kernel/proc/irq.c
(search for "affinity_hint" in quotes, line 331 here, the bit on the  
left edge is the commit hash.)

commit e7a297b0d7d6049bd4e423ac1e17da31e4c401b8
Author: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Date:   Fri Apr 30 14:44:50 2010 -0700

     genirq: Add CPU mask affinity hint

     This patch adds a cpumask affinity hint to the irq_desc structure,
     along with a registration function and a read-only proc entry for  
each
     interrupt.

     This affinity_hint handle for each interrupt can be used by  
underlying
     drivers that need a better mechanism to control interrupt affinity.
     The underlying driver can register a cpumask for the interrupt,  
which
     will allow the driver to provide the CPU mask for the interrupt to
     anything that requests it.  The intent is to extend the userspace
     daemon, irqbalance, to help hint to it a preferred CPU mask to  
balance
     the interrupt into.

     [ tglx: Fixed compile warnings, added WARN_ON, made SMP only ]

     Signed-off-by: Peter P Waskiewicz Jr  
<peter.p.waskiewicz.jr@intel.com>

That doesn't clarifiy much. Grepping the source for irq_affinity it  
looks like the kernel treats this as a write-only property, and never  
does anything with the info. However, include/linux/irqdesc.h has  
documentation for the structure containing the property, and it says  
this about that field:

  * @affinity_hint:      hint to user space for preferred irq affinity

So this "irqbalance" daemon you're probably not running (unless it got  
sucked into the systemd hairball, in which case you don't know you're  
running it and can't stop it) reads this process and tells the kernel  
to move the irq worker thread to this CPU while load balancing.

It sounds like you're saying Documentation/filesystems/proc.txt should  
be updated to include this information?

Rob