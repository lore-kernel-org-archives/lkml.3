Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaHLS5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:57:34 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47731 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaHLS5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:57:32 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 0/4] VFS revoke()
Date: Tue, 12 Aug 2014 20:54:04 +0200
Message-Id: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset implements synchronous shutdown of file->f_op->xyz() access. It
provides generic helpers that can be used by any provider of file->f_op to
prevent new tasks from entering a file-operation and synchronously waiting for
all pending file-operations to finish.
Furthermore, it includes two patches to show how it can be used by device
drivers (here: Input-evdev as an example).

There are several use-cases for this patchset:

1) Hotplug Support
Currently, a device driver for hotpluggable hardware has to jump through hoops
to make unplugging work. Imagine a driver that registers a cdev via cdev_add()
in the ->probe() callback on its bus. Once cdev_add() returns, user-space might
start entering file->f_op->xyz() callbacks on the cdev.
Now, if the hardware device is unplugged, the ->remove() callback of the device
driver is called on its bus. The driver now removes the cdev via cdev_del(),
but this does not guarantee that there's no open file-description left.
Furthermore, it does not prevent any further entry to file-operations.
Therefore, the driver has to protect all its f_op callbacks and deny new tasks
whenever the device was removed. This needlessly leaves the device around
(albeit disabled) until all file-descriptions are closed by user-space.
With generic revoke() support, a driver can synchronously shutdown all
file-operations. This way, it can guarantee that all open files are closed
before returning from its ->remove() callback on the bus.

2) Access Management
Once a user-space process was granted access to a device node, there is no way
to revoke that access again. This is problematic for all devices that are shared
between sessions. Imagine switching between multiple graphics servers, there is
currently no way to make sure only the foreground server gets access to graphics
and input devices.
The easiest solution, obviously, is to provide a user-space daemon that
dispatches between those processes. However, this requires to wrap *all* API
calls and reduces performance of device-operations considerably.
Therefore, input and graphics drivers have started to implement access
management as part of their API. To avoid duplicating that code everywhere, we
need a generic revoke() implementation that revokes *just one file-description*.
This way, generic access-management (like the 'logind' daemon) can hand out
file-descriptors to processes and retain a copy themselves. By revoking access
to the file, the process will loose access, too. We'd love to see such revoke
support for webcams, audio devices, disks and more, so we can prevent background
sessions from accessing those.

3) Generic revoke() / frevoke()
Obviously, the generic revoke() syscall can be implemented with this, too.
Unlike 2), this syscall revokes access to *all* open file-descriptions attached
to a device/object. This can be exposed to user-space, but is also handy to
implement existing syscalls like vhangup().


This patchset introduces two new objects:
  struct revokable_device:
      This is the entry point to revoke-support. Every object that needs revoke
      support has to have a revokable_device embedded somewhere. This is usually
      part of the "cdev", "inode" or other kinds of parent devices. However, it
      can be used freely and does not enforce any restrictions.
      The revokable_device object is used as parent for all open files on the
      underlying device. That is, each file on that device that is opened via
      ->open() will be attached to this revokable_device object. Each attached
      file can be managed independently of the parent device and can be revoked
      by itself.
      The revokable_device object now allows to manage all attached files at
      once. That is, if you call revoke_device(), this will cause all attached
      files to be revoked at the same time and prevent new files from being
      opened.
  struct revokable_file:
      Inside of the ->open() callback, a driver needs to call make_revokable()
      if it needs revoke-support on a file. This will create a new
      "revokable_file" object and link it from file->f_revoke. The object will
      also be attached to the parent revokable_device object that is passed to
      make_revokable().
      Once make_revokable() returns, the file is active and may be revoked at
      any time (maybe even before you return from ->open()).
      Each revokable_file can be revoked independently of each other. Once a
      device is revoked, any new entry to a file-operation is denied and pending
      operations are completed synchronously. Once all those operations are
      done, the ->release() callback of the file is called early so the device
      driver can detach from it. Once the last file-reference is dropped,
      __fput() will no longer call ->release(), as it has already been called.

