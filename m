Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaLDC1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:27:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:52828 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaLDC1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:27:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,512,1413270000"; 
   d="scan'208";a="642079452"
Message-ID: <547FC5DE.4010701@intel.com>
Date: Thu, 04 Dec 2014 10:24:30 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
CC: "Tian, Kevin" <kevin.tian@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full GPU
 virtualization) for KVM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

  We are pleased to announce the first release of KVMGT project. KVMGT is the implementation of Intel GVT-g technology, a full GPU virtualization solution. Under Intel GVT-g, a virtual GPU instance is maintained for each VM, with part of performance critical resources directly assigned. The capability of running native graphics driver inside a VM, without hypervisor intervention in performance critical paths, achieves a good balance of performance, feature, and sharing capability.


  KVMGT is still in the early stage:

   - Basic functions of full GPU virtualization works, guest can see a full-featured vGPU.
     We ran several 3D workloads such as lightsmark, nexuiz, urbanterror and warsow.

   - Only Linux guest supported so far, and PPGTT must be disabled in guest through a
     kernel parameter(see README.kvmgt in QEMU).

   - This drop also includes some Xen specific changes, which will be cleaned up later.

   - Our end goal is to upstream both XenGT and KVMGT, which shares ~90% logic for vGPU
     device model (will be part of i915 driver), with only difference in hypervisor
     specific services

   - insufficient test coverage, so please bear with stability issues :)



  There are things need to be improved, esp. the KVM interfacing part:

	1	a domid was added to each KVMGT guest

		An ID is needed for foreground OS switching, e.g.

			# echo <domid>	>	/sys/kernel/vgt/control/foreground_vm

		domid 0 is reserved for host OS.


  	2	SRCU workarounds.

		Some KVM functions, such as:

				kvm_io_bus_register_dev
				install_new_memslots

		must be called *without* &kvm->srcu read-locked. Otherwise it hangs.

		In KVMGT, we need to register an iodev only *after* BAR registers are
		written by guest. That means, we already have &kvm->srcu hold -
		trapping/emulating PIO(BAR registers) makes us in such a condition.
		That will make kvm_io_bus_register_dev hangs.

		Currently we have to disable rcu_assign_pointer() in such functions.

		These were dirty workarounds, your suggestions are high welcome!


	3	syscalls were called to access "/dev/mem" from kernel

		An in-kernel memslot was added for aperture, but using syscalls like
		open and mmap to open and access the character device "/dev/mem",
		for pass-through.

  


The source codes(kernel, qemu as well as seabios) are available at github:

	git://github.com/01org/KVMGT-kernel
	git://github.com/01org/KVMGT-qemu
	git://github.com/01org/KVMGT-seabios

In the KVMGT-qemu repository, there is a "README.kvmgt" to be referred.



More information about Intel GVT-g and KVMGT can be found at:

	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
	http://events.linuxfoundation.org/sites/events/files/slides/KVMGT-a%20Full%20GPU%20Virtualization%20Solution_1.pdf


Appreciate your comments, BUG reports, and contributions!




--
Thanks,
Jike
