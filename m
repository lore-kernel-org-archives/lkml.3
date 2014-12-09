Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaLIJyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:54:31 -0500
Received: from thoth.sbs.de ([192.35.17.2]:45975 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbaLIJy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:54:28 -0500
Message-ID: <5486C6CA.8080006@siemens.com>
Date: Tue, 09 Dec 2014 10:54:18 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jike Song <jike.song@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
CC: "White, Michael L" <michael.l.white@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Dong, Eddie" <eddie.dong@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com>
In-Reply-To: <547FC5DE.4010701@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-04 03:24, Jike Song wrote:
> Hi all,
> 
>  We are pleased to announce the first release of KVMGT project. KVMGT is
> the implementation of Intel GVT-g technology, a full GPU virtualization
> solution. Under Intel GVT-g, a virtual GPU instance is maintained for
> each VM, with part of performance critical resources directly assigned.
> The capability of running native graphics driver inside a VM, without
> hypervisor intervention in performance critical paths, achieves a good
> balance of performance, feature, and sharing capability.
> 
> 
>  KVMGT is still in the early stage:
> 
>   - Basic functions of full GPU virtualization works, guest can see a
> full-featured vGPU.
>     We ran several 3D workloads such as lightsmark, nexuiz, urbanterror
> and warsow.
> 
>   - Only Linux guest supported so far, and PPGTT must be disabled in
> guest through a
>     kernel parameter(see README.kvmgt in QEMU).
> 
>   - This drop also includes some Xen specific changes, which will be
> cleaned up later.
> 
>   - Our end goal is to upstream both XenGT and KVMGT, which shares ~90%
> logic for vGPU
>     device model (will be part of i915 driver), with only difference in
> hypervisor
>     specific services
> 
>   - insufficient test coverage, so please bear with stability issues :)
> 
> 
> 
>  There are things need to be improved, esp. the KVM interfacing part:
> 
>     1    a domid was added to each KVMGT guest
> 
>         An ID is needed for foreground OS switching, e.g.
> 
>             # echo <domid>    >    /sys/kernel/vgt/control/foreground_vm
> 
>         domid 0 is reserved for host OS.
> 
> 
>      2    SRCU workarounds.
> 
>         Some KVM functions, such as:
> 
>                 kvm_io_bus_register_dev
>                 install_new_memslots
> 
>         must be called *without* &kvm->srcu read-locked. Otherwise it
> hangs.
> 
>         In KVMGT, we need to register an iodev only *after* BAR
> registers are
>         written by guest. That means, we already have &kvm->srcu hold -
>         trapping/emulating PIO(BAR registers) makes us in such a condition.
>         That will make kvm_io_bus_register_dev hangs.
> 
>         Currently we have to disable rcu_assign_pointer() in such
> functions.
> 
>         These were dirty workarounds, your suggestions are high welcome!
> 
> 
>     3    syscalls were called to access "/dev/mem" from kernel
> 
>         An in-kernel memslot was added for aperture, but using syscalls
> like
>         open and mmap to open and access the character device "/dev/mem",
>         for pass-through.
> 
>  
> 
> 
> The source codes(kernel, qemu as well as seabios) are available at github:
> 
>     git://github.com/01org/KVMGT-kernel
>     git://github.com/01org/KVMGT-qemu
>     git://github.com/01org/KVMGT-seabios
> 
> In the KVMGT-qemu repository, there is a "README.kvmgt" to be referred.
> 
> 
> 
> More information about Intel GVT-g and KVMGT can be found at:
> 
>     https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
> 
>     http://events.linuxfoundation.org/sites/events/files/slides/KVMGT-a%20Full%20GPU%20Virtualization%20Solution_1.pdf
> 
> 
> 
> Appreciate your comments, BUG reports, and contributions!
> 

There is an even increasing interest to keep KVM's in-kernel guest
interface as small as possible, specifically for security reasons. I'm
sure there are some good performance reasons to create a new in-kernel
device model, but I suppose those will need good evidences why things
are done in the way they finally should be - and not via a user-space
device model. This is likely not a binary decision (all userspace vs. no
userspace), it is more about the size and robustness of the in-kernel
model vs. its performance.

One aspect could also be important: Are there hardware improvements in
sight that will eventually help to reduce the in-kernel device model and
make the overall design even more robust? How will those changes fit
best into a proposed user/kernel split?

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
