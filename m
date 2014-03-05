Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaCEHfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:35:25 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35515 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaCEHfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:35:24 -0500
Date: Tue, 4 Mar 2014 23:35:16 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: linux-mtd@lists.infradead.org, Amul Kumar Saha <amul.saha@samsung.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/2] mtd: Fix the behavior of otp write if
 there is not enough room for data
Message-ID: <20140305073516.GM13420@norris-Latitude-E6410>
References: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
 <b8fb0b78-04b2-41bf-a1f4-6f54039b7829@mary.at.omicron.at>
 <20140305072010.GL13420@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305072010.GL13420@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more things...

On Tue, Mar 04, 2014 at 11:20:10PM -0800, Brian Norris wrote:
> On Tue, Jan 28, 2014 at 09:29:45AM +0100, Christian Riesch wrote:
> > An OTP write shall write as much data as possible to the OTP memory
> > and return the number of bytes that have actually been written.
> > If no data could be written at all due to lack of OTP memory,
> > return -ENOSPC.
[snip]
> > diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
> > index 7aa581f..cf423a6 100644
> > --- a/drivers/mtd/chips/cfi_cmdset_0001.c
> > +++ b/drivers/mtd/chips/cfi_cmdset_0001.c
> > @@ -2387,8 +2387,17 @@ static int cfi_intelext_write_user_prot_reg(struct mtd_info *mtd, loff_t from,
> >  					    size_t len, size_t *retlen,
> >  					     u_char *buf)
> >  {
> > -	return cfi_intelext_otp_walk(mtd, from, len, retlen,
> > -				     buf, do_otp_write, 1);
> > +	int ret;
> > +
> > +	ret = cfi_intelext_otp_walk(mtd, from, len, retlen,
> > +				    buf, do_otp_write, 1);
> > +
> > +	/* if no data could be written due to lack of OTP memory,
> > +	   return ENOSPC */
> 
> /*
>  * Can you use this style of mult-line comments please?
>  * It's in Documentation/CodingStyle
>  */
> 
> > +	if (!ret && len && !(*retlen))
> > +		return -ENOSPC;
> 
> Couldn't (shouldn't) this check be pushed to the common
> mtd_write_user_prot_reg() helper in mtdcore.c? And once you do that, you
> will see that cfi_intelext_write_user_prot_reg() (and other
> mtd->_write_user_prot_reg() implementations) will never be called with
> len == 0. So this just becomes (in mtdcore.c):
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 0a7d77e65335..ee6730748f7e 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -909,11 +909,16 @@ EXPORT_SYMBOL_GPL(mtd_read_fact_prot_reg);
>  int mtd_get_user_prot_info(struct mtd_info *mtd, size_t len, size_t *retlen,
>  			   struct otp_info *buf)
>  {
> +	int ret;
> +
>  	if (!mtd->_get_user_prot_info)
>  		return -EOPNOTSUPP;
>  	if (!len)
>  		return 0;
> -	return mtd->_get_user_prot_info(mtd, len, retlen, buf);
> +	ret = mtd->_get_user_prot_info(mtd, len, retlen, buf);
> +	if (ret)
> +		return ret;
> +	return !(*retlen) ? -ENOSPC: 0;
>  }
>  EXPORT_SYMBOL_GPL(mtd_get_user_prot_info);

Sorry, I patched the wrong function here! Please use your brain and
apply this to the OTP write function :)

> > +
> > +	return ret;
> >  }
> >  
> >  static int cfi_intelext_lock_user_prot_reg(struct mtd_info *mtd,
> > diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
> > index 09c69ce..5236d85 100644
> > --- a/drivers/mtd/devices/mtd_dataflash.c
> > +++ b/drivers/mtd/devices/mtd_dataflash.c
> > @@ -545,14 +545,11 @@ static int dataflash_write_user_otp(struct mtd_info *mtd,
> >  	struct dataflash	*priv = mtd->priv;
> >  	int			status;
> >  
> 
> I'm not sure I quite follow the logic for the following hunk. I think it
> deserves some more explanation, either in your commit or in a comment.
> As it stands, you're deleting a comment and potentially changing the
> return code behavior subtly.
> 
> > -	if (len > 64)
> > -		return -EINVAL;
> > -
> > -	/* Strictly speaking, we *could* truncate the write ... but
> > -	 * let's not do that for the only write that's ever possible.
> > -	 */
> > -	if ((from + len) > 64)
> > -		return -EINVAL;
> > +	if ((from + len) > 64) {
> > +		len = 64 - from;
> 
> Why are you reassigning len? Are you trying to undo the comment above,
> so that you *can* truncate the write? (It looks like there are other
> implmentations which will truncate the write and return -ENOSPC, FWIW.)
> 
> > +		if (len <= 0)
> > +			return -ENOSPC;
> > +	}

I looked a bit more at [1] and it looks like you're actually trying to
straighten out some inconsistencies (hence the "harmonizing" in
$subject). I think this warrants:

(1) A little more in the commit message. You describe the new policy,
    but you should also note *how* this is changing existing
    implementations.

(2) A comment next to mtd_write_user_prot_reg() to describe the new
    harmony.

> >  
> >  	/* OUT: OP_WRITE_SECURITY, 3 zeroes, 64 data-or-zero bytes
> >  	 * IN:  ignore all

[1] http://patchwork.ozlabs.org/patch/239897/

Brian
