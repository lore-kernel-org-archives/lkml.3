Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3CRI7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:59:15 -0400
Received: from canardo.mork.no ([148.122.252.1]:57770 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab3CRI7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:59:12 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        elezegarcia@gmail.com
Subject: Re: [RFC V1 5/8] smi2021: Add smi2021_video.c
Organization: m
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
	<1363270024-12127-6-git-send-email-jonarne@jonarne.no>
	<201303180917.03572.hverkuil@xs4all.nl>
Date: Mon, 18 Mar 2013 09:58:32 +0100
In-Reply-To: <201303180917.03572.hverkuil@xs4all.nl> (Hans Verkuil's message
	of "Mon, 18 Mar 2013 09:17:03 +0100")
Message-ID: <87620p3wzr.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Verkuil <hverkuil@xs4all.nl> writes:

>> +/*
>> + *
>> + * The device delivers data in chunks of 0x400 bytes.
>> + * The four first bytes is a magic header to identify the chunks.
>> + *	0xaa 0xaa 0x00 0x00 = saa7113 Active Video Data
>> + *	0xaa 0xaa 0x00 0x01 = PCM - 24Bit 2 Channel audio data
>> + */
>> +static void process_packet(struct smi2021_dev *dev, u8 *p, int len)
>> +{
>> +	int i;
>> +	u32 *header;
>> +
>> +	if (len % 0x400 != 0) {
>> +		printk_ratelimited(KERN_INFO "smi2021::%s: len: %d\n",
>> +				__func__, len);
>> +		return;
>> +	}
>> +
>> +	for (i = 0; i < len; i += 0x400) {
>> +		header = (u32 *)(p + i);
>> +		switch (__cpu_to_be32(*header)) {
>
> That's not right. You probably mean __be32_to_cpu, that makes more sense.
>
>> +		case 0xaaaa0000: {
>> +			parse_video(dev, p+i+4, 0x400-4);
>> +			break;
>> +		}
>> +		case 0xaaaa0001: {
>> +			smi2021_audio(dev, p+i+4, 0x400-4);
>> +			break;
>> +		}

This could be just me, but I would have done it like this to take
advantage of compile time constant conversions (and also dropping the
noisy extra {}s):

		switch (*header) {
		case cpu_to_be32(0xaaaa0000):
			parse_video(dev, p+i+4, 0x400-4);
			break;
		case cpu_to_be32(0xaaaa0001):
			smi2021_audio(dev, p+i+4, 0x400-4);
			break;
                ..


>From the name of the function I assume the difference may actually be
measurable here if this runs for every processed packet.


Bjørn
