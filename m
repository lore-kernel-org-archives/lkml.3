Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3BDXQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:16:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40410 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab3BDXQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:16:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 01/12] Add sys_hotplug.h for system device hotplug framework
Date: Tue, 05 Feb 2013 00:23:07 +0100
Message-ID: <1910026.S9WaQTy2uW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360011567.23410.179.camel@misato.fc.hp.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com> <3007489.fG0fDZGHrB@vostro.rjw.lan> <1360011567.23410.179.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 01:59:27 PM Toshi Kani wrote:
> On Mon, 2013-02-04 at 20:45 +0100, Rafael J. Wysocki wrote:
> > On Monday, February 04, 2013 09:46:18 AM Toshi Kani wrote:
> > > On Mon, 2013-02-04 at 04:46 -0800, Greg KH wrote:
> > > > On Sun, Feb 03, 2013 at 05:28:09PM -0700, Toshi Kani wrote:
> > > > > On Sat, 2013-02-02 at 16:01 +0100, Greg KH wrote:
> > > > > > On Fri, Feb 01, 2013 at 01:40:10PM -0700, Toshi Kani wrote:
> > > > > > > On Fri, 2013-02-01 at 07:30 +0000, Greg KH wrote:
> > > > > > > > On Thu, Jan 31, 2013 at 06:32:18PM -0700, Toshi Kani wrote:
> > > > > > > >  > This is already done for PCI host bridges and platform devices and I don't
> > > > > > > > > > see why we can't do that for the other types of devices too.
> > > > > > > > > > 
> > > > > > > > > > The only missing piece I see is a way to handle the "eject" problem, i.e.
> > > > > > > > > > when we try do eject a device at the top of a subtree and need to tear down
> > > > > > > > > > the entire subtree below it, but if that's going to lead to a system crash,
> > > > > > > > > > for example, we want to cancel the eject.  It seems to me that we'll need some
> > > > > > > > > > help from the driver core here.
> > > > > > > > > 
> > > > > > > > > There are three different approaches suggested for system device
> > > > > > > > > hot-plug:
> > > > > > > > >  A. Proceed within system device bus scan.
> > > > > > > > >  B. Proceed within ACPI bus scan.
> > > > > > > > >  C. Proceed with a sequence (as a mini-boot).
> > > > > > > > > 
> > > > > > > > > Option A uses system devices as tokens, option B uses acpi devices as
> > > > > > > > > tokens, and option C uses resource tables as tokens, for their handlers.
> > > > > > > > > 
> > > > > > > > > Here is summary of key questions & answers so far.  I hope this
> > > > > > > > > clarifies why I am suggesting option 3.
> > > > > > > > > 
> > > > > > > > > 1. What are the system devices?
> > > > > > > > > System devices provide system-wide core computing resources, which are
> > > > > > > > > essential to compose a computer system.  System devices are not
> > > > > > > > > connected to any particular standard buses.
> > > > > > > > 
> > > > > > > > Not a problem, lots of devices are not connected to any "particular
> > > > > > > > standard busses".  All this means is that system devices are connected
> > > > > > > > to the "system" bus, nothing more.
> > > > > > > 
> > > > > > > Can you give me a few examples of other devices that support hotplug and
> > > > > > > are not connected to any particular buses?  I will investigate them to
> > > > > > > see how they are managed to support hotplug.
> > > > > > 
> > > > > > Any device that is attached to any bus in the driver model can be
> > > > > > hotunplugged from userspace by telling it to be "unbound" from the
> > > > > > driver controlling it.  Try it for any platform device in your system to
> > > > > > see how it happens.
> > > > > 
> > > > > The unbind operation, as I understand from you, is to detach a driver
> > > > > from a device.  Yes, unbinding can be done for any devices.  It is
> > > > > however different from hot-plug operation, which unplugs a device.
> > > > 
> > > > Physically, yes, but to the driver involved, and the driver core, there
> > > > is no difference.  That was one of the primary goals of the driver core
> > > > creation so many years ago.
> > > > 
> > > > > Today, the unbind operation to an ACPI cpu/memory devices causes
> > > > > hot-unplug (offline) operation to them, which is one of the major issues
> > > > > for us since unbind cannot fail.  This patchset addresses this issue by
> > > > > making the unbind operation of ACPI cpu/memory devices to do the
> > > > > unbinding only.  ACPI drivers no longer control cpu and memory as they
> > > > > are supposed to be controlled by their drivers, cpu and memory modules.
> > > > 
> > > > I think that's the problem right there, solve that, please.
> > > 
> > > We cannot eliminate the ACPI drivers since we have to scan ACPI.  But we
> > > can limit the ACPI drivers to do the scanning stuff only.   This is
> > > precisely the intend of this patchset.  The real stuff, removing actual
> > > devices, is done by the system device drivers/modules.
> > 
> > In case you haven't realized that yet, the $subject patchset has no future.
> 
> That's really disappointing, esp. the fact that this basic approach has
> been proven to work on other OS for years...
> 
> 
> > Let's just talk about how we can get what we need in more general terms.
> 
> So, are we heading to an approach of doing everything in ACPI?  I am not
> clear about which direction we have agreed with or disagreed with.
> 
> As for the eject flag approach, I agree with Greg.

Well, I'm not sure which of the Greg's thoughts you agree with. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
