Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab3GZKLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:11:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18394 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3GZKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:11:31 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-37-51f24b526ce7
Date: Fri, 26 Jul 2013 12:11:23 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
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
Message-id: <20130726121123.2d7da79a@amdc308.digital.local>
In-reply-to: <CAKohpokK8eNid3yNGTEax_-3CZNaJ4T6Osz8RrXk11hn+Mmxxg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-3-git-send-email-l.majewski@samsung.com>
 <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
 <20130726103321.21238bbb@amdc308.digital.local>
 <CAKohpokK8eNid3yNGTEax_-3CZNaJ4T6Osz8RrXk11hn+Mmxxg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAd0g70+BBq+PSVlsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8f7QM2aLy7vmsFl87j3CaNG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo/b/x4ze6yb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wARxSX
	TUpqTmZZapG+XQJXxtWPLewFX9krOn7fZG5gXM7WxcjJISFgIjHp8xomCFtM4sK99UBxLg4h
	gUWMEuf+/meCcNqZJH78PcQKUsUioCqxZOJqsG42AT2Jz3efAhVxcIgIaEm8vJkKUs8ssJVF
	4tWGB2BThQU8JI78+gZm8wpYS3w5sY0RxOYUCJZoevWFGcQWEvjPJLHyjD6IzS8gKdH+7wcz
	xEV2Euc+bWCH6BWU+DH5HguIzQy0a/O2JlYIW15i85q3zBMYBWchKZuFpGwWkrIFjMyrGEVT
	C5ILipPSc430ihNzi0vz0vWS83M3MYKj65n0DsZVDRaHGAU4GJV4eBWcPgYKsSaWFVfmHmKU
	4GBWEuFd6/gpUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwen
	VANjwetrt6yF/KS2de6pXbcq8ujKUoYcj5cOl1sfHlzqcd7h8tPawq2JU1JXLPqzeIdn5Y8l
	W93/t/RzXdBWsej6fo4vJGy76+Nns1zCpp/7cuNiIDvnVH/+8OCuyDK+0+tfGzF5TXYuZdzF
	0BO1L9NpriPfROWUx1PWHTUykNgRc1ZIRma6/9e5SizFGYmGWsxFxYkAom03lKoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:06:45 +0530 Viresh Kumar wrote,
> On 26 July 2013 14:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
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
> Problem is not only that.. but we shouldn't call boost_set() of
> drivers like acpi-cpufreq with this lock..... Leave it as it is for
> now.. Let me see if I can think of any problems that can happen due
> to this.

Ok. No problem.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
