Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab3KHVhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:37:04 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41672 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349Ab3KHVhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:37:00 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH v3] ext4: Fix reading of extended tv_sec (bug 23732)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1383866807.23882.41.camel@chiang>
Date: Fri, 8 Nov 2013 14:37:57 -0700
Cc: Jan Kara <jack@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
References: <1383808590.23882.13.camel@chiang> <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang> <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang>
To: David Turner <novalis@novalis.org>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2013, at 4:26 PM, David Turner <novalis@novalis.org> wrote:
> On Fri, 2013-11-08 at 00:14 +0100, Jan Kara wrote:
>> Still unnecessary type cast here (but that's a cosmetic issue).
> ...
>> Otherwise the patch looks good. You can add:
>> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Thanks.  A version with this correction and the reviewed-by follows.

Thanks for working on this.  It was (seriously) in my list of things to
get done, but I figured I still had a few years to work on it...

My (unfinished) version of this patch had a nice comment at ext4_encode_time()
that explained the encoding that is being used very clearly:

/*
 * We need is an encoding that preserves the times for extra epoch "00":
 *
 * extra  msb of                         adjust for signed
 * epoch  32-bit                         32-bit tv_sec to
 * bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid time range
 * 0 0    1    -0x80000000..-0x00000001  0x000000000     1901-12-13..1969-12-31
 * 0 0    0    0x000000000..0x07fffffff  0x000000000     1970-01-01..2038-01-19
 * 0 1    1    0x080000000..0x0ffffffff  0x100000000     2038-01-19..2106-02-07
 * 0 1    0    0x100000000..0x17fffffff  0x100000000     2106-02-07..2174-02-25
 * 1 0    1    0x180000000..0x1ffffffff  0x200000000     2174-02-25..2242-03-16
 * 1 0    0    0x200000000..0x27fffffff  0x200000000     2242-03-16..2310-04-04
 * 1 1    1    0x280000000..0x2ffffffff  0x300000000     2310-04-04..2378-04-22
 * 1 1    0    0x300000000..0x37fffffff  0x300000000     2378-04-22..2446-05-10
 */

It seems that your version of the patch seems to use a different encoding.  Not
that this is a problem, per-se, since my patch wasn’t in use anywhere, but it
would be nice to have a similarly clear explanation of what the mapping is so
that it can be clearly understood.

My ext4_{encode,decode}_extra_time() used add/subtract instead of mask/OR ops,
which changed the on-disk format for times beyond 2038, but those were already
broken, and presumably not in use by anyone yet.  However, it seemed to me this
was easier to produce the correct results.  Have you tested your patch with
a variety of timestamps to verify its correctness?  It looks to me like you
have mapped the 1901-1969 range onto 0x3 for the epoch bits, instead of the
(IMHO) natural 0x0 bits. The critical time ranges are listed above.

Cheers, Andreas

> --
> In ext4, the bottom two bits of {a,c,m}time_extra are used to extend
> the {a,c,m}time fields, deferring the year 2038 problem to the year
> 2446.  The representation (which this patch does not alter) is a bit
> hackish, in that the most-significant bit is no longer (alone)
> sufficient to indicate the sign.  That's because we're representing an
> asymmetric range, with seven times as many positive values as
> negative.
> 
> When decoding these extended fields, for times whose bottom 32 bits
> would represent a negative number, sign extension causes the 64-bit
> extended timestamp to be negative as well, which is not what's
> intended.  This patch corrects that issue, so that the only negative
> {a,c,m}times are those between 1901 and 1970 (as per 32-bit signed
> timestamps).
> 
> Signed-off-by: David Turner <novalis@novalis.org>
> Reported-by: Mark Harris <mh8928@yahoo.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23732
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
> fs/ext4/ext4.h | 13 +++++++++----
> 1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index af815ea..3c2d0b3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -722,10 +722,15 @@ static inline __le32 ext4_encode_extra_time(struct timespec *time)
> 
> static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> {
> -       if (sizeof(time->tv_sec) > 4)
> -	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> -			       << 32;
> -       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
> +	if (sizeof(time->tv_sec) > 4) {
> +		u64 extra_bits = le32_to_cpu(extra) & EXT4_EPOCH_MASK;
> +		if (time->tv_sec > 0 || extra_bits != EXT4_EPOCH_MASK) {
> +			time->tv_sec &= 0xFFFFFFFF;
> +			time->tv_sec |= extra_bits << 32;
> +		}
> +	}
> +	time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >>
> +		EXT4_EPOCH_BITS;
> }
> 
> #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
> -- 
> 1.8.1.2
> 
> 
> 


Cheers, Andreas





