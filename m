Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab3GKOXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:23:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34103 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755894Ab3GKOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:23:20 -0400
Date: Thu, 11 Jul 2013 10:23:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Lan Tianyu <lantianyu1986@gmail.com>,
        =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, <tianyu.lan@intel.com>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
In-Reply-To: <51DE4F44.6060506@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1307111010180.1276-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Srivatsa S. Bhat wrote:

> Oops! You are right. Hmm, this looks quite difficult to get right :(
> There are multiple challenges here:
> 
> 1. The sysfs files must not be removed during cpu_down, and not initialized
> 
>    during cpu_up. That would help us preserve the file permissions.
> 2. But we should ensure that we really do the cpufreq-core parts of the cpu
>    initialization during cpu_up. If we fail to free some of the data-structures
>    during cpu_down, the cpu_up callback will think that a full-init is not
>    required and not do its job. That will make cpufreq behave erratically after
>    suspend/resume and take us back to square one.
> 
> 3. A full re-init in the cpu_up callback also involves memory allocations.
>    So if we don't release the memory in the cpu_down callback, we'll end up
>    in a memory leak.
> 
> I tried to address all these in this patch, but you found yet another serious
> loop-hole. I guess I'm out of ideas now... if anybody has any thoughts on how
> to get this right, then I'm all ears. Else, we'll just revert the original
> commit like Rafael suggested and leave it upto userspace to save and restore
> the permissions across suspend/resume if it wants ;-(

Asking as a naive outsider who is completely unfamiliar with the code,
why are any of these things at all troublesome?

	Can't cpu_up tell the difference between activating a brand-new
	CPU and reactivating one that was present before but was
	temporarily disabled?

	Doesn't cpu_up know which data structures get freed when an
	active CPU is temporarily deactivated?

	Doesn't cpu_down know what memory gets allocated in cpu_up?
	Can't it deallocate just the right parts for the type of
	transition it is doing?

It sounds like you're really asking how to make sure that cpu_up and 
cpu_down both know what the other is doing, so that each can do the 
opposite of the other.  That doesn't sound hard.

Alan Stern

