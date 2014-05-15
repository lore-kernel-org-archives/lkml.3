Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaEODPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:15:32 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49365 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaEODPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:15:31 -0400
Date: Wed, 14 May 2014 22:15:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael H. Warfield" <mhw@WittsEnd.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140515031527.GA146352@ubuntu-hedt>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Michael H. Warfield" <mhw@WittsEnd.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Biederman <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	lxc-devel@lists.linuxcontainers.org
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 10:17:31PM -0400, Michael H. Warfield wrote:
> > > Using devtmpfs is one possible
> > > solution, and it would have the added benefit of making container setup
> > > simpler. But simply letting containers mount devtmpfs isn't sufficient
> > > since the container may need to see a different, more limited set of
> > > devices, and because different environments making modifications to
> > > the filesystem could lead to conflicts.
> > > 
> > > This series solves these problems by assigning devices to user
> > > namespaces. Each device has an "owner" namespace which specifies which
> > > devtmpfs mount the device should appear in as well allowing priveleged
> > > operations on the device from that namespace. This defaults to
> > > init_user_ns. There's also an ns_global flag to indicate a device should
> > > appear in all devtmpfs mounts.
> 
> > I'd strongly argue that this isn't even a "problem" at all.  And, as I
> > said at the Plumbers conference last year, adding namespaces to devices
> > isn't going to happen, sorry.  Please don't continue down this path.
> 
> I was just mentioning that to Serge just a week or so ago reminding him
> of what you told all of us face to face back then.  We were having a
> discussion over loop devices into containers and this topic came up.

It was the loop device use case that got me started down this path in
the first place, so I don't personally have any interest in physical
devices right now (though I was sure others would).

As things stand today, to support loop devices lxc would need to do
something like this: grab some unused loop devices, remove them from
/dev, and make device nodes with appropriate ownership/permissions in
the container's /dev. Otherwise there's potential for accidental
duplicate use of the devices, which besides having unexpected results
could result in information leak into the container. At that point you
have some loop devices that the container can use, but privileged
operations such as re-reading partitions and encrypted loop aren't
possible. Even if you can re-read partitions device nodes will appear in
the main /dev and not in the container.

With these patches the container could mount devtmpfs, and since
loop-control is global it would appear in the mount. The
LOOP_CTL_GET_FREE ioctl can be used to get an unused loop device which
will owned by the container's user namespace, so it will only appear in
that container's devtmpfs mount. Privileged operations would be allowed
on the loop device by root in the namespace, and if partition devices
were created they would inherit the namespace from the parent and thus
show up in the container's devtmpfs mount.

I think this use case demonstrates some real problems with only half-way
solutions atm. I'm certainly open to other suggestions about how to
solve them.

Thanks,
Seth
