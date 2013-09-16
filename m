Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846Ab3IPUmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:42:35 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:58012 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3IPUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:42:34 -0400
Message-ID: <1379364614.32763.587.camel@haakon3.risingtidesystems.com>
Subject: Re: target: Add support for EXTENDED_COPY copy offload emulation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nab@daterainc.com, target-devel <target-devel@vger.kernel.org>
Date: Mon, 16 Sep 2013 13:50:14 -0700
In-Reply-To: <20130913204354.GA20782@redhat.com>
References: <20130913000121.C53A6660D4A@gitolite.kernel.org>
	 <20130913204354.GA20782@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, 2013-09-13 at 16:43 -0400, Dave Jones wrote:
> On Fri, Sep 13, 2013 at 12:01:21AM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=cbf031f425fd0b30ff10ba83b612753189a6bbbf
>  > Commit:     cbf031f425fd0b30ff10ba83b612753189a6bbbf
>  > Parent:     89c12cc925a7d0982dc53b743a42108acc76aef4
>  > Author:     Nicholas Bellinger <nab@daterainc.com>
>  > AuthorDate: Tue Aug 20 15:38:55 2013 -0700
>  > Committer:  Nicholas Bellinger <nab@linux-iscsi.org>
>  > CommitDate: Tue Sep 10 16:48:43 2013 -0700
>  > 
>  >     target: Add support for EXTENDED_COPY copy offload emulation
> 
> ...
> 
>  > +static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op *xop,
>  > +					unsigned char *p)
>  > +{
>  > +	unsigned char *desc = p;
>  > +	int dc = (desc[1] & 0x02);
>  > +	unsigned short desc_len;
>  > +
>  > +	desc_len = get_unaligned_be16(&desc[2]);
>  > +	if (desc_len != 0x18) {
>  > +		pr_err("XCOPY segment desc 0x02: Illegal desc_len:"
>  > +				" %hu\n", desc_len);
>  > +		return -EINVAL;
>  > +	}
>  > +
>  > +	xop->stdi = get_unaligned_be16(&desc[4]);
>  > +	xop->dtdi = get_unaligned_be16(&desc[6]);
>  > +	pr_debug("XCOPY seg desc 0x02: desc_len: %hu stdi: %hu dtdi: %hu, DC: %d\n",
>  > +		desc_len, xop->stdi, xop->dtdi, dc);
>  > +
>  > +	xop->nolb = get_unaligned_be16(&desc[10]);
>  > +	xop->src_lba = get_unaligned_be64(&desc[12]);
>  > +	xop->dst_lba = get_unaligned_be64(&desc[20]);
>  > +	pr_debug("XCOPY seg desc 0x02: nolb: %hu src_lba: %llu dst_lba: %llu\n",
>  > +		xop->nolb, (unsigned long long)xop->src_lba,
>  > +		(unsigned long long)xop->dst_lba);
>  > +
>  > +	if (dc != 0) {
>  > +		xop->dbl = (desc[29] << 16) & 0xff;
>  > +		xop->dbl |= (desc[30] << 8) & 0xff;
>  > +		xop->dbl |= desc[31] & 0xff;
>  > +
>  > +		pr_debug("XCOPY seg desc 0x02: DC=1 w/ dbl: %u\n", xop->dbl);
>  > +	}
>  > +	return 0;
>  > +}
> 
> Coverity picked up a new warning in this code.
> It notes that (desc[30] << 8) & 0xff is always zero.
> 
> Did you want
> 
>  	xop->dbl = (desc[29] >> 16) & 0xff;
> 
> instead maybe ?
> 

Mmmm, the left shift and bitwise AND are reversed..

Adding the following patch for v3.12-rc target-fixes.

Thanks for reporting!

--nab

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 4d22e7d..3da4fd1 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -298,8 +298,8 @@ static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op
                (unsigned long long)xop->dst_lba);
 
        if (dc != 0) {
-               xop->dbl = (desc[29] << 16) & 0xff;
-               xop->dbl |= (desc[30] << 8) & 0xff;
+               xop->dbl = (desc[29] & 0xff) << 16;
+               xop->dbl |= (desc[30] & 0xff) << 8;
                xop->dbl |= desc[31] & 0xff;
 
                pr_debug("XCOPY seg desc 0x02: DC=1 w/ dbl: %u\n", xop->dbl);

