Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3J3LUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:20:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21318 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3J3LUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:20:52 -0400
Date: Wed, 30 Oct 2013 12:19:24 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        ian.campbell@citrix.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com,
        The development of GNU GRUB <grub-devel@gnu.org>,
        david.woodhouse@intel.com, richard.l.maliszewski@intel.com,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        seth.goldberg@oracle.com, pjones@redhat.com,
        linux-kernel@vger.kernel.org, keir@xen.org, mjg59@srcf.ucam.org,
        shidokht.yadegari@oracle.com, neal.pollack@oracle.com,
        arvidjaar@gmail.com, mchang@suse.com, mchang.novell@gmail.com
Subject: Is: Wrap-up Was: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131030111924.GE3425@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <526599A8.9090501@gmail.com>
 <52663D54.2020800@gmail.com>
 <20131028162603.GA4716@phenom.dumpdata.com>
 <526EA686.70008@gmail.com>
 <526F7FC402000078000FD7BA@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F7FC402000078000FD7BA@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a short summary of our discussion. It looks
that we have two choices right now:
  - chainloader,
  - multiboot2 protocol.

chainloader solution could be implemented quite easily. Some code should be
added for command line parsing. However, all arguments for Xen itself and
modules must be passed as single line with special separators (e.g. ///;
correct me if I am wrong). This thing makes that solution not very convenient,
especially if you would like to edit boot command line directly from boot
loader. chainloader will support PE images directly. However, it could load
only PE image with Xen. Xen image should load all other parts but they could
be loaded from FAT filesystem only. This works because it was implemented
in original Xen EFI implementation. Support for secure boot and shim loader
could be added. It was implemented by SUSE guys and is available in latest SUSE
distros. However, it is not merged into GRUB2 upstream (like linuxefi). I do
not know what are GRUB2 and SUSE guys plans to upstream this solution.

multiboot2 protocol requires some more changes. However, about 80% of code
is ready. In this case Xen and modules are loaded by GRUB2 itself. It means
that all images could be placed on any filesystem recognized by GRUB2. Options
for Xen and modules are passed separately which simplifies command line editing
in boot loader and parsing. multiboot2 protocol is very flexible and could be
easily extended in the future if a need arises. Support for secure boot and
shim loader could be added. However, it was not implemented yet. Probably
linuxefi module could be used as a reference or even as a base for development.
However, I do not know are there plans to support such solution by GRUB2
community. Currently, support for native PE images signatures and GPG signatures
is under development for GRUB2 upstream.

Personally I prefer multiboot2 protocol solution because it is much
more flexible and easier for use (even if it is more difficult to
implement).

There is still open question that ExitBootServices() should be called by GRUB2
loader or by loaded image itself on EFI platform. UEFI spec 2.4 states in many
places that it is "OS loader" or "Operating System" responsibility. However,
I think that "OS loader" should be understood as a integral piece of "Operating
System" responsible for its load into memory without usage of any additional
loader like GRUB2. So in this situation it looks that "Operating System" should
call ExitBootServices() on EFI platforms instead of GRUB2. Even if we agree that
this assumption is wrong I think that it is better to give an "Operating System"
a choice to use boot services. This way OS could decide which source of information
is more convenient in its case, do extra things with EFI platform support (e.g.
get memory map directly from EFI) and call ExitBootServices() in relevant time.

There is also third solution for issues with ExitBootServices(). In case
of multiboot2 protocol OS could request that EFI should be left as is.
Solution was proposed by Vladimir and I think that it makes sense. However,
this does not solve problem with ExitBootServices() in case of other
boot loaders/protocols. So we should take a decision accordingly to above
considerations in regards to linux, chainloader and similar stuff.

Daniel
