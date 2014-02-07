Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaBGNPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:15:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53504 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754451AbaBGLsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Patch v1] ACPI, x86: fix bug in associating hot-added CPUs with corresponding NUMA node
Date: Fri, 07 Feb 2014 13:03:06 +0100
Message-ID: <1440384.cOMzyfyUzg@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <52F4A4B9.2060006@linux.intel.com>
References: <1390185115-26850-1-git-send-email-jiang.liu@linux.intel.com> <4676819.HL23G4Egmr@vostro.rjw.lan> <52F4A4B9.2060006@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 05:17:45 PM Jiang Liu wrote:
> 
> On 2014/2/5 8:14, Rafael J. Wysocki wrote:
> > On Monday, January 20, 2014 10:31:54 AM Jiang Liu wrote:
> >> Current ACPI cpu hotplug driver fails to associate hot-added CPUs with
> >> corresponding NUMA node when doing socket online. The code path to
> >> associate CPU with NUMA node is as below:
> >> acpi_processor_add()
> >>     ->acpi_processor_get_info()
> >> 	->acpi_processor_hotadd_init()
> >> 	    ->acpi_map_lsapic()
> >> 		->_acpi_map_lsapic()
> >> 		    ->acpi_map_cpu2node()
> >> cpu_subsys_online()
> >>     ->try_online_node()
> >> 	->node_set_online()
> >>
> >> When doing socket online, a new NUMA node is introduced in addition to
> >> hot-added CPU and memory device. And the new NUMA node is marked as
> >> online when onlining hot-added CPUs through sysfs interface
> >> /sys/devices/system/cpu/cpuxx/online.
> >>
> >> On the other hand, acpi_map_cpu2node() will only build the CPU to node
> >> map if corresponding NUMA node is already online, so it always fails
> >> to associate hot-added CPUs with corresponding NUMA node because the
> >> NUMA node is still in offline state.
> >>
> >> For the fix, we could safely remove the "node_online(node)" check in
> >> function acpi_map_cpu2node() because it's only called for hot-added CPUs
> >> by acpi_processor_hotadd_init().
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > 
> > I wonder what the status here is?  Did this patch go anywhere?
> Hi Rafael,
> 	It's still in review stage, hasn't been accepted by any
> maintainer yet.

OK

Peter, are you fine with the patch below?

Rafael


> > 
> >> ---
> >>  arch/x86/kernel/acpi/boot.c |    8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> >> index 6c0b43b..7625de9 100644
> >> --- a/arch/x86/kernel/acpi/boot.c
> >> +++ b/arch/x86/kernel/acpi/boot.c
> >> @@ -614,10 +614,10 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
> >>  	int nid;
> >>  
> >>  	nid = acpi_get_node(handle);
> >> -	if (nid == -1 || !node_online(nid))
> >> -		return;
> >> -	set_apicid_to_node(physid, nid);
> >> -	numa_set_node(cpu, nid);
> >> +	if (nid != -1) {
> >> +		set_apicid_to_node(physid, nid);
> >> +		numa_set_node(cpu, nid);
> >> +	}
> >>  #endif
> >>  }
> >>  
> >>
> > 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
