Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3GJX5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:57:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36347 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GJX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:57:24 -0400
Date: Thu, 11 Jul 2013 00:51:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Simon Horman <horms@verge.net.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] kexec: return error of machine_kexec() fails
Message-ID: <20130710235147.GZ24642@n2100.arm.linux.org.uk>
References: <1373421296-6112-1-git-send-email-horms@verge.net.au> <87obaaiiry.fsf@xmission.com> <51DDB159.2080003@wwwdotorg.org> <87txk2cfkm.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txk2cfkm.fsf@xmission.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 01:42:17PM -0700, Eric W. Biederman wrote:
> I meant code not hardware architecture.  We keep having code thrown in
> the the shutdown paths because ARM only supports cpu shutdown via cpu
> hotunplug and cpu hotunplug is not universally available.
> 
> That is a software architecture BUG with the ARM kernels.

There are many problems here:

1) if you can't place a CPU individually into reset, what do you do with
it over a kexec?

Once woken it executes code.  It will never stop executing code.  If you
place it inside an infinite loop in the existing kernel, and then
overwrite it, it will then start executing the instructions there when
the new kernel broadcasts the cache flushes, and it will start executing
whatever code is there.

2) if the CPU itself needs to execute code to shut itself down, how do
you get it to do that on a crash-based kexec when IPI broadcasts may not
work?

3) what about situations where you need the requestor to also do something
to shut down the secondary CPU?

Taking CPUs offline is not an easy thing to do when every platform plays
their own games with doing that, and then you have security crap that
gets in the way too, with the security crap having platform specific
interfaces.

CPU hotplug is by far the best solution we have to this mess.
