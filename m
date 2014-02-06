Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaBFTmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:42:39 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55703 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaBFTmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:42:37 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 6 Feb 2014 11:42:17 -0800
Message-ID: <CALCETrV+tRSJ_s5eYVP5O-Ok4pNe+6biJvscmYB+jgC5_ky-ow@mail.gmail.com>
Subject: [RFC/ANNOUNCE] virtme, a easy way to test your kernel changes in qemu/kvm
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tl;dr: virtme-runkernel ~/whatever/arch/x86/boot/bzImage


Once upon a time, whenever I wanted to test a kernel change, I would
install the kernel, boot it, and watch it crash and burn.

Then KVM came along.  So, to test a kernel change, I would scrounge
around for a disk image, try to remember the magic QEMU incantation to
boot my kernel with that image, and spend a while cursing at the
initramfs that would inevitable fail to find my "hard disk".  Then I'd
curse more because it's a real PITA to share files between the host
and a guest.  At some point I'd accidentally corrupt my image, and
then I'd start over.

Then virtfs came along.  I wrote some truly awful scripts.  They worked.

Virtme is a drastic cleanup (i.e. complete rewrite) of the scripts.
It's called "virtme" because it runs *the host distribution* in the
guest.  The entire process takes about three seconds on my laptop.
Here's how it works:

virtme-mkinitramfs generates a very simple initramfs that chains to a
virtfs root.  It invokes virtme-init.

virtme-init is an init binary that does some minimal setup to get a
working environment overlaid on top of a read-only virtfs mount.  It's
enough to have a very functional shell, complete with job control,
colors (!), a few VTs, and no password prompt (!).  Oh yeah, you can
cd into your very own home directory so you can run those handy test
scripts you just downloaded.

virtme-runkernel is a silly script that wraps virtme-mkinitramfs and qemu-kvm.


Here are some ideas for future directions:

 - Fix the module situation.  You should be able to run virtme on a
distro kernel.  Either this will be a giant hack or I'll have to learn
how to use libkmod to resolve dependencies properly.

 - Integrate (optionally) with libvirt.  This trick might be useful
for things other than kernel hacking :)

 - Come up with syntax to invoke a script in the VM, report the
results, and shut down, AKA automated testing without any real need to
provision anything.

 - Come up with syntax to mount things more flexibly (e.g. have a
read-write directory, perhaps).

 - Make it work across architectures and get the guest part into
distributions.  I want to be able to unpack a Fedora ARM root (or
Debian or whatever) and virtme into it.  This is conceptually trivial,
but the tools are currently too dumb to make it work.

 - Real error messages!

 - Fall back to the host's modprobe, sh, mount, and switch_root if
busybox is unavailable.  That will be a decent amount of code (and
slowdown) for minimal benefit, though.

 - Test this thing on something other than Fedora 20.

 - Run systemd in the guest.  (I am very unlikely to do this unless
someone presents a good use case, though.)

 - Use virtconsole so that copy and paste works.  (If I try this, I
will complain to everyone involved for the fact that there's
apparently no way at all to figure out which virtio port matches which
hvc device in the guest. Are we really stuck in the dark ages of
guessing what /dev/hvcN is?)

 - Build a tight sandbox around this.

Thoughts?


https://git.kernel.org/cgit/utils/kernel/virtme/virtme.git
https://github.com/amluto/virtme
