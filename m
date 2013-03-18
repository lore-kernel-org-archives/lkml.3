Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3CRL5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:57:41 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47742 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3CRL5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <1363601689.2412.12.camel@dabdike.int.hansenpartnership.com>
References: <1363508951-3011-1-git-send-email-linkinjeon@gmail.com>
	<1363601689.2412.12.camel@dabdike.int.hansenpartnership.com>
Date: Mon, 18 Mar 2013 20:57:38 +0900
Message-ID: <CAKYAXd-thiuWagZPf8825=eKLQPyx3w+h5vzKXn_O_g7n9CpDg@mail.gmail.com>
Subject: Re: [PATCH] [SCSI]: print the msgbytes and statusbyte from scsi result
From: Namjae Jeon <linkinjeon@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Sun, 2013-03-17 at 17:29 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Introduce msgbyte and statusbyte in the prints as part of the
>> result which is returned by the lower layer driver in response to
>> SCSI command issued, in case of any error conditions.
>>
>> Purpose of adding these prints is to convey, during any I/O
>> error case, which condition exactly has happened in lower device and
>> from the prints we can directly deduce, what is the status of command
>> issued. This will help to quickly debug the scenario and also making
>> a test case to create new scenarios.
>>
>> Also change the printk to more appropriate pr_* macro.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  drivers/scsi/constants.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 76e4c03..77bb1dc 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1445,8 +1445,10 @@ void scsi_show_result(int result)
>>
>>  void scsi_show_result(int result)
>>  {
>> -	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
>> -	       host_byte(result), driver_byte(result));
>> +	pr_info("Result: hostbyte=0x%02x driverbyte=0x%02x"
>> +			"msgbyte=0x%02x statusbyte=0x%02x\n",
>> +	       host_byte(result), driver_byte(result), msg_byte(result),
>> +							status_byte(result));
Hi James.
>
> You didn't test this, did you? If you did, you'd have noticed the change
> from printk to pr_info gives you an unwanted "6" in the message.
Yes, we tested with "printk" version of the patch, but before sending
the patch, when we checked for issues using "checkpatch.pl" it showed
warning.
So, we thought that to be a cosmetic change and replaced the printk
with  pr_info. Sorry, if below your douting is clear, I will change
log level as current one.

>
> Also, what are you hoping to achieve? scsi_show_result() is only used by
> sd in a very few special command situations.  I can't believe the msg
> byte would be anything other than zero and the status byte check
> condition.
Regarding the introduction of additional information in prints.
We encountered an error with error logs like:
[ 131.673096] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[ 131.679038] sd 0:0:0:0: [sda] Sense Key : 0xb [current]
[ 131.684801] sd 0:0:0:0: [sda] ASC=0x8 ASCQ=0x3
[ 131.689241] sd 0:0:0:0: [sda] CDB: cdb[0]=0x2a: 2a 00 00 cb 0c 00 00 00 f0 00

Looking at the logs it was clear it was due "ABORTED command" but we
wanted to check in the code if there was any retry in such case:
In ‘scsi_decide_disposition’ there are "3" main conditions

switch (host_byte(scmd->result)) -> this returned "DID_OK"
        if (msg_byte(scmd->result) != COMMAND_COMPLETE)
                return FAILED;

And the last was:
switch (status_byte(scmd->result)) {
…
    case TASK_ABORTED:
                goto maybe_retry;
    case CHECK_CONDITION:
…

So, if the status/host bytes were known - we could have directly
deduced from the code. Instead we needed to introduce prints and then
check the path.

Thanks.
>
> James
>
>
>
