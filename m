Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3IYNYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:24:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52933 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153Ab3IYNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:24:35 -0400
Message-ID: <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
Subject: Double fault when single-stepping compat task with PREEMPT_RT
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: 723180@bugs.debian.org, Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 14:24:09 +0100
In-Reply-To: <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
	 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
	 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
	 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
	 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Sv85+vOpNXwn35/b0kOz"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Sv85+vOpNXwn35/b0kOz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-09-24 at 13:43 -0700, Brian Silverman wrote:
[...]
> I got down to a really simple program that reproduces this bug:
>=20
>=20
> #include <sys/syscall.h>
> #include <unistd.h>
> int main() {
>   // I've tried SYS_getpid, SYS_write, and SYS_read here too.
>   syscall(SYS_gettid);
> }
>=20
>=20
> Any syscall I put in there seems to give the same results. In order
> for it to trigger the bug, you have to compile it with `gcc -m32
> whatever.c` (I'm testing with the standard Wheezy gcc (4:4.7.2-1) and
> gdb (7.4.1+dfsg-0.1)). I would imagine that something in gcc and/or
> gdb is contributing to this too.
>=20
>=20
> I also minimized the gdb commands down to:
>=20
>=20
> break main
> run
> record

I assume this enables single-stepping.

> continue
[...]

I can reproduce this in VMs running the latest Debian RT kernel versions
(based on 3.2.51-rt72, and on 3.10.11 with the 3.10.10-rt7 patch).

As Brian says, x86_64 userland on x86_64 kernel works, and similarly for
i386 on i386.  So it is specifically the 'compat' case that's broken.

Here's what I got:

