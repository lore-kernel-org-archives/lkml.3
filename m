Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3IMUoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3IMUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:44:05 -0400
Date: Fri, 13 Sep 2013 16:43:54 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: nab@daterainc.com
Subject: Re: target: Add support for EXTENDED_COPY copy offload emulation
Message-ID: <20130913204354.GA20782@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	nab@daterainc.com
References: <20130913000121.C53A6660D4A@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913000121.C53A6660D4A@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:01:21AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=cbf031f425fd0b30ff10ba83b612753189a6bbbf
 > Commit:     cbf031f425fd0b30ff10ba83b612753189a6bbbf
 > Parent:     89c12cc925a7d0982dc53b743a42108acc76aef4
 > Author:     Nicholas Bellinger <nab@daterainc.com>
 > AuthorDate: Tue Aug 20 15:38:55 2013 -0700
 > Committer:  Nicholas Bellinger <nab@linux-iscsi.org>
 > CommitDate: Tue Sep 10 16:48:43 2013 -0700
 > 
 >     target: Add support for EXTENDED_COPY copy offload emulation

...

 > +static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op *xop,
 > +					unsigned char *p)
 > +{
 > +	unsigned char *desc = p;
 > +	int dc = (desc[1] & 0x02);
 > +	unsigned short desc_len;
 > +
 > +	desc_len = get_unaligned_be16(&desc[2]);
 > +	if (desc_len != 0x18) {
 > +		pr_err("XCOPY segment desc 0x02: Illegal desc_len:"
 > +				" %hu\n", desc_len);
 > +		return -EINVAL;
 > +	}
 > +
 > +	xop->stdi = get_unaligned_be16(&desc[4]);
 > +	xop->dtdi = get_unaligned_be16(&desc[6]);
 > +	pr_debug("XCOPY seg desc 0x02: desc_len: %hu stdi: %hu dtdi: %hu, DC: %d\n",
 > +		desc_len, xop->stdi, xop->dtdi, dc);
 > +
 > +	xop->nolb = get_unaligned_be16(&desc[10]);
 > +	xop->src_lba = get_unaligned_be64(&desc[12]);
 > +	xop->dst_lba = get_unaligned_be64(&desc[20]);
 > +	pr_debug("XCOPY seg desc 0x02: nolb: %hu src_lba: %llu dst_lba: %llu\n",
 > +		xop->nolb, (unsigned long long)xop->src_lba,
 > +		(unsigned long long)xop->dst_lba);
 > +
 > +	if (dc != 0) {
 > +		xop->dbl = (desc[29] << 16) & 0xff;
 > +		xop->dbl |= (desc[30] << 8) & 0xff;
 > +		xop->dbl |= desc[31] & 0xff;
 > +
 > +		pr_debug("XCOPY seg desc 0x02: DC=1 w/ dbl: %u\n", xop->dbl);
 > +	}
 > +	return 0;
 > +}

Coverity picked up a new warning in this code.
It notes that (desc[30] << 8) & 0xff is always zero.

Did you want

 	xop->dbl = (desc[29] >> 16) & 0xff;

instead maybe ?

The << 16 looks suspect too, though it didn't warn on that.

	Dave


