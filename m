Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3BUMKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:10:51 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58399 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab3BUMKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:10:50 -0500
Message-ID: <51260EA8.20402@gmail.com>
Date: Thu, 21 Feb 2013 13:10:16 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Pawel Moll <mail@pawelmoll.com>, Jaroslav Kysela <perex@perex.cz>,
        Daniel Mack <daniel@caiaq.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb: Fix Processing Unit Descriptor parsers
References: <1361411750-30056-1-git-send-email-mail@pawelmoll.com> <s5hip5mhwd5.wl%tiwai@suse.de>
In-Reply-To: <s5hip5mhwd5.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.02.2013 10:03, Takashi Iwai wrote:
> At Thu, 21 Feb 2013 01:55:50 +0000,
> Pawel Moll wrote:
>>
>> Commit 99fc86450c439039d2ef88d06b222fd51a779176 "ALSA: usb-mixer:
>> parse descriptors with structs" introduced a set of useful parsers
>> for descriptors. Unfortunately the parses for the Processing Unit
>> Descriptor came with a very subtle bug...
>>
>> Functions uac_processing_unit_iProcessing() and
>> uac_processing_unit_specific() were indexing the baSourceID array
>> forgetting the fields before the iProcessing and process-specific
>> descriptors.
>>
>> The problem was observed with Sound Blaster Extigy mixer,
>> where nNrModes in Up/Down-mix Processing Unit Descriptor
>> was accessed at offset 10 of the descriptor (value 0)
>> instead of offset 15 (value 7). In result the resulting
>> control had interesting limit values:
>>
>> Simple mixer control 'Channel Routing Mode Select',0
>>   Capabilities: volume volume-joined penum
>>   Playback channels: Mono
>>   Capture channels: Mono
>>   Limits: 0 - -1
>>   Mono: -1 [100%]
>>
>> Fixed by starting from the bmControls, which was calculated
>> correctly, instead of baSourceID.
>>
>> Now the mentioned control is fine:
>>
>> Simple mixer control 'Channel Routing Mode Select',0
>>   Capabilities: volume volume-joined penum
>>   Playback channels: Mono
>>   Capture channels: Mono
>>   Limits: 0 - 6
>>   Mono: 0 [0%]
>>
>> Signed-off-by: Pawel Moll <mail@pawelmoll.com>
>> ---
>>  include/uapi/linux/usb/audio.h |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/usb/audio.h b/include/uapi/linux/usb/audio.h
>> index ac90037..d2314be 100644
>> --- a/include/uapi/linux/usb/audio.h
>> +++ b/include/uapi/linux/usb/audio.h
>> @@ -384,14 +384,16 @@ static inline __u8 uac_processing_unit_iProcessing(struct uac_processing_unit_de
>>  						   int protocol)
>>  {
>>  	__u8 control_size = uac_processing_unit_bControlSize(desc, protocol);
>> -	return desc->baSourceID[desc->bNrInPins + control_size];
>> +	return *(uac_processing_unit_bmControls(desc, protocol)
>> +			+ control_size);
>>  }
>>  
>>  static inline __u8 *uac_processing_unit_specific(struct uac_processing_unit_descriptor *desc,
>>  						 int protocol)
>>  {
>>  	__u8 control_size = uac_processing_unit_bControlSize(desc, protocol);
>> -	return &desc->baSourceID[desc->bNrInPins + control_size + 1];
>> +	return uac_processing_unit_bmControls(desc, protocol)
>> +			+ control_size + 1;
>>  }
> 
> Looks good to me.
> 
> An alternative would be to change uac_processing_unit_bControlSize()
> to correct the header size, but I don't think it's good, as
> bControlSize fields in other units show the value including the header
> size.
> 
> Daniel, what do you think?

Looks good to me too. and this should be marked for stable of course.

Thanks for fixing this, Pawell!


Daniel
