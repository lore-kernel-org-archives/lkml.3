Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3KZSPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:15:17 -0500
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:44595
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756311Ab3KZSPM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:15:12 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2013 13:15:12 EST
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: staging: comedi: drivers: use comedi_dio_update_state() for
 complex cases
Thread-Topic: staging: comedi: drivers: use comedi_dio_update_state() for
 complex cases
Thread-Index: AQHO3L4bEhqT06FVG0W1HC+tE9Z/tJo36mcg
Date: Tue, 26 Nov 2013 18:07:41 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817E08AC5@P3PWEX4MB008.ex4.secureserver.net>
References: <20131107062754.93B2D660F4A@gitolite.kernel.org>
 <20131108200659.GA2101@redhat.com>
In-Reply-To: <20131108200659.GA2101@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 08, 2013 1:07 PM, Dave Jones wrote:
> On Thu, Nov 07, 2013 at 06:27:54AM +0000, Linux Kernel wrote:
>> Gitweb:     http://git.kernel.org/linus/;a=commit;h=b3ff824a81e8978deb56f6d163479c1a0a606037
>> Commit:     b3ff824a81e8978deb56f6d163479c1a0a606037
>> Parent:     97f4289ad08cffe55de06d4ac4f89ac540450aee
>> Author:     H Hartley Sweeten <hsweeten@visionengravers.com>
>> AuthorDate: Fri Aug 30 11:06:17 2013 -0700
>> Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CommitDate: Tue Sep 17 07:47:40 2013 -0700
>> 
>>     staging: comedi: drivers: use comedi_dio_update_state() for complex cases
>>     
>>     Use comedi_dio_update_state() to handle the boilerplate code to update
>>     the subdevice s->state for more complex cases where the hardware is only
>>     updated based on the 'mask' of the channels that are modified.
>>     
>>     Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>     Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This bit looks suspect :-
>
>>  	if (mask) {
>> -		s->state &= ~mask;
>> -		s->state |= (bits & mask);
>> -
>>  		if (mask & 0x00ff)
>>  			outb(s->state & 0xff, dev->iobase + reg);
>> -		if ((mask & 0xff00) && (s->n_chan > 8))
>> +		if ((mask & 0xff00) & (s->n_chan > 8))
>>  			outb((s->state >> 8) & 0xff, dev->iobase + reg + 1);
>> -		if ((mask & 0xff0000) && (s->n_chan > 16))
>> +		if ((mask & 0xff0000) & (s->n_chan > 16))
>>  			outb((s->state >> 16) & 0xff, dev->iobase + reg + 2);
>> -		if ((mask & 0xff000000) && (s->n_chan > 24))
>> +		if ((mask & 0xff000000) & (s->n_chan > 24))
>>  			outb((s->state >> 24) & 0xff, dev->iobase + reg + 3);
>>  	}
>
>
> should those be shifts ? Like so ?
>
>
> diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
> index d041b714db29..29a54e5d73d6 100644
> --- a/drivers/staging/comedi/drivers/pcl730.c
> +++ b/drivers/staging/comedi/drivers/pcl730.c
> @@ -173,11 +173,11 @@ static int pcl730_do_insn_bits(struct comedi_device *dev,
>  	if (mask) {
> 		if (mask & 0x00ff)
>   			outb(s->state & 0xff, dev->iobase + reg);
> -		if ((mask & 0xff00) & (s->n_chan > 8))
> +		if ((mask & 0xff00) & (s->n_chan >> 8))
>  			outb((s->state >> 8) & 0xff, dev->iobase + reg + 1);
> -		if ((mask & 0xff0000) & (s->n_chan > 16))
> +		if ((mask & 0xff0000) & (s->n_chan >> 16))
>  			outb((s->state >> 16) & 0xff, dev->iobase + reg + 2);
> -		if ((mask & 0xff000000) & (s->n_chan > 24))
> +		if ((mask & 0xff000000) & (s->n_chan >> 24))
>  			outb((s->state >> 24) & 0xff, dev->iobase + reg + 3);
>  	}

No, they should not be bit-shifts.

But, there is a bug here. The if tests should be like this:

		if ((mask & 0xff00) && (s->n_chan > 8))

Sorry about that.

Do you want to post a patch? If I don't see one in the next couple days I'll fix it.

Regards,
Hartley

