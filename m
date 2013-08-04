Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3HDOCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:02:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55116 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3HDOCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:02:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, vasilis.liaskovitis@profitbricks.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: Cannot hot remove a memory device
Date: Sun, 04 Aug 2013 16:12:27 +0200
Message-ID: <4643364.iqi5kenykK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375576646.10300.150.camel@misato.fc.hp.com>
References: <51FA1E41.20304@jp.fujitsu.com> <3856529.sQXzdEem7D@vostro.rjw.lan> <1375576646.10300.150.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 06:37:26 PM Toshi Kani wrote:
> On Sat, 2013-08-03 at 03:01 +0200, Rafael J. Wysocki wrote:
> > On Friday, August 02, 2013 06:04:40 PM Toshi Kani wrote:
> > > On Sat, 2013-08-03 at 01:43 +0200, Rafael J. Wysocki wrote:
> > > > On Friday, August 02, 2013 03:46:15 PM Toshi Kani wrote:
> > > > > On Thu, 2013-08-01 at 23:43 +0200, Rafael J. Wysocki wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Thanks for your report.
> > > > > > 
> > > > > > On Thursday, August 01, 2013 05:37:21 PM Yasuaki Ishimatsu wrote:
> > > > > > > By following commit, I cannot hot remove a memory device.
> > > > > > > 
> > > > > > > ACPI / memhotplug: Bind removable memory blocks to ACPI device nodes
> > > > > > > commit e2ff39400d81233374e780b133496a2296643d7d
> > > > > > > 
> > > > > > > Details are follows:
> > > > > > > When I add a memory device, acpi_memory_enable_device() always fails
> > > > > > > as follows:
> > > > > > > 
> > > > > > > ...
> > > > > > > [ 1271.114116]  [ffffea121c400000-ffffea121c7fffff] PMD -> [ffff880813c00000-ffff880813ffffff] on node 3
> > > > > > > [ 1271.128682]  [ffffea121c800000-ffffea121cbfffff] PMD -> [ffff880813800000-ffff880813bfffff] on node 3
> > > > > > > [ 1271.143298]  [ffffea121cc00000-ffffea121cffffff] PMD -> [ffff880813000000-ffff8808133fffff] on node 3
> > > > > > > [ 1271.157799]  [ffffea121d000000-ffffea121d3fffff] PMD -> [ffff880812c00000-ffff880812ffffff] on node 3
> > > > > > > [ 1271.172341]  [ffffea121d400000-ffffea121d7fffff] PMD -> [ffff880812800000-ffff880812bfffff] on node 3
> > > > > > > [ 1271.186872]  [ffffea121d800000-ffffea121dbfffff] PMD -> [ffff880812400000-ffff8808127fffff] on node 3
> > > > > > > [ 1271.201481]  [ffffea121dc00000-ffffea121dffffff] PMD -> [ffff880812000000-ffff8808123fffff] on node 3
> > > > > > > [ 1271.216041]  [ffffea121e000000-ffffea121e3fffff] PMD -> [ffff880811c00000-ffff880811ffffff] on node 3
> > > > > > > [ 1271.230623]  [ffffea121e400000-ffffea121e7fffff] PMD -> [ffff880811800000-ffff880811bfffff] on node 3
> > > > > > > [ 1271.245148]  [ffffea121e800000-ffffea121ebfffff] PMD -> [ffff880811400000-ffff8808117fffff] on node 3
> > > > > > > [ 1271.259683]  [ffffea121ec00000-ffffea121effffff] PMD -> [ffff880811000000-ffff8808113fffff] on node 3
> > > > > > > [ 1271.274194]  [ffffea121f000000-ffffea121f3fffff] PMD -> [ffff880810c00000-ffff880810ffffff] on node 3
> > > > > > > [ 1271.288764]  [ffffea121f400000-ffffea121f7fffff] PMD -> [ffff880810800000-ffff880810bfffff] on node 3
> > > > > 
> > > > > It appears that each memory object only has 64MB of memory.  This is
> > > > > less than the memory block size, which is 128MB.  This means that a
> > > > > single memory block associates with two ACPI memory device objects.
> > > > 
> > > > That'd be bad.
> > > > 
> > > > How did that work before if that indeed is the case?
> > > 
> > > Well, it looks to me that it has never worked before...
> > > 
> > > > > > > ...	
> > > > > > > [ 1271.325841] acpi PNP0C80:03: acpi_memory_enable_device() error
> > > > > > 
> > > > > > Well, the only new way acpi_memory_enable_device() can fail after that commit
> > > > > > is a failure in acpi_bind_memory_blocks().
> > > > > 
> > > > > Agreed.
> > > > > 
> > > > > > This means that either handle is NULL, which I think we can exclude, because
> > > > > > acpi_memory_enable_device() wouldn't be called at all if that were the case, or
> > > > > > there's a more subtle error in acpi_bind_one().
> > > > > > 
> > > > > > One that comes to mind is that we may be calling acpi_bind_one() twice for the
> > > > > > same memory region, in which it will trigger -EINVAL from the sanity check in
> > > > > > there.
> > > > > 
> > > > > I think it fails with -EINVAL at the place with dev_warn(dev, "ACPI
> > > > > handle is already set\n").  When two ACPI memory objects associate with
> > > > > a same memory block, the bind procedure of the 2nd ACPI memory object
> > > > > sees that ACPI_HANDLE(dev) is already set to the 1st ACPI memory object.
> > > > 
> > > > That sound's plausible, but I wonder how we can fix that?
> > > > 
> > > > There's no way for a single physical device to have two different ACPI
> > > > "companions".  It looks like the memory blocks should be 64 M each in that
> > > > case.  Or we need to create two child devices for each memory block and
> > > > associate each of them with an ACPI object.  That would lead to complications
> > > > in the user space interface, though.
> > > 
> > > Right.  Even bigger issue is that I do not think __add_pages() and
> > > __remove_pages() can add / delete a memory chunk that is less than
> > > 128MB.  128MB is the granularity of them.  So, we may just have to fail
> > > this case gracefully.
> > 
> > Sigh.
> > 
> > BTW, why do you think they are 64 M each (it's late and I'm obviously tired)?
> 
> Oops!  Sorry, I had confused the above messages with the one in
> init_memory_mapping(), which shows a memory range being added, i.e. the
> size of an ACPI memory device object.  But the above messages actually
> came from vmemmap_populate_hugepages(), which was called during boot-up.
> So, these messages have nothing to do with ACPI memory device objects.
> And even worse, I do not seem to be able to count a number of zeros...
> In the above messages, each memory range is 4MB (0x400000), not 64MB
> (0x4000000)...  My bad. :-(

Well, no problem. :-)

> So, while we may still need to do something for the less-than-128MB
> issue, Yasuaki may be hitting a different one.  Let's wait for Yasuaki
> to give us more info.

My somewhat educated guess is that ACPI_MAX_PHYSICAL_NODE is too low for that
particular system, but that only is a guess.

Thanks,
Rafael

