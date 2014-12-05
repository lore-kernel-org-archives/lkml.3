Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaLEQDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:03:30 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:26240
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbaLEQD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:03:29 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/1] mm: Fix a deadlock in the hotplug code
Thread-Topic: [PATCH 1/1] mm: Fix a deadlock in the hotplug code
Thread-Index: AQHQDmdjWvVi0rQbtEiOZ+gv09oPVpyAirAAgAChjeA=
Date: Fri, 5 Dec 2014 16:03:26 +0000
Message-ID: <BY2PR0301MB0711CEB6E2CC2D227EF1CF02A0790@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417553218-12339-1-git-send-email-kys@microsoft.com>
 <54814EFC.5020904@jp.fujitsu.com>
In-Reply-To: <54814EFC.5020904@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:64c0:5863:544c:df26]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 04163EF38A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(13464003)(51704005)(479174003)(377454003)(24454002)(189002)(164054003)(2656002)(74316001)(64706001)(122556002)(87936001)(99396003)(31966008)(33656002)(19580405001)(50986999)(76176999)(62966003)(19580395003)(107046002)(97736003)(120916001)(77156002)(101416001)(21056001)(54606007)(54206007)(106356001)(20776003)(110136001)(86362001)(575784001)(102836002)(15975445007)(105586002)(68736005)(86612001)(4396001)(46102003)(92566001)(106116001)(54356999)(40100003)(76576001)(99286002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Yasuaki Ishimatsu [mailto:isimatu.yasuaki@jp.fujitsu.com]
> Sent: Thursday, December 4, 2014 10:22 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; olaf@aepfle.de; apw@canonical.com;
> linux-mm@kvack.org
> Subject: Re: [PATCH 1/1] mm: Fix a deadlock in the hotplug code
> 
> (2014/12/03 5:46), K. Y. Srinivasan wrote:
> > Andy Whitcroft <apw@canonical.com> initially saw this deadlock. We
> > have seen this as well. Here is the original description of the
> > problem (and a potential solution) from Andy:
> >
> > https://lkml.org/lkml/2014/3/14/451
> >
> > Here is an excerpt from that mail:
> >
> > "We are seeing machines lockup with what appears to be an ABBA
> > deadlock in the memory hotplug system.  These are from the 3.13.6 based
> Ubuntu kernels.
> > The hv_balloon driver is adding memory using add_memory() which takes
> > the hotplug lock, and then emits a udev event, and then attempts to
> > lock the sysfs device.  In response to the udev event udev opens the
> > sysfs device and locks it, then attempts to grab the hotplug lock to online
> the memory.
> > This seems to be inverted nesting in the two cases, leading to the hangs
> below:
> >
> > [  240.608612] INFO: task kworker/0:2:861 blocked for more than 120
> seconds.
> > [  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120
> seconds.
> >
> > I note that the device hotplug locking allows complete retries (via
> > ERESTARTSYS) and if we could detect this at the online stage it could
> > be used to get us out.  But before I go down this road I wanted to
> > make sure I am reading this right.  Or indeed if the hv_balloon driver
> > is just doing this wrong."
> >
> > This patch is based on Andy's analysis and suggestion.
> 
> How about use lock_device_hotplug() before calling add_memory() in
> hv_mem_hot_add()?
> Commit 0f1cfe9d0d06 (mm/hotplug: remove stop_machine() from
> try_offline_node()) said:
> 
>   ---
>     lock_device_hotplug() serializes hotplug & online/offline operations.  The
>     lock is held in common sysfs online/offline interfaces and ACPI hotplug
>     code paths.
> 
>     And here are the code paths:
> 
>     - CPU & Mem online/offline via sysfs online
>         store_online()->lock_device_hotplug()
> 
>     - Mem online via sysfs state:
>         store_mem_state()->lock_device_hotplug()
> 
>     - ACPI CPU & Mem hot-add:
>         acpi_scan_bus_device_check()->lock_device_hotplug()
> 
>     - ACPI CPU & Mem hot-delete:
>         acpi_scan_hot_remove()->lock_device_hotplug()
>   ---
> 
> CPU & Memory online/offline/hotplug are serialized by
> lock_device_hotplug().
> So using lock_device_hotplug() solves the ABBA issue.

Thank you!  I will make the necessary adjustments including exporting the relevant
Functions lock/unlock the device_hotplug lock.

Regards,

K. Y
> 
> Thanks,
> Yasuaki Ishimatsu
> 
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >   mm/memory_hotplug.c |   24 +++++++++++++++++-------
> >   1 files changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c index
> > 9fab107..e195269 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -104,19 +104,27 @@ void put_online_mems(void)
> >
> >   }
> >
> > -static void mem_hotplug_begin(void)
> > +static int mem_hotplug_begin(bool trylock)
> >   {
> >   	mem_hotplug.active_writer = current;
> >
> >   	memhp_lock_acquire();
> >   	for (;;) {
> > -		mutex_lock(&mem_hotplug.lock);
> > +		if (trylock) {
> > +			if (!mutex_trylock(&mem_hotplug.lock)) {
> > +				mem_hotplug.active_writer = NULL;
> > +				return -ERESTARTSYS;
> > +			}
> > +		} else {
> > +			mutex_lock(&mem_hotplug.lock);
> > +		}
> >   		if (likely(!mem_hotplug.refcount))
> >   			break;
> >   		__set_current_state(TASK_UNINTERRUPTIBLE);
> >   		mutex_unlock(&mem_hotplug.lock);
> >   		schedule();
> >   	}
> > +	return 0;
> >   }
> >
> >   static void mem_hotplug_done(void)
> > @@ -969,7 +977,9 @@ int __ref online_pages(unsigned long pfn, unsigned
> long nr_pages, int online_typ
> >   	int ret;
> >   	struct memory_notify arg;
> >
> > -	mem_hotplug_begin();
> > +	ret = mem_hotplug_begin(true);
> > +	if (ret)
> > +		return ret;
> >   	/*
> >   	 * This doesn't need a lock to do pfn_to_page().
> >   	 * The section can't be removed here because of the @@ -1146,7
> > +1156,7 @@ int try_online_node(int nid)
> >   	if (node_online(nid))
> >   		return 0;
> >
> > -	mem_hotplug_begin();
> > +	mem_hotplug_begin(false);
> >   	pgdat = hotadd_new_pgdat(nid, 0);
> >   	if (!pgdat) {
> >   		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
> @@
> > -1236,7 +1246,7 @@ int __ref add_memory(int nid, u64 start, u64 size)
> >   		new_pgdat = !p;
> >   	}
> >
> > -	mem_hotplug_begin();
> > +	mem_hotplug_begin(false);
> >
> >   	new_node = !node_online(nid);
> >   	if (new_node) {
> > @@ -1684,7 +1694,7 @@ static int __ref __offline_pages(unsigned long
> start_pfn,
> >   	if (!test_pages_in_a_zone(start_pfn, end_pfn))
> >   		return -EINVAL;
> >
> > -	mem_hotplug_begin();
> > +	mem_hotplug_begin(false);
> >
> >   	zone = page_zone(pfn_to_page(start_pfn));
> >   	node = zone_to_nid(zone);
> > @@ -2002,7 +2012,7 @@ void __ref remove_memory(int nid, u64 start,
> u64
> > size)
> >
> >   	BUG_ON(check_hotplug_memory_range(start, size));
> >
> > -	mem_hotplug_begin();
> > +	mem_hotplug_begin(false);
> >
> >   	/*
> >   	 * All memory blocks must be offlined before removing memory.
> > Check
> >
> 

