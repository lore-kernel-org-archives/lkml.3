Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaI2OAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:00:13 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:41142
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaI2OAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:00:12 -0400
Date: Mon, 29 Sep 2014 16:00:10 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Mateusz Guzik <mguzik@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according
 to ns
Message-ID: <20140929140010.GA20069@mail.hallyn.com>
References: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1411552827-31056-3-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5871495633F38949900D2BF2DC04883E5C7377@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5871495633F38949900D2BF2DC04883E5C7377@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen, Hanxiao (chenhanxiao@cn.fujitsu.com):
> Hi,
> 
> > -----Original Message-----
> > From: containers-bounces@lists.linux-foundation.org
> > [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Chen
> > Hanxiao
> > Sent: Wednesday, September 24, 2014 6:00 PM
> > To: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> > Cc: Richard Weinberger; Serge Hallyn; Oleg Nesterov; Mateusz Guzik; David Howells;
> > Eric W. Biederman
> > Subject: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according to ns
> > 
> > If some issues occurred inside a container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> > 
> > This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:
> > a) In init_pid_ns, nothing changed;
> > 
> > b) In one pidns, will tell the pid inside containers:
> > NStgid:	21776   5       1
> > NSpid:  21776   5       1
> > NSpgid:	21776   5       1
> > NSsid:  21729   1       0
> > ** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.
> > 
> > c) If pidns is nested, it depends on which pidns are you in.
> > NStgid: 5       1
> > NSpid:  5       1
> > NSpgid: 5       1
> > NSsid:  1       0
> > ** Views from level 1
> > 
> 
> This patch is simple, useful and safe.
> But currently there is not any feedbacks.
> 
> Any comments or ideas? 

Thanks, Chen.  The code looks fine.  My concern is that you are
exposing information which cannot be checkpointed and restarted.
In particular, if I'm inside a nested container, so I'm in pidns
level 3, then my own NSpid info, when I read it, will show the
pids at parent namespaces.  If I'm restarted at the third pidns
level, only the one pid can be restored.

Now it may be fair to say "this is proc, and proc and sys show
host info which is not containerized and cannot be checkpointed
and restarted, deal with it."  But I'm not sure.

There are two ways you could deal with this.  One would be to
show the nspids only to the level of the reader of the file - but
I don't think you need to do that.  I think you're better off
simply showing the pids up to the level of the struct pid for
the mounter of the procfs.  So if I'm inside container c2 which
is inside container c1, my own /proc will only show pids which
are valid in c2 (and any child namespaces), while the /proc
mounted in c1 will show pids valid in c1 and c2 (and any children),
but not those in the init_pid_ns.  It's then just up to the
container administrators to make sure that c2 cannot see c1's
/proc to confuse itself and confuddle checkpoint-restart

-serge
