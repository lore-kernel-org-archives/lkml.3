Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaAFSI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:08:56 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55715 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaAFSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:08:54 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1386579115-4324-2-git-send-email-b.brezillon@overkiz.com>
References: <1386579115-4324-1-git-send-email-b.brezillon@overkiz.com>
	<1386579115-4324-2-git-send-email-b.brezillon@overkiz.com>
Date: Mon, 6 Jan 2014 10:08:52 -0800
Message-ID: <CAOesGMhtg0vqVaRekfCE3-RZL644xEWBn4oVN22DtZR6L5WTxw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] usb: ohci-at91: replace request_mem_region +
 ioremap by devm_ioremap_resource
From: Olof Johansson <olof@lixom.net>
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

On Mon, Dec 9, 2013 at 12:51 AM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:
> Replace the request_mem_region + ioremap calls by the
> devm_ioremap_resource call which does the same things but with device
> managed resources.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Did you build these patches? There's several breakages due to them in
last night's next. I'm a little puzzled how they passed testing before
you submitted?

This one fails with:

drivers/usb/host/ohci-at91.c: In function 'usb_hcd_at91_probe':
drivers/usb/host/ohci-at91.c:157:36: error: 'dev' undeclared (first
use in this function)
  hcd->regs = devm_ioremap_resource(dev, res);
                                    ^
drivers/usb/host/ohci-at91.c:157:36: note: each undeclared identifier
is reported only once for each function it appears in
drivers/usb/host/ohci-at91.c:157:41: error: 'res' undeclared (first
use in this function)
  hcd->regs = devm_ioremap_resource(dev, res);

There are more too, the original one I was bisecting for was the below
one, but the above hit first:

drivers/usb/host/ohci-at91.c: In function 'usb_hcd_at91_probe':
drivers/usb/host/ohci-at91.c:190:4: error: label 'err' used but not defined
drivers/usb/host/ohci-at91.c: At top level:
drivers/usb/host/ohci-at91.c:206:2: warning: data definition has no
type or storage class [enabled by default]
drivers/usb/host/ohci-at91.c:206:2: error: type defaults to 'int' in
declaration of 'at91_stop_hc' [-Werror=implicit-int]
drivers/usb/host/ohci-at91.c:206:2: warning: parameter names (without
types) in function declaration [enabled by default]
drivers/usb/host/ohci-at91.c:206:2: error: conflicting types for 'at91_stop_hc'
drivers/usb/host/ohci-at91.c:97:13: note: previous definition of
'at91_stop_hc' was here
drivers/usb/host/ohci-at91.c:208:5: error: expected '=', ',', ';',
'asm' or '__attribute__' before ':' token
drivers/usb/host/ohci-at91.c:210:2: error: expected identifier or '('
before 'return'
drivers/usb/host/ohci-at91.c:211:1: error: expected identifier or '('
before '}' token
drivers/usb/host/ohci-at91.c:97:13: warning: 'at91_stop_hc' defined
but not used [-Wunused-function]
 static void at91_stop_hc(struct platform_device *pdev)


Somewhat spectacular.  Greg, can you please drop these until he's
sorted out his submission? :(


-Olof
