Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3CFIq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:46:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab3CFIqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:46:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6823284"
Date: Wed, 6 Mar 2013 16:46:58 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 0/8] pv event interface between host and guest
Message-ID: <20130306084658.GA4719@localhost.localdomain>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <20130303091738.GB23616@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20130303091738.GB23616@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:45:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:45:47,
	Serialize complete at 2013/03/06 16:45:47
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 11:17:38AM +0200, Gleb Natapov wrote:
> On Thu, Feb 28, 2013 at 08:13:10PM +0800, Hu Tao wrote:
> > This series implements a new interface, kvm pv event, to notify host when
> > some events happen in guest. Right now there is one supported event: guest
> > panic.
> > 
> What other event do you have in mind? Is interface generic enough to
> accommodate future, yet unknown, events. It allows to pass only one
> integer specifying even type, what if additional info is needed? My be

guest crash, lockup, or warning.[1] But the first purpose is to do panic
notification(panic event). Since at the point the guest is panicked, I
think it's better to keep the interface as simple as possible.

[1] http://wiki.qemu.org/Features/PVCrashDetection

> stop pretending that device is generic and make it do once thing but do

you mean make the interface just do panic notification?

> it well? For generic even passing interface (whatever it may be needed
> for) much more powerful virtio should be used.
> 
> On implementation itself I do not understand why is this kvm specific.
> The only thing that makes it so is that you hook device initialization
> into guest kvm initialization code, but this is obviously incorrect.
> What stops QEMU tcg or Xen from reusing the same device for the same
> purpose except the artificial limitation in a guest.
> 
> Reading data from a random ioports is not how you discover platform
> devices in 21 century (and the data you read from unassigned port is not
> guarantied to be zero, it may depend on QEMU version), you use ACPI for
> that and Marcelo already pointed that to you. Having little knowledge of
> ACPI (we all do) is not a good reason to not doing it. We probably need
> to reserve QEMU specific ACPI Plug and Play hardware ID to define our own

Do we have to request the ID from some orgnazation?

> devices. After that you will be able to create device with _HID(QEMU0001)

QMU0001, I think. EISA ID requires it to have only 3 letters for PNP ID.

> in DSDT that supplies address information (ioport to use) and capability
> supported. Guest uses acpi_get_devices() to discover a platform device by
> its name (QEMU0001).  Then you put the driver for the platform device
> into drivers/platform/x86/ and QEMU/kvm/Xen all will be able to use it.

Thanks for the information!

> 
> On QEMU side of things I cannot comment much on how QOMified the device
> is (it should be), I hope other reviews will verify it, but I noticed
> that device is only initialized for PIIX, what about Q35?
> 
> --
> 			Gleb.
