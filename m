Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3KWBOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:14:55 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49381 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3KWBOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:14:52 -0500
MIME-Version: 1.0
In-Reply-To: <528FE805.1080001@lougher.demon.co.uk>
References: <CAGG-pURFGv2my_u8Okv5bft1SzpyGH8ccYYonjTFuZ7D=92x1g@mail.gmail.com>
	<528FE805.1080001@lougher.demon.co.uk>
Date: Fri, 22 Nov 2013 23:14:51 -0200
Message-ID: <CAGG-pUQZGpR=gmKG9bhN+a-YR9WoNWZeN+2tvVantnsUWOf41g@mail.gmail.com>
Subject: Re: [RFC PATCH] double free in decompressor.c
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: phillip@squashfs.org.uk, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/22 Phillip Lougher <phillip@lougher.demon.co.uk>:
> On 22/11/13 21:50, Geyslan Gregório Bem wrote:
>>
>> Coverity caught double free possibility (CID 1130962).
>>
>> I can patch this, but I have to know if is correct to free comp_opts
>> in the function squashfs_decompressor_create() or it had to be done in
>> the caller. My bet is the caller.
>>
>>
>> 128void *squashfs_decompressor_setup(struct super_block *sb, unsigned
>> short flags)
>> 129{
>> 130        struct squashfs_sb_info *msblk = sb->s_fs_info;
>> 131        void *stream, *comp_opts = get_comp_opts(sb, flags);
>> 132
>>
>> 1. Condition "IS_ERR(comp_opts)", taking false branch
>> 133        if (IS_ERR(comp_opts))
>> 134                return comp_opts;
>> 135
>>
>> 2. freed_arg: "squashfs_decompressor_create(struct squashfs_sb_info *,
>> void *)" frees "comp_opts".[show details]
>> 136        stream = squashfs_decompressor_create(msblk, comp_opts);
>>
>> 3. Condition "IS_ERR(stream)", taking true branch
>> 137        if (IS_ERR(stream))
>
>
> FALSE positive.
>
> squashfs_decompressor_create() frees comp_opts only on success.
>
> If IS_ERR(stream) is true, then comp_opts has not been freed by
> squashfs_decompressor_create().
>
> Phillip
>
>
>
>>
>> CID 1130962 (#1 of 1): Double free (USE_AFTER_FREE)4. double_free:
>> Calling "kfree(void const *)" frees pointer "comp_opts" which has
>> already been freed.
>> 138                kfree(comp_opts);
>> 139
>> 140        return stream;
>> 141}
>>
>>
>

Philip, set as false positive in Coverity. Thanks.

-- 
Regards,

Geyslan G. Bem
hackingbits.com
