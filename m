Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3D2Lkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:40:46 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:15770 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab3D2Lkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:40:45 -0400
Date: Mon, 29 Apr 2013 13:40:41 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130429114041.GA10884@frolo.macqel>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be> <1366924229-21569-3-git-send-email-phdm@macqel.be> <20130429093756.GB12317@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429093756.GB12317@x2.net.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:37:56AM +0200, Karel Zak wrote:
> On Thu, Apr 25, 2013 at 11:10:26PM +0200, Philippe De Muyter wrote:

Thanks for the interest and the quick reply.

> > +int aix_partition(struct parsed_partitions *state)
> > +{
> > +	int ret = 0;
> > +	Sector sect;
> > +	unsigned char *d;
> > +	u32 pp_bytes_size;
> > +	u32 pp_blocks_size = 0;
> > +	u32 vgda_sector = 0;
> > +	u32 vgda_len = 0;
> > +	int numlvs = 0;
> > +	struct pvd *pvd;
> > +	unsigned short pps_per_lv[16];
> > +	unsigned short pps_found[16];
> > +	unsigned char lv_is_contiguous[16];
> > +	struct lvname *n = NULL;
> > +
> > +	d = read_part_sector(state, 7, &sect);
> > +	if (d) {
> > +		struct lvm_rec *p = (struct lvm_rec *)d;
> > +		u16 lvm_version = be16_to_cpu(p->version);
> > +		char tmp[64];
> > +
> > +		if (lvm_version == 1) {
> > +			int pp_size_log2 = be16_to_cpu(p->pp_size);
> > +
> > +			pp_bytes_size = 1 << pp_size_log2;
> > +			pp_blocks_size = pp_bytes_size / 512;
> > +			snprintf(tmp, sizeof(tmp), " AIX LVM header version %u found\n", lvm_version);
> 
> 'tmp' is nowhere used, maybe you want to use strlcat(state->pp_buf, tmp, PAGE_SIZE); too.

Oops, of course :)
> 
> > +			vgda_len = be32_to_cpu(p->vgda_len);
> > +			vgda_sector = be32_to_cpu(p->vgda_psn[0]);
> > +		} else {
> > +			snprintf(tmp, sizeof(tmp), " unsupported AIX LVM version %d found\n",
> > +				lvm_version);
> > +			strlcat(state->pp_buf, tmp, PAGE_SIZE);
> > +		}
> > +		put_dev_sector(sect);
> > +	}
> > +	if (vgda_sector && (d = read_part_sector(state, vgda_sector, &sect))) {
> > +		struct vgda *p = (struct vgda *)d;
> > +
> > +		numlvs = be16_to_cpu(p->numlvs);
> > +		put_dev_sector(sect);
> > +	}
> > +	if (numlvs && (d = read_part_sector(state, vgda_sector + 1, &sect))) {
> > +		struct lvd *p = (struct lvd *)d;
> > +		int i;
> > +
> > +		n = alloc_lvn(state, vgda_sector + vgda_len - 33);
> > +		if (n) {
> > +			int j = 0;
> > +
> > +			memset(lv_is_contiguous, 0, 16);
> > +			for (i = 0; i < 16; i += 1)
> > +				pps_found[i] = 0;
> 
> why not memset(pps_found, ....)? I also see magical constant 16

Actually 16 is the maximum partition count allowed in a disk by linux,
or should it be 15 ?  Is there already a constant for that ?
The AIX disk I tested with had only :) 11 partitions.

> everywhere, maybe you can use sizeof() and ARRAY_SIZE().

Will do.
> 
> > +			for (i = 0; j < numlvs && i < 16; i += 1) {
> > +				pps_per_lv[i] = be16_to_cpu(p[i].num_lps);
> > +				if (pps_per_lv[i])
> > +					j += 1;
> > +			}
> 
> hmm, what's wrong with j++ and i++, "j += 1" seems like old Python :-)
> 

What's wrong with "j += 1" ?
I only use ++ for side effects; I personaly find "j += 1" more readable :)
But I should rename 'j' to be more explicit.


> > +			while (i < 16)
> > +				pps_per_lv[i++] = 0;
> > +		}
> > +		put_dev_sector(sect);
> > +	}
> > +	pvd = alloc_pvd(state, vgda_sector + 17);
> > +	if (pvd) {
> > +		int numpps = be16_to_cpu(pvd->pp_count);
> > +		int psn_part1 = be32_to_cpu(pvd->psn_part1);
> > +		int i;
> > +		int cur_lv_ix = -1;
> > +		int next_lp_ix = 1;
> > +		int lp_ix;
> > +
> > +		for (i = 0; i < numpps; i += 1) {
> > +			struct ppe *p = pvd->ppe + i;
> > +			int lv_ix;
> > +
> > +			lp_ix = be16_to_cpu(p->lp_ix);
> > +			if (!lp_ix) {
> > +				next_lp_ix = 1;
> > +				continue;
> > +			}
> > +			lv_ix = be16_to_cpu(p->lv_ix) - 1;
> > +			pps_found[lv_ix] += 1;
> 
>  Would be better to be a little paranoid when you read the data from
>  disk and check that lv_ix is in range 0..16 ?

Of course.

> 
> > +			if (lp_ix != next_lp_ix)
> > +				continue;
> > +			if (lp_ix == 1)
> > +				cur_lv_ix = lv_ix;
> > +			else if (lv_ix != cur_lv_ix)
> > +				next_lp_ix = 1;
> > +			if (lp_ix == pps_per_lv[lv_ix]) {
> > +				char tmp[70];
> > +
> > +				put_partition(state, lv_ix + 1,
> > +					(i + 1 - lp_ix) * pp_blocks_size + psn_part1,
> > +					pps_per_lv[lv_ix] * pp_blocks_size);
> > +				snprintf(tmp, sizeof(tmp), " <%s>\n", n[lv_ix].name);
> > +				strlcat(state->pp_buf, tmp, PAGE_SIZE);
> > +				lv_is_contiguous[lv_ix] = 1;
> > +				ret = 1;
> > +				next_lp_ix = 1;
> > +			} else
> > +				next_lp_ix += 1;
> > +		}
> > +		for (i = 0; i < 16; i += 1)
> > +			if (pps_found[i] && !lv_is_contiguous[i])
> > +				printk("partition %s (%d pp's found) is not contiguous\n", n[i].name, pps_found[i]);
> > +		kfree(pvd);
> > +	}
> > +	if (n)
> > +		kfree(n);
> > +	return ret;
> > +}
> 
> Philippe, do you have any disk image with AIX LVM? It would be nice to
> have a way how to test the code. I'd like to add support for AIX to
> libblkid too.

Of course.  But that's not a couple of blocks.  I'll try to cut the
slice that you need.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
