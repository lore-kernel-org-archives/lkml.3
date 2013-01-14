Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3ANRI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:08:29 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:40037 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3ANRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <20130113231836.GJ5041@opensource.wolfsonmicro.com>
References: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
	<1358024054-9895-4-git-send-email-andrew.smirnov@gmail.com>
	<20130113231836.GJ5041@opensource.wolfsonmicro.com>
Date: Mon, 14 Jan 2013 09:08:27 -0800
Message-ID: <CAHQ1cqGWYsfBAsp_8AOyJ0Q-7_PS-v6wRv6w5DQTju5tNf9fdg@mail.gmail.com>
Subject: Re: [PATCH 3/3] [regmap] [RESEND] Add "no-bus" option for regmap API
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "andrey.smirnov@convergeddevices.net" 
	<andrey.smirnov@convergeddevices.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 3:18 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Jan 12, 2013 at 12:54:14PM -0800, Andrey Smirnov wrote:
>
>> +     bool cache_registers;
>> +
>
> I'm afraid I don't quite understand this...
>
>> -     if (!map->cache_bypass && map->format.format_write) {
>> +     if (!map->cache_bypass && map->cache_registers) {
>>               ret = regcache_write(map, reg, val);
>
> ...I think it's mostly to service this check here, but looking at the
> code I can't quite think why the code is doing what it's doing - I
> suspect we should just remove the check for format_write() here.  I
> think it was there to support potential bulk writes from the cache code
> (which we don't do yet) but we're not actually doing those and it's not
> clear that this should be doing that anyway.
>

>From my understanding of the code it is done because the caching is
handled differently for cases when format_write() and format_reg(),
format_val() are provided.
In case of 'format_write' the regcache_write() is called in
_regmap_write() directly whereas when format_reg(), format_val() are
there _regmap_write() calls _regmap_raw_write() which in turn calls
regcache_write(). If I remove that variable and corresponding check
then regcache_write() would be called twice in the case of
format_reg(), format_val(), when _regmap_write() is called, would it
not? I apologise if I miss something obvious and that is not a case(or
issue).

>>       int ret;
>> +     void *context = (map->bus) ? map : map->bus_context;
>> +
>
> Can you please make this a static inline regmap_map_get_context() or
> something?  The same thing appears in quite a few places and the terery
> operator isn't great at the best of times.
>

Will do in the next version of this patch.


Completely unrelated off-topic question: the following code in
regmap_bulk_write()

...

if (map->use_single_rw) {
    for (i = 0; i < val_count; i++) {
        ret = regmap_raw_write(map,
                                           reg + (i * map->reg_stride),
                                           val + (i * val_bytes),
                                           val_bytes);
        if (ret != 0)
            return ret;
    }
}

....

Would it not deadlock, since both regmap_bulk_write() and
regmap_raw_write() call map->lock(...)?
Once again, sorry for off-topic, I just didn't want to start a new
thread because of what very well may by my poor understanding of the
code(I'll submit a patch to change regmap_raw_write() to
_regmap_raw_write() If I am correct).
