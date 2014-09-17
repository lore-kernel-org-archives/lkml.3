Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaIQUst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:48:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902AbaIQUsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:48:38 -0400
Date: Wed, 17 Sep 2014 21:46:35 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        david@fromorbit.com, bmr@redhat.com, jcastillo@redhat.com,
        mguzik@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: Use a seperate wq for do_sync_work() to avoid a
 potential deadlock
Message-ID: <20140917204634.GB25400@atomlin.usersys.redhat.com>
References: <1410953942-32144-1-git-send-email-atomlin@redhat.com>
 <20140917182202.GE19308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140917182202.GE19308@redhat.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 08:22:02PM +0200, Oleg Nesterov wrote:
> On 09/17, Aaron Tomlin wrote:
> >
> > Since do_sync_work() is a deferred function it can block indefinitely by
> > design. At present do_sync_work() is added to the global system_wq.
> > As such a deadlock is theoretically possible between sys_unmount() and
> > sync_filesystems():
> >
> >   * The current work fn on the system_wq (do_sync_work()) is blocked
> >     waiting to aquire a sb's s_umount for reading.
> >
> >   * The "umount" task is the current owner of the s_umount in
> >     question but is waiting for do_sync_work() to continue.
> >     Thus we hit a deadlock situation.
> >
> I can't comment the patches in this area, but I am just curious...
> 
> Could you explain this deadlock in more details? I simply can't understand
> what "waiting for do_sync_work()" actually means.

Hopefully this helps:

	           "umount"                                      "events/1"

sys_umount					    sysrq_handle_sync
  deactivate_super(sb)				      emergency_sync
  {						    	schedule_work(work)
    ...						    	  queue_work(system_wq, work)
    down_write(&s->s_umount)			    	    do_sync_work(work)
    ...						      	      sync_filesystems(0)
    kill_block_super(s)				    		...
      generic_shutdown_super(sb)		    		down_read(&sb->s_umount)
      // sop->put_super(sb)
      ext4_put_super(sb)
	invalidate_bdev(sb->s_bdev)
	  lru_add_drain_all()
	    for_each_online_cpu(cpu) {
	      schedule_work_on(cpu, work)
		queue_work_on(cpu, system_wq, work)
		...
	    }
  }

  - Both lru_add_drain and do_sync_work work items are added to
    the same global system_wq

  - The current work fn on the system_wq is do_sync_work and is
    blocked waiting to aquire an sb's s_umount for reading

  - The umount task is the current owner of the s_umount in
    question but is waiting for do_sync_work to continue.
    Thus we hit a deadlock situation.


-- 
Aaron Tomlin
