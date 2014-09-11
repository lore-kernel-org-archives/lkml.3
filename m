Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaIKN63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:58:29 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62002 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750863AbaIKN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:58:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Thu, 11 Sep 2014 16:17:56 +0200
Message-ID: <2362560.tfnxFWQpxu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140911130840.GH22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <20140910132417.GF25219@dhcp22.suse.cz> <20140911130840.GH22042@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 11, 2014 03:08:40 PM Michal Hocko wrote:
> On Wed 10-09-14 15:24:17, Michal Hocko wrote:
> > On Tue 09-09-14 22:53:32, Rafael J. Wysocki wrote:
> > > On Wednesday, September 10, 2014 01:46:58 AM Tejun Heo wrote:
> > > > Hello,
> > > > 
> > > > On Tue, Sep 09, 2014 at 06:06:25PM +0200, Michal Hocko wrote:
> > > > > > Even for userland tasks, try_to_freeze() can currently be anywhere in
> > > > > > the kernel.  The frequently used ones are few but there are some odd
> > > > > 
> > > > > I always thought that user space tasks can be in the fridge only on the
> > > > > way out from the kernel (get_signal_to_deliver). I have quickly greped
> > > > 
> > > > It *can* be anywhere.  We used to have some deep in nfs.  They got
> > > > removed later due to deadlocks but in theory they still can be
> > > > anywhere.
> > > 
> > > Well, it would be good to determine the difference between theory and practice
> > > in this particular respect, because if in practice it can't be anywhere,
> > > we can just set an "every new instance of try_to_freeze() has to be documented"
> > > rule (which may not be a bad idea anyway) and disallow people to break things.
> > 
> > What do you think about this way to help distinguish kernel threads and
> > user processes and keep the future maintenance of freezer saner?
> 
> This is not enough. I have completely missed freezer_count... Will have
> to think about this. There is quite large base of callers of this... It
> won't be trivial to check whether all of them are safe. Especially after
> 467de1fc67d1b which made the functionality usable for !user tasks as
> well. Btw. is this even desirable? The follow up patch (33e638b9070b)
> have (ab)used freezer_{do_not_}count just to be reverted later by
> 72081624d5ad3. I haven't checked other kernel thread users which might be
> added later. Don't rather put try_to_freeze_user_task into freezer_count
> to reflect the original intention (assuming that a separate API for user
> and kthread is desirable of course).

Well, to me the only difference is that user space is frozen "automatically"
while kernel threads need to flag themselves as "freezable" and then call
try_to_freeze() directly somewhere.  Whether or not that difference is big
enough for a separate API is a good question and I'm not sure if they can be
entirely separate anyway.

And I'm still wondering if the OOM killer may be made avoid killing frozen
tasks.

Rafael

