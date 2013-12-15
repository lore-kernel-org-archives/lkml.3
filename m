Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3LONvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 08:51:14 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62784 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3LONvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 08:51:12 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Andrew Bresticker <abrestic@google.com>,
        Doug Anderson <dianders@google.com>
Subject: Re: [RFC v2 1/4] power: asv: Add common ASV support for Samsung SoCs
Date: Sun, 15 Dec 2013 14:51:03 +0100
Message-ID: <11098201.47kElN2vGm@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <CAKew6eVSOQaHjYj3JRhJKnozY26OkeUGhvC2usadfUqW9hyu2Q@mail.gmail.com>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org> <4229773.U5JovcREjb@amdc1227> <CAKew6eVSOQaHjYj3JRhJKnozY26OkeUGhvC2usadfUqW9hyu2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 of December 2013 22:30:13 Yadwinder Singh Brar wrote:
[snip]
> >> +
> >> +     return NULL;
> >> +}
> >> +
> >> +unsigned int asv_get_volt(enum asv_type_id target_type,
> >> +                                             unsigned int target_freq)
> >
> > Do you need this function at all? I believe this is all about populating
> > device's OPP array with frequencies and voltages according to its ASV
> > level. Users will be able to query for required voltage using standard OPP
> > calls then, without a need for ASV specific functions like this one.
> >
> 
> Yes, I had put a comment in initial version after commit message :
> "Hopefully asv_get_volt() can go out in future, once all users start using OPP
> library." , which seems to be missed in this version.
> I had kept it for the time being in initial version, to keep it
> usable(for testing) with
> existing cpufreq drivers, which need to reworked and may take time.

Hmm, at the moment none of cpufreq drivers use ASV, so they need to be
reworked anyway to use it either by the means of a private get_volt
function or OPP framework. I agree that OPP may require more work,
though.

If we decide to keep this function in final version, a comment should be
added saying that its usage is deprecated in favor of generic OPP helpers.

> 
> [snip]
> >> +
> >> +     for (i = 0; i < asv_info->nr_dvfs_level; i++) {
> >> +             if (dev_pm_opp_add(dev, dvfs_table[i].freq * 1000,
> >> +                     dvfs_table[i].volt)) {
> >> +                     dev_warn(dev, "Failed to add OPP %d\n",
> >> +                              dvfs_table[i].freq);
> >
> > Hmm, shouldn't it be considered a failure instead?
> >
> 
> hmm, not really always. Theoretically system with some less(failed to add)
> levels can work. Moreover I had prefered to keep it only warning, just to
> keep the behaviour of  asv_init_opp_table() similar to that of its
> counter part of_init_opp_table().

I'm not quite convinced about it. If dev_pm_opp_add() fails, doesn't it mean
that something broke seriously in upper layer and we should propagate the
error down? Especially when looking at opp_add(), the only failure
conditions I can find are memory allocation errors which mean that the
system is unlikely to operate correctly anyway.

> 
> >> +                     continue;
> >> +             }
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static struct asv_member *asv_init_member(struct asv_info *asv_info)
> >> +{
> >> +     struct asv_member *asv_mem;
> >> +     int ret = 0;
> >> +
> >> +     if (!asv_info) {
> >> +             pr_err("No ASV info provided\n");
> >> +             return NULL;
> >
> > I'd suggest adopting the ERR_PTR() convention, which allows returning more
> > information about the error.
> >
> 
> Will it be really usefull here?, as we are not checking return value
> of any function.

Why not? Here you have ERR_PTR(-EINVAL), then...

> Bur for some cases below, i will also like to get it used.
> 
> >> +     }
> >> +
> >> +     asv_mem = kzalloc(sizeof(*asv_mem), GFP_KERNEL);
> >> +     if (!asv_mem) {
> >> +             pr_err("Allocation failed for member: %s\n", asv_info->name);
> >> +             return NULL;

ERR_PTR(-ENOMEM) here.

These are two completely different error cases.

> >> +     }
> 
> [snip]
> >
> > Hmm, I don't see a point of these three separate callbacks above.
> >
> > In general, I'd suggest a different architecture. I'd see this more as:
> >
> > 1) Platform code registers static platform device to instantiate SoC ASV
> >    driver.
> > 2) SoC specific ASV driver probes, reads group ID from hardware register,
> >    calls register_asv_member() with appropriate DVFS table for detected
> >    group.
> > 3) Driver using ASV calls asv_init_opp_table() with its struct device and
> >    ASV member name, which causes the ASV code to fill device's operating
> >    point using OPP calls.
> >
> > Now client driver has all the information it needs and the work of ASV
> > subsystem is done. The control flow between drivers would be much simpler
> > and no callbacks would have to be called.
> >
> 
> Architecture stated above seems to be a subset(one possible way of use),
> of the proposed architecture. If someone really have nothing much to do,
> he can adopt the above stated approach using this framework also,
> callbacks are not mandatory.

I believe that kernel design principles are to first start with something
simple and then if a real need for an extension shows up then extend
existing code base with missing features.

> 
> Since we usually have more things to do other than only reading
> fused group value and simply parsing a table index, so in drivers we have to
> implement functions to segregate stuff and different people do it in
> different way. Its an attempt to provide a way to keep structure(functions)
> similar for easy understanding and factoring out of common code.

I fail to see those more things. Could you elaborate a bit about them?

>From what I see, all the potential ASV users need is a set of operating
points (frequency:voltage pairs) appropriate for the SoC we are running
on (i.e. matching our ASV group index). Is there anything more we need to
do for ASV support?

> 
> Moreover, I feels need of callbacks if we have to do something depending
> upon(specific) the user/instance of  ASV member. One thing came
> in my mind was dev_node may be required if we may think of parsing
> ASV table from DT and may be more things in future.

We can always add such things later, if real need shows up. As I said
above, we should rather start with something simple, to avoid
overdesigning things without knowing real use cases that may show
up later.

Best regards,
Tomasz

