Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3HUGBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:01:34 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41763 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3HUGBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:01:33 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <20130820140447.GL27005@ZenIV.linux.org.uk>
References: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
	<20130820055153.GH27005@ZenIV.linux.org.uk>
	<CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
	<20130820073622.GK27005@ZenIV.linux.org.uk>
	<20130820140447.GL27005@ZenIV.linux.org.uk>
Date: Wed, 21 Aug 2013 11:31:32 +0530
X-Google-Sender-Auth: ptFKOEQEIt1fQM6gqIC_gXX3j7s
Message-ID: <CAKZGPAPX+cDWJorAnXkKRLtGijKtJgfU_8WLpfjvbkXSUv9UFA@mail.gmail.com>
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

On Tue, Aug 20, 2013 at 7:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 20, 2013 at 08:36:22AM +0100, Al Viro wrote:
>
>> Aha.  _That_ is a bug, all right - dynamic_dname() is simply not suitable
>> for that kind of uses.  ashmem.c is certainly abusing shmem_file_setup();
>> feeding that kind of mess as dentry name is a Bad Idea(tm).  Anyway,
>> I'd suggest this for a fix:
>>
>>       va_list args;
>>       size_t sz;
>>       va_start(args, fmt);
>>       sz = vsnprintf(NULL, 0, fmt, args) + 1;
>>       va_end(args);
>>       if (sz > buflen)
>>               return ERR_PTR(-ENAMETOOLONG);
>>       va_start(args, fmt);
>>       buffer += buflen - sz;
>>       vsprintf(buffer, fmt, args);
>>       va_end(args);
>>       return buffer;
>>
>> Either right in dynamic_dname(), or as possibly_fucking_long_dname(),
>> to be used by shmem.c...
>
> Actually, looking at the users of dynamic_dname()...  Most of them are
> fine with dynamic_dname() as it is, with 2 possible exceptions:
> hugetlb_dname() and shmem_dname().  Both are using "/%s (deleted)",
> dentry->d_name.name as format...  So the solution above may very
> well be an overkill; something like
>
> char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
> {
>         char *end = buffer + buflen;
>         /* these dentries are never renamed, so d_lock is not needed */
>         if (prepend(&end, &buflen, " (deleted)", 11) ||
>             prepend_name(&end, &buflen, &dentry->d_name) ||
>             prepend(&end, &buflen, "/", 1))
>                 end = ERR_PTR(-ENAMETOOLONG);
>         return end;
> }
>
> will do for those two.  Care to test the diff below?
Patch works fine.

Tested-by: Arun KS<arunks.linux@gmail.com>

Thanks,
Arun
>
> cope with potentially long ->d_dname() output for shmem/hugetlb
>
> dynamic_dname() is both too much and too little for those - the
> output may be well in excess of 64 bytes dynamic_dname() assumes
> to be enough (thanks to ashmem feeding really long names to
> shmem_file_setup()) and vsnprintf() is an overkill for those
> guys.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 87bdb53..83cfb83 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2724,6 +2724,17 @@ char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
>         return memcpy(buffer, temp, sz);
>  }
>
> +char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
> +{
> +       char *end = buffer + buflen;
> +       /* these dentries are never renamed, so d_lock is not needed */
> +       if (prepend(&end, &buflen, " (deleted)", 11) ||
> +           prepend_name(&end, &buflen, &dentry->d_name) ||
> +           prepend(&end, &buflen, "/", 1))
> +               end = ERR_PTR(-ENAMETOOLONG);
> +       return end;
> +}
> +
>  /*
>   * Write full pathname from the root of the filesystem into the buffer.
>   */
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index a3f868a..4e5f332 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -916,14 +916,8 @@ static int get_hstate_idx(int page_size_log)
>         return h - hstates;
>  }
>
> -static char *hugetlb_dname(struct dentry *dentry, char *buffer, int buflen)
> -{
> -       return dynamic_dname(dentry, buffer, buflen, "/%s (deleted)",
> -                               dentry->d_name.name);
> -}
> -
>  static struct dentry_operations anon_ops = {
> -       .d_dname = hugetlb_dname
> +       .d_dname = simple_dname
>  };
>
>  /*
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index b90337c..4a12532 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -336,6 +336,7 @@ extern int d_validate(struct dentry *, struct dentry *);
>   * helper function for dentry_operations.d_dname() members
>   */
>  extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
> +extern char *simple_dname(struct dentry *, char *, int);
>
>  extern char *__d_path(const struct path *, const struct path *, char *, int);
>  extern char *d_absolute_path(const struct path *, char *, int);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 8335dbd..e43dc55 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2909,14 +2909,8 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
>
>  /* common code */
>
> -static char *shmem_dname(struct dentry *dentry, char *buffer, int buflen)
> -{
> -       return dynamic_dname(dentry, buffer, buflen, "/%s (deleted)",
> -                               dentry->d_name.name);
> -}
> -
>  static struct dentry_operations anon_ops = {
> -       .d_dname = shmem_dname
> +       .d_dname = simple_dname
>  };
>
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
