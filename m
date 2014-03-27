Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaC0Ixy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:53:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56351 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaC0Ixv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:53:51 -0400
Date: Thu, 27 Mar 2014 09:53:47 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>,
        Alejandro Comisario <alejandro.comisario@mercadolibre.com>,
        kvm@vger.kernel.org, ghammer@redhat.com,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] Massive read only kvm guests when backing file was
 missing
Message-ID: <20140327085347.GB9580@stefanha-thinkpad.redhat.com>
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
 <20140327064158.GA17563@redhat.com>
 <87y4zwt7mu.fsf@blackfin.pond.sub.org>
 <20140327081040.GA21756@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140327081040.GA21756@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 10:10:40AM +0200, Michael S. Tsirkin wrote:
> On Thu, Mar 27, 2014 at 08:36:57AM +0100, Markus Armbruster wrote:
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> > 
> > > On Wed, Mar 26, 2014 at 11:08:03PM -0300, Alejandro Comisario wrote:
> > >> Hi List!
> > >> Hope some one can help me, we had a big issue in our cloud the other
> > >> day, a couple of our openstack regions ( +2000 kvm guests with qcow2 )
> > >> went read only filesystem from the guest side because the backing
> > >> files directory (the openstack _base directory) was compromised and
> > >> the data was lost, when we realized the data was lost, it took us 5
> > >> mins to restore the backup of the backing files, but by that time all
> > >> the kvm guests received some kind of IO error from the hypervisor
> > >> layer, and went read only on root filesystem.
> > >> 
> > >> My question would be, is there a way to hold the IO operations against
> > >> the backing files ( i thought that would be 99% READ operations ) for
> > >> a little longer ( im asking this because i dont quite understand what
> > >> is the process and when it raises the error ) in a case the backing
> > >> files are missing (no IO possible) but is recoverable within minutes ?
> > >> 
> > >> Any tip  on how to achieve this if possible, or information about how
> > >> backing files works on kvm, will be amazing.
> > >> Waiting for feedback!
> > >> 
> > >> kindest regards.
> > >> Alejandro Comisario
> > >
> > >
> > > I'm guessing this is what happened: guests timed out meanwhile.
> > > You can increase the timeout within the guest:
> > > echo 600 > /sys/block/sda/device/timeout
> > > to timeout after 10 minutes.
> > >
> > > If you have installed qemu guest agent on your system, you can do this
> > > from the host. Unfortunately by default it's memory can be pushed out to swap
> > > and then on disk error access there might will fail :(
> > > Maybe we should consider mlock on all its memory at least as an option.
> > >
> > > You could pause your guests, restart them after the issue is resolved,
> > > and we could I guess add functionality to pause VM on disk errors
> > > automatically.
> > > Stefan?
> > 
> > Would -drive rerror=stop do?
> 
> I think it will. It's a pity it doesn't appear in --help output -
> would make it easier to find.

It is documented on the man page.  I'll send a patch to document it in
the --help output too.

But there's still a problem because the guest can have a shorter timeout
or the image may be NFS mounted on the host.  In that case the guest may
give up on the request before the host.  Then there is nothing QEMU can
do to avoid an error being returned to the application or the guest file
system going into read-only mode.

So make sure the timeout inside the guest is high.

Stefan
