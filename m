Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3FXNYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:24:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49112 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3FXNYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:24:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
Date: Mon, 24 Jun 2013 15:33:41 +0200
Message-ID: <2165396.dF1lQyPRVT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponQQphBGv9jUCF9_r2NQs7T=wkaWp_d5oO3RT=mY_zqcg@mail.gmail.com>
References: <cover.1371630975.git.viresh.kumar@linaro.org> <11846442.bozySFIXTh@vostro.rjw.lan> <CAKohponQQphBGv9jUCF9_r2NQs7T=wkaWp_d5oO3RT=mY_zqcg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 06:46:39 PM Viresh Kumar wrote:
> On 24 June 2013 18:53, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > You can do
> >
> >         if (WARN(transition_ongoing, "<text>"))
> >                 return;
> >
> > and below analogously.
> 
> Ahh.. stupid code.. Check if this fixup is fine (attached too)

Looks OK, but since transition_ongoing is either 0 or 1 now, as far as I can
say, it would be better to make it a bool and use = true/false instead of
++/-- I suppose.

Thanks,
Rafael


> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6624694..6ca7eac 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -267,10 +267,9 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>         switch (state) {
> 
>         case CPUFREQ_PRECHANGE:
> -               if (transition_ongoing) {
> -                       WARN(1, "In middle of another frequency transition\n");
> +               if (WARN(transition_ongoing,
> +                               "In middle of another frequency transition\n"))
>                         return;
> -               }
> 
>                 transition_ongoing++;
> 
> @@ -293,10 +292,9 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>                 break;
> 
>         case CPUFREQ_POSTCHANGE:
> -               if (!transition_ongoing) {
> -                       WARN(1, "No frequency transition in progress\n");
> +               if (WARN(!transition_ongoing,
> +                               "No frequency transition in progress\n"))
>                         return;
> -               }
> 
>                 transition_ongoing--;
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
