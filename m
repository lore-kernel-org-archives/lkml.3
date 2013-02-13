Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab3BML4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:56:18 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43318 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab3BML4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:56:16 -0500
Message-ID: <511B7F58.4000909@mev.co.uk>
Date: Wed, 13 Feb 2013 11:56:08 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Peter Huewe <peterhuewe@gmx.de>, Ian Abbott <ian.abbott@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Fix undefined array subscript
References: <1360726254-7895-1-git-send-email-peterhuewe@gmx.de> <20130213073214.GR4937@mwanda>
In-Reply-To: <20130213073214.GR4937@mwanda>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-13 07:32, Dan Carpenter wrote:
> On Wed, Feb 13, 2013 at 04:30:54AM +0100, Peter Huewe wrote:
>> In vmk80xx_do_insn_bits the local variable reg, which is used as an
>> index to the tx_buf array, can be used uninitialized if
>> - data[0] == 0
>> and
>> - devpriv->model != VMK8061_MODEL
>> -> we get into the else branch without having reg initialized.
>
> It's weird that GCC doesn't warn about this...
>
> This patch works, or at least it doesn't break anything that wasn't
> already broken, but it doesn't feel like the right thing.  Probably
> we could move the reg setting outside the if statement.
>
> 	if (devpriv->model == VMK8055_MODEL) {
> 		reg = VMK8055_DO_REG;
> 		cmd = VMK8055_CMD_WRT_AD;
> 	} else { /* VMK8061_MODEL */
> 		reg = VMK8061_DO_REG;
> 		cmd = VMK8061_CMD_DO;
> 	}
>
> 	if (data[0]) {
> 		tx_buf[reg] &= ~data[0];

Either method would be fine.

> Or maybe data[0] == 0 needs to be handled differently.
>
> Ian would know for sure.

The insn_bits instruction always reads back the channels after any 
modification of the channels specified by bitmask data[0] with the new 
channel values bitmask data[1].  data[0] == 0 implies you are not 
changing any of the channels so only read back the current values.

For a digital output subdevice, you could either read back the current 
values directly from the hardware or just use the value previously 
written.  The Velleman K8055 doesn't have a command to read back the 
digital outputs from the hardware, so the last written value has to be 
used.  But what if the digital outputs have never been written (or the 
analog outputs have never been written, since the same command updates 
all analog and digital channels)?  A "reset" command is sent to the 
hardware on initialization by vmk80xx_reset_device() (only called for 
the K8055), but I don't know what effect this has on the actual digital 
(and analog) outputs (though I could find out easily enough as we appear 
to have one of these kits (assembled) lying around in the office).  If 
necessary, we may have to also send a "write" command on initialization 
to make the hardware outputs match the initial software state.

For the Velleman K8061, reading the digital outputs from the hardware 
every time is a bit inefficient as it should only be necessary in the 
case where the digital outputs have never been written (similarly for 
the analog outputs).  We could read back the initial state of the 
digital and analog outputs during hardware initialization and keep the 
state up-to-date in software without having to query the hardware again.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
