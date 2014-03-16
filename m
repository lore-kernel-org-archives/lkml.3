Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaCPQMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:12:55 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:49483 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752646AbaCPQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:12:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3743:3865:3867:3868:3870:3871:3872:3873:3874:4184:4250:4321:4605:5007:6119:6691:7652:7903:9040:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12663:12740:13095:13161:13229:14093:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: verse99_362e621c25319
X-Filterd-Recvd-Size: 3831
Message-ID: <1394986370.5689.17.camel@joe-AO722>
Subject: Re: [PATCH 1/1] NTFS: Logging clean-up
From: Joe Perches <joe@perches.com>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Sun, 16 Mar 2014 09:12:50 -0700
In-Reply-To: <3BC5D985-1160-4685-8656-A01350DECEBB@tuxera.com>
References: <20140316132743.9e869dd95f2022572edc1745@skynet.be>
	 <3BC5D985-1160-4685-8656-A01350DECEBB@tuxera.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 15:53 +0000, Anton Altaparmakov wrote:
> Hi,
> 
> Looks good, thanks.  You can add my Acked-by if you like.  Can I assume you have test it builds?
> 
> Andrew, can you please merge this via your patch series?  Thanks!

I think a few things need fixing first

> On 16 Mar 2014, at 12:27, Fabian Frederick <fabf@skynet.be> wrote:
> 
> > -All printk(KERN_foo converted to pr_foo().
> > -Add pr_fmt and remove redundant prefixes.

I'm not sure there are "redundant prefixes"

This changes prefixes from "NTFS-fs" to "ntfs"
and should be at a minimum mentioned in the
changelog.

The va_end location needs moving.

Converting printk(KERN_DEBUG -> pr_debug will
not always emit that message now.  Now, only if
DEBUG is #defined or dynamic_debugging is enabled
for the build _and_ the message is specifically
enabled will the message be output.

So, the debugging output has been silenced by default.

That's not necessarily good.

> > diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
[]
> > @@ -59,17 +53,15 @@ void __ntfs_warning(const char *function, const struct super_block *sb,
> > #endif
> > 	if (function)
> > 		flen = strlen(function);
> > -	spin_lock(&err_buf_lock);
> > 	va_start(args, fmt);
> > -	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
> > +	vaf.fmt = fmt;
> > +	vaf.va = &args;

> > 	va_end(args);

This va_end should be moved after the pr_warns.

> > 	if (sb)
> > -		printk(KERN_ERR "NTFS-fs warning (device %s): %s(): %s\n",
> > -				sb->s_id, flen ? function : "", err_buf);
> > +		pr_warn("(device %s): %s(): %pV\n",
> > +			sb->s_id, flen ? function : "", &vaf);
> > 	else
> > -		printk(KERN_ERR "NTFS-fs warning: %s(): %s\n",
> > -				flen ? function : "", err_buf);
> > -	spin_unlock(&err_buf_lock);
> > +		pr_warn("%s(): %pV\n", flen ? function : "", &vaf);
> > }
> > 
> > /**
> > @@ -94,6 +86,7 @@ void __ntfs_warning(const char *function, const struct super_block *sb,
> > void __ntfs_error(const char *function, const struct super_block *sb,
> > 		const char *fmt, ...)
> > {
> > +	struct va_format vaf;
> > 	va_list args;
> > 	int flen = 0;
> > 
> > @@ -103,17 +96,15 @@ void __ntfs_error(const char *function, const struct super_block *sb,
> > #endif
> > 	if (function)
> > 		flen = strlen(function);
> > -	spin_lock(&err_buf_lock);
> > 	va_start(args, fmt);
> > -	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
> > +	vaf.fmt = fmt;
> > +	vaf.va = &args;
> > 	va_end(args);

Here too

> > 	if (sb)
> > -		printk(KERN_ERR "NTFS-fs error (device %s): %s(): %s\n",
> > -				sb->s_id, flen ? function : "", err_buf);
> > +		pr_err("(device %s): %s(): %pV\n",
> > +		       sb->s_id, flen ? function : "", &vaf);
> > 	else
> > -		printk(KERN_ERR "NTFS-fs error: %s(): %s\n",
> > -				flen ? function : "", err_buf);
> > -	spin_unlock(&err_buf_lock);
> > +		pr_err("%s(): %pV\n", flen ? function : "", &vaf);


