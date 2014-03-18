Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbaCRTIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:08:53 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42904 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaCRTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:08:51 -0400
Message-ID: <532899B2.2060106@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 00:38:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        patrick.marlier@gmail.com, viresh.kumar@linaro.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH v3 0/2] Add stop callback to the cpufreq_driver interface.
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com> <1395163361-26380-1-git-send-email-dirk.j.brandewie@intel.com>
In-Reply-To: <1395163361-26380-1-git-send-email-dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031819-2000-0000-0000-0000103D2C59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:52 PM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>

I don't mean to nitpick, but generally its easier to deal with
patchsets if you post the subsequent versions in fresh email threads.
Otherwise it can get a bit muddled along with too many other email
discussions in the same thread :-(
 
> Changes: 
> v2->v3
> Changed the calling of the ->stop() callback to be conditional on the
> core being the last core controlled by a given policy.
> 

Wait, why? I'm sorry if I am not catching up with the discussions on
this issue quickly enough, but I don't see why we should make it
conditional on _that_. I thought we agreed that we should make it
conditional in the sense that ->stop() should be invoked only for
->setpolicy drivers, right?

The way I look at it, ->stop() gives you a chance to stop managing
the CPU going offline. As in "stop this CPU". ->exit() is your chance
to cleanup the policy, since all its users have gone offline (or this
is the last CPU belonging to that policy which is going offline).

With this in mind, we should invoke ->stop() every time we take a
CPU offline, and invoke ->exit() only when the last CPU in the policy
goes offline.

What am I missing?

Regards,
Srivatsa S. Bhat

> v1->2
> Change name of callback function added to cpufreq_driver interface.
> 
> Some drivers (intel_pstate) need to modify state on a core before it
> is completely offline.  The ->exit() callback is executed during the
> CPU_POST_DEAD phase of the cpu offline process which is too late to
> change the state of the core.
> 
> Patch 1 adds an optional callback function to the cpufreq_driver
> interface which is called by the core during the CPU_DOWN_PREPARE
> phase of cpu offline in __cpufreq_remove_dev_prepare().
> 
> Patch 2 changes intel_pstate to use the ->stop callback to do
> its cleanup during cpu offline. 
> 
> Dirk Brandewie (2):
>   cpufreq: Add exit_prepare callback to cpufreq_driver interface
>   intel_pstate: Set core to min P state during core offline
> 
>  Documentation/cpu-freq/cpu-drivers.txt |  8 +++++++-
>  drivers/cpufreq/cpufreq.c              |  3 +++
>  drivers/cpufreq/intel_pstate.c         | 20 +++++++++++++-------
>  include/linux/cpufreq.h                |  1 +
>  4 files changed, 24 insertions(+), 8 deletions(-)
> 


