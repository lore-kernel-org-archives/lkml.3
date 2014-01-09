Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaAIRiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:38:15 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46534 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAIRiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:38:05 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 12:38:05 EST
Message-ID: <1389288265.1792.108.camel@misato.fc.hp.com>
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
From: Toshi Kani <toshi.kani@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Baoquan <bhe@redhat.com>,
        linux-acpi@vger.kernel.org, zhangyanfei@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, dyoung@redhat.com
Date: Thu, 09 Jan 2014 10:24:25 -0700
In-Reply-To: <20140109162427.GF25897@redhat.com>
References: <52CD6E33.400@redhat.com> <20140108155829.GC13649@redhat.com>
	 <8500545.JVNPnKcyD1@vostro.rjw.lan>
	 <1389226308.1792.39.camel@misato.fc.hp.com>
	 <20140109145035.GB25897@redhat.com>
	 <1389283439.1792.66.camel@misato.fc.hp.com>
	 <20140109162427.GF25897@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 11:24 -0500, Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 09:03:59AM -0700, Toshi Kani wrote:
> 
> [..]
> > > > > > So basically acpi thinks that some memory block is a hot plug memory
> > > > > > and tries to add it. And that consumes lots of memory and we don't have
> > > > > > that memory in second kernel.
> > > > > 
> > > > > That's not exactly the case.  What seems to happen is that there is an ACPI
> > > > > memory object in the ACPI namespace and the ACPI memory hotplug driver
> > > > > attempts to bind to it.  That driver attempts to find removable memory blocks
> > > > > associated with that object and to add them to the memory map.
> > > > > 
> > > > > Why don't you simply append acpi=off to the kexec command line?  That should
> > > > > make the problem go away.
> > > > 
> > > > Yes, that should work, but Baoquan's approach makes sense to me.  When
> > > > memmap=exactmap is specified, the kernel should ignore any memory
> > > > information from the firmware.
> > > 
> > > memmap=exactmap is only for E820 map. It does not say that later memory
> > > can not be hotplugged. So to me specifying exactmap does not imply that
> > > memory hotplugging is disabled.
> > 
> > There are multiple ways to describe memory range info in the firmware;
> > e820, EFI memory descriptor table, and ACPI memory device objects.  They
> > basically provide the same info.
> 
> So ACPI memory device objects contain all the memory ranges as exported
> in E820?

Yes.  (Some vendors might choose to implement some portion of memory
with memory objects, but I think they are special cases.)
 
> > This problem happens when the firmware implements ACPI memory device
> > objects, which are necessary to support memory hotplug, but do not mean
> > that the system always supports hotplug when they exist.  They are
> > optional objects that firmware vendors may choose to implement.
> 
> This is confusing. So even if memory hotplug is not supported, ACPI memory
> device objects might be present. What's the purpose? How do they help.

They do not help at this point, but the point is that memory objects can
be present without hotplug support.  There is nothing wrong with it per
the spec.

> If they represent same info as firmware provided using a BIOS call early
> (E820 map), then how does system later avoid adding same memory ranges.

It attempts to add, but fails with -EEXIST because it is already there.

> IOW, in terms of design, what's the objective. Why to create this
> additional path of getting memory information.

To support memory hot-remove requests, ACPI objects need to be
initialized for the existing memory ranges beforehand.
 
> > While the exactmap option does not imply that memory hotplug is
> > disabled,
> 
> But Bao's approach will disable memory hotplug on exactmap.

Right, but it does not seem worthwhile for adding complexity to support
memory hotplug and exactmap at the same time.

> > it does require that the kernel only consumes user-supplied
> > memory range information.  Hence, Baoquan's approach makes sense to me.
> 
> I am fine with this as long as memmap=exactmap is not the only way to
> disable memory hotplug. I need another way too so that users who are
> not using exactmap can still disable memory hotplug.

There is a config option to enable/disable memory hotplug.  You are
right that the exactmap option is not the way to disable memory hotplug.
This option requests the kernel to use user-supplied memory ranges only,
so memory hotplug will not be supported under this constrain.
 
> > > IMO, it makes sense to have a separate knob to disable memory hotplug
> > > behavior.
> > 
> > Regular users do not know if their systems implement ACPI memory device
> > objects or not.  So, asking users to specify a separate option when
> > their systems implement ACPI memory objects is tricky, IMO.
> 
> They can always specify no_memory_hotplug, irrespective of the fact that
> kernel supports memory hotplug or not.
> 
> Anyway, I don't mind if one implicitly disables memory hotplug if
> memmap=exactmap or mem=X is specified. It is just a matter of figuring
> how what should be a more intutive behavior from user's point of view.

Since memory hotplug won't work under the constrain of the exactmap
option, it seems natural to disable it. 

> But I do want a separate path to disable memory hotplug so that even 
> if I am not using memmap=exactmap or mem=X, I should be able to disable
> memory hotplug.

I think this is a separate topic.
 
> > > Also from kdump point of view, I don't want to rely on exactmap as in 
> > > new implementation I am planning to move away from exactmap. I will
> > > pass new memory map in bootparams and stop passing it on command line.
> > 
> > I think we still need a flag that indicates the kernel can only consume
> > the new memory map in bootparams, and cannot to obtain from the
> > firmware.
> 
> I think creating a new command line option is simpler as compared to
> creating a new flag in bootparam which in turn disables memory hotplug.
> More users can use that option. For example, if for some reason hotplug
> code is crashing, one can just disable it on command line as work around
> and move on.

I do not have a strong opinion about having such option.  However, I
think it is more user friendly to keep the exactmap option works alone
on any platforms.

Thanks,
-Toshi

