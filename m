Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJ0K6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:58:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaJ0K63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:58:29 -0400
Message-ID: <1414407519.26910.5.camel@linux-0dmf.site>
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R
 devices
From: Oliver Neukum <oneukum@suse.de>
To: russ.dill@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, greg@kroah.com
Date: Mon, 27 Oct 2014 11:58:39 +0100
In-Reply-To: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
References: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 01:52 -0700, russ.dill@gmail.com wrote:
> From: Russ Dill <Russ.Dill@gmail.com>
> 
> This patch provides the FTDI genuine product verification steps
> as contained within the new 2.12.00 official release. It ensures
> that counterfeiters don't exploit engineering investment made
> by FTDI. Counterfeit ICs are destroying innovation in the
> industry.
> 
> FTDI recommends that to guarantee genuine FTDI products
> please purchase either from FTDI directly or an authorised
> distributor.
> 
> This is definitely not targeting end users - if you're unsure if
> ICs are genuine then please don't use the drivers.

So you don't want this merged?
If you want to have it merged please explain the benefit.

> +static void ftdi_verify(struct usb_serial_port *port)
> +{
> +	struct ftdi_private *priv = usb_get_serial_port_data(port);
> +	u16 *eeprom_data;
> +	u16 checksum;
> +	int eeprom_size;
> +	int i;
> +
> +	switch (priv->chip_type) {
> +	case FT232RL:
> +		eeprom_size = 0x40;
> +		break;
> +	default:
> +		/* Unsupported for verification */
> +		return;
> +	}
> +
> +	/* Latency timer needs to be 0x77 to unlock EEPROM programming */
> +	if (priv->latency != 0x77) {
> +		int orig_latency = priv->latency;
> +		priv->latency = 0x77;
> +		write_latency_timer(port);
> +		priv->latency = orig_latency;
> +	}
> +
> +	eeprom_data = kzalloc(eeprom_size * 2, GFP_KERNEL);
> +	if (!eeprom_data)
> +		return;
> +
> +	/* Read in EEPROM */
> +	for (i = 0; i < eeprom_size; i++)
> +		if (read_eeprom(port, i, eeprom_data + i) < 0)
> +			goto end_verify;
> +
> +	/* Verify EEPROM is valid */
> +	checksum = ftdi_checksum(eeprom_data, eeprom_size);
> +	if (checksum != eeprom_data[eeprom_size - 1])
> +		goto end_verify;
> +
> +	/* Attempt to set Vendor ID to 0 */
> +	eeprom_data[1] = 0;
> +
> +	/* Calculate new checksum to avoid bricking devices */
> +	checksum = ftdi_checksum(eeprom_data, eeprom_size);
> +
> +	/* Verify EEPROM programming behavior/nonbehavior */
> +	write_eeprom(port, 1, 0);

In case of disconnect here, what have we just done to the device?

> +	write_eeprom(port, eeprom_size - 1, checksum);
> +
> +end_verify:
> +	kfree(eeprom_data);
> +}
> +

	Oliver