Unlike previous attempts to implement revoke(), this series implements revoke()
on the file-description level. That is, each open file description can be
revoked independently of each other. This is required to implement
access-management on a per-file level, instead of revoking the whole device.
Furthermore, this series splits revoke_file() and drain_file(). The former only
marks the file as revoked and prevents new file-operations, the latter waits for
pending operations to finish. This split allows drivers to perform any required
actions in between both calls (or avoid draining at all). Note that if
drain_file() is called, the driver needs to wake up sleeping file-operations
after revoke_file() was called. Otherwise, drain_file() might stall.

Open questions:
 * Obviously, we need to protect all calls into file->f_op->xyz(). This series
   provides enter_file() and leave_file() that can be used like:
      if (enter_file(file))
          retval = file->f_op->xyz(file, ...);
      else
          retval = -ENODEV;
   Question is, should we do this at the time we actually invoke those
   callbacks or should we do it at the syscall-entry time? If we do it right
   when calling the f_op, we might and up with stacked calls. This works fine,
   but makes drain_file_self() awful to implement.
   Note that I have implemented both, but didn't include the patches in this
   series as I wasn't sure which to go with and they need much more love...
   Making sure we call enter_file/leave_file everywhere will require proper
   auditing and I guess people will tell me to drop drain_self(), but lets see..
 * Do we need drain_file_self()? That is, do we really want to allow drivers
   to drain a file while being inside a f_op callback? It is handy to implement
   existing calls like EVIOCREVOKE properly, but makes the whole system a lot
   more complex.
   It was a nice challenge to implement it, but I'm fine with dropping it again.
 * What should revoke() do? Currently, revoke_device() calls revoke_file() on
   *all* attached files and prevents any new calls to ->open(). This is handy to
   make hotplugging work, but doesn't make much sense if called on real files.
   We definitely want to allow new calls to open(), so I guess setting
   "device->revoked" to "true" should be optional and only used by drivers
   explicitly on unplug. The currently implementation can be made to allow both.
   But parallel calls to open() while revoke_device() is called will still be
   revoked until revoke_device() really returns.
 * What error code do we want to return when a file is revoked? poll() should
   probably signal POLLHUP, but what for all the other stuff? ENODEV? EACCES?
   For user-space code, a separate EUNPLUG code would be *very* handy to make
   dealing with asynchronous unplug more easy. EREVOKED would also work, but
   doesn't allow to distinguish between device unplug and plain access
   revocation.
 * What to do with remaining data in receive buffers? On revoke() we want all
   access to the device to be denied, but on unplug we *might* want to allow
   user-space to retrieve already queued data in the receive buffers. That is,
   poll returns POLLHUP | POLLIN and read() can return already queued data. I
   haven't seen any reason to do this, though. Iff hardware shows up that has
   really short lifetime and we want all data to be forwarded to user-space, we
   might want to add some special flag to allow poll() and read(). Until then, I
   think we can safely ignore it.

