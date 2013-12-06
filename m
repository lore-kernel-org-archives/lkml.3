Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3LFAfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:35:19 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51656 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3LFAfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:35:15 -0500
MIME-Version: 1.0
In-Reply-To: <20131206000117.GA21358@kroah.com>
References: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131008202016.19377.17182.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131203180425.GC15279@kroah.com> <20131203224143.GA19962@google.com> <20131206000117.GA21358@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Dec 2013 17:34:54 -0700
Message-ID: <CAErSpo5zWigf=b41uA=OBaFsCb3DNxXFj+2RoD1X8vSqTKDQ4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] kobject: remove kset from sysfs immediately in kset_unregister()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Matt Domsch <Matt_Domsch@dell.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 5:01 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Dec 03, 2013 at 03:41:43PM -0700, Bjorn Helgaas wrote:
>> [+cc Matt, Tejun]
>>
>> On Tue, Dec 03, 2013 at 10:04:25AM -0800, Greg Kroah-Hartman wrote:
>> > On Tue, Oct 08, 2013 at 02:20:16PM -0600, Bjorn Helgaas wrote:
>> > > There's no explicit "unlink from sysfs" interface for ksets, so I think
>> > > callers of kset_unregister() expect the kset to be removed from sysfs
>> > > immediately, without waiting for the last reference to be released.
>> > >
>> > > This patch makes the sysfs removal happen immediately, so the caller may
>> > > create a new kset with the same name as soon as kset_unregister() returns.
>> > >
>> > > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> >
>> > With the PCI MSI attribute change, this patch is no longer needed,
>> > right?
>>
>> Well, yes and no.  The attached patch extends Russell's delayed kobject
>> release to make the delay somewhat random.  I *think* that should be
>> valid, but correct me if I'm wrong.
>
> Heh, I like it, mind if I queue it up?

Sure, that'd be fine.  I'll resend these two patches with my sign-off
and updated changelogs.

>> With the random delay patch, it's easy to trigger the "sysfs: cannot
>> create duplicate filename" error, e.g., by unloading and reloading the
>> edd module, because the module unload only waits for the /sys/module/edd
>> object to be released.  Other objects, such as the /sys/firmware/edd
>> kset, may be released later.
>>
>> Modules like edd could be changed to explicitly call kobject_del() on
>> the kset kobject.  Maybe that's a better approach, so we consistently
>> use kobject_del() to remove things from sysfs.  But I don't know whether
>> it's really useful to allow the kset to hang around in sysfs after
>> kset_unregister(), and it's sort of subtle to track down problems like
>> this.
>>
>> Several other kset_unregister() callers have this situation, so if we
>> don't change it to call kobject_del() internally, maybe we should add a
>> note to Documentation/kobject.txt about calling kobject_del() first.
>> The existing hint only talks about using it when you need a two-stage
>> delete, which isn't really the case here.
>>
>> If we *do* decide to change kset_unregister(), I have an updated
>> documentation patch that makes it more clear that the release may
>> happen after kset_unregister() returns.
>
> Ok, I'll take this patch, it makes sense on the module unload path for
> example.  Thanks for the explanation.
