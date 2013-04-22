Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3DVLbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:31:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:40051 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3DVLbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:31:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,526,1363158000"; 
   d="scan'208";a="322878647"
Message-ID: <53398.163.33.213.79.1366630241.squirrel@linux.intel.com>
In-Reply-To: <20130422071943.GK1283@intel.com>
References: <alpine.DEB.2.02.1304191859570.17829@localhost>
    <20130422071943.GK1283@intel.com>
Date: Mon, 22 Apr 2013 04:30:41 -0700 (PDT)
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
From: "Josef Ahmad" <josef.ahmad@linux.intel.com>
To: "Mika Westerberg" <mika.westerberg@linux.intel.com>
Cc: "Josef Ahmad" <josef.ahmad@linux.intel.com>,
        "Wolfram Sang" <wsa@the-dreams.de>, "Ben Dooks" <ben-linux@fluff.org>,
        "Jean Delvare" <khali@linux-fr.org>, "Stefan Roese" <sr@denx.de>,
        "Axel Lin" <axel.lin@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Dirk Brandewie" <dirk.brandewie@gmail.com>
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 19, 2013 at 07:05:30PM +0100, Josef Ahmad wrote:
>> >From a969728248c3b439dc97a69e7dac133b5efa34e7 Mon Sep 17 00:00:00 2001
>> From: Josef Ahmad <josef.ahmad@linux.intel.com>
>> Date: Fri, 19 Apr 2013 17:28:10 +0100
>> Subject: [PATCH] i2c-designware: fix RX FIFO overrun
>>
>> i2c_dw_xfer_msg() pushes a number of bytes to transmit/receive
>> to/from the bus into the TX FIFO.
>> For master-rx transactions, the maximum amount of data that can be
>> received is calculated depending solely on TX and RX FIFO load.
>>
>> This is racy - TX FIFO may contain master-rx data yet to be
>> processed, which will eventually land into the RX FIFO. This
>> data is not taken into account and the function may request more
>> data than the controller is actually capable of storing.
>>
>> This patch ensures the driver takes into account the outstanding
>> master-rx data in TX FIFO to prevent RX FIFO overrun.
>
> Can you add something to the changelog to show what the error looks like
> (a dump from dmesg for example)?
>

The issue is, the data is silently corrupted and not notified to the I2C core
driver.
The master-rx transaction returns success and the RX buffer overflow is not
reported by the driver, which will read dropped data.

FWIW, I have a simple test application receiving well-known data from a slave
in a single transaction, and comparing received to expected data.
Here's the outcome of three runs:

[19/03/13 20:30:14] i2c-error   : rcv'd message != ref msg (first diff
@byte 33)
[19/03/13 20:30:43] i2c-error   : rcv'd message != ref msg (first diff
@byte 108)
[19/03/13 20:31:24] i2c-error   : rcv'd message != ref msg (first diff
@byte 133)

>> Signed-off-by: Josef Ahmad <josef.ahmad@linux.intel.com>
>> ---
>>  drivers/i2c/busses/i2c-designware-core.c |   11 ++++++++++-
>>  drivers/i2c/busses/i2c-designware-core.h |    2 ++
>>  2 files changed, 12 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-designware-core.c
>> b/drivers/i2c/busses/i2c-designware-core.c
>> index 94fd818..8dbeef1 100644
>> --- a/drivers/i2c/busses/i2c-designware-core.c
>> +++ b/drivers/i2c/busses/i2c-designware-core.c
>> @@ -426,8 +426,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
>>  				cmd |= BIT(9);
>>
>>  			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
>> +
>> +				/* avoid rx buffer overrun */
>> +				if (rx_limit - dev->rx_outstanding <= 0)
>> +					break;
>> +
>>  				dw_writel(dev, cmd | 0x100, DW_IC_DATA_CMD);
>>  				rx_limit--;
>> +				dev->rx_outstanding++;
>
> Instead of adding a new variable, is there something preventing a use of
> DW_IC_STATUS bits RFNE and TFNF?
>

DW_IC_STATUS bits won't give information of the type of elements (read or
write) that are in the fifos.
What we need here is more specific information, i.e. how many RX elements are
currently in TX fifo. The register set doesn't provide this information to my
knowledge, so I had to work it out externally with a status variable.

Consider this example with 8-byte fifos (E=empty, R=read, W=write elements):

State of the fifos:
        +-----------------+
TX  ->  | E E E E E W W R |
        +-----------------+
        +-----------------+
RX      | E E R R R R R R | <-
        +-----------------+

Now, say the transaction requires to pump 2 additional R elements into TX
fifo. We need to ensure that at this stage only 1 of the 2 R elements is
actually put into TX fifo: this way we we won't saturate the RX fifo.
Failing to do so exposes a race condition: if we don't read RX quickly
enough,
the R element + the new 2 R elements in the TX fifo will land into the RX,
resulting in an element being dropped.

>>  			} else
>>  				dw_writel(dev, cmd | *buf++, DW_IC_DATA_CMD);
>>  			tx_limit--; buf_len--;
>> @@ -480,8 +486,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
>>
>>  		rx_valid = dw_readl(dev, DW_IC_RXFLR);
>>
>> -		for (; len > 0 && rx_valid > 0; len--, rx_valid--)
>> +		for (; len > 0 && rx_valid > 0; len--, rx_valid--) {
>>  			*buf++ = dw_readl(dev, DW_IC_DATA_CMD);
>> +			dev->rx_outstanding--;
>> +		}
>>
>>  		if (len > 0) {
>>  			dev->status |= STATUS_READ_IN_PROGRESS;
>> @@ -539,6 +547,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg
>> msgs[], int num)
>>  	dev->msg_err = 0;
>>  	dev->status = STATUS_IDLE;
>>  	dev->abort_source = 0;
>> +	dev->rx_outstanding = 0;
>>
>>  	ret = i2c_dw_wait_bus_not_busy(dev);
>>  	if (ret < 0)
>

