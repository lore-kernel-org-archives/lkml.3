Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3JIAt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:49:26 -0400
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:47234 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752705Ab3JIAtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:49:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2901:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:4321:4605:5007:6119:7652:7903:10004:10044:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,
X-HE-Tag: trade18_6ed19789d255e
X-Filterd-Recvd-Size: 3455
Message-ID: <1381279758.23937.42.camel@joe-AO722>
Subject: Re: [PATCH v2] vsprintf: Check real user/group id for %pK
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
Date: Tue, 08 Oct 2013 17:49:18 -0700
In-Reply-To: <5254A034.5020700@gmail.com>
References: <5254A034.5020700@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 11:15 +1100, Ryan Mallon wrote:
> Some setuid binaries will allow reading of files which have read
> permission by the real user id. This is problematic with files which
> use %pK because the file access permission is checked at open() time,
> but the kptr_restrict setting is checked at read() time. If a setuid
> binary opens a %pK file as an unprivileged user, and then elevates
> permissions before reading the file, then kernel pointer values may be
> leaked.

I think it should explicitly test 0.

Dan? Might this be any problem?

Otherwise, just style notes:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1312,10 +1312,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}
> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> -			ptr = NULL;
> +
> +		/*
> +		 * If kptr_restrict is set to 2, then %pK always prints as
> +		 * NULL. If it is set to 1, then only print the real pointer
> +		 * value if the current proccess has CAP_SYSLOG and is running
> +		 * with the same credentials it started with. This is because
> +		 * access to files is checked at open() time, but %pK checks
> +		 * permission at read() time. We don't want to leak pointer
> +		 * values if a binary opens a file using %pK and then elevates
> +		 * privileges before reading it.
> +		 */
> +		{
> +			const struct cred *cred = current_cred();

Please add #include <linux/cred.h>

> +			if (kptr_restrict == 2 || (kptr_restrict == 1 &&
> +			     (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +			      !uid_eq(cred->euid, cred->uid) ||
> +			      !gid_eq(cred->egid, cred->gid))))
> +				ptr = NULL;
> +		}
>  		break;

Also, it might be easier to read as:

		if (kptr_restrict == 0)
			break;
		else if (kptr_restrict == 1) {
			const struct cred *cred = current_cred();

			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
			    !uid_eq(cred->euid, cred->uid) ||
			    !gid_eq(cred->egid, cred->gid))
				ptr = NULL;
		} else {
			ptr = NULL;
		}
		break;

>  	case 'N':
>  		switch (fmt[1]) {


