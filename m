Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631Ab3BOLFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:05:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3BOLFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:05:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link error
Date: Fri, 15 Feb 2013 11:05:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dinh Nguyen <dinguyen@altera.com>, Pavel Machek <pavel@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Simon Horman <horms+renesas@verge.net.au>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-9-git-send-email-arnd@arndb.de> <511D7701.8040809@wwwdotorg.org>
In-Reply-To: <511D7701.8040809@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151105.14253.arnd@arndb.de>
X-Provags-ID: V02:K0:GSCgIuWAQ6GZyr9xMXmADwwMPetAYW7XMTqQJz96SBY
 hc8mo76bIZgTgP6o4koIcV3BE0QXKTLJi67ipGb3DQxAkdIyt4
 jBn7HYaEgh35wh+AOdY9GTkp2cwEzz9TW0+2NLLUBrDnnDmFGg
 cjOu90MJfl9sx40be9JXCjBavKkUoOaggG0YQBSii94vRVXYAI
 3E3tkpqgdXyofICzXHbb0HejWnVm1zRm/6re7GcH/hqBmz9Atq
 JCTqN6EVB2dl3QMWYfbWabNxvIPd6yNQrYeXVxIjBkwmqFPvsF
 0o+Sp7YekocDgxPRMXUU9xxnh9T34MR3tXT8VnZUEU0HgqGp87
 +TIKrEFzq1+8Mo7Ec4mQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Stephen Warren wrote:
> On 02/14/2013 03:47 PM, Arnd Bergmann wrote:
> > Patch c08e20d24 "arm: Add v7_invalidate_l1 to cache-v7.S"
> > moves the v7_invalidate_l1 symbol out of imx/headsmp.S,
> > which seems to cause a link error because it is now
> > too far away from v7_cpu_resume when building an
> > allyesconfig kernel.
> 
> Is the problem from the following in arch/arm/mach-imx/headsmp.S:
> 
> ENTRY(v7_cpu_resume)
>         bl      v7_invalidate_l1
> 
> Isn't the range of bl +/- 32MiB (or +/- 16MibB in Thumb 2). Is the
> kernel really that big? Sorry, I'm having trouble understanding what
> causes the problem.


Well, it is an "allyesconfig" kernel, so things can get pretty big:

$ size  obj-tmp/vmlinux -A
obj-tmp/vmlinux  :
section                  size         addr
.head.text                504   3221258240
.text                32707336   3221258752
.text.head                  8   3253966088
.rodata              14028722   3253968896
__bug_table            127764   3267997624
.builtin_fw               684   3268125388
__ksymtab               53424   3268126072
__ksymtab_gpl           43560   3268179496
__kcrctab               26712   3268223056
__kcrctab_gpl           21780   3268249768
__ksymtab_strings      233706   3268271548
__param                 33104   3268505256
__modver                 4104   3268538360
__ex_table               4112   3268542464
.ARM.unwind_idx        967784   3268546576
.ARM.unwind_tab       1452168   3269514360
.notes                     36   3270966528
.init.text             677840   3270967296
.exit.text             125672   3271645136
.init.arch.info          5396   3271770808
.init.tagtable             72   3271776204
.init.smpalt              928   3271776276
.init.pv_table           1704   3271777204
.init.data             678108   3271778912
.exit.data                119   3272457020
.data..percpu         1460032   3272458240
.data                 3370068   3273924608
.tcm_start                940   3277294676
.bss                  8007724   3277295616
.comment                   43            0
.ARM.attributes            50            0
.debug_line          15780363            0
.debug_info          57192143            0
.debug_abbrev         5747374            0
.debug_aranges         299608            0
.debug_ranges         5414592            0
.debug_frame          4801748            0
.debug_str            7003282            0
.debug_loc           36237476            0
Total               196510790

THUMB2 support is obviously enabled (allyesconfig), and from the start of the
.head.text section to the end of .bss, it is 64,045,100 bytes, using yesterday's
linux-next kernel with my fixes. It will get bigger as we add more stuff
to multiplatform. The .text section alone is just short of 32MB.

	Arnd
