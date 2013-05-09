Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3EITd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:33:29 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38136 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3EITd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:33:27 -0400
References: <1367930422-25972-2-git-send-email-jeff.dagenais@gmail.com> <1367935248-12118-1-git-send-email-jeff.dagenais@gmail.com> <20130509110333.f6ba3b4cc22e87c7adb30993@linux-foundation.org>
In-Reply-To: <20130509110333.f6ba3b4cc22e87c7adb30993@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Message-Id: <1A322F9E-F2A7-42E6-8C37-8A5C3F2E28FD@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
Subject: Re: [PATCH V2] w1: ds2408: add magic sequence to disable P0 test mode
Date: Thu, 9 May 2013 15:33:23 -0400
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-05-09, at 2:03 PM, Andrew Morton wrote:
[...]
>> +static int w1_f29_disable_test_mode(struct w1_slave *sl)
>> +{
>> +	int res;
>> +	u8 magic[10] = {0x96, };
>> +	u64 rn = le64_to_cpu(*((u64*)&sl->reg_num));
>> +	memcpy(&magic[1], &rn, 8);
>> +	magic[9] = 0x3C;
> 
> (please put a blank line between end-of-locals and start-of-code)
> 
> The casting looks decidedly dodgy.  I guess it won't cause an unalignned
> exception due to reg_num's alignment, but it appears to defeat the
> endianness handling in the definotion of `struct w1_reg_num'.
> 
> Are you sure this will work OK with all architectures and both
> __LITTLE_ENDIAN_BITFIELD and __BIG_ENDIAN_BITFIELD?

To be honest, I didn't really thought about it that much, I just copy pasted that from Evgeniy Polyakov's hunk at drivers/w1/w1_io.c, function w1_reset_select_slave(struct w1_slave *sl) exept I changed the MATCH_ROM with magic 0x96 and appended magic 0x3C. I have tested it only on the available platform I have which is x86. I agree it looks dodgy. Do you have an alternative? You are certainly more familiar with the kernel's fancy bit and endian tools than I am. I'd be willing to test prior to sending V3.


struct w1_reg_num
{
#if defined(__LITTLE_ENDIAN_BITFIELD)
	__u64	family:8,
		id:48,
		crc:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
	__u64	crc:8,
		id:48,
		family:8;
#else
#error "Please fix <asm/byteorder.h>"
#endif
};

On the wire, the family byte should be sent first, then the MSB of id, then the rest of id and finally the crc.

Perhaps Evgeniy can chime in here?

Cheers,
/jfd