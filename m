Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3IJPOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:14:21 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48681 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3IJPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:14:18 -0400
MIME-Version: 1.0
In-Reply-To: <4292924.3iHJT5nzNS@vostro.rjw.lan>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
	<CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
	<4292924.3iHJT5nzNS@vostro.rjw.lan>
Date: Tue, 10 Sep 2013 20:44:18 +0530
Message-ID: <CAKohponUdE0LCciPb+nf3t_vfNqAy3MeWQO8gTOdEDvQJeWcgg@mail.gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Greg KH <greg@kroah.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2013 17:19, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> That said I'm actually unsure what problems *exactly* are fixed by commit
> 7c30ed5.  The commit log only says that PRECHANGE or POSTCHAGE shouldn't be
> called twice in a row, but it doesn't say why.  As the fallout indicates,
> that actually happened before commit 7c30ed5 and nothing visibly broke, so
> the benefit from having that commit is questionable to me.  On the other hand,
> the commit itself is evidently broken, so what exactly is the reason for
> keeping it?

Okay, so the first question is can we have multiple PRECHANGE notfication
done without any POSTCHANGE inbetween?
- Scenario: One reading value of cpuinfo_cur_freq, which will call
__cpufreq_cpu_get()->cpufreq_out_of_sync()->cpufreq_notify_transition()..

And ondemand governor trying to change freq of cpu and so doing notification..

There can be more similar scenarios possible..


Now Second question, is this fine to have multiple PRECHANGE notfications
before any POSTCHANGE notification?

Logically it looks obvious to me that these must be serialized..
Otherwise this is what we are broadcasting:
- We are changing for freq X, please prepare and let us know if you are
okay with it..
- Oh.. So sorry, we are changing to freq Y instead, please adjust accordingly.

- Yes we have changed to freq Y...
- Yes we have changed to freq X...

This looks stupid, isn't it? I don't know how the drivers would behave when
they see such notifications and so got to this patch initially..
