Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaLJH2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:28:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:11935 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaLJH2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:28:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496484820"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Song, Jike" <jike.song@intel.com>, Jan Kiszka <jan.kiszka@siemens.com>
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
Thread-Index: AQHQFENUR9sn/FTTFEy+ONRxxlNBGJyIZjnA
Date: Wed, 10 Dec 2014 07:28:27 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D126115185@SHSMSX101.ccr.corp.intel.com>
References: <547FC5DE.4010701@intel.com> <5486C6CA.8080006@siemens.com>
 <5487E96D.70609@intel.com>
In-Reply-To: <5487E96D.70609@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBA7Skus004626

> From: Song, Jike
> Sent: Wednesday, December 10, 2014 2:34 PM
> 
> CC Kevin.
> 
> 
> On 12/09/2014 05:54 PM, Jan Kiszka wrote:
> > On 2014-12-04 03:24, Jike Song wrote:
> >> Hi all,
> >>
> >>   We are pleased to announce the first release of KVMGT project. KVMGT
> is
> >> the implementation of Intel GVT-g technology, a full GPU virtualization
> >> solution. Under Intel GVT-g, a virtual GPU instance is maintained for
> >> each VM, with part of performance critical resources directly assigned.
> >> The capability of running native graphics driver inside a VM, without
> >> hypervisor intervention in performance critical paths, achieves a good
> >> balance of performance, feature, and sharing capability.
> >>
> >>
> >>   KVMGT is still in the early stage:
> >>
> >>    - Basic functions of full GPU virtualization works, guest can see a
> >> full-featured vGPU.
> >>      We ran several 3D workloads such as lightsmark, nexuiz, urbanterror
> >> and warsow.
> >>
> >>    - Only Linux guest supported so far, and PPGTT must be disabled in
> >> guest through a
> >>      kernel parameter(see README.kvmgt in QEMU).
> >>
> >>    - This drop also includes some Xen specific changes, which will be
> >> cleaned up later.
> >>
> >>    - Our end goal is to upstream both XenGT and KVMGT, which shares
> ~90%
> >> logic for vGPU
> >>      device model (will be part of i915 driver), with only difference in
> >> hypervisor
> >>      specific services
> >>
> >>    - insufficient test coverage, so please bear with stability issues :)
> >>
> >>
> >>
> >>   There are things need to be improved, esp. the KVM interfacing part:
> >>
> >>      1    a domid was added to each KVMGT guest
> >>
> >>          An ID is needed for foreground OS switching, e.g.
> >>
> >>              # echo <domid>    >
> /sys/kernel/vgt/control/foreground_vm
> >>
> >>          domid 0 is reserved for host OS.
> >>
> >>
> >>       2    SRCU workarounds.
> >>
> >>          Some KVM functions, such as:
> >>
> >>                  kvm_io_bus_register_dev
> >>                  install_new_memslots
> >>
> >>          must be called *without* &kvm->srcu read-locked. Otherwise it
> >> hangs.
> >>
> >>          In KVMGT, we need to register an iodev only *after* BAR
> >> registers are
> >>          written by guest. That means, we already have &kvm->srcu
> hold -
> >>          trapping/emulating PIO(BAR registers) makes us in such a
> condition.
> >>          That will make kvm_io_bus_register_dev hangs.
> >>
> >>          Currently we have to disable rcu_assign_pointer() in such
> >> functions.
> >>
> >>          These were dirty workarounds, your suggestions are high
> welcome!
> >>
> >>
> >>      3    syscalls were called to access "/dev/mem" from kernel
> >>
> >>          An in-kernel memslot was added for aperture, but using syscalls
> >> like
> >>          open and mmap to open and access the character device
> "/dev/mem",
> >>          for pass-through.
> >>
> >>
> >>
> >>
> >> The source codes(kernel, qemu as well as seabios) are available at github:
> >>
> >>      git://github.com/01org/KVMGT-kernel
> >>      git://github.com/01org/KVMGT-qemu
> >>      git://github.com/01org/KVMGT-seabios
> >>
> >> In the KVMGT-qemu repository, there is a "README.kvmgt" to be referred.
> >>
> >>
> >>
> >> More information about Intel GVT-g and KVMGT can be found at:
> >>
> >>
> https://www.usenix.org/conference/atc14/technical-sessions/presentation/tia
> n
> >>
> >>
> http://events.linuxfoundation.org/sites/events/files/slides/KVMGT-a%20Full%2
> 0GPU%20Virtualization%20Solution_1.pdf
> >>
> >>
> >>
> >> Appreciate your comments, BUG reports, and contributions!
> >>
> >
> > There is an even increasing interest to keep KVM's in-kernel guest
> > interface as small as possible, specifically for security reasons. I'm
> > sure there are some good performance reasons to create a new in-kernel
> > device model, but I suppose those will need good evidences why things
> > are done in the way they finally should be - and not via a user-space
> > device model. This is likely not a binary decision (all userspace vs. no
> > userspace), it is more about the size and robustness of the in-kernel
> > model vs. its performance.

Thanks for explaining the background. We're not against the userspace
model if applied, but based on our analysis we figured out the in-kernel
model is the best suite, not just for performance reason, but also for
the tight couple to i915 functionalities (scheduling, interrupt, security, etc.)
and hypervisor functionalities (GPU shadow page table, etc.) which are 
best handled in kernel directly. Definitely we don't want to split it just for
performance reason, w/o a functionally clear separation, because that 
just creates unnecessary/messy user/kernel interfaces. And now we've
got i915 community's signal that they're willing to pick the core code
into i915 driver, which we're currently working on.

So, not to eliminate the possibility of user/kernel split, how about we first
look at those in-kernel dm changes for KVM? Then you can help judge
whether it's a reasonable change or instead there's a better option. Jike 
will summarize and start the discussion in a separate thread. 

> >
> > One aspect could also be important: Are there hardware improvements in
> > sight that will eventually help to reduce the in-kernel device model and
> > make the overall design even more robust? How will those changes fit
> > best into a proposed user/kernel split?
> >

I can't talk about hardware improvements publicly, but the foreseen 
changes target support in kernel drivers. :-)

Thanks
Kevin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
