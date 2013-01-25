Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3AYK6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:58:43 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:45154 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab3AYK6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:58:39 -0500
Message-ID: <51026551.7010001@mev.co.uk>
Date: Fri, 25 Jan 2013 10:58:25 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <PeterHuewe@gmx.de>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Move comedi_pci_auto_unconfig to drivers.c
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de> <1358895810-27115-1-git-send-email-peterhuewe@gmx.de> <510106BB.2080709@mev.co.uk> <201301242230.49732.PeterHuewe@gmx.de>
In-Reply-To: <201301242230.49732.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/01/24 09:30 PM, Peter Huewe wrote:
> Am Donnerstag, 24. Januar 2013, 11:02:35 schrieb Ian Abbott:
>> On 2013-01-22 23:03, Peter Huewe wrote:
>>> Since comedi_pci_auto_unconfig cannot be inlined anymore after
>>>
>>>   staging/comedi: Use comedi_pci_auto_unconfig directly for
>>>   pci_driver.remove
>>>
>>> is applied, it makes sense to move it drivers.c
>>>
>>> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
>>> ---
>>>
> 
>> Embarassingly (for me) I submitted a patch to do the exact opposite
>> previously, but I've no problem doing it this way if it saves some code.
> 
> Hi Ian,
> ;)

Hi.

> If you think it's cleaner the way it is currently we can leave it like that. 
> Especially if you think some driver might actually do something in the remove 
> function (in the future).

Well I was only using the inlined version to eliminate a function call
overhead, but your method eliminates a function call overhead in a
different way (for the majority of drivers whose remove function
consists solely of a call to comedi_pci_auto_unconfig()) and has the
benefit of removing lots of virtually identical function definitions.

If drivers want to do something else in the remove function, they still
have the option of doing that.

> However if we could also find a way to remove all the probe function stuff as 
> well we should remove it.
> Most (comedi pci) drivers simply call comedi_pci_auto_config and not much more 
> - but I'm currently not sure how to do this ;)

I can think of a couple of ways, but I don't like either of them.  The
difficulty is passing through the comedi driver's context (the struct
comedi_driver) to the comedi core during the probe.

One way would be to use a variant of the module_comedi_pci_driver()
macro that also creates a probe function that just calls
comedi_pci_auto_config(), and define another macro to retrieve the name
of that function (for initializing the .probe entry).  This only reduces
the number of source lines a little bit, not the amount of amount of
code generated, and is a little obfuscating.

Another way would be to point the driver_data of each struct
pci_device_id to the struct comedi_driver, and have a common probe
function that gets uses that information.  That might eliminate one
small probe function from lots of modules, but makes the PCI device
table in those modules a lot uglier.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
