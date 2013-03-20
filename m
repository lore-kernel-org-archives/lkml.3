Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3CTKT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:19:56 -0400
Received: from ams-iport-3.cisco.com ([144.254.224.146]:26786 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3CTKTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:19:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAKWJSVGQ/khR/2dsb2JhbAA5CogSvQCBSBZ0giQBAQQBIysrEAsYAgImAgIxJgYICxsCBIdtBgyvRpJQF4EjjDKBBzMHgi2BEwOWYIEfiE2HFoMLOw
X-IronPort-AV: E=Sophos;i="4.84,876,1355097600"; 
   d="scan'208";a="12297885"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Arne =?utf-8?q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Subject: Re: [RFC V1 5/8] smi2021: Add smi2021_video.c
Date: Wed, 20 Mar 2013 11:09:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.7-7.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: =?utf-8?q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, elezegarcia@gmail.com
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no> <87620p3wzr.fsf@nemi.mork.no> <20130320100636.GM17291@dell.arpanet.local>
In-Reply-To: <20130320100636.GM17291@dell.arpanet.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303201109.27443.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20 March 2013 11:06:36 Jon Arne Jørgensen wrote:
> On Mon, Mar 18, 2013 at 09:58:32AM +0100, Bjørn Mork wrote:
> > Hans Verkuil <hverkuil@xs4all.nl> writes:
> > 
> > >> +/*
> > >> + *
> > >> + * The device delivers data in chunks of 0x400 bytes.
> > >> + * The four first bytes is a magic header to identify the chunks.
> > >> + *	0xaa 0xaa 0x00 0x00 = saa7113 Active Video Data
> > >> + *	0xaa 0xaa 0x00 0x01 = PCM - 24Bit 2 Channel audio data
> > >> + */
> > >> +static void process_packet(struct smi2021_dev *dev, u8 *p, int len)
> > >> +{
> > >> +	int i;
> > >> +	u32 *header;
> > >> +
> > >> +	if (len % 0x400 != 0) {
> > >> +		printk_ratelimited(KERN_INFO "smi2021::%s: len: %d\n",
> > >> +				__func__, len);
> > >> +		return;
> > >> +	}
> > >> +
> > >> +	for (i = 0; i < len; i += 0x400) {
> > >> +		header = (u32 *)(p + i);
> > >> +		switch (__cpu_to_be32(*header)) {
> > >
> > > That's not right. You probably mean __be32_to_cpu, that makes more sense.
> > >
> > >> +		case 0xaaaa0000: {
> > >> +			parse_video(dev, p+i+4, 0x400-4);
> > >> +			break;
> > >> +		}
> > >> +		case 0xaaaa0001: {
> > >> +			smi2021_audio(dev, p+i+4, 0x400-4);
> > >> +			break;
> > >> +		}
> > 
> > This could be just me, but I would have done it like this to take
> > advantage of compile time constant conversions (and also dropping the
> > noisy extra {}s):
> > 
> > 		switch (*header) {
> > 		case cpu_to_be32(0xaaaa0000):
> > 			parse_video(dev, p+i+4, 0x400-4);
> > 			break;
> > 		case cpu_to_be32(0xaaaa0001):
> > 			smi2021_audio(dev, p+i+4, 0x400-4);
> > 			break;
> >                 ..
> > 
> > 
> > >From the name of the function I assume the difference may actually be
> > measurable here if this runs for every processed packet.
> > 
> > 
> 
> You are both right, I will have a second look at this code.
> I guess I'll try to implement Bjørns suggestion.
> 
> As I'm working with a byte-array, I could probably change this code to:
> 
> 		if (header[0] == 0xaa && header[1] == 0xaa
> 			&& header[2] == 0x00 && header[3] == 0x00) {
> 
> 			{...}
> 
> 		} else if (header[0] == 0xaa && header[1] == 0xaa
> 			&& header[2] == 0x00 && header[3] == 0x01) {
> 		
> 			{...}
> 		}
> 
> But I hope you agree that the switch statement is cleaner?
> 
> (I just find it hard to wrap my head around the big vs. little endian
> differences when dealing with hexadecimal integer notation :) )

Bjørn's solution is best in this case.

Regards,

	Hans

> 
> > Bjørn
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
