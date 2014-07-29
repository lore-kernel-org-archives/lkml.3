Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaG2DFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:05:10 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:18101
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbaG2DFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:05:07 -0400
Date: Tue, 29 Jul 2014 10:55:19 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>, Fabio Estevam <festevam@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        <patches@opensource.wolfsonmicro.com>, <b02247@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Nicolin Chen" <b42378@freescale.com>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: wm8962: Let CODEC driver enable
 and disable its own MCLK
Message-ID: <20140729025518.GB3350@MrMyself>
References: <1406547718-21498-1-git-send-email-nicoleotsuka@gmail.com>
 <20140728122211.GS17528@sirena.org.uk>
 <CAOMZO5DgE9RjC9MG7FbGPKwsgxunntw70W6Sj8WQKFYG+j8BsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DgE9RjC9MG7FbGPKwsgxunntw70W6Sj8WQKFYG+j8BsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(377454003)(199002)(189002)(51704005)(76482001)(104016003)(46102001)(85306003)(74502001)(81342001)(31966008)(81542001)(74662001)(64706001)(80022001)(47776003)(33716001)(97736001)(50466002)(95666004)(105606002)(83506001)(84676001)(20776003)(79102001)(6806004)(99396002)(4396001)(83072002)(92566001)(85852003)(107046002)(44976005)(21056001)(19580395003)(83322001)(106466001)(102836001)(50986999)(19580405001)(33656002)(26826002)(76176999)(77982001)(54356999)(87936001)(23726002)(97756001)(92726001)(46406003)(86362001)(68736004);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB322;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:19:43PM -0300, Fabio Estevam wrote:
> Hi Nicolin,
> 
> On Mon, Jul 28, 2014 at 9:22 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Jul 28, 2014 at 07:41:58PM +0800, Nicolin Chen wrote:
> >
> >> +     pdata->mclk = devm_clk_get(&i2c->dev, NULL);
> >> +
> >
> > This is broken for deferred probe.

Hi Mark,

Sorry. I don't get why deferred probe would be broken by this.
And I just took a test by adding this:

[...]
@@ -3545,10 +3545,11 @@ static int wm8962_set_pdata_from_of(struct i2c_client *i2c,
	}

+bool letstry = true;
static int wm8962_i2c_probe(struct i2c_client *i2c,
			const struct i2c_device_id *id)
@@ -3573,10 +3574,15 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
		ret = wm8962_set_pdata_from_of(i2c, &wm8962->pdata);
		if (ret != 0)
			return ret;
	}
+       if (letstry) {
+               letstry = false;
+               return -EPROBE_DEFER;
+       }
	/* Mark the mclk pointer to NULL if no mclk assigned */
	if (IS_ERR(wm8962->pdata.mclk))
		wm8962->pdata.mclk = NULL;
[...]

And it still works for me with a deferred probe:

[] i2c 0-001a: Driver wm8962 requests probe deferral
[]...
[]wm8962 0-001a: customer id 0 revision D
[]input: WM8962 Beep Generator as /devices/soc0/soc/2100000......
[]fsl-asoc-card sound: wm8962 <-> 202c000.ssi mapping ok

> 
> You can take a look at sgtl5000 to see how we handle deferred probe in
> devm_clk_get().

Hi Fabio,

Thank you for the hint.

But actually, unlike sgtl5000, this patch doesn't error out for
IS_ERR(mclk) case.

There might be a machine driver that has already got and enabled
the clock while getting the clock from other way or other DT node
rather than WM8962's.

Thank you.
Nicolin
