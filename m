Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaLPNAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:00:44 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62410 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLPNAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:00:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141216113602.GA21888@e103737-lin.cambridge.arm.com>
References: <1418242572-20998-1-git-send-email-ashwin.chaugule@linaro.org>
	<548AAA95.6020001@arm.com>
	<CAJ5Y-eYFsK_heBRQUOmPXGtkLtze-NGzWKy1=0qJVV3x2EycUw@mail.gmail.com>
	<20141216113602.GA21888@e103737-lin.cambridge.arm.com>
Date: Tue, 16 Dec 2014 08:00:42 -0500
Message-ID: <CAJ5Y-easPFRgmH+_fGoTdJiOTa-tivMLEU0zU1ETSxOG1ptfsA@mail.gmail.com>
Subject: Re: [Linaro-acpi] [PATCH] Mailbox: Complete wait event only if Tx was successful
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2014 at 06:36, Sudeep Holla <sudeep.holla@arm.com> wrote:
> On Fri, Dec 12, 2014 at 05:47:26PM +0000, Ashwin Chaugule wrote:
>> On 12 December 2014 at 03:43, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> > On Thursday 11 December 2014 01:46 AM, Ashwin Chaugule wrote:
>> >>
>> >> If a wait_for_completion_timeout() call returns due to a timeout,
>> >> the mbox code can still call complete() after returning from the wait.
>> >> This can cause subsequent transmissions on a channel to fail, since
>> >> the wait_for_completion_timeout() sees the completion variable
>> >> is !=0, caused by the erroneous complete() call, and immediately
>> >> returns without waiting for the time as expected by the client.
>> >>
>> >> Fix this by calling complete() only if the TX was successful.
>> >>
>> >> Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
>> >> ---
>> >>   drivers/mailbox/mailbox.c | 2 +-
>> >>   1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
>> >> index 17e9e4a..4acaddb 100644
>> >> --- a/drivers/mailbox/mailbox.c
>> >> +++ b/drivers/mailbox/mailbox.c
>> >> @@ -101,7 +101,7 @@ static void tx_tick(struct mbox_chan *chan, int r)
>> >>         if (mssg && chan->cl->tx_done)
>> >>                 chan->cl->tx_done(chan->cl, mssg, r);
>> >>
>> >> -       if (chan->cl->tx_block)
>> >> +       if ((!r) && chan->cl->tx_block)
>> >>                 complete(&chan->tx_complete);
>> >
>> >
>> > Just curious to check if there's another possible race which is
>> > a different issue.
>> >
>> > Suppose the timer fired and indicated that the Tx is complete, then
>> > it tries to execute complete while the wait_for_completion_timeout timed
>> > out. Does that make sense ?
>> >
>> > So if yes, how about adding !completion_done(..) to the check while you
>> > are at this ?
>>
>> Yea. Seems like another race condition. I'll add it along with this..
>>
>
> Thanks !

IIUC, it looks like adding the !completion_done() will not really fix
this race. Once the lock inside wait_for_completion.. is released,
completion_done() will return 0, and we'll call complete(), which is
not what we want, since the "wait" is already over (after a timeout).
I think the only right thing here is to increase the timeout in
wait_for_completion_timeout(). Thoughts?

Cheers,
Ashwin
