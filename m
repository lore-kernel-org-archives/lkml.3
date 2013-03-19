Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3CSNhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:37:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64366 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3CSNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:37:32 -0400
Date: Tue, 19 Mar 2013 06:38:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH v4] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130319133852.GD24313@kroah.com>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
 <20130319002742.GA11050@kroah.com>
 <20130318231154.GC9685@logfs.org>
 <20130318233413.GD9685@logfs.org>
 <20130319015354.GA21045@kroah.com>
 <20130319033112.GA11307@logfs.org>
 <20130319050954.GA23390@kroah.com>
 <20130319035803.GB11307@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130319035803.GB11307@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:58:03PM -0400, Jörn Engel wrote:
> On Mon, 18 March 2013 22:09:54 -0700, Greg Kroah-Hartman wrote:
> > On Mon, Mar 18, 2013 at 11:31:12PM -0400, Jörn Engel wrote:
> > > On Mon, 18 March 2013 18:53:54 -0700, Greg Kroah-Hartman wrote:
> > 
> > > > And why not _irqstore() anymore?
> > > 
> > > Because I thought the resulting code would be horrible.  But going
> > > through the excercise, it does seem half as bad as I feared.  In fact,
> > > I rather like it now.
> > 
> > You changed the kref code too, does it work better now?
> 
> It compiles.  I don't have a good testcase, so the procedure is to
> throw it into the test infrastructure and wait a week.

Really?  Please make a test cast to test it out properly.

> > > It is possible for one thread to to take se_sess->sess_cmd_lock in
> > > core_tmr_abort_task() before taking a reference count on
> > > se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> > > se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> > > 
> > > This introduces kref_put_spinlock_irqsave() and uses it in
> > > target_put_sess_cmd() to close the race window.
> > > 
> > > Signed-off-by: Joern Engel <joern@logfs.org>
> > > ---
> > >  drivers/target/target_core_transport.c |    7 +++----
> > >  include/linux/kref.h                   |   32 ++++++++++++++++++++++++++++++++
> > >  2 files changed, 35 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > > index 04ec9cb..7e856b9 100644
> > > --- a/drivers/target/target_core_transport.c
> > > +++ b/drivers/target/target_core_transport.c
> > > @@ -2203,13 +2203,11 @@ out:
> > >  	return ret;
> > >  }
> > >  
> > > -static void target_release_cmd_kref(struct kref *kref)
> > > +static void target_release_cmd_kref(struct kref *kref, unsigned long flags)
> > >  {
> > >  	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
> > >  	struct se_session *se_sess = se_cmd->se_sess;
> > > -	unsigned long flags;
> > >  
> > > -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > 
> > Why pass flags to a release function?
> > 
> > I don't think you can do that, but it's been a while since I looked at
> > the spinlock code.
> 
> The alternative would be to call local_irq_restore(flags); from
> kref_put_spinlock_irqsave() and not pass the flags.  Getting rid of
> the extra parameter would be nice.  But I'm not sure I want to prove
> that
> 	spin_unlock(lock);
> 	local_irq_restore(flags);
> is the same as 
> 	spin_unlock_irqrestore(lock, flags);
> on all architectures and with all combinations of CONFIG options.

It should be.

> I think it should be, but I wouldn't bet half a cookie on it.

That's why we have the code readable for everyone to see :)

I suggest doing some research and determining if this is true or not,
please, before I can accept this.

greg k-h
