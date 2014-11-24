Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaKXUDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:03:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaKXUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:03:23 -0500
Date: Mon, 24 Nov 2014 21:02:35 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [2/5] i2c: davinci: query STP always when NACK is received
Message-ID: <20141124200235.GV4431@pengutronix.de>
References: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com>
 <20141120221953.GI27002@pengutronix.de>
 <546F34B9.1000206@ti.com>
 <20141121131008.GQ27002@pengutronix.de>
 <546F5B51.1030006@ti.com>
 <20141123203314.GF4431@pengutronix.de>
 <547333EB.5050403@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547333EB.5050403@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grygorii,

On Mon, Nov 24, 2014 at 03:34:35PM +0200, Grygorii Strashko wrote:
> On 11/23/2014 10:33 PM, Uwe Kleine-König wrote:
> > A call to .master_xfer with a message sequence implicitly expects ACKs
> > from the slave and doesn't tell anything about what should be done on a
> > NAK. So IMHO you must not send a P when the slave responds with a NAK,
> > but error out and let the sender decide if it wants to reply with P or
> > Sr.
> 
> Sry, but what should be done is defined by I2C/SMbus specs? Does it?
> For SMBus devices, the specification states (http://smbus.org/specs/)
> "4.2.Acknowledge (ACK) and not acknowledge (NACK)":
> - "The slave device detects an invalid command or invalid data. In this 
>   case the slave device must not acknowledge the received byte. The master
>   upon detection of this condition must generate a STOP condition and
>   retry the transaction"
> For I2C devices, the specification states [http://www.nxp.com/documents/user_manual/UM10204.pdf]:
> "3.1.6 Acknowledge (ACK) and Not Acknowledge (NACK)"
> "When SDA remains HIGH during this ninth clock pulse, this is defined as the Not
> Acknowledge signal. The master can then generate either a STOP condition to
> abort the transfer, or a repeated START condition to start a new transfer."
Yes, that's exactly what I meant. The master has the choice, and the
driver should not eliminate options here.
 
> Let take a look on i2c/smbus xfer:
> i2c_lock_adapter(adap)
>  adap->algo->master_xfer/smbus_xfer()
> i2c_unlock_adapter(adap);
>  |- rt_mutex_unlock(&adapter->bus_lock);
>     |- task switch
>  
> So, there is no guarantee that next xfer will address the same I2C client device,
> which, in turn, may lead to BB detection (will lead to BB detection if previous
> transfer has been not acknowledged by SMbus client device).
That's a valid concern.
 
> Small summary, I2C core + Davinci I2C driver provide ability to use repeated
> start (Sr) only within one I2C transaction - which is a number of write/read
> operations specified by i2c_msg array. NACK always interrupts transaction
> with -EREMOTEIO.
> 
> Also, the I2C core doesn't provide ability to manually send P.
Hmm, Wolfram, what do you think?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
