Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaLEIPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:15:44 -0500
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:42976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbaLEIPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:15:42 -0500
Date: Fri, 5 Dec 2014 09:15:29 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: rajeev kumar <rajeevkumar.linux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
CC: <wsa@the-dreams.de>, <mark.rutland@arm.com>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <vishnum@xilinx.com>, <harinikatakamlinux@gmail.com>
Subject: Re: [PATCH v2 1/3] i2c: cadence: Handle > 252 byte transfers
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
	<1417610126-7957-2-git-send-email-harinik@xilinx.com>
 <CAA7nrtg_G+U2EVxy0joZC+fBGyXS_uOwe1RZ8PyoDv7icu6OBw@mail.gmail.com>
In-Reply-To: <CAA7nrtg_G+U2EVxy0joZC+fBGyXS_uOwe1RZ8PyoDv7icu6OBw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21150.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <66a490c827bc47d98a0118a58d7060e7@BN1BFFO11FD054.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174003)(377454003)(199003)(189002)(51704005)(24454002)(164054003)(50986999)(86362001)(19580395003)(92566001)(87936001)(108616004)(62966003)(20776003)(120916001)(83506001)(31966008)(106466001)(50466002)(6806004)(64706001)(54356999)(46102003)(217423001)(107046002)(21056001)(74316001)(76176999)(104016003)(4396001)(99396003)(33646002)(47776003)(77156002)(23676002)(65806001)(65956001)(19580405001)(77096005)(92726002)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB017;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB017;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(1)(2);SRVR:BN1BFFO11HUB017;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB017;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 06:41 AM, rajeev kumar wrote:
> On Wed, Dec 3, 2014 at 6:05 PM, Harini Katakam <harinik@xilinx.com> wrote:
>> The I2C controller sends a NACK to the slave when transfer size register
>> reaches zero, irrespective of the hold bit. So, in order to handle transfers
>> greater than 252 bytes, the transfer size register has to be maintained at a
>> value >= 1. This patch implements the same.
> 
> Why 252 Bytes ?  Is it word allign or what ?
> 
>> The interrupt status is cleared at the beginning of the isr instead of
>> the end, to avoid missing any interrupts - this is in sync with the new
>> transfer handling.
>>
> 
> No need to write this, actually this is the correct way of handling interrupt.
> 
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> ---
>>
>> v2:
>> No changes
>>
>> ---
>>  drivers/i2c/busses/i2c-cadence.c |  156 ++++++++++++++++++++------------------
>>  1 file changed, 81 insertions(+), 75 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
>> index 63f3f03..e54899e 100644
>> --- a/drivers/i2c/busses/i2c-cadence.c
>> +++ b/drivers/i2c/busses/i2c-cadence.c
>> @@ -126,6 +126,7 @@
>>   * @suspended:         Flag holding the device's PM status
>>   * @send_count:                Number of bytes still expected to send
>>   * @recv_count:                Number of bytes still expected to receive
>> + * @curr_recv_count:   Number of bytes to be received in current transfer
> 
> Please do the alignment properly

Alignments are correct when you apply this patch.
Please let us know if you see any problem.

Thanks,
Michal

