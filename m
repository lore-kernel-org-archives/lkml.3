Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaGKCqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:46:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:14874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaGKCqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,641,1400050800"; 
   d="scan'208";a="568254487"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Sebastian Reichel <sre@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "David Cohen" <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Thread-Topic: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Thread-Index: AQHPlEmiwCL4psBg3UmQFWJgLR5uO5uOGRuAgAejXICAAEkMAIABPgGA
Date: Fri, 11 Jul 2014 02:46:35 +0000
Message-ID: <20ADAB092842284E95860F279283C56422F9B99C@BGSMSX104.gar.corp.intel.com>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
 <20140703145617.GA23309@earth.universe>
 <20ADAB092842284E95860F279283C56422F95A3E@BGSMSX104.gar.corp.intel.com>
 <20140708155614.GA12945@earth.universe>
In-Reply-To: <20140708155614.GA12945@earth.universe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sebastian Reichel [mailto:sre@kernel.org]
> Sent: Tuesday, July 08, 2014 9:26 PM
> To: Tc, Jenny
> Cc: linux-kernel@vger.kernel.org; Dmitry Eremin-Solenikov; Pavel Machek; Stephen
> Rothwell; Anton Vorontsov; David Woodhouse; David Cohen; Pallala, Ramakrishna
> Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
> 
> On Tue, Jul 08, 2014 at 06:07:29AM +0000, Tc, Jenny wrote:
> > > > +static int get_tempzone(struct psy_pse_chrg_prof *pse_mod_bprof,
> > > > +		int temp)
> > > > +{
> > > > +	int i = 0;
> > > > +	int temp_range_cnt;
> > > > +
> > > > +	temp_range_cnt =  min_t(u16, pse_mod_bprof->temp_mon_ranges,
> > > > +					BATT_TEMP_NR_RNG);
> > > > +	if ((temp < pse_mod_bprof->temp_low_lim) ||
> > > > +		(temp > pse_mod_bprof->temp_mon_range[0].temp_up_lim))
> > > > +		return -EINVAL;
> > > > +
> > > > +	for (i = 0; i < temp_range_cnt; ++i)
> > > > +		if (temp > pse_mod_bprof->temp_mon_range[i].temp_up_lim)
> > > > +			break;
> > > > +	return i-1;
> > > > +}
> > >
> > > pse_mod_bprof->temp_mon_ranges > BATT_TEMP_NR_RNG is not allowed, so
> > > I suggest to print an error and return some error code.
> > >
> > min_t takes care of the upper bound. The algorithm process
> > BATT_TEMP_NR_RNG even if the actual number of zones are greater than this.
> 
> Right, the function will not fail, but the zone information table is truncated. I would
> expect at least warning about that. I think it doesn't hurt to have a small function,
> which validates the zone data as good as possible. Using incorrect temperature
> zones is a safety thread and we should try our best to avoid exploding batteries ;)
> 
> Maybe something like that:
> 
> static bool check_tempzones(struct psy_pse_chrg_prof *pse_mod_bprof) {
>     int i = 0;
>     int last_temp = ;
> 
>     /* check size */
>     if (BATT_TEMP_NR_RNG > pse_mod_bprof->temp_mon_ranges)
>         return false;

This is in a way good to have, OK to implement the same.

But KO with below suggestion. This doesn't guarantee safety. IMHO
Safety is 1/0 - SAFE or NOT SAFE. No half safety.

To ensure complete safety, measures should be taken at the entry point- where data
is read from external source. Since the algorithm gets the data from internal
kernel component (power_supply_charger.c), it trust the data. Since the data
is originated from battery identification driver, the safety should be ensured at
that level.

> 
>     /* check zone order */
>     for (i = 0; i < pse_mod_bprof->temp_mon_ranges; i++) {
>         if (last_temp < pse_mod_bprof->temp_mon_range[i].temp_up_lim)
>             return false;
>         last_temp = pse_mod_bprof->temp_mon_range[i].temp_up_lim;
>     }
> 
>     return true;
> }
> 
> -- Sebastian
