Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab3LTNlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:41:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab3LTNlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:41:04 -0500
Date: Fri, 20 Dec 2013 08:40:49 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(), cleanup and fixes crash bugs
Message-ID: <20131220134049.GC30373@redhat.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <y0m38loefhx.fsf@fche.csb> <52B3C5E6.2040802@hitachi.com> <20131220082056.GA15934@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220082056.GA15934@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

mingo wrote:
> [...]
> For example a hash table (hashed by probe address) could be used in 
> addition to the list, to speed up basic operations.

In the past, when this sort of behavior popped up, it was due to
machine-wide halt/sync operations being done too eagerly.  At one
point, the kprobes-unregistration interface grew a mass-unregister API
to batch them (and save the machine sync's between operations).  Maybe
with the new checks/logic, a similar batching API may be needed for
the registration side.

I'll try to get more perf data once the VM comes back up; after a
couple of hours of the test getting started, it died (for possibly
unrelated reasons).


[  133.073670] stap_bc6054113aa63134d411836da0afefc3_123_1261: module verification failed: signature and/or  required key missing - tainting kernel
[  404.357210] stap_4c53547addc9f25dd87ac4afa0407ed6_36_1948: systemtap: 2.5/0.157, base: ffffffffa0201000, memory: 15882data/24text/1ctx/2058net/4625alloc kb, probes: 34692
[ 1655.745075] hrtimer: interrupt took 1225946 ns
[ 3969.175039] [sched_delayed] sched: RT throttling activated
[10812.665534] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[10812.665534] BUG: unable to handle kernel paging request at ffff88007902f038
[10812.665534] IP: [<ffff88007902f038>] 0xffff88007902f038
[10812.665534] PGD 2d90067 PUD 2d93067 PMD 80000000790001e3 
[10812.665534] Oops: 0010 [#1] SMP 
[10812.665534] Modules linked in: stap_4c53547addc9f25dd87ac4afa0407ed6_36_1948(OF) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache ppdev microcode parport_pc parport i2c_piix4 virtio_balloon i2c_core serio_raw virtio_net virtio_pci ata_generic virtio_ring pata_acpi virtio [last unloaded: stap_89fcd2b984e11a30dd08d141e6b47e13_123_1681]
[10812.665534] CPU: 1 PID: -30720 Comm: <F8><A1><D0>x Tainted: GF          O 3.13.0-rc4-01828-g8b349c29efae #1
[10812.665534] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[10812.665534] BUG: unable to handle kernel paging request at 000000008f896e09
[10812.665534] IP: [<ffffffff810d9f55>] do_raw_spin_trylock+0x5/0x60
[10812.665534] PGD 0 
[10812.665534] Thread overran stack, or stack corrupted
[10812.665534] Oops: 0000 [#2] SMP 
[10812.665534] Modules linked in: stap_4c53547addc9f25dd87ac4afa0407ed6_36_1948(OF) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache ppdev microcode parport_pc parport i2c_piix4 virtio_balloon i2c_core serio_raw virtio_net virtio_pci ata_generic virtio_ring pata_acpi virtio [last unloaded: stap_89fcd2b984e11a30dd08d141e6b47e13_123_1681]
[10812.665534] CPU: 1 PID: -30720 Comm: <F8><A1><D0>x Tainted: GF          O 3.13.0-rc4-01828-g8b349c29efae #1
[10812.665534] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[10812.665534] BUG: unable to handle kernel paging request at 000000008f896e09
[10812.665534] IP: [<ffffffff810d9f55>] do_raw_spin_trylock+0x5/0x60
[10812.665534] PGD 0 
[10812.665534] Thread overran stack, or stack corrupted
[10812.665534] Oops: 0000 [#3] SMP 
[10812.665534] Modules linked in: stap_4c53547addc9f25dd87ac4afa0407ed6_36_1948(OF) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache ppdev microcode parport_pc parport i2c_piix4 virtio_balloon i2c_core serio_raw virtio_net virtio_pci ata_generic virtio_ring pata_acpi virtio [last unloaded: stap_89fcd2b984e11a30dd08d141e6b47e13_123_1681]
[10812.665534] CPU: 1 PID: -30720 Comm: <F8><A1><D0>x Tainted: GF          O 3.13.0-rc4-01828-g8b349c29efae #1
[10812.665534] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[10812.665534] BUG: unable to handle kernel paging request at 000000008f896e09
[10812.665534] IP: [<ffffffff810d9f55>] do_raw_spin_trylock+0x5/0x60
[10812.665534] PGD 0 
[10812.665534] Thread overran stack, or stack corrupted
[10812.665534] Oops: 0000 [#4] SMP 
[10812.665534] Modules linked in: stap_4c53547addc9f25dd87ac4afa0407ed6_36_1948(OF) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache ppdev microcode parport_pc parport i2c_piix4 virtio_balloon i2c_core serio_raw virtio_net virtio_pci ata_generic virtio_ring pata_acpi virtio [last unloaded: stap_89fcd2b984e11a30dd08d141e6b47e13_123_1681]
[10812.665534] CPU: 1 PID: -30720 Comm: <F8><A1><D0>x Tainted: GF          O 3.13.0-rc4-01828-g8b349c29efae #1
[10812.665534] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[10812.665534] BUG: unable to handle kernel paging request at 000000008f896e09
[10812.665534] IP: [<ffffffff810d9f55>] do_raw_spin_trylock+0x5/0x60
[10812.665534] PGD 0 
[10812.665534] Thread overran stack, or stack corrupted
[10812.665042] ------------[ cut here ]------------
[10812.665042] WARNING: CPU: 0 PID: 1948 at arch/x86/kernel/kprobes/core.c:600 reenter_kprobe+0x3c/0xd0()
[10812.665042] Modules linked in: stap_4c53547addc9f25dd87ac4afa0407ed6_36_1948(OF) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache ppdev microcode parport_pc parport i2c_piix4 virtio_balloon i2c_core serio_raw virtio_net virtio_pci ata_generic virtio_ring pata_acpi virtio [last unloaded: stap_89fcd2b984e11a30dd08d141e6b47e13_123_1681]


- FChE
