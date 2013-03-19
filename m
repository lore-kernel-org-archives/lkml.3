Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3CSSDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:03:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50627 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3CSSDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:03:40 -0400
Message-ID: <5148A879.6000309@wwwdotorg.org>
Date: Tue, 19 Mar 2013 12:03:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI controllers
References: <20130318210510.203500214@linuxfoundation.org> <20130318210511.127988921@linuxfoundation.org>
In-Reply-To: <20130318210511.127988921@linuxfoundation.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 03:06 PM, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

This patch causes reboot/shutdown to fail on Tegra-based systems in 3.9-rc3.

I reported this at:

http://www.spinics.net/lists/linux-usb/msg82518.html

although there's been no discussion there yet, and I haven't had time to
investigate exactly what the problem is.

> ------------------
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit 6402c796d3b4205d3d7296157956c5100a05d7d6 upstream.
> 
> This patch (as1660) works around a hardware problem present in some
> (if not all) Intel EHCI controllers.  After a QH has been unlinked
> from the async schedule and the corresponding IAA interrupt has
> occurred, the controller is not supposed access the QH and its qTDs.
> There certainly shouldn't be any more DMA writes to those structures.
> Nevertheless, Intel's controllers have been observed to perform a
> final writeback to the QH's overlay region and to the most recent qTD.
> For more information and a test program to determine whether this
> problem is present in a particular controller, see
> 
> 	http://marc.info/?l=linux-usb&m=135492071812265&w=2
> 	http://marc.info/?l=linux-usb&m=136182570800963&w=2
> 
> This patch works around the problem by always waiting for two IAA
> cycles when unlinking an async QH.  The extra IAA delay gives the
> controller time to perform its final writeback.
> 
> Surprisingly enough, the effects of this silicon bug have gone
> undetected until quite recently.  More through luck than anything
> else, it hasn't caused any apparent problems.  However, it does
> interact badly with the path that follows this one, so it needs to be
> addressed.
> 
> This is the first part of a fix for the regression reported at:
> 
> 	https://bugs.launchpad.net/bugs/1088733

