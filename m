Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3CRRVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:21:02 -0400
Received: from canardo.mork.no ([148.122.252.1]:35838 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab3CRRU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:20:59 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        linux-hotplug@vger.kernel.org, linux-pci@vger.kernel.org,
        yuxiangl@marvell.com, yxlraid@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
Organization: m
References: <20130316213512.2974.17303.stgit@amt.stowe>
	<20130316213519.2974.38954.stgit@amt.stowe>
	<20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
	<20130317010317.GB9641@kroah.com>
	<1363493482.16793.69.camel@ul30vt.home>
	<20130317053611.GC948@kroah.com>
	<1363527503.16793.75.camel@ul30vt.home>
	<CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
	<1363623880.24132.351.camel@bling.home>
	<20130318164126.GA20565@kroah.com>
	<1363625463.24132.367.camel@bling.home>
Date: Mon, 18 Mar 2013 18:20:46 +0100
In-Reply-To: <1363625463.24132.367.camel@bling.home> (Alex Williamson's
	message of "Mon, 18 Mar 2013 10:51:03 -0600")
Message-ID: <87obeg39qp.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:

> At least for KVM the kernel fix is the addition of the vfio driver which
> gives us a non-sysfs way to do this.  If this problem was found a few
> years later and we were ready to make the switch I'd support just
> removing these resource files.  In the meantime we have userspace that
> depends on this interface, so I'm open to suggestions how to fix it.

I am puzzled by a couple of things in this discussion:

1) do you seriously mean that a userspace application (any, not just
   udevadm or qemu or whatever) should be able to read and write these
   registers while the device is owned by a driver?  How is that ever
   going to work?

2) is it really so that a device can be so fundamentally screwed up by
   reading some registers, that a later driver probe cannot properly
   reinitialize it?

I would have thought that the solution to all this was to return -EINVAL
on any attemt to read or write these files while a driver is bound to
the device.  If userspace is going to use the API, then the application
better unbind any driver first.

Or? Am I missing something here?

> If we want to blacklist this specific device, that's fine, but as others
> have pointed out it's really a class problem.  Perhaps we report 1 byte
> extra for the file length where EOF-1 is an enable byte?  Is there
> anything else in file ops that we could use to make it slightly more
> complicated than open(), read() to access the device?  Thanks,

If there really are devices which cannot handle reading at all, and
cannot be reset to a sane state by later driver initialization, then a
blacklist could be added for those devices.  This should not be a common
problem.



Bjørn
