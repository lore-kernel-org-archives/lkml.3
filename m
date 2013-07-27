Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3G0NfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:35:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:58276 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab3G0Ne7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:34:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,757,1367996400"; 
   d="scan'208";a="372169403"
Date: Sat, 27 Jul 2013 21:34:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [ipc,shm] BUG: lock held when returning to user space!
Message-ID: <20130727133439.GA14847@localhost>
References: <20130720131343.GB13893@localhost>
 <CAJn8CcFhsTjA1swBu6V0CUED6X9Ty1Y_zxv37iqOR44vkxDUtA@mail.gmail.com>
 <1374338805.2184.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374338805.2184.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 09:46:45AM -0700, Davidlohr Bueso wrote:
> On Sun, 2013-07-21 at 00:02 +0800, Xiaotian Feng wrote:
> > On Sat, Jul 20, 2013 at 9:13 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > > Greetings,
> > >
> > > I got the below dmesg and the first bad commit is
> > >
> > > commit c5d0282a0405b0a81fa3390e4230e4cbb3ced7a2
> > > Author: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > > Date:   Fri Jul 19 09:56:58 2013 +1000
> > >
> > >     ipc,shm: shorten critical region for shmat
> > >
> > >     Similar to other system calls, acquire the kern_ipc_perm lock after doing
> > >     the initial permission and security checks.
> > >
> > >     Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > >     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > >     Cc: Rik van Riel <riel@redhat.com>
> > >     Cc: Manfred Spraul <manfred@colorfullife.com>
> > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >
> > > [   20.702156]
> > > [   20.702493] ================================================
> > > [   20.703511] [ BUG: lock held when returning to user space! ]
> > > [   20.704532] 3.11.0-rc1-next-20130719 #50 Not tainted
> > > [   20.705416] ------------------------------------------------
> > > [   20.706425] trinity-child0/174 is leaving the kernel with locks still held!
> > > [   20.707638] 1 lock held by trinity-child0/174:
> > > [   20.708475]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff814a8491>] do_shmat+0xe1/0x500
> > >
> > 
> > ----
> > ns = current->nsproxy->ipc_ns;
> > - shp = shm_lock_check(ns, shmid);
> > + rcu_read_lock();
> > + shp = shm_obtain_object_check(ns, shmid);
> > if (IS_ERR(shp)) {
> > err = PTR_ERR(shp);
> > goto out;
> > ----
> > 
> > If shm_obtain_object_check() failed, goto out will return with
> > rcu_read_lock() held.  I think following patch should cure this.
> 
> Yep that should solve it, sorry about that. Sasha Levin sent out a fix
> for it yesterday (offline).

What's the patch's status? The bug is still there in linux-next 20130726.

Thanks,
Fengguang
