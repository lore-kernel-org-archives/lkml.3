Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaLICtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:49:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:12174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbaLICtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:49:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,542,1413270000"; 
   d="scan'208";a="644583485"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
        "Song, Jike" <jike.song@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: RE: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
Thread-Topic: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of
 Intel GVT-g(full GPU virtualization) for KVM
Thread-Index: AQHQEGiLR9sn/FTTFEy+ONRxxlNBGJyAcNAAgAYSpgA=
Date: Tue, 9 Dec 2014 02:49:06 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D12611365D@SHSMSX101.ccr.corp.intel.com>
References: <547FC5DE.4010701@intel.com>
 <1417769421.11297.37.camel@nilsson.home.kraxel.org>
 <5481AD24.3000703@redhat.com>
In-Reply-To: <5481AD24.3000703@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB92o1q2029282

Here is some background of this KVMGT release:

- the major purpose is for early experiment of this technique in KVM, and 
throw out issues about adding in-kernel device model (or mediated pass-through 
framework) in KVM.

- KVMGT shares 90% code as XenGT, regarding to vGPU device model. The
only difference is the in-kernel dm interface. The vGPU device model will be
split and integrated in i915 driver. It will register to in-kernel dm framework
provided either by Xen or KVM at boot time. Upstreaming of vGPU device
model is already in progress, with valuable comments received from i915 
community. However the refactoring mostly happen in XenGT repo now 

- Now we have XenGT/KVMGT separately maintained, and KVMGT lags
behind XenGT regarding to features and qualities. Likely you'll continue
see stale code (like Xen inst decoder) for some time. In the future we
plan to maintain a single kernel repo for both, so KVMGT can share
same quality as XenGT once KVM in-kernel dm framework is stable.

- Regarding to Qemu hacks, KVMGT really doesn't have any different 
requirements as what have been discussed for GPU pass-through, e.g. 
about ISA bridge. Our implementation is based on an old Qemu repo, 
and honestly speaking not cleanly developed, because we know we
can leverage from GPU pass-through support once it's in Qemu. At 
that time we'll leverage the same logic with minimal changes to 
hook KVMGT mgmt. APIs (e.g. create/destroy a vGPU instance). So
we can ignore this area for now. :-)

Thanks
Kevin

> From: Paolo Bonzini
> Sent: Friday, December 05, 2014 9:04 PM
> 
> 
> 
> On 05/12/2014 09:50, Gerd Hoffmann wrote:
> > A few comments on the kernel stuff (brief look so far, also
> > compile-tested only, intel gfx on my test machine is too old).
> >
> >  * Noticed the kernel bits don't even compile when configured as
> >    module.  Everything (vgt, i915, kvm) must be compiled into the
> >    kernel.
> 
> I'll add that the patch is basically impossible to review with all the
> XenGT bits still in.  For example, the x86 emulator seems to be
> unnecessary for KVMGT, but I am not 100% sure.
> 
> I would like a clear understanding of why/how Andrew Barnes was able to
> do i915 passthrough (GVT-d) without hacking the ISA bridge, and why this
> does not apply to GVT-g.
> 
> Paolo
> 
> >  * Design approach still seems to be i915 on vgt not the other way
> >    around.
> >
> > Qemu/SeaBIOS bits:
> >
> > I've seen the host bridge changes identity from i440fx to
> > copy-pci-ids-from-host.  Guess the reason for this is that seabios uses
> > this device to figure whenever it is running on i440fx or q35.  Correct?
> >
> > What are the exact requirements for the device?  Must it match the host
> > exactly, to not confuse the guest intel graphics driver?  Or would
> > something more recent -- such as the q35 emulation qemu has -- be good
> > enough to make things work (assuming we add support for the
> > graphic-related pci config space registers there)?
> >
> > The patch also adds a dummy isa bridge at 0x1f.  Simliar question here:
> > What exactly is needed here?  Would things work if we simply use the q35
> > lpc device here?
> >
> > more to come after I've read the paper linked above ...
> >
> > cheers,
> >   Gerd
> >
> >
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx
> >
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
