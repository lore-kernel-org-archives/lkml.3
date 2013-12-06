Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3LFABW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:01:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3LFABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:01:19 -0500
Date: Thu, 5 Dec 2013 16:01:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Matt Domsch <Matt_Domsch@dell.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kobject: remove kset from sysfs immediately in
 kset_unregister()
Message-ID: <20131206000117.GA21358@kroah.com>
References: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131008202016.19377.17182.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131203180425.GC15279@kroah.com>
 <20131203224143.GA19962@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203224143.GA19962@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 03:41:43PM -0700, Bjorn Helgaas wrote:
> [+cc Matt, Tejun]
> 
> On Tue, Dec 03, 2013 at 10:04:25AM -0800, Greg Kroah-Hartman wrote:
> > On Tue, Oct 08, 2013 at 02:20:16PM -0600, Bjorn Helgaas wrote:
> > > There's no explicit "unlink from sysfs" interface for ksets, so I think
> > > callers of kset_unregister() expect the kset to be removed from sysfs
> > > immediately, without waiting for the last reference to be released.
> > > 
> > > This patch makes the sysfs removal happen immediately, so the caller may
> > > create a new kset with the same name as soon as kset_unregister() returns.
> > > 
> > > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > With the PCI MSI attribute change, this patch is no longer needed,
> > right?
> 
> Well, yes and no.  The attached patch extends Russell's delayed kobject
> release to make the delay somewhat random.  I *think* that should be
> valid, but correct me if I'm wrong.

Heh, I like it, mind if I queue it up?

> With the random delay patch, it's easy to trigger the "sysfs: cannot
> create duplicate filename" error, e.g., by unloading and reloading the
> edd module, because the module unload only waits for the /sys/module/edd
> object to be released.  Other objects, such as the /sys/firmware/edd
> kset, may be released later.
> 
> Modules like edd could be changed to explicitly call kobject_del() on
> the kset kobject.  Maybe that's a better approach, so we consistently
> use kobject_del() to remove things from sysfs.  But I don't know whether
> it's really useful to allow the kset to hang around in sysfs after
> kset_unregister(), and it's sort of subtle to track down problems like
> this.
> 
> Several other kset_unregister() callers have this situation, so if we
> don't change it to call kobject_del() internally, maybe we should add a
> note to Documentation/kobject.txt about calling kobject_del() first.
> The existing hint only talks about using it when you need a two-stage
> delete, which isn't really the case here.
> 
> If we *do* decide to change kset_unregister(), I have an updated
> documentation patch that makes it more clear that the release may
> happen after kset_unregister() returns.

Ok, I'll take this patch, it makes sense on the module unload path for
example.  Thanks for the explanation.

greg k-h
