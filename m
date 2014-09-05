Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaIERZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:25:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaIERZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:25:49 -0400
Date: Fri, 5 Sep 2014 19:25:41 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, falcon@meizu.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        hare@suse.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, santosh@chelsio.com, Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2 2/6] driver-core: add driver async_probe support
Message-ID: <20140905172541.GA17986@wotan.suse.de>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com> <1409899047-13045-3-git-send-email-mcgrof@do-not-panic.com> <20140905112417.GB22778@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905112417.GB22778@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 01:24:17PM +0200, Oleg Nesterov wrote:
> On 09/04, Luis R. Rodriguez wrote:
> >
> >  struct driver_private {
> >  	struct kobject kobj;
> >  	struct klist klist_devices;
> >  	struct klist_node knode_bus;
> >  	struct module_kobject *mkobj;
> > +	struct driver_attach_work *attach_work;
> >  	struct device_driver *driver;
> 
> I am not arguing, just curious...
> 
> Are you trying to shrink sizeof(driver_private) ? 

Yeap.

> The code can be simpler
> if you just embedd "struct work_struct attach_work" into driver_private,
> and you do not need "struct driver_attach_work" or another ->driver pointer
> this way.

Agreed, I considered it and figured it wouldn't make much sense
to push onto folks more bytes if this feature was optional and
likely only used by a few drivers, so a pointer / kzalloc seemed
better to deal with. This saves us 24 bytes. I even tried to
implement a container_of_p() for pointers but that obviosly
didn't work well fast as a pointer can have any address and is
not relative to the parent, and if its on stack the address
can vary depending on implementation. For example the first member
should always have the same address as the struct but if the
first member is a pointer it would be off for me by 12 bytes.
I am not sure if this is standarized or not.

  Luis
