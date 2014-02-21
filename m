Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbaBUPs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:48:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbaBUPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:48:26 -0500
Date: Fri, 21 Feb 2014 16:48:23 +0100
From: Jan Kara <jack@suse.cz>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: poma <pomidorabelisima@gmail.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, eparis@parisplace.org,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000100000003
 - Oops: 0000 [#1] SMP
Message-ID: <20140221154823.GA21405@quack.suse.cz>
References: <53073B1A.3040709@gmail.com>
 <CAFLxGvygOyXrMt=UBnMUziVFG40sEQvRquGKV8kyrhdp-_NrgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvygOyXrMt=UBnMUziVFG40sEQvRquGKV8kyrhdp-_NrgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-02-14 14:08:03, Richard Weinberger wrote:
> On Fri, Feb 21, 2014 at 12:40 PM, poma <pomidorabelisima@gmail.com> wrote:
> >
> > Affected kernels - 3.14.0-0.rc3*:
> >
> > - 3.14.0-0.rc3.git0.1
> >   http://koji.fedoraproject.org/koji/buildinfo?buildID=498711
> >
> > - 3.14.0-0.rc3.git0.7 based on 3.14.0-0.rc3.git0.1
> >
> > - 3.14.0-0.rc3.git2.1
> >   http://koji.fedoraproject.org/koji/buildinfo?buildID=499061
> >
> > - 3.14.0-0.rc3.git5.1
> >   http://koji.fedoraproject.org/koji/buildinfo?buildID=499636
> >
> > Memtest86+ 4.20 - OK
> > http://goo.gl/1nm1nV
> >
> > RHBZ
> > https://bugzilla.redhat.com/show_bug.cgi?id=1067919
> >
> > messages-Oops-es-3.14.0-0.rc3
> > https://bugzilla.redhat.com/attachment.cgi?id=865926
> 
> Maybe commits 7053aee26a3548ebaba046ae2e52396ccf56ac6c (fsnotify: do
> not share events between notification groups)
> and 85816794240b9659e66e4d9b0df7c6e814e5f603 (fanotify: Fix use after
> free for permission events) introduced this regression.
  So the immediate problem seems to be that event->tgid is 0xffffffff
instead of a pointer. I don't see how this could be use after free and we
unconditionally initialize event->tgid to something sensible. Hum, but if
it is an overflow event, we are in a trouble since that doesn't have ->tgid
field at all so we read random crap that happens to be beyond the event
structure. Actually there seem to be more problems in the handling of
overflow event so I better add that to my testing (both for fanotify and
inotify). I'll work on the fix. Thanks for report!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
