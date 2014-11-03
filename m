Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaKCPpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:45:41 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37378 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaKCPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:45:40 -0500
Message-ID: <5457A314.8080806@linux.vnet.ibm.com>
Date: Mon, 03 Nov 2014 09:45:24 -0600
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Streetman <ddstreet@ieee.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
CC: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Daniel Walter <dwalter@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Neil Zhang <zhangwm@marvell.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: use device_online/offline() instead of cpu_up/down()
References: <CALZtONCwrBb+HPY7j7x4R-xmyhajFNCwaS3sns50RMDxHxyiEQ@mail.gmail.com> <1414784494-12573-1-git-send-email-ddstreet@ieee.org>
In-Reply-To: <1414784494-12573-1-git-send-email-ddstreet@ieee.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110315-0025-0000-0000-000005D0BE2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 02:41 PM, Dan Streetman wrote:
> In powerpc pseries platform dlpar operations, Use device_online() and
> device_offline() instead of cpu_up() and cpu_down().
> 
> Calling cpu_up/down directly does not update the cpu device offline
> field, which is used to online/offline a cpu from sysfs.  Calling
> device_online/offline instead keeps the sysfs cpu online value correct.
> The hotplug lock, which is required to be held when calling
> device_online/offline, is already held when dlpar_online/offline_cpu
> are called, since they are called only from cpu_probe|release_store.
> 
> This patch fixes errors on PowerVM systems that have cpu(s) added/removed
> using dlpar operations; without this patch, the
> /sys/devices/system/cpu/cpuN/online nodes do not correctly show the
> online state of added/removed cpus.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>

Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

> ---
> 
> Previous discussion for this:
> https://lkml.org/lkml/2014/10/29/839
> 
>  arch/powerpc/platforms/pseries/dlpar.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
> index 6ad83bd..c22bb1b 100644
> --- a/arch/powerpc/platforms/pseries/dlpar.c
> +++ b/arch/powerpc/platforms/pseries/dlpar.c
> @@ -382,7 +382,7 @@ static int dlpar_online_cpu(struct device_node *dn)
>  			BUG_ON(get_cpu_current_state(cpu)
>  					!= CPU_STATE_OFFLINE);
>  			cpu_maps_update_done();
> -			rc = cpu_up(cpu);
> +			rc = device_online(get_cpu_device(cpu));
>  			if (rc)
>  				goto out;
>  			cpu_maps_update_begin();
> @@ -467,7 +467,7 @@ static int dlpar_offline_cpu(struct device_node *dn)
>  			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
>  				set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
>  				cpu_maps_update_done();
> -				rc = cpu_down(cpu);
> +				rc = device_offline(get_cpu_device(cpu));
>  				if (rc)
>  					goto out;
>  				cpu_maps_update_begin();
> 

