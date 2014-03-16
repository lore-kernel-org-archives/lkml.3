Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaCPQ1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:27:35 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:38678 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaCPQ1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:27:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 1/1] NTFS: Logging clean-up
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=US-ASCII
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <1394986370.5689.17.camel@joe-AO722>
Date: Sun, 16 Mar 2014 16:27:28 +0000
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <DB070619-215B-407E-827E-B9F383465DE2@tuxera.com>
References: <20140316132743.9e869dd95f2022572edc1745@skynet.be> <3BC5D985-1160-4685-8656-A01350DECEBB@tuxera.com> <1394986370.5689.17.camel@joe-AO722>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16 Mar 2014, at 16:12, Joe Perches <joe@perches.com> wrote:

> On Sun, 2014-03-16 at 15:53 +0000, Anton Altaparmakov wrote:
>> Hi,
>> 
>> Looks good, thanks.  You can add my Acked-by if you like.  Can I assume you have test it builds?
>> 
>> Andrew, can you please merge this via your patch series?  Thanks!
> 
> I think a few things need fixing first

Yes, quite right - I had assume that had been tested!

> On 16 Mar 2014, at 12:27, Fabian Frederick <fabf@skynet.be> wrote:
>> 
>>> -All printk(KERN_foo converted to pr_foo().
>>> -Add pr_fmt and remove redundant prefixes.
> 
> I'm not sure there are "redundant prefixes"
> 
> This changes prefixes from "NTFS-fs" to "ntfs"
> and should be at a minimum mentioned in the
> changelog.

As long as it says ntfs in the string so dmesg output can be "grep -i ntfs"-ed I am not fussed.

> The va_end location needs moving.

Yes, well spotted, thanks.

> Converting printk(KERN_DEBUG -> pr_debug will
> not always emit that message now.  Now, only if
> DEBUG is #defined or dynamic_debugging is enabled
> for the build _and_ the message is specifically
> enabled will the message be output.
> 
> So, the debugging output has been silenced by default.
> 
> That's not necessarily good.

No that is not good at all.  I didn't know about those pr_debug semantics so thank you for pointing them out.  That needs fixing otherwise we might as well not have the messages at all...  Being able to enable all ntfs debug messages using a insmod option or via /proc as is at the moment is a very valuable debugging too and I have scripts that use this so am not keen on this being changed at all.

Fabian, can you please fix the issues pointed out by Joe and also please make sure you actually test it!

Thanks a lot in advance!

Best regards,

	Anton

> diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
> []
>>> @@ -59,17 +53,15 @@ void __ntfs_warning(const char *function, const struct super_block *sb,
>>> #endif
>>> 	if (function)
>>> 		flen = strlen(function);
>>> -	spin_lock(&err_buf_lock);
>>> 	va_start(args, fmt);
>>> -	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
>>> +	vaf.fmt = fmt;
>>> +	vaf.va = &args;
> 
>>> 	va_end(args);
> 
> This va_end should be moved after the pr_warns.
> 
>>> 	if (sb)
>>> -		printk(KERN_ERR "NTFS-fs warning (device %s): %s(): %s\n",
>>> -				sb->s_id, flen ? function : "", err_buf);
>>> +		pr_warn("(device %s): %s(): %pV\n",
>>> +			sb->s_id, flen ? function : "", &vaf);
>>> 	else
>>> -		printk(KERN_ERR "NTFS-fs warning: %s(): %s\n",
>>> -				flen ? function : "", err_buf);
>>> -	spin_unlock(&err_buf_lock);
>>> +		pr_warn("%s(): %pV\n", flen ? function : "", &vaf);
>>> }
>>> 
>>> /**
>>> @@ -94,6 +86,7 @@ void __ntfs_warning(const char *function, const struct super_block *sb,
>>> void __ntfs_error(const char *function, const struct super_block *sb,
>>> 		const char *fmt, ...)
>>> {
>>> +	struct va_format vaf;
>>> 	va_list args;
>>> 	int flen = 0;
>>> 
>>> @@ -103,17 +96,15 @@ void __ntfs_error(const char *function, const struct super_block *sb,
>>> #endif
>>> 	if (function)
>>> 		flen = strlen(function);
>>> -	spin_lock(&err_buf_lock);
>>> 	va_start(args, fmt);
>>> -	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
>>> +	vaf.fmt = fmt;
>>> +	vaf.va = &args;
>>> 	va_end(args);
> 
> Here too
> 
>>> 	if (sb)
>>> -		printk(KERN_ERR "NTFS-fs error (device %s): %s(): %s\n",
>>> -				sb->s_id, flen ? function : "", err_buf);
>>> +		pr_err("(device %s): %s(): %pV\n",
>>> +		       sb->s_id, flen ? function : "", &vaf);
>>> 	else
>>> -		printk(KERN_ERR "NTFS-fs error: %s(): %s\n",
>>> -				flen ? function : "", err_buf);
>>> -	spin_unlock(&err_buf_lock);
>>> +		pr_err("%s(): %pV\n", flen ? function : "", &vaf);


-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

