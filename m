Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaBDR2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:28:03 -0500
Received: from linuxhacker.ru ([217.76.32.60]:48691 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbaBDR17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:27:59 -0500
Subject: Re: [PATCH 2/4] staging/lustre/obdclass: read jobid from proc
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140204165742.GA19660@kroah.com>
Date: Tue, 4 Feb 2014 12:27:48 -0500
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EDB9D331-03D7-42D4-AD33-6D55122373B6@linuxhacker.ru>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com> <1383132636-8952-2-git-send-email-bergwolf@gmail.com> <20131030132101.GD30087@kroah.com> <20140204061210.GA944142@fiona.linuxhacker.ru> <20140204165742.GA19660@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Feb 4, 2014, at 11:57 AM, Greg Kroah-Hartman wrote:

> What exactly are you doing here?  Calling out to userspace for what
> information?  And how are you going to handle namespaces and containers
> by doing that?  Are you going to block in the kernel for this
> information?
> 
> What are you trying to solve with this code in the first place?

So, as an overview of a feature:

When you have tens of thousand (and even hundreds) of nodes doing IO,
it's no longer practical to tell them apart separately or in some
network-related groups based on their address server-side
(for purposes like monitoring and load control).
Since such systems are usually managed by some sort of a job/batch scheduler,
it's much more natural to organize them into "jobs" as known to the
job scheduler instead. This job id information is harvested and added to
all RPCs so that server side can do useful things with this information
(like aggregate statistics, identify pathologically bad workcases,
QoS and so on).

Most of batch schedulers out there let userspace know their own JOBID as an
environment variable. So original implementation was just harvesting this
info directly from process environment. I certainly can see why this is not
really desirable.

So, the patch does away with the environment parsing, instead it adds two
new venues of getting this information:

1. In vast majorities of cases entire node is dedicated to a single job, so
we just create a /proc variable where you can input job id from job scheduler
prologue (and then clear it from an epilogue). Getting jobid in this case does
does not dip in userspace anymore. This also does not block anywhere.

2. In some more rare systems with lots of cores they actually seem to be subdividing
individual nodes across jobs. Additionally all systems usually have login/interactive
nodes. While these sort of interactive nodes do not have jobs scheduled on them, it
still might be useful to distinguish between different user sessions happening there.
This is where the upcalls come into play. First time a process does IO an upcall
would be called that would provide the kernel with jobid identifier (however it might
want to obtain it, we don't really care at this point). This would block (with a timeout)
for the reply. The reply is then cached and reused for subsequent io from the same process.
I did not really think about containers before, but I think it would work out anyway:
I think namespaces and containers still have non-intersecting pid space so we should be
fine in this regard. There is a "master container"/namespace of some sort I think, that is able to see
entire pid space, and that's where the upcall would be run (do I need to somehow force that?)

Bye,
    Oleg

