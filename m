Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3CTWdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:33:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47214 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3CTWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:33:03 -0400
Message-ID: <514A391D.9010005@wwwdotorg.org>
Date: Wed, 20 Mar 2013 16:33:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: core: Split out in place value parsing
References: <1362359680-23747-1-git-send-email-broonie@opensource.wolfsonmicro.com> <5147A63D.3040502@wwwdotorg.org> <20130319165007.GA22168@opensource.wolfsonmicro.com> <514A35EA.2090001@wwwdotorg.org>
In-Reply-To: <514A35EA.2090001@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 04:19 PM, Stephen Warren wrote:
> On 03/19/2013 10:50 AM, Mark Brown wrote:
>> On Mon, Mar 18, 2013 at 05:41:49PM -0600, Stephen Warren wrote:
>>
>>> It took a very quick look at the patch and couldn't see anything 
>>> actively wrong. I wonder if one of the existing unconverted users
>>> of .parse_val() relies on the in-place modification of the buffer
>>> as well as getting the result back, and so should have been
>>> converted to calling both .parse_inplace() and then
>>> .parse_val()?
>>
>> Possibly, though you'd have thought that if it were just that one
>> of the other users would have noticed - my primary development
>> board uses regmap extensively for example.  Does seem the most
>> likely option though.  Can't test anything again until Friday
>> sadly.
>>
>> Might also be some unusual code path WM8903 exercises, though again
>> it's pretty simple.
> 
> I haven't thought through why the patch in question causes/exposes the
> issue yet, but I have found out what the problem is.
> 
> _regmap_bus_raw_write() formats the value into work_buf + reg_bytes +
> pad_bytes, i.e. work_buf + 1.
> 
> For the first regmap_write() that the WM8903 driver does, work_buf is
> now xx 89 03.
> 
> _regmap_raw_write() then memcpy()s from val (i.e. work_buf + 1) to
> workbuf, and parses the value to send to the caching code:
> 
>> if (!map->cache_bypass && map->format.parse_val) { unsigned int
>> ival; int val_bytes = map->format.val_bytes; for (i = 0; i <
>> val_len / val_bytes; i++) { memcpy(map->work_buf, val + (i *
>> val_bytes), val_bytes); ival =
>> map->format.parse_val(map->work_buf);
> 
> This corrupts that value at work_buf + 1 since it overlaps the copy
> destination at work_buf. work_buf is now 89 03 03.

Ah, here's why it used to work:

When parse_val used to both return the value and modify the buffer in
place, parse_val used to re-write the buffer from 89 03 03 to 03 89 03,
which is the same content that it originally had before the memcpy, at
least for the region that holds the value rather than the address, which
is all that's relevant since the address gets over-written later. The
combination of the memcpy-down-by-1-byte followed by swap-first-2-bytes,
just accidentally happened to leave the buffer in a valid state. Of
course, this only works for certain combinations of register address and
value sizes, I think...

So, I think that the fix I mentioned below really is valid, and what's
more is technically needed irrespective of whether "regmap: core: Split
out in place value parsing" is applied. I'll assume so and send out that
patch.

> _regmap_raw_write() then formats the register address into work_buf,
> yielding 00 03 03.
> 
> That data stream is then sent over I2C, causing a write to register 0
> (correct) of value 03 03 (rather than 89 03).
> 
> If I comment out the memcpy, and instead pass the value address
> directly to .parse_val(), everything works again.

