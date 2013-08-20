Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3HTHgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:36:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53222 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HTHg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:36:27 -0400
Date: Tue, 20 Aug 2013 08:36:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arun KS <arunks.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Subject: Re: [PATCH v1] seq_file: Fix overflow condition in seq_commit
Message-ID: <20130820073622.GK27005@ZenIV.linux.org.uk>
References: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
 <20130820055153.GH27005@ZenIV.linux.org.uk>
 <CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:51:56PM +0530, Arun KS wrote:

> d_path expects the pathname to be less than 64 bytes. If its more than
> 64, it returns -ENAMETOOLONG.

?!?!?  d_path() does not expect anything of that sort - it can very
well produce names much longer, without ENAMETOOLONG.

> char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
>                         const char *fmt, ...)
> {
>         va_list args;
>         char temp[64];
>         int sz;
> 
>         va_start(args, fmt);
>         sz = vsnprintf(temp, sizeof(temp), fmt, args) + 1;
>         va_end(args);
> 
>         if (sz > sizeof(temp) || sz > buflen)
>                 return ERR_PTR(-ENAMETOOLONG);
> 
>         buffer += buflen - sz;
>         return memcpy(buffer, temp, sz);
> }

Aha.  _That_ is a bug, all right - dynamic_dname() is simply not suitable
for that kind of uses.  ashmem.c is certainly abusing shmem_file_setup();
feeding that kind of mess as dentry name is a Bad Idea(tm).  Anyway,
I'd suggest this for a fix:

	va_list args;
	size_t sz;
	va_start(args, fmt);
	sz = vsnprintf(NULL, 0, fmt, args) + 1;
	va_end(args);
	if (sz > buflen)
		return ERR_PTR(-ENAMETOOLONG);
	va_start(args, fmt);
	buffer += buflen - sz;
	vsprintf(buffer, fmt, args);
	va_end(args);
	return buffer;

Either right in dynamic_dname(), or as possibly_fucking_long_dname(),
to be used by shmem.c...
