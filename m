Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaCMXJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:09:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaCMXJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:09:17 -0400
Date: Thu, 13 Mar 2014 16:09:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] kernel: Avoid softlockups in stop_machine() during
 heavy printing
Message-Id: <20140313160915.17f0a285ae1cde36dbc76399@linux-foundation.org>
In-Reply-To: <1394726318-2757-7-git-send-email-jack@suse.cz>
References: <1394726318-2757-1-git-send-email-jack@suse.cz>
	<1394726318-2757-7-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 16:58:38 +0100 Jan Kara <jack@suse.cz> wrote:

> When there are lots of messages accumulated in printk buffer, printing
> them (especially over serial console) can take a long time (tens of
> seconds). stop_machine() will effectively make all cpus spin in
> multi_cpu_stop() waiting for the CPU doing printing to print all the
> messages which triggers NMI softlockup watchdog and RCU stall detector
> which add even more to the messages to print. Since machine doesn't do
> anything (except serving interrupts) during this time, also network
> connections are dropped and other disturbances may happen.
> 
> Paper over the problem by waiting for printk buffer to be empty before
> starting to stop CPUs. In theory a burst of new messages can be appended
> to the printk buffer before CPUs enter multi_cpu_stop() so this isn't a 100%
> solution but it works OK in practice and I'm not aware of a reasonably
> simple better solution.
> 

Yes it's rather hacky, but it's simple and direct and explicit and
obvious.  It's the stealth hackiness which causes harm.

