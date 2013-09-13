Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3IMS3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:29:37 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:44703 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3IMS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:29:36 -0400
Message-ID: <1379096972.2197.31.camel@buesod1.americas.hpqcorp.net>
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
From: Davidlohr Bueso <davidlohr@hp.com>
To: Karel Zak <kzak@redhat.com>
Cc: Matt Porter <matt.porter@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Date: Fri, 13 Sep 2013 11:29:32 -0700
In-Reply-To: <20130913181720.GA1614@x2.net.home>
References: <20130913145033.GA8502@ohporter.com>
	 <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
	 <52334506.9030802@linaro.org>
	 <1379095648.2197.27.camel@buesod1.americas.hpqcorp.net>
	 <523354F3.70001@linaro.org> <20130913181720.GA1614@x2.net.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 20:17 +0200, Karel Zak wrote:
> On Fri, Sep 13, 2013 at 02:09:55PM -0400, Matt Porter wrote:
> > >Come to think of it, we do have a long existing workaround: the
> > >force_gpt option. Setting it will bypass any MBR checking
> > >(is_pmbr_valid(), specifically).
> > 
> > Yes, that's what I used at first after seeing what the problem was. But then
> > I opted to fix my PMBR.
> > 
> > I felt like it was a regression since it required a new option passed on the
> > cmdline.
> 
>  Yep, it is *regression* and I guess Davidlohr is going to fix it asap :-)

I was doing a git revert, but what would you guys think of keeping the
check but making it more flexible? Instead of enforcing the minimum,
just make sure that the size_in_lba is either the whole disk or 2 TiB,
that should take care of Matt's issue.

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 1a5ec9a..df2fca1 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -220,8 +220,8 @@ check_hybrid:
         * Hybrid MBRs do not necessarily comply with this.
         */
        if (ret == GPT_MBR_PROTECTIVE) {
-               if (le32_to_cpu(mbr->partition_record[part].size_in_lba) !=
-                   min((uint32_t) total_sectors - 1, 0xFFFFFFFF))
+               if (le32_to_cpu(mbr->partition_record[part].size_in_lba) != (uint32_t) total_sectors - 1 ||
+                   le32_to_cpu(mbr->partition_record[part].size_in_lba) != 0xFFFFFFFF)
                        ret = 0;
        }
 done:

Karel, I guess any changes that we do here should apply to fdisk :)

Thanks,
Davidlohr

