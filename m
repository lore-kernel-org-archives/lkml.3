Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab3E2SHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:07:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:36806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986Ab3E2SGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:06:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="345121443"
Date: Wed, 29 May 2013 11:06:52 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank =?iso-8859-1?Q?L=F6mker?= <Frank.Loemker@isa.de.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: xhci: Use non-interruptible sleep for XHCI commands
Message-ID: <20130529180652.GJ32085@xanatos>
References: <1369445977-31404-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369445977-31404-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really wish you had contacted me about this issue before writing code
to fix it.  Now I don't know the backstory behind this issue, which
makes it hard to evaluate whether this fix is correct.

On Fri, May 24, 2013 at 06:39:37PM -0700, Julius Werner wrote:
> The XHCI stack usually uses wait_for_completion_interruptible_timeout()
> to wait for the completion of an XHCI command, and treats both timeouts
> and interruptions as errors. This is a bad idea, since these commands
> are often essential for the correct operation of the USB stack, and
> their failure can leave devices in a misconfigured and/or unusable
> state.

What causes the devices to be "unusable"?  If a Configure Endpoint
command fails, the USB core is supposed to try to put the device back
into its original state.  Is there a mismatch caused by the command
being interrupted, and if so, how can we fix it, rather than allowing
the kernel to go into an uninterruptible sleep?

> While a timeout probably means a real problem that needs to be
> dealt with, a random signal to the controlling user-space process should
> not cause such harsh consequences.

We should deal with the canceled command gracefully, rather than
papering over the issue.

> This patch changes that behavior to use uninterruptible waits instead.
> It fixes an easy to reproduce bug that occurs when you kill -9 a
> process that reads from a UVC camera. The UVC driver's release code
> tries to set the camera's alternate setting back to 0, but the lingering
> SIGKILL instantly aborts any Stop Endpoint or Configure Endpoint command
> sent to the xHC. The code dies halfway through the bandwidth allocation
> process, leaving the device in an active configuration and preventing
> future access to it due to the now out-of-sync bandwidth calculation.

Obviously the command handling needs to be re-worked so this bandwidth
mismatch doesn't happen.  What I would like to see instead (but have not
had time to implement) is a global command queue manager.  It would have
a queue of commands, similar to what we do for the TD lists, but only
one list per xhci_hcd.  The command queue manager would handle
cancellation requests, and properly keep track of whether each command
completed.

Functions submitting commands would all have a unique completion, and
wait (interruptibly) on that completion.  Commands that are interrupted
with a signal should attempt to cancel the command, and wait on the
completion to see if their command was canceled or successfully
completed.  If it was successfully completed, it should return success,
rather than -ETIMEOUT.

I think that change will fix the case where the bandwidth allocation
gets out-of-sync with the USB core, but since you haven't shared the
details of how the code handles being interrupted, I can't tell whether
this is actually a good solution.

Sarah Sharp
