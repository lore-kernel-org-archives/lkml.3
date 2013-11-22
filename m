Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3KVX0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:26:06 -0500
Received: from mdfmta005.mxout.tch.inty.net ([91.221.169.46]:39241 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755484Ab3KVX0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:26:05 -0500
Message-ID: <528FE805.1080001@lougher.demon.co.uk>
Date: Fri, 22 Nov 2013 23:25:57 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
CC: phillip@squashfs.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] double free in decompressor.c
References: <CAGG-pURFGv2my_u8Okv5bft1SzpyGH8ccYYonjTFuZ7D=92x1g@mail.gmail.com>
In-Reply-To: <CAGG-pURFGv2my_u8Okv5bft1SzpyGH8ccYYonjTFuZ7D=92x1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-MDF-HostID: 18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/13 21:50, Geyslan Gregório Bem wrote:
> Coverity caught double free possibility (CID 1130962).
>
> I can patch this, but I have to know if is correct to free comp_opts
> in the function squashfs_decompressor_create() or it had to be done in
> the caller. My bet is the caller.
>
>
> 128void *squashfs_decompressor_setup(struct super_block *sb, unsigned
> short flags)
> 129{
> 130        struct squashfs_sb_info *msblk = sb->s_fs_info;
> 131        void *stream, *comp_opts = get_comp_opts(sb, flags);
> 132
>
> 1. Condition "IS_ERR(comp_opts)", taking false branch
> 133        if (IS_ERR(comp_opts))
> 134                return comp_opts;
> 135
>
> 2. freed_arg: "squashfs_decompressor_create(struct squashfs_sb_info *,
> void *)" frees "comp_opts".[show details]
> 136        stream = squashfs_decompressor_create(msblk, comp_opts);
>
> 3. Condition "IS_ERR(stream)", taking true branch
> 137        if (IS_ERR(stream))

FALSE positive.

squashfs_decompressor_create() frees comp_opts only on success.

If IS_ERR(stream) is true, then comp_opts has not been freed by
squashfs_decompressor_create().

Phillip


>
> CID 1130962 (#1 of 1): Double free (USE_AFTER_FREE)4. double_free:
> Calling "kfree(void const *)" frees pointer "comp_opts" which has
> already been freed.
> 138                kfree(comp_opts);
> 139
> 140        return stream;
> 141}
>
>

