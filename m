Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3ELAGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 20:06:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39638 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3ELAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 20:06:19 -0400
Date: Sun, 12 May 2013 01:06:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] next cycle fun: ->release() API change
Message-ID: <20130512000616.GR25399@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
 <CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
 <20130511172242.GP25399@ZenIV.linux.org.uk>
 <CA+55aFzsgr6ZHWxNRvM3VZu=bWn75TfGb0EAXO1wdFnBFTCz-Q@mail.gmail.com>
 <20130511210641.GQ25399@ZenIV.linux.org.uk>
 <CA+55aFy8Y9w0OBHLTqHxjLLXZXOSf+d5YJ-huNaMOs3V5DycCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy8Y9w0OBHLTqHxjLLXZXOSf+d5YJ-huNaMOs3V5DycCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 02:12:25PM -0700, Linus Torvalds wrote:
> On Sat, May 11, 2013 at 2:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Less boilerplate?  We used to pass inode to fput() as well, but
> > switched to passing file alone...
> 
> .. and that was painful.
> 
> The advantage has to be balanced against the pain it causes. I'm not
> seeing the advantage here as being worth it. If this kind of thing not
> only causes way more churn, _and_ it causes us to pick a new (worse)
> name just because it also forces a non-compatible ABI, I'm really
> doubtful.
> 
> I mean, if we had *other* reasons for the churn, and the name needed
> to change anyway, then maybe, but..

Hell knows...  FWIW, most of the work in that series is reviewing the
instances for locking and leaks - IOW, the pieces that are dropping off
into separate patches anyway.  With all of them done it'll probably
boil down to something less painful.

BTW, I'm not all that fond of 'close', for the reasons you've mentioned.
OTOH, 'release' has another problem - it's probably the most common method
name, making it very hard to grep for.  We have 60-odd structures with method
called release, many of those with widespread instances.  In include/linux
alone we have
af_alg_type
drm_global_reference
block_device_operations
cdrop_device_ops
bsg_class_device
cftype
configfs_item_operations
device_type
device
dma_buf_ops
file_operations
hsi_port
irq_affinity_notify
ipack_device
iscsi_boot_kobj
kobj_type
loop_func_table	(what the devil is _that_ doing in include/linux?)
mmu_notifier_ops
mtd_blktrans_ops
proto_ops
nfs_gpio_header
hotplug_slot
pipe_buf_operations
posix_clock_operations
posix_clock
rtc_class_ops
auth_ops
uio_info
usb_serial_driver
vfio_device_ops
vfio_iommu_driver_ops
media_file_operations
media_devnode
saa7146_use_ops
v4l2_file_operations
video_device
v4l2_device
cfsrvl	(jst wht th fck hd th thr f tht sht bn smkng?)
tcp_congestion_ops
snd_emux_operators
snd_hwdep_ops
sound_info_entry_ops
and while some of those don't have a lot of instances, some do.  I'm not
saying that going back to original K&R "struct members form a single
namespace and must be unique across different structures" would be a good
idea, but this one is inconveniently common - makes finding the instances
and call sites a very unpleasant work ;-/

BTW, a lot of those guys are returning void, but there are some that return
int and I think we ought to review those as well.  And that's probably
worth doing *before* we start merging file_operations ->release() change,
whether it's just int->void variant or anything more ambitious.

I don't know; let's hold that off for now and see how much calves off
that patchset.  If we go for your 'switch the return type of ->release()
and then deal with the instances', we can do that in 3.11-rc1 as well as
in 3.10-rc1...
