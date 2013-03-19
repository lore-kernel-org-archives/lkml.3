Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3CSFIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:08:38 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54848 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3CSFIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:08:36 -0400
Date: Mon, 18 Mar 2013 22:09:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH v4] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130319050954.GA23390@kroah.com>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
 <20130319002742.GA11050@kroah.com>
 <20130318231154.GC9685@logfs.org>
 <20130318233413.GD9685@logfs.org>
 <20130319015354.GA21045@kroah.com>
 <20130319033112.GA11307@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130319033112.GA11307@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:31:12PM -0400, Jörn Engel wrote:
> On Mon, 18 March 2013 18:53:54 -0700, Greg Kroah-Hartman wrote:
> > On Mon, Mar 18, 2013 at 07:34:13PM -0400, Jörn Engel wrote:
> > > ---
> > >  drivers/target/target_core_transport.c |   17 +++++++++++------
> > >  include/linux/kref.h                   |   26 ++++++++++++++++++++++++++
> > >  2 files changed, 37 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > > index 04ec9cb..b98c158 100644
> > > --- a/drivers/target/target_core_transport.c
> > > +++ b/drivers/target/target_core_transport.c
> > > @@ -2207,21 +2207,19 @@ static void target_release_cmd_kref(struct kref *kref)
> > >  {
> > >  	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
> > >  	struct se_session *se_sess = se_cmd->se_sess;
> > > -	unsigned long flags;
> > >  
> > > -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > >  	if (list_empty(&se_cmd->se_cmd_list)) {
> > > -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> > > +		spin_unlock(&se_sess->sess_cmd_lock);
> > 
> > Wait, who has this locked?  You took out the call to spin_lock_* above.
> 
> The spinlock needs to be taken atomically wrt. the final kref_put.  So
> either the kref_put was not final and we don't end up calling
> target_release_cmd_kref() or it was and the spinlock is already taken
> when calling the release function.  You could call that the central
> bit of the patch. ;)

Ah, ok.

> > And why not _irqstore() anymore?
> 
> Because I thought the resulting code would be horrible.  But going
> through the excercise, it does seem half as bad as I feared.  In fact,
> I rather like it now.

You changed the kref code too, does it work better now?



> 
> Jörn
> 
> --
> Happiness isn't having what you want, it's wanting what you have.
> -- unknown
> 
> 
> It is possible for one thread to to take se_sess->sess_cmd_lock in
> core_tmr_abort_task() before taking a reference count on
> se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> 
> This introduces kref_put_spinlock_irqsave() and uses it in
> target_put_sess_cmd() to close the race window.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/target/target_core_transport.c |    7 +++----
>  include/linux/kref.h                   |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 04ec9cb..7e856b9 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2203,13 +2203,11 @@ out:
>  	return ret;
>  }
>  
> -static void target_release_cmd_kref(struct kref *kref)
> +static void target_release_cmd_kref(struct kref *kref, unsigned long flags)
>  {
>  	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
>  	struct se_session *se_sess = se_cmd->se_sess;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);

Why pass flags to a release function?

I don't think you can do that, but it's been a while since I looked at
the spinlock code.

greg k-h
