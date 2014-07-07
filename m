Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaGGPpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:45:04 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43170 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaGGPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:45:00 -0400
Message-ID: <1404747894.3029.58.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmitry.kasatkin@gmail.com
Date: Mon, 07 Jul 2014 11:44:54 -0400
In-Reply-To: <53BAA281.7040903@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
	 <dc5977267c662c98f02cd637dd44c42be850916f.1404475462.git.d.kasatkin@samsung.com>
	 <1404734207.3029.22.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53BAA281.7040903@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070715-0928-0000-0000-0000032E12A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 16:37 +0300, Dmitry Kasatkin wrote: 
> On 07/07/14 14:56, Mimi Zohar wrote:
> > On Fri, 2014-07-04 at 15:05 +0300, Dmitry Kasatkin wrote: 

> >>
> >> +/**
> > This is the kernel-doc delimiter.
> >
> >> + * ima_calc_file_hash - calculae file hash
> >> + *
> > Missing kernel-doc argument descriptions.  Refer to
> > Documentation/kernel-doc-nano-HOWTO.txt.

Not defining the arguments results in a kernel-doc warning.  Providing
kernel-doc is nice, but is unnecessary in this case, as it isn't an
exported loadable module, nor an externally visible function to other
kernel files.  Either remove the extra asterisk, making it a regular
comment, or add the arguments.

> 
> There is no need to explain arguments as they self-evident.
> 
> >> + * if ima_ahash_minsize parameter is non-zero, this function uses
> >> + * ahash for hash caclulation. ahash performance varies for different
> >> + * data sizes on different crypto accelerators. shash performance might
> >> + * be better for small file. 'ima.ahash_minsize' module parameter allows
> >> + * to specify the best value for the system.
> >> + *
> >> + * If ahash fails, it fallbacks to shash.
> >> + */
> >> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >> +{
> >> +	loff_t i_size;
> >> +	int rc;
> >> +
> >> +	i_size = i_size_read(file_inode(file));
> >> +
> >> +	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
> >> +		rc = ima_calc_file_ahash(file, hash);
> >> +		if (!rc)
> >> +			return 0;
> >> +	}
> >> +
> >> +	return ima_calc_file_shash(file, hash);
> >> +}
> > If the crypto accelerator fails, it falls back to using shash.  Is their
> > any indication that the HW error is intermittent or persistent?  Should
> > ima_ahash_minsize be reset?
> 
> If hw constantly does not work then it is simply broken.

True

> You want to be protected from "random" failures.

> For me it is not the case either... If it works then it works...

This discussion isn't about your particular HW environment, but a
general question.  For example, suppose we were discussing a laptop with
a HW crypto accelerator.  If the HW crypto broke, I would at least want
to be able to quiesce the system properly.  I'd most likely want to be
able to continue using my laptop with software crypto.

> > If the crypto accelerator, built as a kernel module, is removed,
> > ima_ahash_minsize would still be set.  It would continue to use ahash.
> > Is this the correct behavior? Or should ima_ahash_minsize be reset?
> >
> 
> It cannot be removed, because it is used and module usage counter
> protects from removing...

Ok

Mimi

