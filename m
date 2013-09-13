Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3IMVgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:36:15 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:50736 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IMVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:36:14 -0400
Date: Fri, 13 Sep 2013 17:36:10 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
Message-ID: <20130913213607.GB8502@ohporter.com>
References: <20130913145033.GA8502@ohporter.com>
 <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
 <52334506.9030802@linaro.org>
 <1379095648.2197.27.camel@buesod1.americas.hpqcorp.net>
 <523354F3.70001@linaro.org>
 <20130913181720.GA1614@x2.net.home>
 <1379096972.2197.31.camel@buesod1.americas.hpqcorp.net>
 <52335A7A.6000406@linaro.org>
 <1379100399.2197.34.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379100399.2197.34.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:26:39PM -0700, Davidlohr Bueso wrote:
> On Fri, 2013-09-13 at 14:33 -0400, Matt Porter wrote:
> > On 09/13/2013 02:29 PM, Davidlohr Bueso wrote:
> > > On Fri, 2013-09-13 at 20:17 +0200, Karel Zak wrote:
> > >> On Fri, Sep 13, 2013 at 02:09:55PM -0400, Matt Porter wrote:
> > >>>> Come to think of it, we do have a long existing workaround: the
> > >>>> force_gpt option. Setting it will bypass any MBR checking
> > >>>> (is_pmbr_valid(), specifically).
> > >>>
> > >>> Yes, that's what I used at first after seeing what the problem was. But then
> > >>> I opted to fix my PMBR.
> > >>>
> > >>> I felt like it was a regression since it required a new option passed on the
> > >>> cmdline.
> > >>
> > >>   Yep, it is *regression* and I guess Davidlohr is going to fix it asap :-)
> > >
> > > I was doing a git revert, but what would you guys think of keeping the
> > > check but making it more flexible? Instead of enforcing the minimum,
> > > just make sure that the size_in_lba is either the whole disk or 2 TiB,
> > > that should take care of Matt's issue.
> > 
> > That seems to be the way to go given the departure from the spec.
> 
> Matt, could you please verify that this patch fixes your problem?
> 
> Thanks!
> 
> 8<-------------------------------------------------
> 
> From: Davidlohr Bueso <davidlohr@hp.com>
> Subject: [PATCH] partitions/efi: loosen pmbr size in lba check
> 
> Matt found that commit 27a7c64 (partitions/efi: account for pmbr size in lba)
> caused his GPT formatted eMMC device not to boot. The reason is that this commit
> enforced Linux to always check the lesser of the whole disk or 2Tib for the
> pMBR size in LBA. While most disk partitioning tools out there create a pMBR with
> these characteristics, Microsoft does not, as it always sets the entry to the
> maximum 32-bit limitation - even though a drive may be smaller than that[1].
> 
> Loosen this check and only verify that the size is either the whole disk or
> 0xFFFFFFFF. No tool in its right mind would set it to any value other than these.
> 
> [1] http://thestarman.pcministry.com/asm/mbr/GPT.htm#GPTPT
> 
> Reported-by: Matt Porter <matt.porter@linaro.org>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  block/partitions/efi.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 1a5ec9a..9bae49c 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -186,6 +186,7 @@ invalid:
>   */
>  static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
>  {
> +	uint32_t sz = 0;
>  	int i, part = 0, ret = 0; /* invalid by default */
>  
>  	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
> @@ -216,12 +217,15 @@ check_hybrid:
>  	/*
>  	 * Protective MBRs take up the lesser of the whole disk
>  	 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
> +	 * Some partitioning programs, nonetheless, choose to set
> +	 * the size to the maximum 32-bit limitation, disregarding
> +	 * the disk size.
>  	 *
>  	 * Hybrid MBRs do not necessarily comply with this.
>  	 */
>  	if (ret == GPT_MBR_PROTECTIVE) {
> -		if (le32_to_cpu(mbr->partition_record[part].size_in_lba) !=
> -		    min((uint32_t) total_sectors - 1, 0xFFFFFFFF))
> +		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
> +		if (sz != (uint32_t) total_sectors - 1 || sz != 0xFFFFFFFF)

Almost! You'll want to get that brown paper bag out cause I've worn it
for this same type of bug before. Add this fix in and you can have my

Tested-by: Matt Porter <matt.porter@linaro.org>

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 9bae49c..1eb09ee 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -225,7 +225,7 @@ check_hybrid:
         */
        if (ret == GPT_MBR_PROTECTIVE) {
                sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
-               if (sz != (uint32_t) total_sectors - 1 || sz != 0xFFFFFFFF)
+               if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
			ret = 0;
        }
 done:

Thanks,
Matt
