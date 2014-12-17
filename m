Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaLQXrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:47:23 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51195 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLQXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:47:22 -0500
Date: Wed, 17 Dec 2014 15:47:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
Message-ID: <20141217234713.GT5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
 <1418771379-24369-4-git-send-email-dtor@chromium.org>
 <CAKohpok0UieH=Pi4nU2tKqV1_LH+3uzMDr0B8wsN61g1BnG4pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpok0UieH=Pi4nU2tKqV1_LH+3uzMDr0B8wsN61g1BnG4pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121723-0021-0000-0000-0000070BE649
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 10:06:17AM +0530, Viresh Kumar wrote:
> On 17 December 2014 at 04:39, Dmitry Torokhov <dtor@chromium.org> wrote:
> > A lot of callers are missing the fact that dev_pm_opp_get_opp_count
> > needs to be called under RCU lock. Given that RCU locks can safely be
> > nested, instead of providing *_locked() API, let's take RCU lock inside
> 
> Hmm, I asked for a *_locked() API because many users of
> dev_pm_opp_get_opp_count() are already calling it from rcu read side
> critical sections.
> 
> Now, there are two questions:
> - Can rcu-read side critical sections be nested ?
> 
> Yes, this is what the comment over rcu_read_lock() says
> 
>  * RCU read-side critical sections may be nested.  Any deferred actions
>  * will be deferred until the outermost RCU read-side critical section
>  * completes.
> 
> - Would it be better to drop these double rcu_read_locks() ? i.e. either
> get a *_locked() API or fix the callers of dev_pm_opp_get_opp_count().
> 
> @Paul: What do you say ?

Yep, they can be nested.  Both rcu_read_lock() and rcu_read_unlock()
are quite fast, as are their friends, so there is almost no performance
penalty from nesting.  So the decision normally turns on maintainability
and style.

							Thanx, Paul

> > dev_pm_opp_get_opp_count() and leave callers as is.
> >
> > Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> > ---
> >  drivers/base/power/opp.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> > index 413c7fe..ee5eca2 100644
> > --- a/drivers/base/power/opp.c
> > +++ b/drivers/base/power/opp.c
> > @@ -216,9 +216,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
> >   * This function returns the number of available opps if there are any,
> >   * else returns 0 if none or the corresponding error value.
> >   *
> > - * Locking: This function must be called under rcu_read_lock(). This function
> > - * internally references two RCU protected structures: device_opp and opp which
> > - * are safe as long as we are under a common RCU locked section.
> > + * Locking: This function takes rcu_read_lock().
> >   */
> >  int dev_pm_opp_get_opp_count(struct device *dev)
> >  {
> > @@ -226,13 +224,14 @@ int dev_pm_opp_get_opp_count(struct device *dev)
> >         struct dev_pm_opp *temp_opp;
> >         int count = 0;
> >
> > -       opp_rcu_lockdep_assert();
> > +       rcu_read_lock();
> >
> >         dev_opp = find_device_opp(dev);
> >         if (IS_ERR(dev_opp)) {
> > -               int r = PTR_ERR(dev_opp);
> > -               dev_err(dev, "%s: device OPP not found (%d)\n", __func__, r);
> > -               return r;
> > +               count = PTR_ERR(dev_opp);
> > +               dev_err(dev, "%s: device OPP not found (%d)\n",
> > +                       __func__, count);
> > +               goto out_unlock;
> >         }
> >
> >         list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
> > @@ -240,6 +239,8 @@ int dev_pm_opp_get_opp_count(struct device *dev)
> >                         count++;
> >         }
> >
> > +out_unlock:
> > +       rcu_read_unlock();
> >         return count;
> >  }
> 
> Looked fine otherwise:
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

