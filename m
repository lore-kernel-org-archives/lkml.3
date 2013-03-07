Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab3CGSVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:21:48 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35832 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab3CGSVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:21:47 -0500
Date: Thu, 7 Mar 2013 10:21:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: lockdep trace from prepare_bprm_creds
Message-ID: <20130307182140.GF29601@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307180139.GD29601@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:01:39AM -0800, Tejun Heo wrote:
> Hello, Oleg.
> 
> On Thu, Mar 07, 2013 at 06:25:45PM +0100, Oleg Nesterov wrote:
> > > [  944.011126] Chain exists of:
> > >   &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex
> > >
> > > [  944.012745]  Possible unsafe locking scenario:
> > >
> > > [  944.013617]        CPU0                    CPU1
> > > [  944.014280]        ----                    ----
> > > [  944.014942]   lock(&sig->cred_guard_mutex);
> > > [  944.021332]                                lock(cgroup_mutex);
> > > [  944.028094]                                lock(&sig->cred_guard_mutex);
> > > [  944.035007]   lock(&sb->s_type->i_mutex_key#9);
> > > [  944.041602]
> > 
> > And cgroup_mount() does i_mutex -> cgroup_mutex...
> 
> Hmmm...
> 
> > Add cc's. I do not think we can move open_exec() outside of cred_guard_mutex.
> > We can change do_execve_common(), but binfmt->load_binary() does open() too.
> > 
> > And it is not easy to avoid ->cred_guard_mutex in threadgroup_lock(), we can't
> > change de_thread() to do threadgroup_change_begin/end...
> > 
> > Or perhaps we can? It doesn't need to sleep under ->group_rwsem, we only
> > need it around ->group_leader changing. Otherwise cgroup_attach_proc()
> > can rely on do_exit()->threadgroup_change_begin() ?
> 
> Using cred_guard_mutex was mostly to avoid adding another locking in
> de_thread() path as it already had one.  We can add group_rwsem
> locking deeper inside and avoid this problem.
> 
> > But perhaps someone can suggest another fix in cgroup.c.
> 
> Another possibility is moving cgroup_lock outside threadgroup_lock(),
> which was impossible before because of cgroup_lock abuses in specific
> controller implementations but most of that have been updated and we
> should now be pretty close to being able to make cgroup_lock outer to
> most other locks.  Appending a completely untested patch below.

This probably doesn't help as the dependency involves i_mutex.  I
think Oleg's proposed patch should work.

Thanks.

-- 
tejun
