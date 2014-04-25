Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaDYGWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:22:19 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59918 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDYGWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:22:17 -0400
Date: Fri, 25 Apr 2014 01:22:13 -0500
From: Michael Welling <mwelling@ieee.org>
To: gnomes@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz
Subject: Re: [PATCH 1/2] tty serial: xr17c15x driver
Message-ID: <20140425062213.GA2371@deathray>
Reply-To: 20140410114648.68bfbf61@alan.etchedpixels.co.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe I found a related unresolved kernel bug:
"Bug 61961 – My Exar Corp. XR17C/D152 Dual PCI UART modem does not
work with 3.8.0"

The issue appears to be the same and gave me a clue as to where to
look.

Comparing the code from 3.5 to 3.8, I noticed that the UART_CAP_SLEEP
flag was added to the XR17D15X Exar chip.

Then I noticed what appears to be a bug in the serial8250_set_sleep
function:
.
.
        if ((p->port.type == PORT_XR17V35X) ||
           (p->port.type == PORT_XR17D15X)) {
                serial_out(p, UART_EXAR_SLEEP, 0xff);
                return;
        }
.
.

The if statement disregards the sleep parameter and always puts all of
the ports to sleep.

Something like this would be more appropriate:
.
.
        if ((p->port.type == PORT_XR17V35X) ||
           (p->port.type == PORT_XR17D15X)) {
                serial_out(p, UART_EXAR_SLEEP, sleep ? 0xff : 0);
                return;
        }
.
.

Now I don't know that this is the problem yet and I would like someone
to confirm that I am not crazy.

I can try the patch at work tomorrow and see if it fixes the issue.
Then maybe we can close Bug 61961.
