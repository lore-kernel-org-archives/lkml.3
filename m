Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3JIRXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:23:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33980 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3JIRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:23:40 -0400
Date: Wed, 9 Oct 2013 18:23:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: George Spelvin <linux@horizon.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Message-ID: <20131009172336.GH13318@ZenIV.linux.org.uk>
References: <20131009115502.16230.qmail@science.horizon.com>
 <20131009151853.GA25608@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009151853.GA25608@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 05:18:53PM +0200, Jan Kara wrote:

>   This is really weird. We are delivering a signal to a task. While task is

ITYM "a fatal signal"

> returning from kernel space we are running queued task works and one of

get_signal_to_deliver() notices that the signal has to be dealt with
via default reaction, which happens to be "die, you bastard".  So it
calls do_group_exit().  Which means that we'll never be returning to userland,
so the time to run pending __fput() is now.

> that works is dropping last file reference. Ext4 then does some data
> flushing and at that point we find out irqs are disabled. It isn't really
> clear to me where in that call chain got irqs disabled. I went through it
> and didn't find any such place... If this is reproducible, there would be
> ways to debug this (like irq tracing). Otherwise I'm not sure... I'm CCing
> Al since he was digging in this code recently. Maybe he will have some
> idea.

Note that do_group_exit() is preceded by
                spin_unlock_irq(&sighand->siglock);
so no matter what happened in callers, irq is enabled.  I'd suggest sticking
such BUG_ON() into __fput() and trying to reproduce that crap...
