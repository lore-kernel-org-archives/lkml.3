Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCFJpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:45:25 -0500
Received: from mx0.aculab.com ([213.249.233.131]:39815 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751837AbaCFJpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:45:20 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Sukadev Bhattiprolu'" <sukadev@linux.vnet.ibm.com>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
CC: Michael Ellerman <michaele@au1.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>
Subject: RE: [PATCH 3/3] perf: Use 64-bit value when comparing sample_regs
Thread-Topic: [PATCH 3/3] perf: Use 64-bit value when comparing sample_regs
Thread-Index: AQHPOPa0HhCuRKR9rUmCkUl46/2MdZrTzNeQ
Date: Thu, 6 Mar 2014 09:44:47 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D3983@AcuExch.aculab.com>
References: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1394080919-17957-4-git-send-email-sukadev@linux.vnet.ibm.com>
In-Reply-To: <1394080919-17957-4-git-send-email-sukadev@linux.vnet.ibm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s269jWua024446

From: Sukadev Bhattiprolu
> When checking whether a bit representing a register is set in
> sample_regs, a 64-bit mask, use 64-bit value (1LL).
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/util/unwind.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> index 742f23b..2b888c6 100644
> --- a/tools/perf/util/unwind.c
> +++ b/tools/perf/util/unwind.c
> @@ -396,11 +396,11 @@ static int reg_value(unw_word_t *valp, struct regs_dump *regs, int id,
>  {
>  	int i, idx = 0;
> 
> -	if (!(sample_regs & (1 << id)))
> +	if (!(sample_regs & (1LL << id)))
>  		return -EINVAL;
> 
>  	for (i = 0; i < id; i++) {
> -		if (sample_regs & (1 << i))
> +		if (sample_regs & (1LL << i))
>  			idx++;
>  	}

There are much faster ways to count the number of set bits, especially
if you might need to check a significant number of bits.
There might even be a function defined somewhere to do it.
Basically you just add up the bits, for 16 bit it would be:
	val = (val & 0x5555) + (val >> 1) & 0x5555;
	val = (val & 0x3333) + (val >> 2) & 0x3333;
	val = (val & 0x0f0f) + (val >> 4) & 0x0f0f;
	val = (val & 0x00ff) + (val >> 8) & 0x00ff;
As the size of the work increases the improvement is more significant.
(Some of the later masking can probably be proven unnecessary.)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
