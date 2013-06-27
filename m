Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3F0Pz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:55:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45495 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3F0Pzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:55:55 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-cd-51cc60898cb1
Date: Thu, 27 Jun 2013 17:55:46 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130627175546.677d9f9b@amdc308.digital.local>
In-reply-to: <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd3OhDOBBt3fzSz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz6Djy
	jdli41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mlq/bWAt+MhVcef9NLYGxg72LkZODgkBE4kN/16wQNhiEhfurWfrYuTiEBJYxCix
	aV0XM4TTziRxce9dNpAqFgFVidPfbjKD2GwCehKf7z5l6mLk4BAR0JJ4eTMVpJ5ZYDuLxKWm
	WWD1wgIeEtt39bOC2LwC1hKLWq+C2ZwCwRL9rYugFrQwSZy91gA2lF9AUqL93w9miJPsJM59
	2sAO0Swo8WPyPbBTmYGWbd7WxAphy0tsXvOWeQKj4CwkZbOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnBUPZPewbiqweIQowAHoxIP7wfG04FCrIllxZW5hxglOJiVRHiP
	+J8JFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDo9XZ5
	M5vUjT0Smm+qDLaz3Jxqo+HTcO/4+9/pNXvjD1aWzNCYISPjpOwczV5Z1rCJP6pFgbGei29C
	at/88u83JoeJzO/baZy+bLa5zRGuldFlKzfNe829cUHMjsmnHzX9LN7L+0OkuNAlavfUuvd9
	B3bvS3y42vHvnOjYjMSd68KVY9jMsvyUWIozEg21mIuKEwGOWgf2pgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 16:24:32 +0530, Viresh Kumar wrote:

> > +int cpufreq_boost_trigger_state(int state)
> > +{
> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       if (boost_enabled != state) {
> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +               boost_enabled = state;
> > +               if (cpufreq_driver->enable_boost)
> > +                       ret = cpufreq_driver->enable_boost(state);
> > +               else
> > +                       ret = cpufreq_boost_trigger_state_sw();

I will use only one call to cpufreq_driver->enable_boost(state) [*] with
either cpufreq_boost_enable_sw() (function with SW boost handling) or
 the one provided by cpufreq driver.

Only when cpufreq driver doesn't provide [*], it will be filled with
"default" cpufreq_boost_enable_sw().

> > +
> > +               if (ret) {
> > +                       boost_enabled = 0;
> > +
> > write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > +                       pr_err("%s: BOOST cannot enable (%d)\n",
> > +                              __func__, ret);
> > +
> > +                       return ret;
> > +               }
> > +               write_unlock_irqrestore(&cpufreq_driver_lock,
> > flags);  


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
