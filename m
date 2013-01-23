Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3AWAkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:40:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:29438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3AWAkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:40:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,518,1355126400"; 
   d="scan'208";a="277209266"
Message-ID: <1358901594.7408.85.camel@yhuang-dev>
Subject: Re: ERST: how to avoid a dynamic memory allocation in panic case
From: Huang Ying <ying.huang@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "robert.moore@intel.com" <robert.moore@intel.com>,
        "trenn@suse.de" <trenn@suse.de>,
        "myron.stowe@redhat.com" <myron.stowe@redhat.com>
Date: Wed, 23 Jan 2013 08:39:54 +0800
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A51F3D@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A51F3D@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 23:30 +0000, Seiji Aguchi wrote:
> [Issue]
> 
> Current erst driver is kicked in panic case.
> On the other hand, a dynamic memory allocation seems to run in it
> with a following code path.
> 
> erst_writer -> erst_write -> __erst_write_to_storage -> many of apei_exec_run -> 
> ctx->ins_table[entry->instruction].run()
> 
> which are functions defined in erst_ins_type table i.e:
> 
> apei_exec_read_register -> apei_read -> acpi_os_read_memory64 -> acpi_os_ioremap -> ioremap_cache
> 
> which possibly involve IOMMU allocator.
> 
> I may cause a failure of  an erst driver if the panic happens in an interrupt context.
> 
> [Idea]
> 
> If we can remove ioremap_cache() from acpi_os_read_memory() as follows,
> It is easy to fix this issue.
> But I'm not sure if it is feasible because I can't see the reason of tying acpi_os_ioremap()  from a git log...
> 
> Any comment?
> 
> <snip>
> @@ -918,10 +918,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
>  	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
>  	if (!virt_addr) {
>  		rcu_read_unlock();
> -		virt_addr = acpi_os_ioremap(phys_addr, size);
> -		if (!virt_addr)
> -			return AE_BAD_ADDRESS;
> -		unmap = true;
> +		return AE_BAD_ADDRESS;

No.  We can not do that.  Because some users rely on acpi_os_read_memory
to do ioremap for them.

The correct fixing should be pre-map the io-memory that may be accessed
in erst code patch with acpi_map().

Best Regards,
Huang Ying

>  	}
>  
>  	if (!value)
> <snip>
> 
> Seiji


