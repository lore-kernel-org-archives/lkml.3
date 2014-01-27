Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaA0XkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:40:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaA0XkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:40:19 -0500
Date: Tue, 28 Jan 2014 00:40:17 +0100
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140127234017.GA7868@quack.suse.cz>
References: <20140122062730.GA25601@redhat.com>
 <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
 <20140122233622.GB27916@quack.suse.cz>
 <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz>
 <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
 <20140123235549.GA7363@quack.suse.cz>
 <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 24-01-14 08:26:45, Jiri Kosina wrote:
> On Fri, 24 Jan 2014, Jan Kara wrote:
> 
> >   Strange. I've installed systemd system (openSUSE 13.1) and it boots 
> > with the latest Linus' kernel just fine (and I have at least FANOTIFY 
> > and SLAB debugging set the same way as you). But it was only a KVM 
> > guest. I'll try tomorrow with a physical machine I guess.
> 
> FWIW the system I am reliably able to reproduce this on is opensuse 12.3 
> with this systemd version: 
> 
> Version     : 195
> Release     : 13.18.1
  Hum, still no luck with reproduction (either on physical machine or with
KVM). Anyway, I've looked at the code again and the previous patch had a
stupid bug (passing different pointer to fsnotify_destroy_event() than we
should have), plus also the merging function in fanotify was too
aggressive. Can you try the attached patch? It boots for me but that means
nothing since I cannot reproduce the issue... Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--5mCyUwZo2JvN/JJP
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="fanotify.diff"

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 58772623f02a..1b3dd9de8518 100644
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
+	if (fsn_event->mask & FAN_ALL_PERM_EVENTS) {
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

--5mCyUwZo2JvN/JJP--
