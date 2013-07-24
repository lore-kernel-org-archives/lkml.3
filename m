Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3GXKcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:32:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49740 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3GXKcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:32:46 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-73-51efad4c4a7e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: gregkh@linuxfoundation.org, Piotr Sarna <p.sarna@partner.samsung.com>,
        konrad.wilk@oracle.com, bob.liu@oracle.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Date: Wed, 24 Jul 2013 12:32:32 +0200
Message-id: <7560549.NYTHa4SYx0@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <20130724100441.GA3976@dhcp22.suse.cz>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
 <20130724100235.GC2540@dhcp22.suse.cz> <20130724100441.GA3976@dhcp22.suse.cz>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jAV2fte8DDa72qFl0nZrKYrHnzC92
	i+bF69ksli1+ymhxtukNu8XlXXPYLF41f2e1WLUoyoHD496+wywe++euYff4+PQWi8fBd3uY
	PPq2rGL0OLPgCLvH501yAexRXDYpqTmZZalF+nYJXBkt/w4yFewVq/hzZAdzA+NdwS5GTg4J
	AROJe1d7mSBsMYkL99azdTFycQgJLGKUOHa8jxUkISTQwiRx7jYfiM0mYCUxsX0VI4gtIqAo
	cf/aK0aQBmaBe4wSp48/YQNJCAvYSzw/+ZEZxGYRUJVYsOoumM0roCnx6N1TsKGiAq4S5xb9
	YAGxOQWMJe4vn8EKsXk2o8TFrvdQDYISPybfAytiFpCX2Ld/KiuErSWxfudxpgmMArOQlM1C
	UjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR8ExqB+PKBotDjAIcjEo8vAWz
	3gUKsSaWFVfmHmKU4GBWEuG1mv8+UIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS
	1OzU1ILUIpgsEwenVANjGseew20Z9wTPbs15toxnXargYffombXafLnsTBfyBesynq93ZN5j
	4VT64Z5nI7tLbesxy1UGy0+/32WjtS2T50fN0v833h/9PfOW+UyjmzOiZoRWnPnabvAkNvHR
	O6nFzj6V5VZsup5G35WOL2xvO7LP6/WH6OkH9NgvbOI6Mu39c072mWV2SizFGYmGWsxFxYkA
	p626Z34CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, July 24, 2013 12:04:41 PM Michal Hocko wrote:
> On Wed 24-07-13 12:02:35, Michal Hocko wrote:
> > I have posted a similar fix quite some time ago and I guess Greg should
> > already have it.
> 
> For reference https://lkml.org/lkml/2013/6/26/410

There was a reply from Greg:

	https://lkml.org/lkml/2013/6/26/410
 
and it seems that Greg's request has not been fullfilled.

Anyway Piotr's patch seems to be more complete:
- it also fixes case in which invalid "zcache=" option is given (returns
  an error value 1 while with your patch the code still erronously retuns 0)
- it prints information about compressor type being used when "zcache="
  option is used (your patch skips it due to addition of "goto out_alloc")

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Greg?
> > 
> > On Fri 19-07-13 16:46:41, Piotr Sarna wrote:
> > > Commit 835f2f5 ("staging: zcache: enable zcache to be built/loaded as
> > > a module") introduced an incorrect handling of "zcache=" parameter.
> > > 
> > > Inside zcache_comp_init() function, zcache_comp_name variable is
> > > checked for being empty. If not empty, the above variable is tested
> > > for being compatible with Crypto API. Unfortunately, after that
> > > function ends unconditionally (by the "goto out" directive) and returns:
> > > - non-zero value if verification succeeded, wrongly indicating an error
> > > - zero value if verification failed, falsely informing that function
> > >   zcache_comp_init() ended properly.
> > > 
> > > A solution to this problem is as following:
> > > 1. Move the "goto out" directive inside the "if (!ret)" statement
> > > 2. In case that crypto_has_comp() returned 0, change the value of ret
> > >    to non-zero before "goto out" to indicate an error.
> > > 
> > > Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> > > Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/staging/zcache/zcache-main.c |    6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> > > index dcceed2..81972fa 100644
> > > --- a/drivers/staging/zcache/zcache-main.c
> > > +++ b/drivers/staging/zcache/zcache-main.c
> > > @@ -1811,10 +1811,12 @@ static int zcache_comp_init(void)
> > >  #else
> > >  	if (*zcache_comp_name != '\0') {
> > >  		ret = crypto_has_comp(zcache_comp_name, 0, 0);
> > > -		if (!ret)
> > > +		if (!ret) {
> > >  			pr_info("zcache: %s not supported\n",
> > >  					zcache_comp_name);
> > > -		goto out;
> > > +			ret = 1;
> > > +			goto out;
> > > +		}
> > >  	}
> > >  	if (!ret)
> > >  		strcpy(zcache_comp_name, "lzo");

