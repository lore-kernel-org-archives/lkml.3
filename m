Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3D2R2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:28:25 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53867 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3D2R2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <517EA87B.9090906@calxeda.com>
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
	<1367086496-28647-1-git-send-email-jaswinder.singh@linaro.org>
	<517EA36E.2050106@ti.com>
	<CAJe_ZhcHVAQfPZJ-+upr-78B+MqLw36jTmS8geZpc2=_-gGzGQ@mail.gmail.com>
	<517EA87B.9090906@calxeda.com>
Date: Mon, 29 Apr 2013 22:58:23 +0530
Message-ID: <CAJe_Zhe6=8F=HPZPw1xkDbuyALHK6iwJ-uZKq50yE7vQ6Bp4BQ@mail.gmail.com>
Subject: Re: [RFC 3/3] mailbox: pl320: Introduce common API driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Suman Anna <s-anna@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2013 22:36, Mark Langsdorf <mark.langsdorf@calxeda.com> wrote:
> On 04/29/2013 11:57 AM, Jassi Brar wrote:
>> On 29 April 2013 22:14, Suman Anna <s-anna@ti.com> wrote:
>>> On 04/27/2013 01:14 PM, jassisinghbrar@gmail.com wrote:
>>>> From: Jassi Brar <jaswinder.singh@linaro.org>
>>>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>>>> ---
>>>>  drivers/cpufreq/highbank-cpufreq.c       |   22 +++-
>>>>  drivers/mailbox/Makefile                 |    2 +-
>>>>  drivers/mailbox/{pl320-ipc.c => pl320.c} |  194 ++++++++++++++++--------------
>>>>  include/linux/pl320-ipc.h                |   17 ---
>>>>  4 files changed, 125 insertions(+), 110 deletions(-)
>>>>  rename drivers/mailbox/{pl320-ipc.c => pl320.c} (51%)
>>>>  delete mode 100644 include/linux/pl320-ipc.h
>>>>
>>>> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
>>>> index 3118b87..5c057e0 100644
>>>> --- a/drivers/cpufreq/highbank-cpufreq.c
>>>> +++ b/drivers/cpufreq/highbank-cpufreq.c
>>>> @@ -19,7 +19,7 @@
>>>>  #include <linux/cpu.h>
>>>>  #include <linux/err.h>
>>>>  #include <linux/of.h>
>>>> -#include <linux/pl320-ipc.h>
>>>> +#include <linux/mailbox_client.h>
>>>>  #include <linux/platform_device.h>
>>>>
>>>>  #define HB_CPUFREQ_CHANGE_NOTE       0x80000001
>>>> @@ -29,8 +29,26 @@
>>>>  static int hb_voltage_change(unsigned int freq)
>>>>  {
>>>>       u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
>>>> +     struct ipc_client cl;
>>>> +     int ret = -ETIMEDOUT;
>>>> +     void *chan;
>>>>
>>>> -     return pl320_ipc_transmit(msg);
>>>> +     cl.rxcb = NULL;
>>>> +     cl.txcb = NULL;
>>>> +     cl.tx_block = true;
>>>> +     cl.tx_tout = 1000; /* 1 sec */
>>>> +     cl.cntlr_data = NULL;
>>>> +     cl.knows_txdone = false;
>>>> +     cl.chan_name = "pl320:A9_to_M3";
>>>> +
>>>> +     chan = ipc_request_channel(&cl);
>>>> +
>>>> +     if (ipc_send_message(chan, (void *)msg))
>>>> +             ret = msg[1]; /* PL320 updates buffer with FIFO after ACK */
>>>> +
>>>> +     ipc_free_channel(chan);
>>>
>>> I think I understand why you have done this, but do you really want to
>>> request and free every time in the highbank cpufreq driver?
>>>
>> Exactly my aim - make the API light enough to enable the client to
>> use-and-throw. And also because the channel are exclusively assigned,
>> acquire a channel only for as long as you need it.
>
> Do you have any numbers on the performance impact? Our cpufreq
> transition throughput is bad enough without adding additional delays.
>
Sorry no numbers.
However if you look closely you'll find for your usecase the message
directly reaches the controller and the reply from remote is directly
handed to your client driver. And since there is no context for
channel on your platform channel request/free shouldn't fail either
(or you could keep the channel allocated for the lifetime of the
client driver). So I would not expect any longer delays than the
original way.
 Compared with TI's framework of RX-via-notifier you should be better
off with this API, imho.

cheers.
