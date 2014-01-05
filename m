Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbaAEH5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 02:57:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaAEH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 02:57:11 -0500
Date: Sat, 4 Jan 2014 23:57:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] printk: Hand over printing to console if printing
 too long
Message-Id: <20140104235743.e6714e29.akpm@linux-foundation.org>
In-Reply-To: <1387831171-5264-10-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
	<1387831171-5264-10-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013 21:39:30 +0100 Jan Kara <jack@suse.cz> wrote:

> Currently, console_unlock() prints messages from kernel printk buffer to
> console while the buffer is non-empty. When serial console is attached,
> printing is slow and thus other CPUs in the system have plenty of time
> to append new messages to the buffer while one CPU is printing. Thus the
> CPU can spend unbounded amount of time doing printing in console_unlock().
> This is especially serious problem if the printk() calling
> console_unlock() was called with interrupts disabled.
> 
> In practice users have observed a CPU can spend tens of seconds printing
> in console_unlock() (usually during boot when hundreds of SCSI devices
> are discovered) resulting in RCU stalls (CPU doing printing doesn't
> reach quiescent state for a long time), softlockup reports (IPIs for the
> printing CPU don't get served and thus other CPUs are spinning waiting
> for the printing CPU to process IPIs), and eventually a machine death
> (as messages from stalls and lockups append to printk buffer faster than
> we are able to print). So these machines are unable to boot with serial
> console attached. Also during artificial stress testing SATA disk
> disappears from the system because its interrupts aren't served for too
> long.
> 
> This patch implements a mechanism where after printing specified number
> of characters (tunable as a kernel parameter printk.offload_chars), CPU
> doing printing asks for help by setting a 'hand over' state. The CPU
> still keeps printing until another CPU running printk() or a CPU being
> pinged by an IPI comes and takes over printing.  This way no CPU should
> spend printing too long if there is heavy printk traffic.

It all seems to rely on luck?  If there are 100k characters queued and
all the other CPUs stop calling printk(), the CPU which is left in
printk is screwed, isn't it?  If so, perhaps it can send an async IPI
to ask for help?
