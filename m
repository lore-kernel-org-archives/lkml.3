Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3HKVDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 17:03:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38067 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab3HKVDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 17:03:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, vasilis.liaskovitis@profitbricks.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: Cannot hot remove a memory device
Date: Sun, 11 Aug 2013 23:13:31 +0200
Message-ID: <1637752.e6s4mPrvSE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376002242.10300.235.camel@misato.fc.hp.com>
References: <51FA1E41.20304@jp.fujitsu.com> <13789925.vhhiTlyGIy@vostro.rjw.lan> <1376002242.10300.235.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 08, 2013 04:50:42 PM Toshi Kani wrote:
> On Fri, 2013-08-09 at 00:12 +0200, Rafael J. Wysocki wrote:
> > On Thursday, August 08, 2013 11:15:20 AM Toshi Kani wrote:
> > > On Fri, 2013-08-02 at 18:04 -0600, Toshi Kani wrote:
> > > > On Sat, 2013-08-03 at 01:43 +0200, Rafael J. Wysocki wrote:
> > > > > On Friday, August 02, 2013 03:46:15 PM Toshi Kani wrote:
> > > > > > On Thu, 2013-08-01 at 23:43 +0200, Rafael J. Wysocki wrote:
> > >  :
> > > > > > I think it fails with -EINVAL at the place with dev_warn(dev, "ACPI
> > > > > > handle is already set\n").  When two ACPI memory objects associate with
> > > > > > a same memory block, the bind procedure of the 2nd ACPI memory object
> > > > > > sees that ACPI_HANDLE(dev) is already set to the 1st ACPI memory object.
> > > > > 
> > > > > That sound's plausible, but I wonder how we can fix that?
> > > > > 
> > > > > There's no way for a single physical device to have two different ACPI
> > > > > "companions".  It looks like the memory blocks should be 64 M each in that
> > > > > case.  Or we need to create two child devices for each memory block and
> > > > > associate each of them with an ACPI object.  That would lead to complications
> > > > > in the user space interface, though.
> > > > 
> > > > Right.  Even bigger issue is that I do not think __add_pages() and
> > > > __remove_pages() can add / delete a memory chunk that is less than
> > > > 128MB.  128MB is the granularity of them.  So, we may just have to fail
> > > > this case gracefully.
> > > 
> > > FYI: I have submitted the patch blow to close this part of the issue...
> > > 
> > > https://lkml.org/lkml/2013/8/8/396
> > 
> > That looks good to me, but we'd still need to make it possible to have
> > memory blocks smaller than 128 MB ...
> 
> Do you mean acpi_bind_one() needs to be able to handle such case?  If
> so, it should not be a problem since a memory block device won't be
> created when add_memory() fails with the change above.  So, there is no
> binding to be done.  If you mean add_memory() needs to be able to handle
> a smaller range, that's quite a tough one unless we make the section
> size smaller.
> 
> BTW, when add_memory() fails, the memory hot-add request still succeeds
> with no driver attached.  This seems logical, but the added device is
> useless when no handler is attached.  And it does not allow ejecting the
> device with no handler.  I am not too worry about this since this is a
> rare case, but it reminded me that the framework won't handle rollback.

I'm not sure which rollback you mean.  During removal?

There are two slight problems here in my view.  First, even if the device
cannot be ejected directly, it still will be removed when its parent is
ejected, so it may be more consistent to just allow everything to be ejected
regardless of whether or not it has a scan handler.  Second, I guess the
removal is undesirable for memory devices for which the registration of the
scan handler failed, so it would be good to fail the "offline" of such devices
regardless of how we get there.  That's why I thought it would be good to have
an "offline disabled" flag in struct acpi_device.

Thanks,
Rafael

