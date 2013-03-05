Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3CEUmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:42:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34869 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3CEUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:42:05 -0500
Message-ID: <51365862.9050401@oracle.com>
Date: Tue, 05 Mar 2013 15:41:06 -0500
From: Christine Spang <christine.spang@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        Jamie Iles <jamie.iles@oracle.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make snd_BUG_ON() always evaluate and return the conditional
 expression.
References: <1362434579-7733-1-git-send-email-christine.spang@oracle.com> <s5h8v62gqt0.wl%tiwai@suse.de>
In-Reply-To: <s5h8v62gqt0.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 04:05 AM, Takashi Iwai wrote:
> At Mon,  4 Mar 2013 17:02:59 -0500,
> Christine Spang wrote:
>> Having snd_BUG_ON() only evaluate its conditional when CONFIG_SND_DEBUG
>> is set leads to frequent bugs, since other similar macros in the kernel
>> have different behavior. Let's make snd_BUG_ON() act like those macros
>> so it will stop being accidentally misused.
>>
>> Signed-off-by: Christine Spang <christine.spang@oracle.com>
> Sounds reasonable.  The dependency on CONFIG_SND_DEBUG was for
> allowing more optimization, but since we use this for more places than
> expected, this change would be safer indeed.
>
> If no one has objection, I'll apply it for 3.10 kernel.
>
>
> thanks,
>
> Takashi

This ought to be considered for 3.9 and stable@ as
well. It fixes NULL derefs all over the place, e.g.

sound/core/device.c:126

    if (snd_BUG_ON(!card || !device_data))
        return -ENXIO;
    list_for_each_entry(dev, &card->devices, list) {
       [...]

If card == NULL and CONFIG_SND_DEBUG is off, this code will NULL deref.

There are some 600 other instances of snd_BUG_ON() being used dubiously
in the current tree. Some of these instances even perform extra cleanup
before returning in error conditions. It's really broken with
CONFIG_SND_DEBUG off, and no major distro ships production kernels with
this setting enabled.

Christine