Notes:
 * This series is loosely based on:
     - previous mails by Al Viro
     - "active"-refs of kernfs by Tejun Heo
     - EVIOCREVOKE on evdev
   The patches are written from scratch (no previous attempt allowed revoke() on
   single files so far), but credits go to these guys, too!
 * We probably want a generic kick() callback. With this in place, we can
   implement frevoke() easily:
       int frevoke(struct file *file)
       {
               if (!file->f_revoke)
                       return -ENOTSUPP;
               if (!enter_file(file))
                       return -ENODEV;
               revoke_device(file->f_revoke->device);
               if (file->f_revoke->device->kick)
                       file->f_revoke->device->kick(file->f_revoke->device);
               leave_file(file);
               /* TODO: need ref on device; f_revoke->device may ne NULL here */
               drain_device(file->f_revoke->device);
               return 0;
       }
   Implementing revoke() is harder as we need a connection between a dentry and
   a revokable_file. We could add inode->i_revoke for that.
   In both cases, we need some guarantee that revokable_device does not vanish
   while we use it. So we either need to know the parent object and hold a ref
   to it, or we add ref-counts to revokable_device.
 * mmap() is obviously left to device-drivers to handle in ->release() or
   ->kick(). I recently posted patches that do page duplication and thus can
   give each open-file effectively a MAP_PRIVATE copy at any time. But if
   drivers map I/O memory directly into user-space, you're screwed, anyway.
   Imho, this is something drivers need to fix on a per-case basis. Same way
   drivers handle ->release() regarding mmaps (either leaving them alive or
   revoking them, or .. whatever).
 * This adds 8 bytes to all "struct file"s that don't use revoke(). I think
   that's a fair tradeoff. If you want revoke(), it adds ~40 bytes for
   revokable_file and ~80 bytes for each revokable_device.
   The fast-paths check file->f_revoke for NULL in enter_file(). Should be fine.
   In case you enabled revoke(), you get atomic_inc_unless_negative() and
   atomic_dec_return() in fast-paths. Slow-paths (in case the file is revoked)
   are heavy, but that should be just fine. I mean, most device release paths
   use several synchronize_rcu() calls and more. Some atomic_t magic for
   revoke() should be just fine.
 * "struct kactive" uses atomic_t heavily to implement active device references.
   I have no idea whether it makes sense to do it that way. Shout at me if the
   slow-paths should be changed to use a spin-lock..
   I'd also appreciate mem-barrier reviews there. I'm not entirely sure I got
   them all right.
 * Makeing revokable_device->active_files RCU protected would be *really* nice.
   I didn't succeed in doing so, though. The hard part is revoke_device() which
   somehow needs to iterate the whole list of devices and cannot allow parallel
   modifications. But it needs to drop the spin-lock for ->release(). My current
   way of moving between two lists works fine without RCU, but not with RCU.
   But maybe the current spin-lock protection is just fine. I mean, there's not
   much traversal going on, anyway, and modifications are always protected by
   the lock.
 * This evdev-patches in this series rely on some non-mainstream trivial
   cleanups. In case anyone cares, see:
       "[PATCH v2] Input: evdev - drop redundant list-locking"
 * ...
 * I probably have a lot more notes that I forgot again. Any comments welcome. I
   just wanted to get this out so people know I'm working on it, and maybe
   people can point out whether this is going into the right direction.


Anyway, regardless of revoke(2), frevoke(2) and stuff, this series already makes
writing device-drivers a lot easier. I included two patches that convert one of
the most trivial drivers (and one of the few drivers that actually does proper
unplug handling) to use the new infrastucture (Input: evdev). I have similar
patches for ALSA and DRM, but they require far more cleanups before, so I didn't
include them for now. Note that most drivers are horribly racy regarding
unplugging (ALSA replaces f_op with a dummy and hopes no-one's inside a f_op so
far) or don't care at all (DRM just destroys the device on PCI unplug). Most of
this works fine so far, because we did our best to reduce races to a minimum.
However, it really looks ugly and it would make many developer lives easier if
we had synchronous shutdown.

After adding enter_file()/leave_file() annotations, this series already works
fine on my machine.

Comments welcome!
David

David Herrmann (4):
  kactive: introduce generic "active"-refcounts
  vfs: add revoke() helpers
  Input: evdev - switch to revoke helpers
  Input: evdev - drop redundant client_list

 drivers/input/evdev.c   | 179 +++++++++++----------------
 fs/Makefile             |   2 +-
 fs/file_table.c         |   4 +-
 fs/revoke.c             | 194 ++++++++++++++++++++++++++++++
 include/linux/fs.h      |   2 +
 include/linux/kactive.h | 269 +++++++++++++++++++++++++++++++++++++++++
 include/linux/revoke.h  | 124 +++++++++++++++++++
 lib/Makefile            |   2 +-
 lib/kactive.c           | 312 ++++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 974 insertions(+), 114 deletions(-)
 create mode 100644 fs/revoke.c
 create mode 100644 include/linux/kactive.h
 create mode 100644 include/linux/revoke.h
 create mode 100644 lib/kactive.c

-- 
2.0.4

