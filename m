Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaI2QYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:24:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaI2QYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:24:44 -0400
Date: Mon, 29 Sep 2014 12:23:47 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-ima-devel@lists.sourceforge.net, dmitry.kasatkin@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/4] evm: skip replacing EVM signature with HMAC on
 read-only filesystem
Message-ID: <20140929162347.GA12303@kroah.com>
References: <cover.1411560295.git.d.kasatkin@samsung.com>
 <aa21c2c52e3cd17825be21aa29ca88019296a712.1411560295.git.d.kasatkin@samsung.com>
 <1412007271.3508.46.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412007271.3508.46.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 12:14:31PM -0400, Mimi Zohar wrote:
> On Wed, 2014-09-24 at 15:07 +0300, Dmitry Kasatkin wrote: 
> > If filesystem is mounted read-only or file is immutable, updating
> > xattr will fail. This is a usual case during early boot until
> > filesystem is remount read-write. This patch verifies conditions
> > to skip unnecessary attempt to calculate HMAC and set xattr.
> > 
> > Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > ---
> >  security/integrity/evm/evm_main.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > index 9685af3..a30be77 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -162,9 +162,14 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  					(const char *)xattr_data, xattr_len,
> >  					calc.digest, sizeof(calc.digest));
> >  		if (!rc) {
> > -			/* we probably want to replace rsa with hmac here */
> > -			evm_update_evmxattr(dentry, xattr_name, xattr_value,
> > -				   xattr_value_len);
> > +			/* Replace RSA with HMAC if not mounted readonly and
> > +			 * not immutable
> > +			 */
> > +			if (!IS_RDONLY(dentry->d_inode) &&
> > +					!IS_IMMUTABLE(dentry->d_inode))
> 
> Previously patches conformed to Lindent, unless there was a valid reason
> not to use it, like conflicting with checkpatch.pl.  Joe Perches
> submitted a patch to remove it from the Documentation/CodingStyle a
> while ago -  https://lkml.org/lkml/2013/2/11/390 and recommends using
> "checkpatch.pl --fix" instead.
> 
> Andrew, Greg, what is the current best practice?

I don't understand, what is wrong with the formatting of this patch?  It
looks ok to me.  If you want to indent the second line of the if to the
left some more, that's fine, but just minor nits, nothing major at all.

thanks,

greg k-h
