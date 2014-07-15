Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbaGOKP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:15:27 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51082 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082AbaGOKPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:15:24 -0400
Message-ID: <53C4FF1B.3080409@mev.co.uk>
Date: Tue, 15 Jul 2014 11:14:51 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: comedi: addi_apci_1564: use addi_watchdog
 module to init watchdog subdevice
References: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>	<1405205049-1828-1-git-send-email-chase.southwood@gmail.com>	<53C3A16B.6030801@mev.co.uk> <CA+jnaaVm9_S1=aVCoq_corBvUHDDz2LC3zSLD_D2PsSbGy_avg@mail.gmail.com>
In-Reply-To: <CA+jnaaVm9_S1=aVCoq_corBvUHDDz2LC3zSLD_D2PsSbGy_avg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 05:00, Chase Southwood wrote:
> On Mon, Jul 14, 2014 at 4:22 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>> On 2014-07-12 23:44, Chase Southwood wrote:
>>>
>>> Use the addi_watchdog module to provide support for the watchdog
>>> subdevice.
>>>
>>> Also, rearrange the subdevice init blocks so that the order makes sense.
>>> Digital input/output subdevices and subdevices for DI/DO interrupt
>>> support, followed by timer/counter/watchdog subdevices is the new order.
>>>
>>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>>> Cc: Ian Abbott <abbotti@mev.co.uk>
>>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>>> ---
>>>    drivers/staging/comedi/drivers/addi_apci_1564.c | 34
>>> +++++++++++++++----------
>>>    1 file changed, 20 insertions(+), 14 deletions(-)
>>
>>
>> I don't think the subdevice order matters that much, and I prefer to keep
>> them stable, but since this driver is in such a state of flux, it doesn't
>> really matter.
>>
>
> Hi Ian!
> Quick question here about this.  First off, duly noted that grouping
> subdevices by function isn't necessary and I won't shuffle them around
> like this in the future.  Second, the reason I stuck the watchdog at
> the end is because it causes an early return if addi_watchdog_init()
> returns an error and it seemed  appropriate at the end so it doesn't
> prevent the initialization of any other subdevices if that call should
> fail.  Now I realize that it is very unlikely that that call fails,
> but in any case should I put future subdevice inits above the watchdog
> for the same reason (so they aren't at risk of not getting
> initialized), or does that count for subdevice order not being stable
> and you would prefer them all to go at the end?

Since you return an error from the auto_attach handler 
apci1564_auto_attach() when addi_watchdog_init() fails, it makes little 
difference what order the subdevices are initialized in.  The error from 
auto_attach handler causes the comedi core to call the detach handler 
apci1564_detach() and tear everything down.  Ultimately, 
comedi_pci_auto_attach() will return an error back to the PCI probe 
function apci1564_pci_probe(), which will propagate it to the PCI subsystem.

In general, if adding a new subdevice, either add it to the end or 
replace an "unused" subdevice.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
