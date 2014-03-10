Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaCJWAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:00:07 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:9490
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbaCJWAE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:00:04 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z54eehz98dIc89bh936eI1432Id799h4015Idbb0izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1d7338h1de098h177df4h17326ah8275bh8275dh1de097h186068hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Mon, 10 Mar 2014 14:59:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Looijmans <mike.looijmans@topic.nl>,
        Michal Simek <michal.simek@xilinx.com>
CC: <git@xilinx.com>, <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
References: <1394449954-10797-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1394449954-10797-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <7e690272-651a-4170-8559-cc8dc8014251@AM1EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

The cadence driver is not in mainline yet. I think for our vendor tree
we can pretty much take it this way.
Regarding getting this into mainline, I'll send another iteration of the
change set and include these changes.

On Mon, 2014-03-10 at 12:12PM +0100, Mike Looijmans wrote:
> Pressing CTRL-C while communicating with an I2C device leads to erratic
> behaviour. The cause is that the controller will interrupt the I2C transfer
> in progress, and leave the client device in an undefined state. Many
> drivers do not handle error return codes on I2C transfers. The calling driver
> has no way of telling how much of the transfer has actually completed, so
> it cannot reliably determine the device's state.
> 
> The best solution here is to not handle signals in the I2C bus driver at all,
> but always complete a transaction before returning control.
> 
> See for a related patch and discussion on this topic:
> http://lkml.org/lkml/2014/1/9/246

Can we get your Signed-off-by, please?

> ---
>  drivers/i2c/busses/i2c-cadence.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
> index 86713d6..32ce2ee 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -452,16 +452,12 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
>  			cdns_i2c_msend(id);
>  
>  		/* Wait for the signal of completion */
> -		ret = wait_for_completion_interruptible_timeout(
> -							&id->xfer_done, HZ);
> -		if (ret < 1) {
> +		ret = wait_for_completion_timeout(&id->xfer_done, HZ);
> +		if (ret == 0) {

To match the style used throughout the file this should just be
	if (!ret) {


Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Thanks,
	Sören


