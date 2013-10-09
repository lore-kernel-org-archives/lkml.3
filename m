Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3JIWAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:00:20 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:43201 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752136Ab3JIWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:00:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2693:2828:2859:2901:2904:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3657:3770:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3
X-HE-Tag: club18_24c91a089e57
X-Filterd-Recvd-Size: 3833
Message-ID: <1381356014.2050.28.camel@joe-AO722>
Subject: Re: [PATCH v3] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 15:00:14 -0700
In-Reply-To: <5255D023.2030907@gmail.com>
References: <5255D023.2030907@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 08:52 +1100, Ryan Mallon wrote:
> Some setuid binaries will allow reading of files which have read
> permission by the real user id. This is problematic with files which
> use %pK because the file access permission is checked at open() time,
> but the kptr_restrict setting is checked at read() time. If a setuid
> binary opens a %pK file as an unprivileged user, and then elevates
> permissions before reading the file, then kernel pointer values may be
> leaked.

Please review the patch I sent you a little more.

> Fix this by adding a check that in addition to the current process
> having CAP_SYSLOG, that effective user and group ids are equal to the
> real ids. If a setuid binary reads the contents of a file which uses
> %pK then the pointer values will be printed as NULL if the real user
> is unprivileged.

[]

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1312,11 +1313,37 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}

Move the interrupt tests and pK-error printk
into case 1:

It's the only case where CAP_SYSLOG needs to be
tested so it doesn't need to be above the switch.


> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> +
> +		switch (kptr_restrict) {
> +		case 0:
> +			/* Always print %pK values */
> +			break;
> +		case 1: {
> +			/*
> +			 * Only print the real pointer value if the current
> +			 * process has CAP_SYSLOG and is running with the
> +			 * same credentials it started with. This is because
> +			 * access to files is checked at open() time, but %pK
> +			 * checks permission at read() time. We don't want to
> +			 * leak pointer values if a binary opens a file using
> +			 * %pK and then elevates privileges before reading it.
> +			 */
> +			const struct cred *cred = current_cred();
> +
> +			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +			    !uid_eq(cred->euid, cred->uid) ||
> +			    !gid_eq(cred->egid, cred->gid))
> +				ptr = NULL;
> +			break;
> +		}
> +		case 2:
> +		default:
> +			/* Always print 0's for %pK */
>  			ptr = NULL;
> +			break;
> +		}
>  		break;
> +
>  	case 'N':
>  		switch (fmt[1]) {
>  		case 'F':
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