[   68.394276] double fault: 0000 [#1] PREEMPT SMP=20
[   68.394304] Modules linked in: rfcomm bnep bluetooth rfkill crc16 nfsd a=
uth_rpcgss oid_registry nfs_acl nfs lockd dns_resolver fscache sunrpc loop =
fuse joydev hid_generic usbhid hid snd_hda_intel snd_hda_codec snd_hwdep sn=
d_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd processor evdev t=
tm drm_kms_helper thermal_sys psmouse soundcore drm i2c_piix4 serio_raw vir=
tio_balloon button i2c_core pcspkr microcode ext3 mbcache jbd sg sr_mod cdr=
om ata_generic virtio_net virtio_blk floppy uhci_hcd ata_piix ehci_hcd liba=
ta usbcore virtio_pci scsi_mod usb_common virtio_ring virtio
[   68.394307] CPU: 0 PID: 3044 Comm: bug723180 Not tainted 3.10-3-rt-amd64=
 #1 Debian 3.10.11-1
[   68.394307] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   68.394309] task: ffff88001df34300 ti: ffff88001b564000 task.ti: ffff880=
01b564000
[   68.394316] RIP: 0010:[<ffffffff8139ec30>]  [<ffffffff8139ec30>] native_=
irq_enable_sysexit+0x10/0x10
[   68.394317] RSP: 0018:0000000000000000  EFLAGS: 00010192
[   68.394318] RAX: 00000000000000e0 RBX: 0000000000000000 RCX: 00000000080=
4842b
[   68.394319] RDX: 00000000f7fc7000 RSI: 0000000008048420 RDI: 00000000000=
00000
[   68.394319] RBP: 00000000ffffd53c R08: 0000000000000000 R09: 00000000000=
00000
[   68.394320] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[   68.394320] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[   68.394321] FS:  0000000000000000(0000) GS:ffff88001fc00000(0063) knlGS:=
00000000f7e1b900
[   68.394322] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[   68.394323] CR2: fffffffffffffff8 CR3: 000000001f121000 CR4: 00000000000=
006f0
[   68.394326] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   68.394329] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   68.394329] Stack:
[   68.394331]  ffff88001fc05e68 ffff88001fc05f58 0000000000000ac0 00000000=
00000000
[   68.394332]  0000000000000000 0000000000000000 0000000000000040 ffffffff=
8100ef56
[   68.394334]  0000000081837a35 00000000ffffffff ffff88001fc05f58 ffffffff=
814011e8
[   68.394334] Call Trace:
[   68.394336]  <#DF>=20
[   68.394340]  [<ffffffff8100ef56>] ? show_regs+0x6d/0x1bd
[   68.394343]  [<ffffffff81399cbe>] ? __die+0x9e/0xdb
[   68.394345]  [<ffffffff8100fbe9>] ? die+0x3d/0x56
[   68.394346]  [<ffffffff8100de24>] ? do_double_fault+0x5c/0x5e
[   68.394348]  [<ffffffff8139e888>] ? double_fault+0x28/0x30
[   68.394350]  [<ffffffff8139ec30>] ? native_irq_enable_sysexit+0x10/0x10
[   68.394351]  <<EOE>>=20
[   68.394361] Code: 1f 84 00 00 00 00 00 0f 1f 40 00 0f 01 f8 0f 07 66 66 =
2e 0f 1f 84 00 00 00 00 00 0f 01 f8 fb 0f 35 66 2e 0f 1f 84 00 00 00 00 00 =
<0f> 01 f8 65 48 8b 24 25 e0 a7 00 00 48 83 c4 28 fb 0f 1f 80 00=20
[   68.394362] RIP  [<ffffffff8139ec30>] native_irq_enable_sysexit+0x10/0x1=
0
[   68.394362]  RSP <0000000000000000>
[   68.394385] ---[ end trace 0000000000000002 ]---
[   68.394434] ------------[ cut here ]------------
[   68.394442] WARNING: at /build/linux-BPzSEt/linux-3.10.11/debian/build/s=
ource_rt/kernel/smp.c:244 smp_call_function_single+0x71/0x157()
[   68.394454] Modules linked in: rfcomm bnep bluetooth rfkill crc16 nfsd a=
uth_rpcgss oid_registry nfs_acl nfs lockd dns_resolver fscache sunrpc loop =
fuse joydev hid_generic usbhid hid snd_hda_intel snd_hda_codec snd_hwdep sn=
d_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd processor evdev t=
tm drm_kms_helper thermal_sys psmouse soundcore drm i2c_piix4 serio_raw vir=
tio_balloon button i2c_core pcspkr microcode ext3 mbcache jbd sg sr_mod cdr=
om ata_generic virtio_net virtio_blk floppy uhci_hcd ata_piix ehci_hcd liba=
ta usbcore virtio_pci scsi_mod usb_common virtio_ring virtio
[   68.394456] CPU: 0 PID: 3044 Comm: bug723180 Tainted: G      D      3.10=
-3-rt-amd64 #1 Debian 3.10.11-1
[   68.394459] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   68.394460]  0000000000000000 ffffffff8103cced 0000000000000000 00000000=
00000000
[   68.394461]  0000000000000000 ffffffff810c08d9 ffff88001fc05e50 ffffffff=
810830f6
[   68.394462]  0000000000000000 0000000000000000 0000000000000000 00000000=
00000000
[   68.394463] Call Trace:
[   68.394466]  <#DF>  [<ffffffff8103cced>] ? warn_slowpath_common+0x5b/0x7=
0
[   68.394470]  [<ffffffff810c08d9>] ? perf_cgroup_exit+0x16/0x16
[   68.394472]  [<ffffffff810830f6>] ? smp_call_function_single+0x71/0x157
[   68.394473]  [<ffffffff810bff63>] ? task_function_call+0x42/0x4c
[   68.394475]  [<ffffffff810c3f87>] ? perf_cgroup_switch+0x141/0x141
[   68.394477]  [<ffffffff810924af>] ? cgroup_exit+0xc8/0xd3
[   68.394478]  [<ffffffff81041cbd>] ? do_exit+0x404/0x946
[   68.394480]  [<ffffffff81399c1b>] ? oops_end+0xa9/0xae
[   68.394482]  [<ffffffff8100de24>] ? do_double_fault+0x5c/0x5e
[   68.394484]  [<ffffffff8139e888>] ? double_fault+0x28/0x30
[   68.394485]  [<ffffffff8139ec30>] ? native_irq_enable_sysexit+0x10/0x10
[   68.394486]  <<EOE>>=20
[   68.394486] ---[ end trace 0000000000000003 ]---

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-Sv85+vOpNXwn35/b0kOz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUkLj+ee/yOyVhhEJAQpaKg/+JzmdIjsXMnaevZAh12S8ekPLvscw6OLE
iiUdqFv5iQkqKIYgwxxAdsQVmMHcGIpFj6vBaoVO9jGBQkeQugVCXc6be7MMKXzF
yf1AlhNY71v42kQS1auNM0JZOh//oWleapxVCVbliPz1cZCJKzxwEn6sBscESMCm
54r8upxJOD1K65POfpPfgTP8PueohlT6BSXrc9ICdFQeLDbJ7UD9j1jR66S/o6gG
ZRC5+7qiXtRMKObyNEsfQkEP4XzwNUq7OVZabnX3cYud/mPBcUE0aNrQ10i4IYLI
OdoRuAlvoZ1HUKmFPdFwIm2VrsAt/3pYO0DYvLBIo2/3/5Lmg4TOyJELBHtXUZ9s
0mvJaBV4egU1X6qzO6tfEmIGIyRUzqUAvQf4BktsdOkZ8114qwe91t8OR8saj21c
KpzbvxpVTzC06oMJAHX3h75hpKPgYfbD4VdAU9GRk4/F9KQjAkK5X+UgmQfjlgSt
a0rG1gRK1gH591rsVLPf5IoID/nXz3xQ6Xopms6cDMXg0m4Nwy5L+iNNGhzh/lDw
2G2TEaAeOXC/8Zv1S0HNRUD0wgrb8C9F/7v1oPdTywRpm25KC5AmpRxFC0hSeN+K
QOnanctqwV0BfH6FhBzHd+wcs9MvD4Ix/95pchkaots0eGlO8vrY0wlS2+JTvjIb
hPWhRo5OyP0=
=1ySU
-----END PGP SIGNATURE-----

--=-Sv85+vOpNXwn35/b0kOz--
