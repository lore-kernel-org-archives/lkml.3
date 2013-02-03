Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3BCN7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:59:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28050 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3BCN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:59:38 -0500
Message-ID: <510E6D3F.2060200@oracle.com>
Date: Sun, 03 Feb 2013 07:59:27 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [RFC] setxattr bugs
References: <20130203043046.GR4503@ZenIV.linux.org.uk>
In-Reply-To: <20130203043046.GR4503@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2013 10:30 PM, Al Viro wrote:
> 	* JFS, since 2005: setxattr(name, "system.posix_acl_access", NULL, 0, 0)
> succeeds, creating an empty EA with "system.posix_acl_access" as name.
> Validity checks should apply _after_
>         if (value == NULL) {    /* empty EA, do not remove */
>                 value = "";
>                 value_len = 0;
>         }
> and not before it.

This is probably a hold-over from weird OS/2 behavior that we really
don't need to keep.

> 	* reiserfs, since 2009: setxattr(name, attr_name, NULL, 0, 0) is
> treated as removexattr(name, attr_name), not as emptying given xattr.
> 
> 	The question is, does either of those cross into "established
> weirdness in ABI" or are they still at the "bugs to be fixed" stage?
> 
> 	FWIW, I'm seriously tempted to stop passing NULL as the
> third argument of ->setxattr(), essentially taking all those
> if (!value) value = ""; pieces from individual ->setxattr() instances
> to __vfs_setxattr_noperm() (all other callers of ->setxattr() never
> pass NULL data or 0 size, so it's irrelevant for them).  Would fix
> both jfs and reiserfs weirdness....
> 
> 	Objections?

no objection from me. I can clean up the jfs code so that it no longer
saves empty xattrs.

Thanks,
Shaggy
