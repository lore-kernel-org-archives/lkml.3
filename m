Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaE3Qho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:37:44 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:52617
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbaE3Qhn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:37:43 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/6] staging: comedi: addi_apci_1564: remove send_sig()
 use
Thread-Topic: [PATCH 1/6] staging: comedi: addi_apci_1564: remove send_sig()
 use
Thread-Index: AQHPe8GHCwIkVDLH30WQavPmVUyFaZtZT/sw
Date: Fri, 30 May 2014 16:37:41 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E83D2B@P3PWEX4MB008.ex4.secureserver.net>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
 <1401424913-21859-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1401424913-21859-1-git-send-email-chase.southwood@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2014 9:42 PM, Chase Southwood wrote:
> The addi-data drivers use send_sig() to let the user know when an
> interrupt has occurred. The "standard" way to do this in the comedi
> subsystem is to have a subdevice that supports asynchronous commands
> and use comedi_event() to signal the user.
>
> Remove the send_sig() usage in this driver.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 23 ----------------------
>  1 file changed, 23 deletions(-)

Chase,

Normally this patch might be a problem.

With this patch you remove the mechanism that the driver uses to signal the
user that an event has occurred without providing a new mechanism. In theory
this "breaks" the driver.

In reality, the driver is already "broke" since the interrupts are currently enabled
using the digital input subdevice (*insn_config) callback and that callback does not
follow the comedi API. Currently the apci1564_di_config() function is using the
data[0] value as a flag to enable/disable the interrupt instead of using it as the
comedi configuration instruction. It is expecting data[0] to be 1 or 0, when it is 1
it expects the data to include 3 additional parameters but the core will sanity check
the instruction length and return -EINVAL if insn->n != 1. You fix this in patch 5/6.

Because the driver is already "broke" I guess this patch is ok.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

