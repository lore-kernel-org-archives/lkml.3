Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab3BMNOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:14:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37904 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab3BMNOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:14:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Cc: Nathan Zimmer <nzimmer@sgi.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH v2 linux-next 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu
Date: Wed, 13 Feb 2013 14:20:35 +0100
Message-ID: <1651157.ApO0q9O4LF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130212155954.GP2666@linux.vnet.ibm.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com> <1953281.cgEiiBGo0f@vostro.rjw.lan> <20130212155954.GP2666@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 12, 2013 07:59:54 AM Paul E. McKenney wrote:
> On Mon, Feb 11, 2013 at 08:36:17PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 11, 2013 05:13:30 PM Nathan Zimmer wrote:
> > > There are some spots that I need to give a much deeper review, cpufreq_register_driver for example.
> > > 
> > > But I believe 
> > > > @@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
> > > >  {
> > > >       if (!sysfs)
> > > >               kobject_put(&data->kobj);
> > > > -     module_put(cpufreq_driver->owner);
> > > > +     module_put(rcu_dereference(cpufreq_driver)->owner);
> > > >  }
> > > would be ok.  In the documentation whatisRCU.txt they give a very similar example.
> > 
> > Well, the very same document states the following:
> > 
> >         Note that the value returned by rcu_dereference() is valid
> >         only within the enclosing RCU read-side critical section.
> 
> Ah, there is a code sample in that document showing a bug.  I added
> comments to the code sample making it clear even to someone skimming
> the document that the code is buggy.
> 
> 							Thanx, Paul
> ------------------------------------------------------------------------
> 
> rcu: Make bugginess of code sample more evident
> 
> One of the code samples in whatisRCU.txt shows a bug, but someone scanning
> the document quickly might mistake it for a valid use of RCU.  Add some
> screaming comments to help keep speed-readers on track.
> 
> Reported-by: Nathan Zimmer <nzimmer@sgi.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
> index 0cc7820..10df0b8 100644
> --- a/Documentation/RCU/whatisRCU.txt
> +++ b/Documentation/RCU/whatisRCU.txt
> @@ -265,9 +265,9 @@ rcu_dereference()
>  		rcu_read_lock();
>  		p = rcu_dereference(head.next);
>  		rcu_read_unlock();
> -		x = p->address;
> +		x = p->address;	/* BUG!!! */
>  		rcu_read_lock();
> -		y = p->data;
> +		y = p->data;	/* BUG!!! */
>  		rcu_read_unlock();
>  
>  	Holding a reference from one RCU read-side critical section
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
