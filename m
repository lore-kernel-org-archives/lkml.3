Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162297Ab3DERkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:40:40 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62171 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162220Ab3DERkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:40:33 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
Date: Fri, 05 Apr 2013 10:40:29 -0700
In-Reply-To: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com> (Sourav
	Poddar's message of "Fri, 5 Apr 2013 18:45:33 +0530")
Message-ID: <87mwtclvua.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> With dt boot, uart wakeup after suspend is non functional while using
> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
> should prevent the runtime suspend of the uart port which is getting used
> as an console.
>
> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
> Cc: Felipe Balbi<balbi@ti.com>
> Cc: Rajendra nayak<rnayak@ti.com>
> Tested on omap5430evm, omap4430sdp.
>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

Rather than make these special checks inside the driver's runtime PM
callbacks, you should just disable runtime PM (pm_runtime_disable())

Then, this should be broken into 2 patches.

1) serial core: add the '->is_console' flag.  (nit on naming: don't call
   it port_is_console, since the struct is already a uart_port)

2) In the OMAP UART driver's ->prepare callback, check the is_console flag
   and pm_runtime_disable() accordingly  (then pm_runtime_enable() in
   the drivers's ->complete callback.

Kevin
