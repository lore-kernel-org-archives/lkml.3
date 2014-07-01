Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076AbaGAWA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:00:56 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39549 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932AbaGAWAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:00:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rob Herring" <rob.herring@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAKohpokaVPn7yNPNAGrE6juGaOYuxZvVsbmkOZmyi9rDub6t7g@mail.gmail.com>
Cc: "Grant Likely" <grant.likely@linaro.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Shawn Guo" <shawn.guo@linaro.org>,
        "Lists linaro-kernel" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Arvind Chauhan" <arvind.chauhan@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, "Sachin Kamat" <spk.linux@gmail.com>,
        "Thomas P Abraham" <thomas.ab@samsung.com>,
        "Nishanth Menon" <nm@ti.com>, "Tomasz Figa" <t.figa@samsung.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Mark Rutland" <Mark.Rutland@arm.com>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
 <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
 <53AB1CC1.4010907@codeaurora.org>
 <CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
 <53ACB568.4000903@codeaurora.org> <20140627015354.32686.83046@quantum>
 <CAKohponvN3rAvJrfi4TojFcq5gq7r2oNE4Q0_NtwBHmEZ8waBA@mail.gmail.com>
 <CAKohpo=dgSW551yzqjAV2_opw_4naqFEWpwUz9ktkGgR5vCBZA@mail.gmail.com>
 <CABGGiswMuofH5WRh4jgwh1=CV+fEXM_Ec3+WNwThbuMLVxsdcg@mail.gmail.com>
 <CAKohpokaVPn7yNPNAGrE6juGaOYuxZvVsbmkOZmyi9rDub6t7g@mail.gmail.com>
Message-ID: <20140701220038.32686.81633@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
Date: Tue, 01 Jul 2014 15:00:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Viresh Kumar (2014-07-01 04:14:04)
> On 1 July 2014 00:03, Rob Herring <rob.herring@linaro.org> wrote:
> >> What about comparing "clocks" property in cpu DT nodes?
> >
> > What if a different clock is selected for some reason.
> 
> I don't know why that will happen for CPUs sharing clock line.
> 
> > I think a clock api function would be better.
> 
> @Mike: What do you think? I think we can get a clock API for
> this.

I can't help but think this is a pretty ugly solution. Why not specify
the nature of the cpu clock(s) in DT directly? There was a thread
already that discussed adding such a property to the CPU DT binding but
it seems to have gone cold[1]. Furthermore my mailer sucks and I see now
that my response to that thread never hit the list due to mangled
headers. Here is a copy/paste of my response to the aforementioned
thread:

"""
I'll join the bikeshedding.

The hardware property that matters for cpufreq-cpu0 users is that a
multi-core CPU uses a single clock input to scale frequency across all
of the cores in that cluster. So an accurate description is:

scaling-method = "clock-ganged"; //hardware-people-speak

Or,

scaling-method = "clock-shared"; //software-people-speak

Versus independently scalable CPUs in an SMP cluster:

scaling-method = "independent"; //x86, Krait, etc.

Or perhaps instead of "independent" at the parent "cpus" node we would
put the following in each cpu@N node:

scaling-method = "clock";

Or "psci" or "acpi" or whatever.

Thought exercise: for Hyperthreaded(tm) CPUs with 2 virtual cores for
every hard CPU (and multiple CPUs in a cluster):

scaling-method = "paired";

Or more simply, "hyperthreaded".
"""

Regards,
Mike

[1] http://www.spinics.net/lists/cpufreq/msg10034.html

> 
> > That being said, I don't really have any issue with such a function.
> > Some comments on the implementation.
> 
> >> +static int of_property_match(const struct device_node *np1,
> >> +                             const struct device_node *np2,
> >> +                             const char *list_name)
> >> +{
> >> +       const __be32 *list1, *list2, *list1_end;
> >
> > s/list/prop/
> >
> > Everywhere.
> 
> Ok.
> 
> >> +       int size1, size2;
> >> +       phandle phandle1, phandle2;
> >> +
> >> +       /* Retrieve the list property */
> >> +       list1 = of_get_property(np1, list_name, &size1);
> >> +       if (!list1)
> >> +               return -ENOENT;
> >> +
> >> +       list2 = of_get_property(np2, list_name, &size2);
> >> +       if (!list2)
> >> +               return -ENOENT;
> >> +
> >> +       if (size1 != size2)
> >> +               return 0;
> >> +
> >> +       list1_end = list1 + size1 / sizeof(*list1);
> >> +
> >> +       /* Loop over the phandles */
> >> +       while (list1 < list1_end) {
> >> +               phandle1 = be32_to_cpup(list1++);
> >> +               phandle2 = be32_to_cpup(list2++);
> >> +
> >> +               if (phandle1 != phandle2)
> >> +                       return 0;
> >> +       }
> >
> > You can just do a memcmp here.
> 
> Yeah, that would be much better.
> 
> > This is wrong anyway because you don't know #clock-cells size.
> 
> I was actually comparing all the clock-cells, whatever there number
> is to make sure "clocks" properties are exactly same. Anyway
> memcmp will still guarantee that.
> 
> Thanks for your review.
