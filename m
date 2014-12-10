Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaLJRqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:46:07 -0500
Received: from mail-bn1on0063.outbound.protection.outlook.com ([157.56.110.63]:15776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932209AbaLJRqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:46:06 -0500
Date: Wed, 10 Dec 2014 09:45:54 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Harini Katakam <harini.katakam@xilinx.com>
CC: <wsa@the-dreams.de>, <mark.rutland@arm.com>, <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
        <harinik@xilinx.com>, Vishnu Motghare <vishnum@xilinx.com>
Subject: Re: [PATCH v4 2/2] i2c: cadence: Check for errata condition
 involving master receive
References: <1418211884-5329-1-git-send-email-harinik@xilinx.com>
 <1418211884-5329-3-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418211884-5329-3-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21166.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <6b2bd13bcd934b0fb09712e8950348e6@BN1AFFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(51704005)(189002)(377424004)(21056001)(92566001)(107046002)(64706001)(83506001)(85202003)(106466001)(4396001)(23676002)(86362001)(54356999)(33646002)(46102003)(53416004)(108616004)(76176999)(110136001)(20776003)(47776003)(50986999)(99396003)(31966008)(77156002)(104016003)(120916001)(551934003)(19580405001)(6806004)(62966003)(87936001)(85182001)(19580395003)(92726002)(74316001)(50466002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB030;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB030;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB030;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB030;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 05:14PM +0530, Harini Katakam wrote:
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
> v4:
> Use single dev_warn and make message grep-able.
> 
> v3:
> Add warning in case of unsupported transfer.
> 
> v2:
> Dont defeteature repeated start. Just check for unsupported conditions in the
> driver and return error.
> 
> ---
>  drivers/i2c/busses/i2c-cadence.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
> index 5f5d4fa..f9269a6 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -541,6 +541,20 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
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
> +				dev_warn(adap->dev.parent, "No support for "
> +					 "repeated start when receive is "
> +					 "followed by a transfer\n");

Still not grepable. There must be no line breaks in the string!

	Sören
