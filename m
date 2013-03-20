Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3CTKDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:03:23 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:47232 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185Ab3CTKDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:03:22 -0400
Date: Wed, 20 Mar 2013 11:06:36 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        elezegarcia@gmail.com
Subject: Re: [RFC V1 5/8] smi2021: Add smi2021_video.c
Message-ID: <20130320100636.GM17291@dell.arpanet.local>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <1363270024-12127-6-git-send-email-jonarne@jonarne.no>
 <201303180917.03572.hverkuil@xs4all.nl>
 <87620p3wzr.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87620p3wzr.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:58:32AM +0100, Bjørn Mork wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
> >> +/*
> >> + *
> >> + * The device delivers data in chunks of 0x400 bytes.
> >> + * The four first bytes is a magic header to identify the chunks.
> >> + *	0xaa 0xaa 0x00 0x00 = saa7113 Active Video Data
> >> + *	0xaa 0xaa 0x00 0x01 = PCM - 24Bit 2 Channel audio data
> >> + */
> >> +static void process_packet(struct smi2021_dev *dev, u8 *p, int len)
> >> +{
> >> +	int i;
> >> +	u32 *header;
> >> +
> >> +	if (len % 0x400 != 0) {
> >> +		printk_ratelimited(KERN_INFO "smi2021::%s: len: %d\n",
> >> +				__func__, len);
> >> +		return;
> >> +	}
> >> +
> >> +	for (i = 0; i < len; i += 0x400) {
> >> +		header = (u32 *)(p + i);
> >> +		switch (__cpu_to_be32(*header)) {
> >
> > That's not right. You probably mean __be32_to_cpu, that makes more sense.
> >
> >> +		case 0xaaaa0000: {
> >> +			parse_video(dev, p+i+4, 0x400-4);
> >> +			break;
> >> +		}
> >> +		case 0xaaaa0001: {
> >> +			smi2021_audio(dev, p+i+4, 0x400-4);
> >> +			break;
> >> +		}
> 
> This could be just me, but I would have done it like this to take
> advantage of compile time constant conversions (and also dropping the
> noisy extra {}s):
> 
> 		switch (*header) {
> 		case cpu_to_be32(0xaaaa0000):
> 			parse_video(dev, p+i+4, 0x400-4);
> 			break;
> 		case cpu_to_be32(0xaaaa0001):
> 			smi2021_audio(dev, p+i+4, 0x400-4);
> 			break;
>                 ..
> 
> 
> >From the name of the function I assume the difference may actually be
> measurable here if this runs for every processed packet.
> 
> 

You are both right, I will have a second look at this code.
I guess I'll try to implement Bjørns suggestion.

As I'm working with a byte-array, I could probably change this code to:

		if (header[0] == 0xaa && header[1] == 0xaa
			&& header[2] == 0x00 && header[3] == 0x00) {

			{...}

		} else if (header[0] == 0xaa && header[1] == 0xaa
			&& header[2] == 0x00 && header[3] == 0x01) {
		
			{...}
		}

But I hope you agree that the switch statement is cleaner?

(I just find it hard to wrap my head around the big vs. little endian
differences when dealing with hexadecimal integer notation :) )

> Bjørn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
