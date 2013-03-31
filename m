Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3CaVX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 17:23:59 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:43605 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab3CaVX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 17:23:57 -0400
Date: Sun, 31 Mar 2013 21:23:54 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Zach Brown <zab@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130331212354.GA5240@dcvr.yhbt.net>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DB089@SACEXCMBX04-PRD.hq.netapp.com>
 <20130223003239.GA1469@dcvr.yhbt.net>
 <20130330194514.GA1005@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130330194514.GA1005@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:
> Eric Wong wrote:
> > [1] my splice() annoyances:
> >     * need to create/manage a pipe
> >     * copy size limited by pipe size
> >     * doesn't reduce userspace syscalls (just data copy overhead)
> >     * easy to misuse and starve with blocking sockets + big buffers
> >     * not many users, so bugs creep in (v3.7.8 was the first usable
> >       version of the 3.7 series for TCP sockets)
> 
> Could library be created to make it less annoying to use, and harder
> to misuse?

Maybe, but getting people to use the library would be the hard, too.
And a library would not reduce syscalls in the common case.

We already have current->splice_pipe for sendfile, so maybe splice can
be taught to transparently use that when neither FD is a pipe.

I also think a SPLICE_F_DONTWAIT flag might be necessary.  It would be a
superset of SPLICE_F_NONBLOCK, but also act like MSG_DONTWAIT for the
non-pipe socket.

> splice man page does not mention pipe size limit...

It probably should.  I think I discovered it by using it many years ago
and burned it into my mind.
