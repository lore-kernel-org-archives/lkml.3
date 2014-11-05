Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaKEMlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:41:14 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:40494
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKEMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:41:13 -0500
Date: Wed, 5 Nov 2014 13:41:11 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Richard Weinberger <richard@nod.at>
Cc: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Mateusz Guzik <mguzik@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
Message-ID: <20141105124111.GA19563@mail.hallyn.com>
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
 <545A13DA.3090207@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545A13DA.3090207@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Weinberger (richard@nod.at):
> Am 05.11.2014 um 11:41 schrieb Chen Hanxiao:
> > We lack of pid hierarchy information, and this will lead to:
> > a) we don't know pids' relationship, who is whose child:
> >    /proc/PID/ns/pid only tell us whether two pids live in different ns
> > b) bring trouble to nested lxc container check/restore/migration
> > c) bring trouble to pid translation between containers;
> > 
> > This patch will show the hierarchy of pid namespace
> > by pidns_hierarchy like:
> > 
> > [root@localhost ~]#cat /proc/pidns_hierarchy
> > 18060 18102 1534
> > 18060 18102 1600
> > 1550
> 
> Hmm, what about printing the pid hierarchy in the same way as /proc/self/mountinfo
> does with mount namespaces?
> Your current approach is not bad but we should really try to be consistent with existing
> sources of information.

Good point.  How would you structure it to make it look mor elike mountinfo?
Adding the pidns inode number (in place of a mount sequence number) might be
useful, but it sounds like you have a more concrete idea?


> > +config PROC_PID_HIERARCHY
> > +	bool "Enable /proc/pidns_hierarchy support" if EXPERT
> > +	depends on PROC_FS
> > +	help
> > +	  Show pid namespace hierarchy information
> 
> Why does this depend on EXPERT?
> Every Linux distro will enable this option.

Agreed here.


> > +static int proc_pidns_list_refresh(struct pid_namespace *curr_ns,
> > +		struct list_head *pidns_pid_list,
> > +		struct list_head *pidns_pid_tree)
> > +{
> > +	struct pid *pid;
> > +	int new_nr, nr = 0;
> > +	int rc;
> > +
> > +	/* collect pids in current namespace */
> > +	while (nr < PID_MAX_LIMIT) {
> > +		rcu_read_lock();
> > +		pid = find_ge_pid(nr, curr_ns);
> > +		if (pid) {
> > +			new_nr = pid_vnr(pid);
> > +			if (!is_child_reaper(pid)) {
> > +				nr = new_nr + 1;
> > +				rcu_read_unlock();
> > +				continue;
> > +			}
> > +			get_pid(pid);
> > +			rcu_read_unlock();
> > +			rc = pidns_list_add(pid, pidns_pid_list);
> 
> This function allocates memory per PID. If we have lots of PIDs, how does this scale?
> I'd go so far and say this can be a DoS'able issue if the pidns_hierarchy file is opened multiple times...

It's not per pid, but per init-pid.  For non-reaper pids he bails and continue
through the loop a few lines above.  This still may be DOS-able if users don't
have kmem restrictions to prevent a ton of pid namespaces, but then the
namespaces themselves will take a lot more memory than the representation here.

-serge
