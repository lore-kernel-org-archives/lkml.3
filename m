Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3BRJpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:45:31 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55825 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3BRJp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:45:29 -0500
MIME-Version: 1.0
In-Reply-To: <1361179560.7859.5.camel@liguang.fnst.cn.fujitsu.com>
References: <1351678279-32615-1-git-send-email-cywang@chromium.org> <1361179560.7859.5.camel@liguang.fnst.cn.fujitsu.com>
From: =?UTF-8?B?Q2h1bmctWWloIFdhbmcgKOeOi+W0h+aHvyk=?= 
	<cywang@google.com>
Date: Mon, 18 Feb 2013 17:45:07 +0800
Message-ID: <CAM2ehZZ9LyTkG+qi_ihGzYJn2fB=s9RCLT67ThZUB9mmyQSzhw@mail.gmail.com>
Subject: Re: [PATCH] Input: psmouse - retry getid command in psmouse_probe()
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tai-hwa Liang <avatar@sentelic.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Paul Fox <pgf@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I could add CONFIG_MOUSE_PS2_SYNAPTICS for the change as we only
need it for synaptics touchpad/touchpoint on lenovo's machines.


On Mon, Feb 18, 2013 at 5:26 PM, li guang <lig.fnst@cn.fujitsu.com> wrote:
> seems a special change for a special device
> so, you may need to place this change with
> corresponding CONFIG_xxx_xxx.
> generally, if command F2 failed, we will assume
> there's no ps2 device, it's normal,
> or do you have some materials(SPEC) to specify
> the change you have made?
>
>
>
> 在 2012-10-31三的 18:11 +0800，Chung-yih Wang写道：
>> As the synaptics device may not respond to the first command in psmouse_probe
>> when a machine is booting up, the patch gives a second probe if the first
>> one fails.
>>
>> Signed-off-by: Chung-yih Wang <cywang@chromium.org>
>> ---
>>  drivers/input/mouse/psmouse-base.c |   13 +++++++++++--
>>  1 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
>> index 22fe254..c4fc5ad 100644
>> --- a/drivers/input/mouse/psmouse-base.c
>> +++ b/drivers/input/mouse/psmouse-base.c
>> @@ -1053,8 +1053,17 @@ static int psmouse_probe(struct psmouse *psmouse)
>>   */
>>
>>       param[0] = 0xa5;
>> -     if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
>> -             return -1;
>> +     if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID)) {
>> +             /*
>> +              * Reprobe the device if it did not respond to the GETID
>> +              * command. Before retry, additional dummy command is sent
>> +              * to clear the 'RESEND' response if exists.
>> +              */
>> +             psmouse_warn(psmouse, "GETID probe failed, retrying...\n");
>> +             ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
>> +             if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
>> +                     return -1;
>> +     }
>>
>>       if (param[0] != 0x00 && param[0] != 0x03 &&
>>           param[0] != 0x04 && param[0] != 0xff)
>
>
