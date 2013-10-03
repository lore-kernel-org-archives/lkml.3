Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3JCS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:56:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43433 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3JCS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:56:32 -0400
Date: Thu, 3 Oct 2013 19:56:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pipe/cred lockdep warning
Message-ID: <20131003185630.GJ13318@ZenIV.linux.org.uk>
References: <20131001145755.GA22729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001145755.GA22729@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:57:55AM -0400, Dave Jones wrote:
> I seem to recall hitting this quite a while ago. Does it look familiar ?
> Either it didn't get fixed, or it's back..

> [ 2836.628506] trinity-child0/30759 is trying to acquire lock:
> [ 2836.628544]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81239045>] proc_pid_attr_write+0xf5/0x140
> [ 2836.628624] 
> but task is already holding lock:
> [ 2836.628664]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff811ccf66>] pipe_lock+0x26/0x30
> [ 2836.628734] 

splice to /proc/<pid>/attr/<something> [cred_guard shite under pipe->mutex]

vs.

splice from XFS [pipe->mutex under exclusive iolock]

vs.

read from XFS in execve() [shared iolock under cred_guard]

Note, BTW, that splice to /proc/<pid>/attr/<something> is broken.
proc_pid_attr_write() is *not* supposed to allow partial writes at all.
Frankly, I'd consider adding a ->splice_write() instance that would
simply return -EINVAL there...
