Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaLERLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:11:15 -0500
Received: from mail-bn1bon0059.outbound.protection.outlook.com ([157.56.111.59]:4192
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750893AbaLERLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:11:14 -0500
Date: Fri, 5 Dec 2014 09:11:03 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Harini Katakam <harini.katakam@xilinx.com>
CC: <wsa@the-dreams.de>, <mark.rutland@arm.com>, <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinik@xilinx.com>,
        <harinikatakamlinux@gmail.com>, Vishnu Motghare <vishnum@xilinx.com>
Subject: Re: [PATCH v3 2/2] i2c: cadence: Check for errata condition
 involving master receive
References: <1417766884-8383-1-git-send-email-harinik@xilinx.com>
 <1417766884-8383-3-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417766884-8383-3-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21152.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <655928d0462248b6a8e4821b5245bc57@BN1BFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(189002)(51704005)(377424004)(164054003)(199003)(46102003)(33646002)(19580395003)(83506001)(110136001)(551934003)(6806004)(104016003)(4396001)(87936001)(77156002)(50466002)(86362001)(19580405001)(64706001)(23676002)(47776003)(53416004)(62966003)(120916001)(92566001)(54356999)(85202003)(107046002)(31966008)(85182001)(106466001)(20776003)(50986999)(21056001)(74316001)(76176999)(99396003)(108616004)(92726002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB039;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harini,

On Fri, 2014-12-05 at 01:38PM +0530, Harini Katakam wrote:
> Cadence I2C controller has the following bugs:
> - completion indication is not given to the driver at the end of
> a read/receive transfer with HOLD bit set.
> - Invalid read transaction are generated on the bus when HW timeout
> condition occurs with HOLD bit set.
> 
> As a result of the above, if a set of messages to be transferred with
> repeated start includes any transfer following a read transfer,
> completion is never indicated and timeout occurs.
> Hence a check is implemented to return -EOPNOTSUPP for such sequences.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
> ---
> 
> v3:
> Add warning in case of unsupported transfer.
> 
> v2:
> Dont defeteature repeated start. Just check for unsupported conditions in the
> driver and return error.
> 
> ---
>  drivers/i2c/busses/i2c-cadence.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
> index 5f5d4fa..3ea3b7a 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -541,6 +541,21 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
>  	 * processed with a repeated start.
>  	 */
>  	if (num > 1) {
> +		/*
> +		 * This controller does not give completion interrupt after a
> +		 * master receive transfer if HOLD bit is set (repeated start),
> +		 * resulting in SW timeout. Hence, if a receive transfer is
> +		 * followed by any other transfer, an error is returned
> +		 * indicating that this sequence is not supported.
> +		 */
> +		for (count = 0; count < num-1; count++) {
> +			if (msgs[count].flags & I2C_M_RD)
> +				dev_warn(adap->dev.parent,
> +					"No support for repeated start when\t");
> +				dev_warn(adap->dev.parent,
> +					"receive is followed by a transfer\n");

Please make this a single dev_warn without a line break in the string.
That way you can grep for the message in the sources.

	Thanks,
	Sören
