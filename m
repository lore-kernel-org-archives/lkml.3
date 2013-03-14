Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3CNW7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:59:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50246 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3CNW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:59:48 -0400
Date: Thu, 14 Mar 2013 22:59:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Message-ID: <20130314225940.GQ21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
 <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
 <20130312222350.GK21522@ZenIV.linux.org.uk>
 <20130313185249.GL21522@ZenIV.linux.org.uk>
 <CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com>
 <20130313231918.GP21522@ZenIV.linux.org.uk>
 <CAJfpegsCirmYYimr6Nn4Q4Kdc7rMYaxWhk+fsmp+BLp6mjb_MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsCirmYYimr6Nn4Q4Kdc7rMYaxWhk+fsmp+BLp6mjb_MQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:37:50AM +0100, Miklos Szeredi wrote:

> > As for whiteouts... I think we ought to pull these bits of unionmoun
> > queue into the common stem and add the missing filesystems to them;
> > ext* and ufs are trivial (keep in mind that FFS derivatives, including
> > ext*, have d_type in directory entry and type 14 (DT_WHT) is there
> > precisely for that purpose).  btrfs also has "dir_type" thing - 8bit
> > field...
> 
> What about userspace interfaces?  Are we allowed to extend d_type and
> st_mode without breaking things?

Huh?
	* from st_mode point of view, it's not going to conflict with
anything; FFS "entry type" matches bits 12..15 of mode_t, and the value
picked by whoever had first implemented whiteouts had been chosen so
that it would not clash with any existing values.  We have
#define S_IFMT  00170000
#define S_IFSOCK 0140000
#define S_IFLNK  0120000
#define S_IFREG  0100000
#define S_IFBLK  0060000
#define S_IFDIR  0040000
#define S_IFCHR  0020000
#define S_IFIFO  0010000
and this sucker would've been 0160000; new filesystem object types are not
frequently introduced, to put it mildly, so I wouldn't expect clashes.
Especially since any such clash would hit Solaris and *BSD (including
MacOS X) as well - all of them use that value for whiteouts.
	* for practically all syscalls these guys are treated as file not
being there; e.g. mkdir() on such name results in whiteout silently
replaced with references to newly created subdirectory, etc.
	* BSDs have one major exposure of those guys to userland - their
getdents(2) shows whiteouts (with d_type equal to DT_WHT and d_fileno - to 1).
Other than that (and we obviously do _not_ want that as default behaviour;
maybe a new O_<something> to produce that), there's practically nothing -
undelete(2) removes a whiteout in attempt to expose the object masked by
it, mknod(2) with S_IFWHT as type does create one.  That's it.

IOW, I don't see how we'd get any kind of userland problems with those.  And
this is not a new API - a bunch of BSD-derived Unices starting with, IIRC,
SunOS 3 and 4.3BSD, as well as their bastard progeny (Solaris, MacOS X)
had that since mid-80s...
