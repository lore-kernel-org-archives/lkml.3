Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaAVXg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:36:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaAVXgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:36:25 -0500
Date: Thu, 23 Jan 2014 00:36:22 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>, jkosina@suse.cz
Subject: Re: fanotify use after free.
Message-ID: <20140122233622.GB27916@quack.suse.cz>
References: <20140122062730.GA25601@redhat.com>
 <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 22-01-14 10:20:01, Linus Torvalds wrote:
> On Tue, Jan 21, 2014 at 10:27 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > BUG fanotify_event_info (Not tainted): Poison overwritten
> 
> Looking at the poison data, it seems that is is the
> 
>         u32 response;
> 
> field that has been overwritten (with all zero).
> 
> That doesn't really help me guess where the bug is, though. That code
> is crazy. For example, looking at one place where it is set, we have:
> 
>  - process_access_response():
> 
>         re->event->response = response;
> 
>         wake_up(&group->fanotify_data.access_waitq);
> 
>         kmem_cache_free(fanotify_response_event_cache, re);
> 
> which looks buggy in *so* many ways. In particular, we're doing a
> kmem_cache_free() on "re", but what happened to "re->event" that we
> just used? There was no release of that anywhere. Wut?
> 
> So it seems that the lifetime of these "fanotify_event_info"
> structures is completely buggered. I don't even see any *attempt* to
> maintain reference counts or other lifetime info. People free the
> containers that point to them without doing anything at all about the
> fsnotify_event that contains the fanotify_event_info that they point
> to.
> 
> Jan - how is the lifetime of the fanotify_event_info tied to the
> lifetime of the fanotify_response_event structure that contains
> pointers into it? Because I don't see it.
  Yeah, I messed that up. They aren't tied in any way - well, in fact they
end up being tied but in a wrong way. fanotify_event_info lives from the
moment event happens to the moment user reads the event. At that moment the
fanotify_response_event gets created (for those special permission events),
pointing to fanotify_event_info which will get freed just several lines
further :-|

But refcounting seems like an overkill for this - there is exactly one
fanotify_response_event structure iff it is a permission event. So
something like the (completely untested) attached patch should fix the
problem. But I agree it's a bit ugly so we might want something different.
I'll try to think about something better tomorrow.

> And considering that it's the response field that gets overwritten, it
> really sounds like *that* is the exact issue at play here - there is
> some fanotify_response_event structure holding a pointer to the
> fanotify_event that is embedded into a fanotify_event_info that has
> been freed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--IS0zKkzwUGydFO0o
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="fanotify_corruption.diff"

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 58772623f02a..756e9b047e27 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -201,8 +201,10 @@ static int fanotify_handle_event(struct fsnotify_group *group,
 	}
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (fsn_event->mask & FAN_ALL_PERM_EVENTS)
+	if (fsn_event->mask & FAN_ALL_PERM_EVENTS) {
 		ret = fanotify_get_response_from_access(group, event);
+		fsnotify_destroy_event(group, event);
+	}
 #endif
 	return ret;
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

--IS0zKkzwUGydFO0o--
