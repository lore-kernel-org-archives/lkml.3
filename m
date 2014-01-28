Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaA1ICG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:02:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaA1ICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:02:04 -0500
Date: Tue, 28 Jan 2014 09:02:01 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140128080201.GA13676@quack.suse.cz>
References: <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
 <20140122233622.GB27916@quack.suse.cz>
 <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz>
 <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
 <20140123235549.GA7363@quack.suse.cz>
 <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
 <20140127234017.GA7868@quack.suse.cz>
 <20140128061037.GA27636@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20140128061037.GA27636@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 28-01-14 01:10:37, Dave Jones wrote:
> On Tue, Jan 28, 2014 at 12:40:17AM +0100, Jan Kara wrote:
>  > On Fri 24-01-14 08:26:45, Jiri Kosina wrote:
>  > > On Fri, 24 Jan 2014, Jan Kara wrote:
>  > > 
>  > > >   Strange. I've installed systemd system (openSUSE 13.1) and it boots 
>  > > > with the latest Linus' kernel just fine (and I have at least FANOTIFY 
>  > > > and SLAB debugging set the same way as you). But it was only a KVM 
>  > > > guest. I'll try tomorrow with a physical machine I guess.
>  > > 
>  > > FWIW the system I am reliably able to reproduce this on is opensuse 12.3 
>  > > with this systemd version: 
>  > > 
>  > > Version     : 195
>  > > Release     : 13.18.1
>  >   Hum, still no luck with reproduction (either on physical machine or with
>  > KVM). Anyway, I've looked at the code again and the previous patch had a
>  > stupid bug (passing different pointer to fsnotify_destroy_event() than we
>  > should have), plus also the merging function in fanotify was too
>  > aggressive. Can you try the attached patch? It boots for me but that means
>  > nothing since I cannot reproduce the issue... Thanks!
> 
> still not good I'm afraid. I still see corruption very early on in boot
> and now it panics and locks up too.
  Ew, thanks for testing.

> Again, this happens so early that I can't grab it over usb-serial.
> I stuck an mdelay(10000) in the slub corruption detector, and managed
> to grab a photo of the first trace.
> 
> Trace:
> ? preempt_schedule
> lock_acquire
> ? lockref_put_or_lock
> _raw_spin_lock
> ? lockref_put_or_lock
> dput
> path_put
> fanotify_free_event
> fsnotify_destroy_event
> fanotify_handle_event
> ? mntput
> ? path_openat
> ? handle_mm_fault
> send_to_group
> ? fsnotify
> fsnotify
> do_sys_open
> sys_open
> RIP: lock_acquire
> 
>   2b:*	4d 8b 64 c6 08       	mov    0x8(%r14,%rax,8),%r12     <-- trapping instruction
> 
> R14 is 0x6b6b6b6b6b6b6c03, which looks like a use-after-free.
  Yup. But I'm somewhat puzzled by the trace. We crash when calling
fsnotify_destroy_event() from fanotify_handle_event(). The fsnotify code
has been called from do_sys_open() so the event was a 'FS_OPEN' which fails
the fsn_event->mask & FAN_ALL_PERM_EVENTS test.

Slapping my forehead, that's a really stupid bug. The event
fsnotify_add_notify_event() returns may be freed by the time we return
because we already dropped the notification mutex. And then fsn_event->mask
& FAN_ALL_PERM_EVENTS test will pass because FAN_ALL_PERM_EVENTS matches
with the poison pattern 0x6b6b6b6b. So yet another hacked up version of
fanotify fix is attached. And I have to seriously think about use counts
for fanotify version of that struct.

> I also notice you mention SLAB above, but I've been using SLUB. I don't
> know if the choice of allocator makes a difference in reproducability.
  Jiri Kosina has SLAB so SLAB/SLUB apparently doesn't matter.

> It's also worth noting that I have lockdep enabled, which may be perturbing things
> to some degree.
  And I've compiled my kernel with lockdep as well since Jiri has it in his
config. But no luck.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--YZ5djTAD1cGYuMQK
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="fanotify.diff"

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 58772623f02a..f80895fb5ca1 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -18,7 +18,7 @@ static bool should_merge(struct fsnotify_event *old_fsn,
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	/* dont merge two permission events */
-	if ((old_fsn->mask & FAN_ALL_PERM_EVENTS) &&
+	if ((old_fsn->mask & FAN_ALL_PERM_EVENTS) ||
 	    (new_fsn->mask & FAN_ALL_PERM_EVENTS))
 		return false;
 #endif
@@ -201,8 +201,10 @@ static int fanotify_handle_event(struct fsnotify_group *group,
 	}
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (fsn_event->mask & FAN_ALL_PERM_EVENTS)
+	if (mask & FAN_ALL_PERM_EVENTS) {
 		ret = fanotify_get_response_from_access(group, event);
+		fsnotify_destroy_event(group, fsn_event);
+	}
 #endif
 	return ret;
 }
@@ -221,7 +223,8 @@ static void fanotify_free_event(struct fsnotify_event *fsn_event)
 	struct fanotify_event_info *event;
 
 	event = FANOTIFY_E(fsn_event);
-	path_put(&event->path);
+	if (event->path.mnt)
+		path_put(&event->path);
 	put_pid(event->tgid);
 	kmem_cache_free(fanotify_event_cachep, event);
 }
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 57d7c083cb4b..d493c72c71fd 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -319,7 +319,8 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 			if (IS_ERR(kevent))
 				break;
 			ret = copy_event_to_user(group, kevent, buf);
-			fsnotify_destroy_event(group, kevent);
+			if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+				fsnotify_destroy_event(group, kevent);
 			if (ret < 0)
 				break;
 			buf += ret;

--YZ5djTAD1cGYuMQK--
