Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaDWViB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:38:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaDWViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:38:00 -0400
Date: Wed, 23 Apr 2014 23:37:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, joern@logfs.org, peterz@infradead.org,
        akpm@linux-foundation.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
In-Reply-To: <20140423125352.704f9fb2@annuminas.surriel.com>
Message-ID: <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Rik van Riel wrote:

> Echoing values into /proc/sysrq-trigger seems to be a popular way to
> get information out of the kernel. However, dumping information about
> thousands of processes, or hundreds of CPUs to serial console can
> result in IRQs being blocked for minutes, resulting in various kinds
> of cascade failures.
> 
> The most common failure is due to interrupts being blocked for a very
> long time. This can lead to things like failed IO requests, and other
> things the system cannot easily recover from.
> 
> This problem is easily fixable by making __handle_sysrq use RCU
> instead of spin_lock_irqsave.
> 
> This leaves the warning that RCU grace periods have not elapsed for a
> long time, but the system will come back from that automatically.

This, however, will make RCU stall detector to send NMI to all online CPUs 
so that they can dump their stacks.

IOW, this might actually make the whole sysrq dump last for much longer, 
and have the log polluted with all-CPU dumps for no good reason.

I wonder whether explicitly setting rcu_cpu_stall_suppress during sysrq 
handling might be a viable workaround for this.

-- 
Jiri Kosina
SUSE Labs

