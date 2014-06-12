Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaFLTpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:45:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63729 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751247AbaFLTpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:45:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Doug Smythies <dsmythies@telus.net>, viresh.kumar@linaro.org,
        dirk.j.brandewie@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
Date: Thu, 12 Jun 2014 22:03:15 +0200
Message-ID: <1815178.vjJU51ubGD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5399BACF.6060201@semaphore.gr>
References: <1402490012-19969-1-git-send-email-stratosk@semaphore.gr> <00b301cf85ba$40fe4290$c2fac7b0$@net> <5399BACF.6060201@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 12, 2014 05:35:59 PM Stratos Karafotis wrote:
> On 12/06/2014 12:15 πμ, Doug Smythies wrote:
> > 
> > 
> > -----Original Message-----
> > From: Stratos Karafotis [mailto:stratosk@semaphore.gr] 
> > Sent: June-11-2014 13:20
> > To: Doug Smythies
> > Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; rjw@rjwysocki.net; viresh.kumar@linaro.org; dirk.j.brandewie@intel.com
> > Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
> > 
> > On 2014.06.11 13:20 Stratos Karafotis wrote:
> >> On 11/06/2014 06:02 μμ, Doug Smythies wrote:
> >>>
> >>> On 2104.06.11 07:08 Stratos Karafotis wrote:
> >>>> On 11/06/2014 04:41 μμ, Doug Smythies wrote:
> >>>>
> >>>> No.
> >>>
> >>>> The intent was only ever to round properly the pseudo floating point result of the divide.
> >>>> It was much more important (ugh, well 4 times more) when FRACBITS was still 6, which also got changed to 8 in a recent patch.
> >>>>
> >>>
> >>> Are you sure?
> >>>
> >>> Yes.
> >>>
> >>>> This rounding was very recently added.
> >>>> As far as I can understand, I don't see the meaning of this rounding, as is.
> >>>> Even if FRAC_BITS was 6, I think it would have almost no improvement in
> >>>> calculations.
> >>>
> >>> Note: I had not seen this e-mail when I wrote a few minutes ago:
> >>>
> >>> You may be correct.
> >>> If Dirk agrees, I will re-analyse the entire driver for rounding effects soon.
> >>> When FRACBITS was 6 there were subtle cases where the driver would get stuck, and not make a final pstate change, with the default PID gains.
> >>> Other things have changed, and the analysis needs to be re-done.
> >>>
> > 
> >> Could you please elaborate a little bit more what we need these 2 lines below?
> >>
> >>        if ((rem << 1) >= int_tofp(sample->mperf))
> >>                core_pct += 1;
> >>
> >> Because nothing is mentioned for them in commit's changelog.
> >> Do we need to round core_pct or not?
> >> Because if we try to round it, I think this patch should work.
> > 
> > As mentioned originally, they are there just to round the pseudo floating number, not the integer portion only.
> > Let us bring back the very numbers you originally gave and work through it.
> > 
> > aperf = 5024
> > mperf = 10619
> > 
> > core_pct = 47.31142292%
> > or 47 and 79.724267 256ths
> > or to the closest kept fractional part 47 and 80 256ths
> > or 12112 as a pseudo float.
> > The maximum error with this rounding will be 1 part in 512 and symmetric instead of the 1 part in 256 always in one direction without.
> > 
> > Now if FRACBITS was still 6:
> > core_pct = 47.31142292%
> > or 47 and 19.931 64ths
> > or to the closest kept fractional part 47 and 20 64ths
> > or 3028 as a pseudo float.
> > The maximum error with this rounding will be 1 part in 128 and symmetric instead of the 1 part in 64 (1.6% !!!) always in one direction without.
> > 
> > Hope this helps.
> > 
> 
> Yes, it helps. Thanks a lot!
> 
> But please note that the maximum error without this rounding will be 1.6% _only_
> in fractional part. In the real number it will be much smaller:
> 
> 47.19 instead of 47.20
> 
> And using FRAC_BITS 8:
> 
> 47.79 instead of 47.80
> 
> This is a 0.0002% difference. I can't see how this is can affect the calculations
> even with FRAC_BITS 6.
> 
> Another thing is that this algorithm generally is used to round to the
> nearest integer. I'm not sure if it's valid to apply it for the rounding of
> the fractional part of fixed point number.

Depending on the original reason, it may or may not be.

In theory, it may help reduce numerical drift resulting from rounding always in
one direction only, but I'm not really sure if that matters here.

Doug seems to have carried out full analysis, though.

Rafael

