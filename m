Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbaGRN4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:56:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30404 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762317AbaGRN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:56:39 -0400
Date: Fri, 18 Jul 2014 09:56:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] xen PVonHVM: use E820_Reserved area for
 shared_info
Message-ID: <20140718135627.GF24044@laptop.dumpdata.com>
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
 <1405431640-649-2-git-send-email-vkuznets@redhat.com>
 <20140715150652.GN3403@laptop.dumpdata.com>
 <87vbqytyp6.fsf@vitty.brq.redhat.com>
 <20140715155045.GB7792@laptop.dumpdata.com>
 <871ttjorjp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ttjorjp.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 01:05:46PM +0200, Vitaly Kuznetsov wrote:
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
> 
> > On Tue, Jul 15, 2014 at 05:43:17PM +0200, Vitaly Kuznetsov wrote:
> >> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
> >> 
> >> > On Tue, Jul 15, 2014 at 03:40:37PM +0200, Vitaly Kuznetsov wrote:
> >> >> From: Olaf Hering <olaf@aepfle.de>
> >> >> 
> >> >> This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
> >> >> ("xen PVonHVM: move shared_info to MMIO before kexec").
> >> >> 
> >> >> Currently kexec in a PVonHVM guest fails with a triple fault because the
> >> >> new kernel overwrites the shared info page. The exact failure depends on
> >> >> the size of the kernel image. This patch moves the pfn from RAM into an
> >> >> E820 reserved memory area.
> >> >> 
> >> >> The pfn containing the shared_info is located somewhere in RAM. This will
> >> >> cause trouble if the current kernel is doing a kexec boot into a new
> >> >> kernel. The new kernel (and its startup code) can not know where the pfn
> >> >> is, so it can not reserve the page. The hypervisor will continue to update
> >> >> the pfn, and as a result memory corruption occours in the new kernel.
> >> >> 
> >> >> The toolstack marks the memory area FC000000-FFFFFFFF as reserved in the
> >> >> E820 map. Within that range newer toolstacks (4.3+) will keep 1MB
> >> >> starting from FE700000 as reserved for guest use. Older Xen4 toolstacks
> >> >> will usually not allocate areas up to FE700000, so FE700000 is expected
> >> >> to work also with older toolstacks.
> >> >> 
> >> >> In Xen3 there is no reserved area at a fixed location. If the guest is
> >> >> started on such old hosts the shared_info page will be placed in RAM. As
> >> >> a result kexec can not be used.
> >> >
> >> > So this looks right, the one thing that we really need to check 
> >> > is e9daff24a266307943457086533041bd971d0ef9
> >> >
> >> >    This reverts commit 9d02b43dee0d7fb18dfb13a00915550b1a3daa9f.
> >> >
> >> >     We are doing this b/c on 32-bit PVonHVM with older hypervisors
> >> >     (Xen 4.1) it ends up bothing up the start_info. This is bad b/c
> >> >     we use it for the time keeping, and the timekeeping code loops
> >> >     forever - as the version field never changes. Olaf says to
> >> >     revert it, so lets do that.
> >> >
> >> > Could you kindly test that the migration on 32-bit PVHVM guests
> >> > on older hypervisors works?
> >> >
> >> 
> >> Sure, will do! Was there anything special about the setup or any 32-bit
> >> pvhvm guest migration (on 64-bit hypervisor I suppose) would fail? I can
> >> try checking both current and old versions to make sure the issue was
> >> acutually fixed.
> >
> > Nothing fancy (well, it was SMP, so 4 CPUs). I did the 'save'/'restore' and the
> > guest would not restore properly.
> >
> 
> The symptoms you saw were: after the resume guest appears to be frozen,
> all vcpus except for the first one spin at 100%? I was able to reproduce

Yes, that is it.
> that on old patch version and everything works fine with your fix
> (calling xen_hvm_set_shared_info() in addition to
> xen_hvm_connect_shared_info() on resume). We're probably safe to apply
> it now, thanks!

Woot!  Could you include that tidbit of information in
the commit please?

> 
> However I'd like to suggest we remove '__init' from
> xen_hvm_set_shared_info() as now we call it on resume.

Good idea.

Lets wait until Stefano responds (for the MSI PIRQ one), and
if he does not have anything special to say, then repost the
whole patchset including this tiny __init fix and the updated
comment?

