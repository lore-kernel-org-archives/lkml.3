Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab3GZNIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:08:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53198 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3GZNIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:08:32 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-a0-51f274ce0b2c
Date: Fri, 26 Jul 2013 15:08:22 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
Message-id: <20130726150822.62891d43@amdc308.digital.local>
In-reply-to: <13618968.iglDI8cQ6h@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
 <20130726103321.21238bbb@amdc308.digital.local>
 <13618968.iglDI8cQ6h@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jQd1zJZ8CDXZskbXYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4v2hZ8wWl3fNYbP43HuE0aJ/YS+TxZOH
	fWwWG796OPB5LN7zksnjzrU9bB63/z1m9lg37S2zR9+WVYwejxa3MHocv7GdyePzJrkAjigu
	m5TUnMyy1CJ9uwSujEUfljEXTJSo+H7mPGMD40uBLkZODgkBE4ntDY3MELaYxIV769m6GLk4
	hASmM0o8/7KNGcJpZ5LYMeUWO0gVi4CqxM2Od4wgNpuAnsTnu0+ZQGwRoPiWJ//ZQRqYBXax
	SOw63Ao2VljAQ+LIr29gRbwC1hK3j91hA7E5BQwlHh59wAix4SmjxJcZt8GK+AUkJdr//YC6
	yU7i3KcN7BDNghI/Jt9jAbGZBbQkNm9rYoWw5SU2r3nLPIFRcBaSsllIymYhKVvAyLyKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIzjCnknvYFzVYHGIUYCDUYmHV8HpY6AQa2JZcWXuIUYJ
	DmYlEd7r3p8ChXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBK
	NTCq5HSX7T8c/+Vc/yXD6Iy3bPNOl67xsuL6wiunc7LA+Qhrpcfp7ljvT9cXPOW6cvNw3zLt
	uEXX6+4w6zMWbXZfWBy464b1FSGb1V6S2ju/VM/stIquyfM49X/e/5YHIgE/n8wKfOji2+G4
	6dcm+b+buBYfzsrye3g9+ZGh5e+gsK91se72n1uUWIozEg21mIuKEwHDr3jlrAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 14:36:08 +0200 Rafael J. Wysocki rjw@sisk.pl wrote,
> On Friday, July 26, 2013 10:33:21 AM Lukasz Majewski wrote:
> > On Fri, 26 Jul 2013 12:47:15 +0530 Viresh Kumar wrote,
> > > On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com>
> > > wrote:
> > > > diff --git a/drivers/cpufreq/cpufreq.c
> > > > b/drivers/cpufreq/cpufreq.c
> > > 
> > > >  /*********************************************************************
> > > > + *
> > > > BOOST                                              *
> > > > +
> > > > *********************************************************************/
> > > > +static int cpufreq_boost_set_sw(int state) +{
> > > > +       struct cpufreq_frequency_table *freq_table;
> > > > +       struct cpufreq_policy *policy;
> > > > +       int ret = -EINVAL;
> > > > +
> > > > +       list_for_each_entry(policy, &cpufreq_policy_list,
> > > > policy_list) {
> > > > +               freq_table =
> > > > cpufreq_frequency_get_table(policy->cpu);
> > > > +               if (freq_table) {
> > > > +                       ret =
> > > > cpufreq_frequency_table_cpuinfo(policy,
> > > > +
> > > > freq_table);
> > > > +                       if (!ret) {
> > > > +                               policy->user_policy.max =
> > > > policy->max;
> > > > +                               __cpufreq_governor(policy,
> > > > CPUFREQ_GOV_LIMITS);
> > > > +                       }
> > > > +               }
> > > > +       }
> > > > +
> > > > +       return ret;
> > > > +}
> > > > +
> > > > +int cpufreq_boost_trigger_state(int state)
> > > > +{
> > > > +       unsigned long flags;
> > > > +       int ret = 0;
> > > > +
> > > > +       if (cpufreq_driver->boost_enabled == state)
> > > > +               return 0;
> > > > +
> > > > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> > > > +       cpufreq_driver->boost_enabled = state;
> > > > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > 	    ^^^^^^^^^^^^^^^^^^^^ [*]
> > > 
> > > Not sure if we should leave the lock at this point of time, as we
> > > haven't enabled boost until now.
> > 
> > The problem here is with the cpufreq_driver->set_boost() call.
> > 
> > I tried to avoid acquiring lock at one function and release it at
> > another (in this case cpufreq_boost_set_sw), especially since the
> > __cpufreq_governor() acquires its own lock - good place for
> > deadlock.
> > 
> > Is it OK for you to grab lock at one function
> > (cpufreq_boost_trigger_state()) and then at other function
> > (cpufreq_boost_set_sw) release it before calling
> > __cpufreq_governor() and grab it again after its completion?
> 
> It generally is better to avoid doing that, although it is not
> unheard of.

In this particular case, one also needs to pass the "flags" parameter to
the set_boost() function. This looks a bit unnatural to mix lock layer
with the boost.

> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
