Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3D2Ede (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 00:33:34 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54018 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3D2Edd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 00:33:33 -0400
Message-ID: <517DF770.6020402@linux.vnet.ibm.com>
Date: Mon, 29 Apr 2013 10:00:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH] cpu: rid cpu_hotplug_disabled check for cpu_down()
References: <1367203791-9723-1-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1367203791-9723-1-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042904-5490-0000-0000-0000035D2B25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 08:19 AM, liguang wrote:
> in cpu_down(), _cpu_down() will do
> "
>         if (num_online_cpus() == 1)
>                  return -EBUSY;
> "
> when cpu_hotplug_disabled was set, num_online_cpus
> will return 1 for there's only 1 boot cpu.
> so, it's unnecessary to check cpu_hotplug_disabled
> here.
>

The 2 checks serve very different purposes; they are not the same!

The num_online_cpus() check is to ensure that the user doesn't do
something insane like trying to offline the last online CPU in the
system.

Whereas, the flag 'cpu_hotplug_disabled' is used to prevent user-
triggered CPU hotplug (such as those initiated through sysfs).
This is useful in cases where the system itself wants to initiate CPU
hotplug and it doesn't want annoying races with CPU hotplug going
on in parallel due to other reasons. One such case is suspend/resume.
That's why, if you have noticed, the suspend/resume code invokes the
_cpu_down() version, in order to bypass the flag and get its job done.

So, no, I think the check needs to stay.

Regards,
Srivatsa S. Bhat

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/cpu.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index b5e4ab2..cd166d3 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -330,14 +330,8 @@ int __ref cpu_down(unsigned int cpu)
> 
>  	cpu_maps_update_begin();
> 
> -	if (cpu_hotplug_disabled) {
> -		err = -EBUSY;
> -		goto out;
> -	}
> -
>  	err = _cpu_down(cpu, 0);
> 
> -out:
>  	cpu_maps_update_done();
>  	return err;
>  }
> 

