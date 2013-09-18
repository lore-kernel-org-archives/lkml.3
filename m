Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3IRPVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:21:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34670 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3IRPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:21:50 -0400
Date: Wed, 18 Sep 2013 16:21:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Savchenko <bircoph@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        suspend-devel@lists.sourceforge.net
Subject: Re: [BUG] 3.7-rc regression bisected: s2disk fails to resume image:
 Processes could not be frozen, cannot continue resuming
Message-ID: <20130918152149.GM13318@ZenIV.linux.org.uk>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
 <20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com>
 <20130918135239.GL13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918135239.GL13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 02:52:39PM +0100, Al Viro wrote:
> On Tue, Aug 27, 2013 at 07:48:43AM +0400, Andrew Savchenko wrote:
> > > Additional (but probably useless) information on this bug may be found
> > > here: https://forums.gentoo.org/viewtopic-p-7371120.html
> 
> Something's very fishy there:
> 
> [quote]
> Digging into suspend-utils code shows that the following ioctl fails on      
> "/dev/snapshot":                                                             
>                                                                                 
>                                     Code:                                       
>                           ioctl(dev, _IO(3, 1), 0);                          
> [end quote]
> 
> but that's _not_ anything freeze-related - that's HDIO_GETGEO, and with zero
> as last argument it will fail, no matter what.  With EFAULT, if nothing
> else...
> 
> Which ioctl() it really is?  A bit further down you write "I modified suspend
> code to see errno, so freeze on /dev/snapshot fails [with EAGAIN]", so you
> have isolated the call in question.  Could you quote the actual code?

*scratches head*  _IO('3', 1), perhaps?  At least that would make sense in
such context...  Assuming that's the case, slap
	printk(KERN_INFO "freeze_process() => %d", error);
after the call of freeze_process() in kernel/power/user.c along with
	printk(KERN_INFO "__usermodehelper_disable() => %d", error);
and
	printk(KERN_INFO "try_to_freeze_tasks() => %d", error);
in kernel/power/process.c:freeze_process(), after the calls of
__usermodehelper_disable() and try_to_freeze_tasks() resp.

FWIW, I suspect that it's __usermodehelper_disable() - it does
        retval = wait_event_timeout(running_helpers_waitq,
                                        atomic_read(&running_helpers) == 0,
                                        RUNNING_HELPERS_TIMEOUT);
and returns -EAGAIN on timeout.  I'm not familiar with swsusp code, but
it smells like we end up waiting for linuxrc itself to finish.

Pavel, any suggestions?  If SNAPSHOT_FREEZE really wants everything run
via usermodehelper gone for some reason, what makes /linuxrc different
from e.g /sbin/modprobe?
