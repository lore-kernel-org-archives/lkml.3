Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3CKNOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:14:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3CKNOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:14:40 -0400
Date: Mon, 11 Mar 2013 09:14:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuahkhan@gmail.com>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>, Dave Young <dyoung@redhat.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>
Subject: Re: 3.9-rc1: crash kernel panic - not syncing: Can not allocate
 SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
Message-ID: <20130311131417.GF23018@phenom.dumpdata.com>
References: <1750036321.11235774.1362722613994.JavaMail.root@redhat.com>
 <CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com>
 <CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
 <51399154.5030500@redhat.com>
 <CAE9FiQVPaG5P7mG9HoFzCkaxF62hkU5hEtq_FhdT7n+38aNs9A@mail.gmail.com>
 <51399442.1080609@redhat.com>
 <CAE9FiQWCfnOjOuWKihv1GamgHb4KLrrPEiBTspQMqK7_fBDunw@mail.gmail.com>
 <5139D5A0.6000600@redhat.com>
 <CAE9FiQU7RP8zTsm9QMnANf8-a9=QRY9Y6sFdEev7+YWd87NDAw@mail.gmail.com>
 <CAE9FiQUwWLUqdvtGZPY7WOFSiC5YZjm7Mcoj+V+m6qJzeRNCLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUwWLUqdvtGZPY7WOFSiC5YZjm7Mcoj+V+m6qJzeRNCLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:39:51AM -0800, Yinghai Lu wrote:
> [ Add more to To list ]
> 
> On Fri, Mar 8, 2013 at 10:24 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Mar 8, 2013 at 4:12 AM, WANG Chao <chaowang@redhat.com> wrote:
> >
> >>> what is 00:02.0 in your system?
> >> This IOMMU issue is related to https://lkml.org/lkml/2012/11/26/814. We can
> >> discuss this IOMMU issue in that thread.
> >> Anyway 00:02.0 is a video card, the box is Ivy Bridge.
> >> # lspci -s 00:02.0 -v
> >> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor
> >> Graphics Controller (rev 09) (prog-if 00 [VGA controller])
> >>         Subsystem: Intel Corporation Device 2211
> >>         Flags: bus master, fast devsel, latency 0, IRQ 44
> >>         Memory at afc00000 (64-bit, non-prefetchable) [size=4M]
> >>         Memory at c0000000 (64-bit, prefetchable) [size=256M]
> >>         I/O ports at 6000 [size=64]
> >>         Expansion ROM at <unassigned> [disabled]
> >>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> >>         Capabilities: [d0] Power Management version 2
> >>         Capabilities: [a4] PCI Advanced Features
> >>         Kernel driver in use: i915
> >
> > disable drm for i915 will make your iommu work with dump?
> >
> >>
> >>
> >> Is it expected to intel_iommu=on or crashkernel_low to make 2nd kernel boot in
> >> 3.9? Back in 3.8, it works just fine w/ only crashkernel param.
> >
> > Yes, I really do not want to set crashkernel low range like 72M
> > automatically for all.
> > that would have the system with proper iommu support lose 72M under 4G
> > in first kernel.
> > And can not play allocate and return tricks, as first kernel have no
> > idea if iommu will work
> > on second kernel even iommu is working on first kernel.
> >
> > Better to fix iommu support at first.

It would seem that if we really want to go that route we should export
the number of megabytes that SWIOTLB is using. And it actually is - via the
swiotlb_nr_tbl() - thought it is no megabytes but slabs so you do have
to do some bit-shifting around.

If you want to use that, and perhaps alter the function to be swiotlb_size()
(and the xen-swiotlb to do the proper bit-shifting)?

> >
> > For old system that does not have DMAR or kernel does not have IOMMU
> > support enabled, or
> > user does not pass intel_iommu=on.
> > We could set crashkernel low range to 72M automatically.
> 
> It seem that it is not worthy to check case that does not support
> IOMMU in second kernel.
> 
> Please check attached patch that will just set crashkernel_low auto, and if the
> system DO support iommu with kdump, user can specify crashkernel_low=0
> to save low 72M.
> 
> Thanks
> 
> Yinghai


