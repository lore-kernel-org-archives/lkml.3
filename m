Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaDCTnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:43:45 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63692 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaDCTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:43:43 -0400
Date: Thu, 3 Apr 2014 15:43:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Message-ID: <20140403194335.GC2472@mtj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
 <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
 <CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
 <CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
 <CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 03, 2014 at 12:01:23PM -0700, Linus Torvalds wrote:
> [ Extending the participants list a bit ]
> 
> On Thu, Apr 3, 2014 at 11:34 AM, Tejun Heo <tj@kernel.org> wrote:
> > On the road so sending from phone. Iirc the param is necessary to
> > distinguishe when a new sb is created so that it can be put properly later.
> > I think cgroup is leaking super ref now and li was planning to send a fix
> > once things are merged.
> 
> So as far as I can tell, cgroup is fine, because the superblock itself
> is properly refcounted by the mounting code. It's the magic hidden

Ah, I remembered the other way around.  We could leak cgroup_root
reference, not the other way around.  cgroup_mount() can be called
multiple times for the same sb and we inc cgroup_root's ref each time
but cgroup_kill_sb() only happens when the sb is released, so if we do
the following,

 # mkdir cpuset cpuset1
 # mount -t cgroup -o cpuset cgroup cpuset
 # mount -t cgroup -o cpuset cgroup cpuset1
 # umount cpuset
 # umount cpuset1

The cgroup_root should be destroyed but it isn't, I think.  We'd need
to bump cgroup_root's refcnt only when a new sb is created.  It's
kinda ugly.  Hmmm...

As for using specific type for ns tag, yeah, that'd be better
regardless of this.  The opaqueness is a bit extreme now.

Thanks.

-- 
tejun
