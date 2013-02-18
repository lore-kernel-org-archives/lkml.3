Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3BRKQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:16:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:48730 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3BRKQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:16:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,686,1355126400"; 
   d="scan'208";a="258307281"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org,
        linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        RavindranathX Doddi <ravindranathx.doddi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20130215200526.GA15811@core.coreip.homeip.net>
References: <20130215112911.68A98E0085@blue.fi.intel.com> <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com> <20130215120022.GA23694@x220> <20130215135141.1EFCEE0085@blue.fi.intel.com> <20130215200526.GA15811@core.coreip.homeip.net>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Content-Transfer-Encoding: 7bit
Message-Id: <20130218101808.EA71CE0085@blue.fi.intel.com>
Date: Mon, 18 Feb 2013 12:18:08 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Fri, Feb 15, 2013 at 03:51:41PM +0200, Kirill A. Shutemov wrote:
> > Johan Hedberg wrote:
> > > Hi David,
> > > 
> > > On Fri, Feb 15, 2013, David Herrmann wrote:
> > > > On Fri, Feb 15, 2013 at 12:29 PM, Kirill A. Shutemov
> > > > <kirill.shutemov@linux.intel.com> wrote:
> > > > > Hi David and all,
> > > > >
> > > > > There's claim in uhid.h that the interface is "compatible even between
> > > > > architectures". But it obviously is not true: struct uhid_create_req
> > > > > contains pointer which breaks everything.
> > > > >
> > > > > The easy way to demonstrate the issue is compile uhid-example.c with -m32
> > > > > and try to run it on 64 bit kernel. Creating of the device will fail.
> > > > 
> > > > Indeed, we missed that. We should probably also notify the HIDP
> > > > developers as "struct hidp_connadd_req" suffers from the same
> > > > problems. (CC'ed)
> > > > 
> > > > > I don't see an easy way to fix this. Few options:
> > > > >
> > > > > 1. Replace the pointer with u64. It will fix the issue, but it breaks ABI
> > > > >    which is never a good idea. Not sure how many users interface already
> > > > >    has.
> > > > 
> > > > The only users I am aware of is an HID debugging tool and experimental
> > > > HoG Bluetooth support (bluez). Maybe Marcel or Johan can comment
> > > > whether this is already used by bluez-5? If it is, then we shouldn't
> > > > break ABI and go with #2+#3. Otherwise, I think changing to u64 should
> > > > be ok.
> > > > On the other hand, it would break any future build for older stable
> > > > kernels so not breaking ABI is probably the best idea. Any comments? I
> > > > can add a COMPAT fix and a comment to fix this in the next version of
> > > > UHID_CREATE.
> > > 
> > > The HoG code in BlueZ 5 does indeed use this API and it's also not
> > > anymore behind any kind of experimental flag (i.e. it is an officially
> > > supported feature).
> > > 
> > > Johan
> > 
> > Here's my attempt to fix the issue.
> > 
> > Not sure if tricks with padding in a good idea. We can  just use __u64
> > instead of pointer, but it will require update of userspace to silence
> > cast warning and will cause warning if you will try to use updated
> > userspace with old kernel headers.
> > 
> > Any comments?
> 
> This does not fix anything really, we simply have to deal with compat
> interface.
> 
> Compiled but not tested.

Works for me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Comment in uhid.h about cross-arch compatibility should be
removed since it's false.

-- 
 Kirill A. Shutemov
