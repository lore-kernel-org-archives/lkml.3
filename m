Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3HTIEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:04:02 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:43031 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3HTID5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:03:57 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <20130820073622.GK27005@ZenIV.linux.org.uk>
References: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
	<20130820055153.GH27005@ZenIV.linux.org.uk>
	<CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
	<20130820073622.GK27005@ZenIV.linux.org.uk>
Date: Tue, 20 Aug 2013 13:33:56 +0530
X-Google-Sender-Auth: BJL5UrKLJ3glF-mT9WLL5LFkJHw
Message-ID: <CAKZGPAP030XW2C1b9Fkxr=zutQ0KWfpVD=Jk+iWpCoQRjW4A1g@mail.gmail.com>
Subject: Re: [PATCH v1] seq_file: Fix overflow condition in seq_commit
From: Arun KS <arunks.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al Viro,

On Tue, Aug 20, 2013 at 1:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 20, 2013 at 12:51:56PM +0530, Arun KS wrote:
>
>> d_path expects the pathname to be less than 64 bytes. If its more than
>> 64, it returns -ENAMETOOLONG.
>
> ?!?!?  d_path() does not expect anything of that sort - it can very
> well produce names much longer, without ENAMETOOLONG.
>
>> char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
>>                         const char *fmt, ...)
>> {
>>         va_list args;
>>         char temp[64];
>>         int sz;
>>
>>         va_start(args, fmt);
>>         sz = vsnprintf(temp, sizeof(temp), fmt, args) + 1;
>>         va_end(args);
>>
>>         if (sz > sizeof(temp) || sz > buflen)
>>                 return ERR_PTR(-ENAMETOOLONG);
>>
>>         buffer += buflen - sz;
>>         return memcpy(buffer, temp, sz);
>> }
>
> Aha.  _That_ is a bug, all right - dynamic_dname() is simply not suitable
> for that kind of uses.  ashmem.c is certainly abusing shmem_file_setup();
> feeding that kind of mess as dentry name is a Bad Idea(tm).  Anyway,
> I'd suggest this for a fix:
>
>         va_list args;
>         size_t sz;
>         va_start(args, fmt);
>         sz = vsnprintf(NULL, 0, fmt, args) + 1;
>         va_end(args);
>         if (sz > buflen)
>                 return ERR_PTR(-ENAMETOOLONG);
>         va_start(args, fmt);
>         buffer += buflen - sz;
>         vsprintf(buffer, fmt, args);
>         va_end(args);
>         return buffer;
>
> Either right in dynamic_dname(), or as possibly_fucking_long_dname(),
> to be used by shmem.c...

This fixes the problem.

Thanks,
Arun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
