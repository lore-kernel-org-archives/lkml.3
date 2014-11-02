Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKBBWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:22:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaKBBWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:22:42 -0400
Date: Sat, 1 Nov 2014 18:21:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141102012130.GA9335@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:00:16AM +0100, Jiri Kosina wrote:
> On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
> 
> > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > the the protocol layer with the existing userspace D-Bus daemon while
> > enabling some features that couldn't be implemented before in userspace.
> 
> I'd be interested in the features that can't be implemented in userspace 
> (and therefore would justify existence of kdbus in the kernel). Could you 
> please point me to such list / documentation?
> 
> It seems to me that most of the highlight features from the cover letter 
> can be "easily" (for certain definition of that word, of course) 
> implemented in userspace (vmsplice(), sending fd through unix socket, user 
> namespaces, UUID management, etc).

Sorry for the long delay in getting back to this, I'm battling a bad
case of jet-lag at the moment...

Here's some reasons why I feel it is better to have kdbus in the kernel
rather than trying to implement the same thing in a userspace daemon:

- performance: fewer process context switches, fewer copies, fewer
  syscalls, larger memory chunks via memfd.  This is really important
  for a whole class of userspace programs that are ported from other
  operating systems that are run on tiny ARM systems that rely on
  hundreds of thousands of messages passed at boot time, and at
  "critical" times in their user interaction loops.
- security: the peers which communicate do not have to trust each other,
  as the only trustworthy compoenent in the game is the kernel which
  adds metadata and ensures that all data passed as payload is either
  copied or sealed, so that the receiver can parse the data without
  having to protect against changing memory while parsing buffers.  Also,
  all the data transfer is controlled by the kernel, so that LSMs can
  track and control what is going on, without involving userspace.
  Because of the LSM issue, security people are much happier with this
  model than the current scheme of having to hook into dbus to mediate
  things.
- more metadata can be attached to messages than in userspace
- semantics for apps with heavy data payloads (media apps, for instance)
  with optinal priority message dequeuing, and global message ordering.
  Some "crazy" people are playing with using kdbus for audio data in the
  system.  I'm not saying that this is the best model for this, but
  until now, there wasn't any other way to do this without having to
  create custom "busses", one for each application library.
- being in the kernle closes a lot of races which can't be fixed with
  the current userspace solutions.  For example, with kdbus, there is a
  way a client can disconnect from a bus, but do so only if no further
  messages present in its queue, which is crucial for implementing
  race-free "exit-on-idle" services
- eavesdropping on the kernel level, so privileged users can hook into
  the message stream without hacking support for that into their
  userspace processes
- a number of smaller benefits: for example kdbus learned a way to peek
  full messages without dequeing them, which is really useful for
  logging metadata when handling bus-activation requests. 

Of course, some of the bits above could be implemented in userspace
alone, for example with more sophisticated memory management APIs, but
this is usually done by losing out on the other details.  For example,
for many of the memory management APIs, it's hard to not require the
communicating peers to fully trust each other.  And we _really_ don't
want peers to have to trust each other.

Another benefit of having this in the kernel, rather than as a userspace
daemon, is that you can now easily use the bus from the initrd, or up to
the very end when the system shuts down.  On current userspace D-Bus,
this is not really possible, as this requires passing the bus instance
around between initrd and the "real" system.  Such a transition of all
fds also requires keeping full state of what has already been read from
the connection fds.  kdbus makes this much simpler, as we can change the
ownership of the bus, just by passing one fd over from one part to the
other.

Regarding binder: binder and kdbus follow very different design
concepts.  Binder implies the use of thread-pools to dispatch incoming
method calls.  This is a very efficient scheme, and completely natural
in programming languages like Java.  On most Linux programs, however,
there's a much stronger focus on central poll() loops that dispatch all
sources a program cares about.  kdbus is much more usable in such
environments, as it doesn't enforce a threading model, and it is happy
with serialized dispatching.  In fact, this major difference had an
effect on much of the design decisions: binder does not guarantee global
message ordering due to the parallel dispatching in the thread-pools,
but  kdbus does.  Moreover, there's also a difference in the way message
handling.  In kdbus, every message is basically taken and dispatched as
one blob, while in binder, continious connections to other peers are
created, which are then used to send messages on.  Hence, the models are
quite different, and they serve different needs.  I believe that the
D-Bus/kdbus model is more compatible and friendly with how Linux
programs are usually implemented.  I went into the kdbus vs. binder
stuff in a blog post that I linked to earlier in this thread that goes
into more detail here.

Hopefully this helps explain why I feel kdbus should be in the kernel
and not a userspace daemon.  I'll put this information in the cover
letter for the next round of patches that are sent out.

thanks,

greg k-h
