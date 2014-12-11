Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866AbaLKHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:16:57 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33760 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbaLKHQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:16:55 -0500
MIME-Version: 1.0
In-Reply-To: <6b2bd13bcd934b0fb09712e8950348e6@BN1AFFO11FD005.protection.gbl>
References: <1418211884-5329-1-git-send-email-harinik@xilinx.com>
	<1418211884-5329-3-git-send-email-harinik@xilinx.com>
	<6b2bd13bcd934b0fb09712e8950348e6@BN1AFFO11FD005.protection.gbl>
Date: Thu, 11 Dec 2014 12:46:53 +0530
Message-ID: <CAFcVECJDfJaEALDxfZg5-+tsD02mVT43s7PX4RLs349Kx9Jaeg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] i2c: cadence: Check for errata condition involving
 master receive
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vishnu Motghare <vishnum@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On Wed, Dec 10, 2014 at 11:15 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Wed, 2014-12-10 at 05:14PM +0530, Harini Katakam wrote:
>> Cadence I2C controller has the following bugs:
>> - completion indication is not given to the driver at the end of
>> a read/receive transfer with HOLD bit set.
>> - Invalid read transaction are generated on the bus when HW timeout
>> condition occurs with HOLD bit set.
>>
>> As a result of the above, if a set of messages to be transferred with
>> repeated start includes any transfer following a read transfer,
>> completion is never indicated and timeout occurs.
>> Hence a check is implemented to return -EOPNOTSUPP for such sequences.
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
>> ---
>>
>> v4:
>> Use single dev_warn and make message grep-able.
>>
>> v3:
>> Add warning in case of unsupported transfer.
>>
>> v2:
>> Dont defeteature repeated start. Just check for unsupported conditions in the
>> driver and return error.
>>
>> ---
>>  drivers/i2c/busses/i2c-cadence.c |   14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
>> index 5f5d4fa..f9269a6 100644
>> --- a/drivers/i2c/busses/i2c-cadence.c
>> +++ b/drivers/i2c/busses/i2c-cadence.c
>> @@ -541,6 +541,20 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
>>        * processed with a repeated start.
>>        */
>>       if (num > 1) {
>> +             /*
>> +              * This controller does not give completion interrupt after a
>> +              * master receive transfer if HOLD bit is set (repeated start),
>> +              * resulting in SW timeout. Hence, if a receive transfer is
>> +              * followed by any other transfer, an error is returned
>> +              * indicating that this sequence is not supported.
>> +              */
>> +             for (count = 0; count < num-1; count++) {
>> +                     if (msgs[count].flags & I2C_M_RD)
>> +                             dev_warn(adap->dev.parent, "No support for "
>> +                                      "repeated start when receive is "
>> +                                      "followed by a transfer\n");
>
> Still not grepable. There must be no line breaks in the string!

This message will be printed in one single line.
Do you want this string to be grepable in the driver? Why is that necessary?

Regards,
Harini
