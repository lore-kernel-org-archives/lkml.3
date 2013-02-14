Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803Ab3BNRWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:22:04 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:37352 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3BNRWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:22:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130213215250.GE23390@core.coreip.homeip.net>
References: <1359707312-12986-1-git-send-email-djkurtz@chromium.org> <20130213215250.GE23390@core.coreip.homeip.net>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 14 Feb 2013 09:15:09 -0800
X-Google-Sender-Auth: mQA7SgJs6V8WgdEJ-Lly-zSfC8A
Message-ID: <CAGS+omDJi6EecXHdtYEGg0iXNqTLSnhHPE7ieHQ=ZNXkowJqKQ@mail.gmail.com>
Subject: Re: [PATCH] Input: synaptics - disable fuzz when using mt slots
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chung-Yih Wang <cywang@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 1:52 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Feb 01, 2013 at 04:28:32PM +0800, Daniel Kurtz wrote:
>> The input fuzz algorithm does a pretty good job filtering out small
>> jitter on input samples.
>>
>> However, there is a subtle problem when fuzz is used with mt drivers that
>> also use input_mt_report_pointer_emulation() to report legacy single
>> touch coordinates.  The reported single touch coordinates are taken from
>> the active MT slot with smallest tracking id.  However, since the MT data
>> is sent first, it has already had FUZZ applied.  Thus, the ST coordinates
>> actually get FUZZ applied a second time, with the just-fuzzed MT value as
>> the 'old value'.
>>
>> It appears that it is non-trivial to fix this in the mt layer/input core,
>> so, for now, just disable fuzz for the synaptics IMAGE_SENSOR path that
>> uses input_mt_report_pointer_emulation().
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/input/mouse/synaptics.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
>> index 12d12ca..b6c6838 100644
>> --- a/drivers/input/mouse/synaptics.c
>> +++ b/drivers/input/mouse/synaptics.c
>> @@ -1211,7 +1211,8 @@ static void set_abs_position_params(struct input_dev *dev,
>>       int x_max = priv->x_max ?: XMAX_NOMINAL;
>>       int y_min = priv->y_min ?: YMIN_NOMINAL;
>>       int y_max = priv->y_max ?: YMAX_NOMINAL;
>> -     int fuzz = SYN_CAP_REDUCED_FILTERING(priv->ext_cap_0c) ?
>> +     int fuzz = (SYN_CAP_REDUCED_FILTERING(priv->ext_cap_0c) &&
>> +                     !SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) ?
>>                       SYN_REDUCED_FILTER_FUZZ : 0;
>
> Hmm, instead of disabling fuzz completely maybe we should disable it
> only on the derived axes (ABS_X/ABS_Y) for multitouch devices?

Yes, that should work...  both would end up fuzzed to the same value,
for a not-so-obvious reason, IMHO :).
It's a bit tricky, and I like it, but is that what you intended by the
suggestion?

-Daniel

>
> Thanks.
>
> --
> Dmitry
