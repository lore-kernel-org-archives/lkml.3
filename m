Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaE1Tku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:40:50 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:63612 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaE1Tks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
Date: Wed, 28 May 2014 12:40:47 -0700
X-Google-Sender-Auth: 8ZeiOAJmlE9Ef_JZ-xSxQM3q5D8
Message-ID: <CAD=FV=WpYRHaydJnu-+Be9V5ab2qLrA7Wz-9Z_QaG97XJhrhfg@mail.gmail.com>
Subject: Re: [PATCH V4 2/3] cpufreq: add support for intermediate (stable) frequencies
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Wed, May 21, 2014 at 1:59 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> @@ -1841,9 +1876,23 @@ static int __target_index(struct cpufreq_policy *policy,
>                 pr_err("%s: Failed to change cpu frequency: %d\n", __func__,
>                        retval);
>
> -       if (notify)
> +       if (notify) {
>                 cpufreq_freq_transition_end(policy, &freqs, retval);
>
> +               /*
> +                * Failed after setting to intermediate freq? Driver should have
> +                * reverted back to initial frequency and so should we. Check
> +                * here for intermediate_freq instead of get_intermediate, in
> +                * case we have't switched to intermediate freq at all.
> +                */
> +               if (unlikely(retval && intermediate_freq)) {
> +                       freqs.old = intermediate_freq;
> +                       freqs.new = policy->restore_freq;
> +                       cpufreq_freq_transition_begin(policy, &freqs);
> +                       cpufreq_freq_transition_end(policy, &freqs, retval);

As far as I can tell this notification says "I tried to switch from
"intermediate_freq" to "policy->restore_freq" but I failed, so I'm
still at "intermediate_freq".  I think you probably want to pass 0 as
the last argument to cpufreq_freq_transition_end() to fix...


Other than that this looks good to me.  I'll do a final review when
you spin the next version (since I think you need to fix stuff for
Stephen too).  I'll probably wait and re-review the Tegra version when
you and Stephen come to a consensus on it.

-Doug
