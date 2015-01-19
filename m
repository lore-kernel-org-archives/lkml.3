Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbbASSiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:38:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbASSiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:38:16 -0500
Date: Tue, 20 Jan 2015 02:38:06 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Message-ID: <20150119183806.GA8479@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150119180642.GA27957@sig21.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 07:06:42PM +0100, Johannes Stezenbach wrote:
> Hi Greg and Daniel,

[Fixing Daniel's email, which I messed up originally...]

> On Fri, Jan 16, 2015 at 11:16:04AM -0800, Greg Kroah-Hartman wrote:
> > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > the the protocol layer with the existing userspace D-Bus daemon while
> > enabling some features that couldn't be implemented before in userspace.
> > 
> > The documentation in the first patch in this series explains the
> > protocol and the API details.
> 
> How about the big picture?
> 
> > Reasons why this should be done in the kernel, instead of userspace as
> > it is currently done today include the following:
> [abbreviated]
> > - performance
> > - security
> > - semantics for apps with heavy data payloads
> 
> 
> First of all I wonder about the relationship with D-Bus.
> http://dbus.freedesktop.org/doc/dbus-specification.html says:
> 
>    D-Bus is designed for two specific use cases:
> 
>        A "system bus" for notifications from the system to user
>        sessions, and to allow the system to request input from
>        user sessions.
> 
>        A "session bus" used to implement desktop environments such
>        as GNOME and KDE. 
> 
>    D-Bus is not intended to be a generic IPC system for any
>    possible application, and intentionally omits many features
>    found in other IPC systems for this reason. 
> 
> Does this also apply to kdbus?  If not, what are the
> suggested uses of kdbus beyond those where D-Bus is
> currently used?

I don't really know.  I have heard from lots of random people who are
starting to look into kdbus as to if it will work for their use cases,
which seem quite varied.  I'll leave it to them to pop up and say if it
will work for them outside of the above specific ways.  But even then,
the above two things are something almost all Linux boxes rely on today,
so it's not like this is a solution searching for a problem to solve :)

> Another related quote by Havoc Pennington:
> http://lists.freedesktop.org/archives/dbus/2012-March/015024.html
> 
>    In general, reading this, I think in some cases there are
>    problems that make sense to fix in dbus, and in other cases
>    there are problems that are best solved by not using dbus.
>    ...
>    there are about 10000 IPC solutions already, from ICE (both of
>    them) to ZeroMQ to AMQP to CORBA to X11 to HTTP to SOAP to
>    WebSockets to SUN-RPC to whatever-the-heck. To me, trying to
>    make dbus configurable so that it can substitute for any of
>    these is a Bad Idea (tm).
> 
> Do you think it also applies to kdbus?

Yes, I do agree, there are lots of existing ipc solutions today that
kdbus is not designed for, nor would it be good to use it for.  The
majority of them being IPC that crosses the network layer, as there are
lots of good solutions today for that problem.  That being said, I do
know one research group that has kdbus working cross-network, just "to
try it out", but I don't know what ever came of it.

> Wrt the performance improvement achieved by kdbus, my impression
> about D-Bus is that the number of messages on my system is
> about a dozen per minute.  Are there actually any existing
> applications using D-Bus that have a performance issue?
> Or is this only about future possible uses?

There are a number of existing applications that have this performance
issue today.  The majority of them have been ported from other operating
systems that have a fast message bus, so their process model is all
about messages.  They use a library layer on Linux to turn that message
bus into D-Bus messages, and have suffered a huge hit in performance
from their previous operating system.  Using kdbus has brought it back
in line to make it reasonable to use.

These applications can be usually found in the Automotive sector, which
has been playing with light-weight dbus library implementations for a
while now, and have done some initial kdbus testing to verify this will
work for them.

> Linked from http://kroah.com/log/blog/2014/01/15/kdbus-details/,
> http://lwn.net/Articles/580194/ "The unveiling of kdbus" says:
> 
>    Unlike most other kernels, Linux has never had a well-designed
>    IPC mechanism. Windows and Mac OS have this feature; even
>    Android, based on Linux, has one in the form of the "binder"
>    subsystem. Linux, instead, has only had the primitives —
>    sockets, FIFOs, and shared memory — but those have never been
>    knitted together into a reasonable application-level API. Kdbus
>    is an attempt to do that knitting and create something that is
>    at least as good as the mechanisms found on other systems.
> 
> These are bold words. I'm not sure what Windows and Mac OS
> have in terms of IPC, but the above suggests that kdbus
> is *the* new Linux IPC that everyone will use for everything,
> rather than a special purpose facility.

Everyone uses D-Bus today for everything on their system, so by
replacing the underlying library with kdbus, they will continue to use
it for everything without having to change any application or library
code at all.

Hope this helps,

greg k-h
