Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaBMOX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:23:59 -0500
Received: from [207.46.163.151] ([207.46.163.151]:47314 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaBMOX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:23:56 -0500
Message-ID: <1392301311.2585.9.camel@e37108.spectralink.com>
Subject: Re: [PATCH v2 1/2] dp83640: Support a configurable number of
 periodic outputs
From: Stefan =?ISO-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Date: Thu, 13 Feb 2014 15:21:51 +0100
In-Reply-To: <20140211200922.GA4254@netboy>
References: <1392132562-23644-1-git-send-email-stefan.sorensen@spectralink.com>
	 <1392132562-23644-2-git-send-email-stefan.sorensen@spectralink.com>
	 <20140211200922.GA4254@netboy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.83.164.162]
X-ClientProxiedBy: AM3PR04CA003.eurprd04.prod.outlook.com (10.242.16.23) To
 DM2PR07MB334.namprd07.prod.outlook.com (10.141.98.12)
X-Forefront-PRVS: 0121F24F22
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(24454002)(377424004)(199002)(189002)(51704005)(74662001)(85306002)(47446002)(93136001)(66066001)(65816001)(50466002)(56816005)(74876001)(86362001)(89996001)(74502001)(90146001)(51856001)(74706001)(69226001)(80022001)(95416001)(88136002)(46102001)(93516002)(81342001)(81542001)(83322001)(33646001)(95666001)(62966002)(74366001)(80976001)(23676002)(31966008)(85852003)(92566001)(56776001)(87266001)(92726001)(50226001)(4396001)(94316002)(81816001)(93916002)(47736001)(83072002)(47976001)(53806001)(47776003)(63696002)(76786001)(77156001)(87286001)(54316002)(76796001)(81686001)(49866001)(77096001)(50986001)(87976001)(94946001)(79102001)(59766001)(42186004)(1411001)(77982001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB334;H:[172.29.194.63];CLIP:213.83.164.162;FPR:8AA4FB18.AC2E5F09.41FDB7A7.83D92112.202BA;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: spectralink.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 21:09 +0100, Richard Cochran wrote:

> > -#define EXT_EVENT	1
> 
> Regarding this EXT_EVENT thing ...
> 
> > @@ -430,12 +419,12 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
> >  	switch (rq->type) {
> >  	case PTP_CLK_REQ_EXTTS:
> >  		index = rq->extts.index;
> > -		if (index < 0 || index >= N_EXT_TS)
> > +		if (index < 0 || index >= n_ext_ts)
> >  			return -EINVAL;
> > -		event_num = EXT_EVENT + index;
> > +		event_num = index;
> 
> there was a mapping between the "event numbers" and the external time
> stamp channels. I don't remember off the top of my head why this these
> two differ by one, but there was a good reason.

I haven't seen anything in the documentation regarding this, output
triggers 0 and 1 are special, but the events should all behave the same.
Could be be a mixup between events and pins? Pin0 means disable the
event.

> Are you sure this is still working with this change?

It has been running with event 0 in one of our products for at least the
last 3 months....

> I am especially wondering about the event decoding here:
> 
> > @@ -642,7 +631,7 @@ static void recalibrate(struct dp83640_clock *clock)
> >  
> >  static inline u16 exts_chan_to_edata(int ch)
> >  {
> > -	return 1 << ((ch + EXT_EVENT) * 2);
> > +	return 1 << ((ch) * 2);
> >  }
> 
> Maybe I am just paranoid, but can you remind me how these event
> numbers are supposed to work, before and after the change?

The mapping was hardcoded to map events 0-5 to event channels 1-6, the
periodic output trigger at channel 6 and the calibration event+trigger
both at channel 7.

The patch will (at least in v3 that I will post shortly) change both the
event and trigger mapping to a direct mapping and keep the calibration
at channel 7.

Stefan


