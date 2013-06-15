Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3FOCcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:32:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3FOCcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:32:16 -0400
MIME-Version: 1.0
In-Reply-To: <op.wyoht9hm9ey1ta@localhost>
References: <op.wyn5vzc89ey1ta@localhost>
	<CAErSpo5nxKi+dNDRn95GtufddncnsC2VyP+NWa=QBMt0aH3AoA@mail.gmail.com>
	<20130614154325.GA30105@roeck-us.net>
	<op.wyoht9hm9ey1ta@localhost>
Date: Sat, 15 Jun 2013 10:32:14 +0800
Message-ID: <CACVXFVP5-d_1RUC+vBTLxnHZje3F1rYaJvDCgbV2-ngXfb_KNw@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
From: Ming Lei <ming.lei@canonical.com>
To: nirinA raseliarison <nirina.raseliarison@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
        Hayes Wang <hayeswang@realtek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 1:07 AM, nirinA raseliarison
<nirina.raseliarison@gmail.com> wrote:

> patch applied and no longer have the bug message when i
> reboot and wake up the ethernet controller.

I am wondering if Guenter's patch can fix the race really, but I'd like to
see Guenter's explanation on his patch.

The race should be caused by below:

- request timeout triggered by internal timer

- user space aborts the requests before the line in _request_firmware_load()

             fw_priv->buf = NULL

which is run in timeout path

- then the abort() called from firmware_loading_store() may use a freed fw buf
since the timeout path will free the fw buffer.

Considered clearing 'fw_priv->buf' in _request_firmware_load()() isn't protected
by fw_lock now, so Guenter's patch can't avoid the race entirely.

Thanks,
--
Ming Lei
