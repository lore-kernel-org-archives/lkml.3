Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3FDXAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:00:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33608 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753896Ab3FDXAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:00:30 -0400
Message-ID: <1370386829.2385.95.camel@joe-AO722>
Subject: Re: [PATCH] jfs: Convert jfs_error to jfs_sb_err
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 04 Jun 2013 16:00:29 -0700
In-Reply-To: <51AE6964.1090002@oracle.com>
References: <76a131f2845ec3f75dd80be6808e513ae3ea4255.1370323137.git.joe@perches.com>
	 <51AE0F37.3020104@oracle.com> <1370363289.2385.41.camel@joe-AO722>
	 <51AE6964.1090002@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added linux-fsdevel to cc)

On Tue, 2013-06-04 at 17:25 -0500, Dave Kleikamp wrote:
> On 06/04/2013 11:28 AM, Joe Perches wrote:

> > This one takes a super_block * and emits a logging message
> > so I chose jfs_sb_err to try to describe the sb * bit.
> > 
> > I like the _err suffix is a bit better than the
> > _error suffix as it's a bit more name consistent
> > with other kernel logging mechanisms like dev_err,
> > pr_err, etc, but if you want to remain consistent
> > with other fs/,,, fine by me.
> 
> It's more than a logging mechanism. It will also make the file-system
> read-only, or panic (or do nothing else) depending on the errors= mount
> option.
> 
> > I think the other fs _error names are sub-optimal.
> 
> They perform a similar function, so I'm going to leave it as is. Even if
> the names are imperfect, it's good to have some similarities in the
> names of the functions between file systems.
> 
> > These functions are a bit overloaded too when
> > CONFIG_PRINTK is not enabled.  The format and args
> > still exist in code and I believe can not be
> > optimized away by the compiler
> > 
> > I think using macro or an in-place expansion to
> > separate the 2 parts of the reporting and then the
> > handling of of the error would be better as it
> > would allow smaller embedded use.
> 
> I can hold off on this a little while if you want to explore that idea
> as an alternate.

Nah.  Is anyone really using jfs in embedded?
I'll just rename it back to jfs_error and resubmit.

for ext[234]_error, it'd maybe make _some_ sense though.

maybe a macro like below could work

#ifdef CONFIG_PRINTK
#define ext4_error(sb, fmt, ...)		\
	ext4_error(sb, fmt, ##__VA_ARGS__)
#else
#define ext4_error(sb, fmt, ...)		\
do {						\
	if (0)					\
		printk(fmt, ##__VA_ARGS__);	\
	ext4_handle_error(sb);			\
} while (0)
#endif

This would allow the compiler to optimize away the
formats and unused args to reduce code size.

That style would even work for jfs if anyone
would really want it.

> > I submitted a patch a few years ago to do that too.
> > Dunno what happened to it,

> I might have put it off and then forgot about it. I don't remember it
> specifically.

No worries.
jfs didn't have any format/argument mismatches anyway.
I think all the other filesystems did though.


