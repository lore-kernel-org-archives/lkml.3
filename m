Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaEaGq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 02:46:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:52982 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaEaGqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 02:46:25 -0400
Message-ID: <53897A95.6030904@ahsoftware.de>
Date: Sat, 31 May 2014 08:45:41 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: [PATCH 1/2] bluetooth: don't include local processing of HCI
 commands in the command timeout
References: <1400076025-5103-1-git-send-email-holler@ahsoftware.de> <C2044AE9-519F-4A3D-BA6D-1076318AA4F5@holtmann.org>
In-Reply-To: <C2044AE9-519F-4A3D-BA6D-1076318AA4F5@holtmann.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.05.2014 07:28, schrieb Marcel Holtmann:
> Hi Alexander,
> 
>> I assume the timeout for processing HCI commands was originally intended to
>> detect hung bluetooth devices and should not include the time needed locally
>> to handle the response to an HCI command. That is important because the time
>> needed locally (by the kernel or even userland) to process responses to HCI
>> commands varies a lot between systems and HCI commands. That's even more true
>> since many actions to HCI command responses are handled inside works which
>> might be delayed quiet some time, depending on the actual system load.
>>
>> So stop the timeout as soon as a response to an HCI command was received.
>>
>> This fixes various problems which resulted in HCI command timeouts and an
>> afterwards non-working bluetooth stack, especially on slower systems like
>> some ARM devices.
>>
>> Drawback is that in-kernel problems like deadlocks aren't detected by HCI
>> command timeouts anymore, but such problems should be detected and handled
>> by other means and not by a timeout where it is hard to specify a value
>> reasonable for all possible systems (-configurations, -loads).
>>
>> Furthermore, if the timeout includes local processing of HCI command
>> responses, in-kernel errors like hung tasks might be masked by the
>> timeout, because the hung task would be killed by the timeout before
>> the hung task would be detected (by other means).
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>> net/bluetooth/hci_event.c | 12 ++++++------
>> 1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 15010a2..94c2dc0 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -2338,6 +2338,9 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
>>
>> 	opcode = __le16_to_cpu(ev->opcode);
>>
>> +	if (opcode != HCI_OP_NOP)
>> +		del_timer(&hdev->cmd_timer);
>> +
> 
> so I actually wonder if we should move away from timer and move to a delayed work item to handle the timeout and if that would actually fix this issue.

The problem is that I have absolutely no clue where these timeouts do
come from. They appear for different commands and almost always only at
boot. If the machine did come up without hci command timeouts, there
never was one afterwards. So I digged in the dark and the above patch
was one of the results. But I still had to increase the command timeout.
And I can't do much testing as I use this box. I just experience this
problem almost always when I boot it (to do kernel updates) and since a
very long time (more than a year I think).

Regards,

Alexander Holler
