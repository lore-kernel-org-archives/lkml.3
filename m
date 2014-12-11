Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbaLKR3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:29:11 -0500
Received: from mail-bn1bon0070.outbound.protection.outlook.com ([157.56.111.70]:36384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932480AbaLKR3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:29:09 -0500
Date: Thu, 11 Dec 2014 09:28:59 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Harini Katakam <harinikatakamlinux@gmail.com>
CC: Harini Katakam <harini.katakam@xilinx.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vishnu Motghare <vishnum@xilinx.com>
Subject: Re: [PATCH v4 2/2] i2c: cadence: Check for errata condition
 involving master receive
References: <1418211884-5329-1-git-send-email-harinik@xilinx.com>
 <1418211884-5329-3-git-send-email-harinik@xilinx.com>
 <6b2bd13bcd934b0fb09712e8950348e6@BN1AFFO11FD005.protection.gbl>
 <CAFcVECJDfJaEALDxfZg5-+tsD02mVT43s7PX4RLs349Kx9Jaeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFcVECJDfJaEALDxfZg5-+tsD02mVT43s7PX4RLs349Kx9Jaeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21170.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <61a2ff3fb6764fa388436dbbe20a8d70@BY2FFO11FD001.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(24454002)(377424004)(51704005)(199003)(377454003)(76176999)(86362001)(92726002)(551934003)(104016003)(77156002)(54356999)(62966003)(92566001)(99396003)(120916001)(50986999)(110136001)(107046002)(87936001)(106466001)(85202003)(53416004)(46102003)(20776003)(64706001)(23676002)(6806004)(31966008)(1411001)(4396001)(19580405001)(93886004)(85182001)(108616004)(83506001)(74316001)(19580395003)(21056001)(47776003)(50466002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB040;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB040;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB040;
X-Forefront-PRVS: 0422860ED4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB040;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 12:46PM +0530, Harini Katakam wrote:
> Hi Soren,
> 
> On Wed, Dec 10, 2014 at 11:15 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > On Wed, 2014-12-10 at 05:14PM +0530, Harini Katakam wrote:
> >> Cadence I2C controller has the following bugs:
> >> - completion indication is not given to the driver at the end of
> >> a read/receive transfer with HOLD bit set.
> >> - Invalid read transaction are generated on the bus when HW timeout
> >> condition occurs with HOLD bit set.
> >>
> >> As a result of the above, if a set of messages to be transferred with
> >> repeated start includes any transfer following a read transfer,
> >> completion is never indicated and timeout occurs.
> >> Hence a check is implemented to return -EOPNOTSUPP for such sequences.
> >>
> >> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> >> Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
> >> ---
> >>
> >> v4:
> >> Use single dev_warn and make message grep-able.
> >>
> >> v3:
> >> Add warning in case of unsupported transfer.
> >>
> >> v2:
> >> Dont defeteature repeated start. Just check for unsupported conditions in the
> >> driver and return error.
> >>
> >> ---
> >>  drivers/i2c/busses/i2c-cadence.c |   14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
> >> index 5f5d4fa..f9269a6 100644
> >> --- a/drivers/i2c/busses/i2c-cadence.c
> >> +++ b/drivers/i2c/busses/i2c-cadence.c
> >> @@ -541,6 +541,20 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
> >>        * processed with a repeated start.
> >>        */
> >>       if (num > 1) {
> >> +             /*
> >> +              * This controller does not give completion interrupt after a
> >> +              * master receive transfer if HOLD bit is set (repeated start),
> >> +              * resulting in SW timeout. Hence, if a receive transfer is
> >> +              * followed by any other transfer, an error is returned
> >> +              * indicating that this sequence is not supported.
> >> +              */
> >> +             for (count = 0; count < num-1; count++) {
> >> +                     if (msgs[count].flags & I2C_M_RD)
> >> +                             dev_warn(adap->dev.parent, "No support for "
> >> +                                      "repeated start when receive is "
> >> +                                      "followed by a transfer\n");
> >
> > Still not grepable. There must be no line breaks in the string!
> 
> This message will be printed in one single line.
> Do you want this string to be grepable in the driver? Why is that necessary?

It's about grepping the sources.
I pointed you to the paragraph in the Codingstyle rules, please read
it.

	Sören
