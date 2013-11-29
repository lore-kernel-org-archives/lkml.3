Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3K2XdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:33:07 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65365 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751073Ab3K2XdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:33:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Date: Sat, 30 Nov 2013 00:45:55 +0100
Message-ID: <4276127.HzbOlVUbc2@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <461934992.nFRx8soJrp@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <CAE9FiQXevSPmPEvxzXjC-CFhpYHic0v+vN5+JV3j5kmX-wv_GQ@mail.gmail.com> <461934992.nFRx8soJrp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 30, 2013 12:38:26 AM Rafael J. Wysocki wrote:
> On Tuesday, November 26, 2013 06:26:54 PM Yinghai Lu wrote:
> > On Tue, Nov 26, 2013 at 5:24 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >
> > > So assume pci_destroy_dev() is called twice in parallel for the same dev
> > > by two different threads.  Thread 1 does the atomic_inc_and_test() and
> > > finds that it is OK to do the device_del() and put_device() which causes
> > > the device object to be freed.  Then thread 2 does the atomic_inc_and_test()
> > > on the already freed device object and crashes the kernel.
> > >
> > thread2 should still hold one extra reference.
> > that is in
> >   device_schedule_callback
> >      ==> sysfs_schedule_callback
> >          ==> kobject_get(kobj)
> > 
> > pci_destroy_dev for thread2 is called at this point.
> > 
> > and that reference will be released from
> >         sysfs_schedule_callback
> >         ==> kobject_put()...
> 
> Well, that would be the case if thread 2 was started by device_schedule_callback(),
> but again, for example, it may be trim_stale_devices() started by acpiphp_check_bridge()
> that doesn't hold extra references to the pci_dev.  [Well, that piece of code
> is racy anyway, because it walks bus->devices without locking.  Which is my
> fault too, because I overlooked that.  Shame, shame.]
> 
> Perhaps we can do something like the (untested) patch below (in addition to the
> $subject patch).  Do you see any immediate problems with it?

Ah, I see one.  It will break pci_stop_bus_device() and pci_remove_bus_device().
So much for being clever.

Moreover, it looks like those two routines above are racy too for the same
reason?

Rafael

