Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3BRIV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:21:58 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55073 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3BRIVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:21:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAM2ehZbMyNP_AhP-9TmCC5-bw9mqd7yunTy3NETEqRX1bX5oYg@mail.gmail.com>
References: <1351678279-32615-1-git-send-email-cywang@chromium.org> <CAM2ehZbMyNP_AhP-9TmCC5-bw9mqd7yunTy3NETEqRX1bX5oYg@mail.gmail.com>
From: =?UTF-8?B?Q2h1bmctWWloIFdhbmcgKOeOi+W0h+aHvyk=?= 
	<cywang@google.com>
Date: Mon, 18 Feb 2013 16:21:34 +0800
Message-ID: <CAM2ehZYL+JwLu-1f3aR-2SDoyfLhv7Grw14PWzUWLLQLtxfwzw@mail.gmail.com>
Subject: Re: [PATCH] Input: psmouse - retry getid command in psmouse_probe()
To: linux-input@vger.kernel.org, Andrew de los Reyes <adlr@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tai-hwa Liang <avatar@sentelic.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Paul Fox <pgf@laptop.org>,
        Chung-yih Wang <cywang@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry and other maintainers,

  Not sure if you have any comment on the patch? As this patch tries
to help some platforms (especially for lenovo's machines) to rescan
the touchpad device after resuming from suspend if the first probe
fails.

Thanks,
Chung-yih

On Mon, Feb 18, 2013 at 4:17 PM, Chung-Yih Wang (王崇懿)
<cywang@chromium.org> wrote:
> Hi Dmitry and other maintainers,
>
>   Not sure if you have any comment on the patch? As this patch tries to help
> some platforms (especially for lenovo's machines) to rescan the touchpad
> device after resuming from suspend if the first probe fails.
>
> Thanks,
> Chung-yih
>
>
> On Wed, Oct 31, 2012 at 6:11 PM, Chung-yih Wang <cywang@chromium.org> wrote:
>>
>> As the synaptics device may not respond to the first command in
>> psmouse_probe
>> when a machine is booting up, the patch gives a second probe if the first
>> one fails.
>>
>> Signed-off-by: Chung-yih Wang <cywang@chromium.org>
>> ---
>>  drivers/input/mouse/psmouse-base.c |   13 +++++++++++--
>>  1 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/mouse/psmouse-base.c
>> b/drivers/input/mouse/psmouse-base.c
>> index 22fe254..c4fc5ad 100644
>> --- a/drivers/input/mouse/psmouse-base.c
>> +++ b/drivers/input/mouse/psmouse-base.c
>> @@ -1053,8 +1053,17 @@ static int psmouse_probe(struct psmouse *psmouse)
>>   */
>>
>>         param[0] = 0xa5;
>> -       if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
>> -               return -1;
>> +       if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID)) {
>> +               /*
>> +                * Reprobe the device if it did not respond to the GETID
>> +                * command. Before retry, additional dummy command is sent
>> +                * to clear the 'RESEND' response if exists.
>> +                */
>> +               psmouse_warn(psmouse, "GETID probe failed,
>> retrying...\n");
>> +               ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
>> +               if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
>> +                       return -1;
>> +       }
>>
>>         if (param[0] != 0x00 && param[0] != 0x03 &&
>>             param[0] != 0x04 && param[0] != 0xff)
>> --
>> 1.7.7.3
>>
>
