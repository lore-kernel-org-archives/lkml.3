Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3FOIIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 04:08:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3FOIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 04:08:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130615063055.GA13766@roeck-us.net>
References: <op.wyn5vzc89ey1ta@localhost>
	<CAErSpo5nxKi+dNDRn95GtufddncnsC2VyP+NWa=QBMt0aH3AoA@mail.gmail.com>
	<20130614154325.GA30105@roeck-us.net>
	<op.wyoht9hm9ey1ta@localhost>
	<CACVXFVP5-d_1RUC+vBTLxnHZje3F1rYaJvDCgbV2-ngXfb_KNw@mail.gmail.com>
	<20130615063055.GA13766@roeck-us.net>
Date: Sat, 15 Jun 2013 16:08:47 +0800
Message-ID: <CACVXFVPVA0N=99K7VXNcGpz6=vE+v-FcebS2iUBwo6V3zR=_og@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
From: Ming Lei <ming.lei@canonical.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: nirinA raseliarison <nirina.raseliarison@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
        Hayes Wang <hayeswang@realtek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 2:30 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Sat, Jun 15, 2013 at 10:32:14AM +0800, Ming Lei wrote:
>> On Sat, Jun 15, 2013 at 1:07 AM, nirinA raseliarison
>> <nirina.raseliarison@gmail.com> wrote:
>>
>> > patch applied and no longer have the bug message when i
>> > reboot and wake up the ethernet controller.
>>
>> I am wondering if Guenter's patch can fix the race really, but I'd like to
>> see Guenter's explanation on his patch.
>>
>> The race should be caused by below:
>>
>> - request timeout triggered by internal timer
>>
>> - user space aborts the requests before the line in _request_firmware_load()
>>
>>              fw_priv->buf = NULL
>>
>> which is run in timeout path
>>
>> - then the abort() called from firmware_loading_store() may use a freed fw buf
>> since the timeout path will free the fw buffer.
>>
>> Considered clearing 'fw_priv->buf' in _request_firmware_load()() isn't protected
>> by fw_lock now, so Guenter's patch can't avoid the race entirely.
>>
> I agree; my patch only protects one specific path, and was based on the
> observation that access to fw_priv->buf is protected elsewhwere in the code.
> My suspicion was that fw_priv->buf was freed while waiting for the mutex in
> firmware_loading_store().
>
> Your patch is more comprehensive.

OK, thanks for your reply.

I will post out one version for merge, and this one moves the
"fw_priv->buf = NULL;" into fw_load_abort() for simplifying change.


Thanks,
--
Ming Lei
