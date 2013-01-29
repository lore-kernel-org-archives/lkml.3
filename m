Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3A2W1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:27:04 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38619 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A2W1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:27:01 -0500
Message-ID: <1359498360.816.40.camel@falcor1.watson.ibm.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 Jan 2013 17:26:00 -0500
In-Reply-To: <20130129201047.GC21002@redhat.com>
References: <20130125210157.GA13152@redhat.com>
	 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	 <20130128151527.GA5868@redhat.com>
	 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
	 <20130128185625.GC5868@redhat.com> <1359404149.3906.75.camel@falcor1>
	 <20130128202241.GB14405@redhat.com> <1359424135.3906.247.camel@falcor1>
	 <20130129182012.GA21002@redhat.com>
	 <1359489673.816.25.camel@falcor1.watson.ibm.com>
	 <20130129201047.GC21002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012922-3620-0000-0000-000001076551
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 15:10 -0500, Vivek Goyal wrote:
> On Tue, Jan 29, 2013 at 03:01:13PM -0500, Mimi Zohar wrote:
> 
> [..]
> > > Hi Mimi,
> > > 
> > > Can we add another field to ima_rule_entry, say .enforcement to control
> > > the behavior of .action. Possible values of .enforcement could be, say.
> > > 
> > > ALL
> > > SIGNED_ONLY
> > > 
> > > ALL will be default. And with .action= MEASURE, one could possibly use
> > > .enforcement=SIGNED_ONLY.
> > 
> > Other than the .action being '.action=APPRAISE', not 'MEASURE',
> > something like what you're suggesting, could work.  How about extending
> > the new 'appraise_type=' option?   The appraise_type enforces a
> > particular type (eg. hash, signature) of verification. 
> > 
> > option: appraise_type:= [imasig[,signed_only]]
> > eg. appraise_type=imasig,signed_only
> 
> Right. Given the fact that signed_only things work only for appraise, it
> probably is better to extend ima_appraise= command line option.
> 
> I just wrote something based on linus tree. That is introduce
> ima_appraise=enforce_labeled_only.
> 
> But I would look at your next branch and try introducing
> imasig_signed_only.
> 
> In the mean time here is the patch I used. I can now boot my unlabeled
> system with "ima_appraise_tcb" and "ima_appraise=enforce_labeled_only".
> 
> But somehow my system has slowed down significantly and I can feel
> slow boot as well as slow file operations on terminal.

The ima_appraise_tcb attempts to appraise all files owned by root, which
is not what you want.  As signatures do not change, you don't need to be
concerned with updating the hash on file close.  Try replacing the
ima_appraise_tcb policy with this one line policy:

appraise fowner=0 func=BPRM_CHECK appraise_type=imasig

thanks,

Mimi


> ---
>  Documentation/kernel-parameters.txt   |    3 ++-
>  security/integrity/ima/ima.h          |    1 +
>  security/integrity/ima/ima_appraise.c |    6 ++++++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/security/integrity/ima/ima_appraise.c
> ===================================================================
> --- linux-2.6.orig/security/integrity/ima/ima_appraise.c	2013-01-18 01:29:29.000000000 -0500
> +++ linux-2.6/security/integrity/ima/ima_appraise.c	2013-01-29 14:56:47.636620835 -0500
> @@ -24,6 +24,8 @@ static int __init default_appraise_setup
>  		ima_appraise = 0;
>  	else if (strncmp(str, "fix", 3) == 0)
>  		ima_appraise = IMA_APPRAISE_FIX;
> +	else if (strncmp(str, "enforce_labeled_only", 21) == 0)
> +		ima_appraise = IMA_APPRAISE_ENFORCE_LABELED_ONLY;
>  	return 1;
>  }
> 
> @@ -144,6 +146,10 @@ out:
>  			ima_fix_xattr(dentry, iint);
>  			status = INTEGRITY_PASS;
>  		}
> +		if ((ima_appraise & IMA_APPRAISE_ENFORCE_LABELED_ONLY) &&
> +		   (status == INTEGRITY_NOLABEL))
> +			status = INTEGRITY_PASS;
> +
>  		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
>  				    op, cause, rc, 0);
>  	} else {
> Index: linux-2.6/security/integrity/ima/ima.h
> ===================================================================
> --- linux-2.6.orig/security/integrity/ima/ima.h	2013-01-18 01:29:29.000000000 -0500
> +++ linux-2.6/security/integrity/ima/ima.h	2013-01-29 14:51:25.762610948 -0500
> @@ -140,6 +140,7 @@ void ima_delete_rules(void);
>  #define IMA_APPRAISE_ENFORCE	0x01
>  #define IMA_APPRAISE_FIX	0x02
>  #define IMA_APPRAISE_MODULES	0x04
> +#define IMA_APPRAISE_ENFORCE_LABELED_ONLY	0x08
> 
>  #ifdef CONFIG_IMA_APPRAISE
>  int ima_appraise_measurement(struct integrity_iint_cache *iint,
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt	2013-01-18 01:29:29.000000000 -0500
> +++ linux-2.6/Documentation/kernel-parameters.txt	2013-01-29 14:52:44.455613365 -0500
> @@ -1064,7 +1064,8 @@ bytes respectively. Such letter suffixes
>  			Set number of hash buckets for inode cache.
> 
>  	ima_appraise=	[IMA] appraise integrity measurements
> -			Format: { "off" | "enforce" | "fix" }
> +			Format: { "off" | "enforce" | "fix" |
> +				  "enforce_labeled_only}
>  			default: "enforce"
> 
>  	ima_appraise_tcb [IMA]
> 



